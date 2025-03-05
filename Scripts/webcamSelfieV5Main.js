//--------------------
// GET USER MEDIA CODE
//--------------------
navigator.getUserMedia = (navigator.getUserMedia ||
    navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia ||
    navigator.msGetUserMedia);

var video;
var webcamStream;

function startWebcam() {
    if (navigator.getUserMedia) {
        navigator.getUserMedia(

            // constraints
            {
                video: true,
                audio: false
            },

            // successCallback
            function (localMediaStream) {
                //const mediaSource = new MediaSource();
                video = document.querySelector('video');
                // Older browsers may not have srcObject

                try {
                    console.log("Webcam Working");
                    video.srcObject = localMediaStream;
                } catch (error) {
                    video.src = window.URL.createObjectURL(localMediaStream);
                }
                video.play();
                webcamStream = localMediaStream;
            },

            // errorCallback
            function (error) {
                if (error.name === "NotAllowedError") {
                    alert("Please allow camera access.");
                } else if (error.name === "NotFoundError") {
                    alert("No webcam detected. Please connect a camera.");
                } else if (error.name === "AbortError") {
                    alert("Webcam access timed out. Try refreshing the page.");
                } else {
                    alert("Error accessing webcam: " + error.message);
                    console.log(error.message)
                }

                webcamStream = undefined;
            }
        );
    } else {
        console.log("getUserMedia not supported");
    }
}

function stopWebcam() {
    webcamStream.stop();
}

//---------------------
// TAKE A SNAPSHOT CODE
//---------------------
var canvas, ctx;
function snapshot(canvasid) {
    canvas = document.getElementById(canvasid);
    ctx = canvas.getContext('2d');
    // Draws current image from the video element into the canvas
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

}
var NoOfSelfie = 0;
function fnSaveContinue() {
    var BandId = $("#ConatntMatter_hdnBandId").val();
    var PageName = $("#ConatntMatter_hdnFolderName").val();
    var inLoginid = document.getElementById("ConatntMatter_hdnLoginID").value;
    inLoginid = (inLoginid == undefined ? 0 : inLoginid);

    var data = new FormData();
    var canvas1 = document.getElementById("myCanvas1");
    var imgData1 = canvas1.toDataURL("image/jpeg");
    imgData1 = imgData1.replace('data:image/jpeg;base64,', '');
    if (imgData1.length < 3000) {
        alert("Kindly Take Selfie of Front View First!");
        return false;
    }

    data.append("ImageData1", imgData1);

    var canvas2 = document.getElementById("myCanvas2");
    var imgData2 = canvas2.toDataURL("image/jpeg");

    imgData2 = imgData2.replace('data:image/jpeg;base64,', '');

    if (imgData2.length < 3000) {
        alert("Kindly Take Selfie of Left View First!");
        return false;
    }
    data.append("ImageData2", imgData2);

    var canvas3 = document.getElementById("myCanvas3");
    var imgData3 = canvas3.toDataURL("image/jpeg");
    imgData3 = imgData3.replace('data:image/jpeg;base64,', '');
    if (imgData3.length < 3000) {
        alert("Kindly Take Selfie of Right View First!");
        return false;
    }
    data.append("ImageData3", imgData3);



    data.append("FolderName", "Snapshot");

    if (confirm("Are you sure to Save & Continue?") == false) {
        return false;
    }

    var rspId = 0;// $("#ConatntMatter_hdnRspID").val();
    rspId = (rspId == undefined ? 0 : rspId);
    data.append("RspID", rspId);

    var rspExerciseId = 0;// $("#ConatntMatter_hdnRSPExerciseID").val();
    rspExerciseId = (rspExerciseId == undefined ? 0 : rspExerciseId);
    data.append("RSPExerciseID", rspExerciseId);

    var inLoginid = document.getElementById("ConatntMatter_hdnLoginID").value;
    inLoginid = (inLoginid == undefined ? 0 : inLoginid);
    data.append("LoginId", inLoginid);
    data.append("PageLocation", window.location.pathname);

    if (inLoginid > 0) {
        $("#pageload").show();
        $.ajax({
            url: "../../FileProctoringUploadHandler.ashx?flgfilefolderid=1",
            type: "POST",
            data: data,
            async: true,
            contentType: false,
            processData: false,
            success: function (result) {
                $("#pageload").hide();
                if (result.split("|")[0] == "1") {
                    var BandId = $("#ConatntMatter_hdnBandId").val();
                    window.location.href = "../../Data_Cohort" + BandId + "/Exercise/ExerciseMain.aspx?intLoginID=" + inLoginid
                }
                else {
                    alert("Error : Seems some network issue,kindly try again!");
                    return false;
                }
            },
            error: function (err) {
                $("#pageload").hide();
                alert("Error : Seems some network issue,kindly try again!");
                //alert(err.statusText)
            }
        });
    }
}
$(document).ready(function () {
    var IsProctoringEnabled = $("#ConatntMatter_hdnIsProctoringEnabled").val();
    if (IsProctoringEnabled == 1) {
        startWebcam();
        setInterval(function () {
            if (webcamStream == undefined) {
                startWebcam();
            }
        }, 10000);
    }

});

