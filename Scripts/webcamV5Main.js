//--------------------
// GET USER MEDIA CODE
//--------------------
navigator.getUserMedia = (navigator.getUserMedia ||
    navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia ||
    navigator.msGetUserMedia);

var webcamStream;
let IsAllowcontinue = 0;
let VoilationCount = 0;
let video;
let canvas;
let ctx;
let statusText;

async function setupCamera() {
    //video.width = 640;
    //video.height = 480;

    let stream = await navigator.getUserMedia({
        video: { facingMode: "user" }
    });
    video.srcObject = stream;

    return new Promise((resolve) => {
        video.onloadedmetadata = () => {
            resolve(video);
        };
    });
}

async function detectFaces() {
    const model = await blazeface.load();
    statusText.innerText = "Monitoring started...";

    setInterval(async () => {
        if (IsAllowcontinue == 0) {
            const predictions = await model.estimateFaces(video, false);

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

            if (predictions.length === 0) {
                statusText.innerText = "Alert: No face detected!";
                fnShowDialogAlert("Face not detected! Stay in front of the camera.");
                fnSaveViolationDB("Face not detected! ");
                VoilationCount++;
            } else if (predictions.length > 1) {
                statusText.innerText = "Alert: Multiple faces detected!";
                fnShowDialogAlert("Multiple faces detected! This is not allowed.");
                fnSaveViolationDB("Multiple faces detected!");
                VoilationCount++;
            } else {
                statusText.innerText = "Monitoring: Face detected.";
                
            }

            predictions.forEach(prediction => {
                let startX = prediction.topLeft[0];
                let startY = prediction.topLeft[1];
                let endX = prediction.bottomRight[0];
                let endY = prediction.bottomRight[1];

                // Draw face rectangle
                ctx.strokeStyle = "red";
                ctx.lineWidth = 3;
                ctx.strokeRect(startX, startY, endX - startX, endY - startY);
            });
        }
    }, 2000); // Runs every 2 seconds
}

async function detectEyeGaze() {
    const video = document.getElementById("video");
    const model = await facemesh.load();

    setInterval(async () => {
        if (IsAllowcontinue == 0) {
            const predictions = await model.estimateFaces(video);

            if (predictions.length > 0) {
                const keypoints = predictions[0].scaledMesh;

                const leftEye = keypoints[130]; // Left eye corner
                const rightEye = keypoints[359]; // Right eye corner
                const nose = keypoints[168]; // Nose tip

                const eyeDirection = (leftEye[0] + rightEye[0]) / 2 - nose[0];

                if (eyeDirection > 10) {
                    console.log("Looking Right - Possible cheating!");
                    fnShowDialogAlert("Please focus on the screen!");
                    fnSaveViolationDB("Looking Right - Possible cheating!");
                    
                } else if (eyeDirection < -10) {
                    console.log("Looking Left - Possible cheating!");
                    fnShowDialogAlert("Please focus on the screen!");
                    fnSaveViolationDB("Looking Left - Possible cheating!");
                    
                }
            }
        }
    }, 2000); // Runs every 2 seconds
}


async function detectHeadPose() {
    const model = await facemesh.load();
    const video = document.getElementById("video");

    setInterval(async () => {
        if (IsAllowcontinue == 0) {
            const predictions = await model.estimateFaces(video);
            if (predictions.length > 0) {
                const keypoints = predictions[0].scaledMesh;

                const leftEar = keypoints[234];
                const rightEar = keypoints[454];
                const nose = keypoints[168];

                let headTilt = Math.abs(leftEar[1] - rightEar[1]);

                if (headTilt > 30) {
                    console.log("Head tilted - Possible cheating!");
                    fnShowDialogAlert("Please keep your head straight!");
                    VoilationCount++;
                    fnSaveViolationDB("Head tilted - Possible cheating!");
                }
            }
        }
    }, 2000);
}

async function detectVoice() {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const stream = await navigator.getUserMedia({ audio: true });
    const microphone = audioContext.createMediaStreamSource(stream);
    const analyser = audioContext.createAnalyser();
    microphone.connect(analyser);

    const bufferLength = analyser.frequencyBinCount;
    const dataArray = new Uint8Array(bufferLength);

    setInterval(() => {
        if (IsAllowcontinue == 0) {
            analyser.getByteFrequencyData(dataArray);
            let volume = dataArray.reduce((a, b) => a + b, 0) / bufferLength;

            if (volume > 50) { // Adjust threshold based on environment
                console.log("Voice detected - Possible cheating!");

                
                fnSaveViolationDB("Voice detected - Possible cheating!");
                fnShowDialogAlert("Talking detected! Please remain silent.");
            }
        }
    }, 2000);
}


async function startWebcam() {
    //video.width = 640;
    //video.height = 480;
    if (navigator.getUserMedia) {
        navigator.getUserMedia(

            // constraints
            {
                video: true,
                facingMode: "user"
            },

            // successCallback
            function (localMediaStream) {
                //const mediaSource = new MediaSource();
                video = document.querySelector('video');
                // Older browsers may not have srcObject

                try {
                    video.srcObject = localMediaStream;
                } catch (error) {
                    video.src = window.URL.createObjectURL(localMediaStream);
                }
                video.play();
                webcamStream = localMediaStream;
            },

            // errorCallback
            function (err) {
                if (err.toString().indexOf('NotAllowedError') > -1) {
                    alert("Please enable camera.");
                }
                else {
                    alert("The following error occured: " + err);
                }

                webcamStream = undefined;
            }
        );
    } else {
        console.log("getUserMedia not supported");
    }
}

async function fnSaveViolationDB(ViolationText) {
    try {


        let url = window.location.href;
        let ViolationAt = url.split('.aspx')[0] + ".aspx";
        $.ajax({
            url: "../../WebService.asmx/fnSaveAssessmentViolationByParticipants",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: '{ViolationText:' + JSON.stringify(ViolationText) + ',ViolationAt:' + JSON.stringify(ViolationAt) + ',flg:0}',
            success: function (response) {
               // window.location.href = "../../Login.aspx";
            },
            error: function (msg) {
               // window.location.href = "../../Login.aspx";
            }
        });
    }
    catch (error) {

    }
}

function stopWebcam() {
    webcamStream.stop();
}

//---------------------
// TAKE A SNAPSHOT CODE
//---------------------
/*var canvas, ctx;*/
function snapshot() {
    canvas = document.getElementById("myCanvas");
    ctx = canvas.getContext('2d');
    // Draws current image from the video element into the canvas
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    var imgData = canvas.toDataURL("image/jpeg");
    imgData = imgData.replace('data:image/jpeg;base64,', '');

    var data = new FormData();
    data.append("ImageData", imgData);

    data.append("FolderName", "Snapshot");

    var rspId = $("#ConatntMatter_hdnRspID").val();
    rspId = (rspId == undefined ? 0 : rspId);
    data.append("RspID", rspId);

    var rspExerciseId = $("#ConatntMatter_hdnRSPExerciseID").val();
    rspExerciseId = (rspExerciseId == undefined ? 0 : rspExerciseId);
    data.append("RSPExerciseID", rspExerciseId);

    var inLoginid = document.getElementById("ConatntMatter_hdnLoginID").value;
    inLoginid = (inLoginid == undefined ? 0 : inLoginid);
    data.append("LoginId", inLoginid);

    data.append("PageLocation", window.location.pathname);
    if (inLoginid > 0) {
        $.ajax({
            url: "../../FileProctoringUploadHandler.ashx?flgfilefolderid=2",
            type: "POST",
            data: data,
            async: true,
            contentType: false,
            processData: false,
            success: function (result) {
                if (result.split("|")[0] == "1") {
                }
                else {
                    //alert("Error : " + result.split("|")[1]);
                    //return false;
                }
            },
            error: function (err) {
                alert("Error : " + err.statusText);
                //alert(err.statusText)
            }
        });
    }
}
var eventVoilationCountTimer;
$(document).ready(async function () {
    $("#videoContainer").draggable();
    video = document.getElementById("video");
    statusText = document.getElementById("status");
    canvas = document.getElementById("myCanvas");
    ctx = canvas.getContext("2d");

    var IsProctoringEnabled = $("#ConatntMatter_hdnIsProctoringEnabled").val();
    if (IsProctoringEnabled == 1) {
        await startWebcam().then(() => {
            detectFaces();
            detectEyeGaze();
            detectHeadPose();
           // detectVoice();
            setTimeout(function () {
                snapshot();
            }, 5000);
            setInterval(function () {
                snapshot();
            }, 60000);
        });

       //eventVoilationCountTimer=setInterval(function () {
       //    if (VoilationCount > 10) {
       //         IsAllowcontinue = 1;
       //         window.clearInterval(eventVoilationCountTimer);
       //         clearTimeout(eventVoilationCountTimer);
       //         var msg=("Your account has been locked due to violation more than " + VoilationCount + " during the assessment. Please contact support to regain access.");
       //         document.title = msg;
       //         fnSaveViolationDB(msg);
       //         $("#dvDialogalert").html("<br>" + msg);
       //         $("#dvDialogalert").dialog({
       //             title: "Warning",
       //             modal: true,
       //             close: function () {
       //                 $(this).html("");
       //                 $(this).dialog("destroy");
       //             },
       //             buttons: {
       //                 "OK": function () {
       //                     document.title = "Assessment";
       //                     $(this).dialog("close");
                            
       //                     window.location.href = "../../Login.aspx";
       //                 }
       //             }
       //         });
       //         return false;
       //     }
       // }, 1000);
        

        /*
        startWebcam();
       

        setInterval(function () {
            if (webcamStream == undefined) {
                startWebcam();
            }
        }, 10000);

        
        */
    }
});

function fnShowDialogAlert(msg) {
    document.title = msg;
    $("#dvDialogalert").html("<br>" + msg);
    $("#dvDialogalert").dialog({
        title: "Warning!",
        modal: true,
        close: function () {
            $(this).html("");
            $(this).dialog("destroy");
        },
        buttons: {
            "OK": function () {
                document.title = "Assessment";
                $(this).dialog("close");
            }
        }
    });
    return false;
}

//$(document).ready(function () {
//    $("#videoContainer").draggable();
//    video = document.getElementById("video");
//    statusText = document.getElementById("status");
//    canvas = document.getElementById("myCanvas");
//    ctx = canvas.getContext("2d");

//    var IsProctoringEnabled = 1;// $("#ConatntMatter_hdnIsProctoringEnabled").val();
//    if (IsProctoringEnabled == 1) {
//        setInterval(function () {
//            if (webcamStream == undefined) {
//                startWebcam();
//            }
//        }, 10000);
//        setTimeout(function () {
//            snapshot();
//        }, 5000);
//        setInterval(function () {
//            snapshot();
//        }, 120000);
//    }
//});

// Enable Resizing
let isResizing = false;
$("#resizeHandle").on("mousedown", function (e) {
    e.preventDefault();
    isResizing = true;
    $(document).on("mousemove", function (event) {
        let newWidth = event.pageX - $("#videoContainer").offset().left;
        let newHeight = event.pageY - $("#videoContainer").offset().top;
        $("#videoContainer").css({ width: newWidth + "px", height: newHeight + "px" });
    });
});

$(document).on("mouseup", function () {
    isResizing = false;
    $(document).off("mousemove");
});



