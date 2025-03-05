<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="false" CodeFile="CaseStudy_Technical2.aspx.vb" Inherits="CaseStudy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../../Scripts/webcamV5Main.js"></script>
    <style type="text/css">
        .ui-widget-overlay {
            background: #000 !important;
            opacity: 0.5 !important;
            filter: alpha(opacity=0.5) !important;
        }
         .ui-dialog-titlebar-close{
            display:none;
        }
    </style>

    <script type="text/javascript">
        function ShowRunningAssesments() {
            $(<%=dvAlertDialog.ClientID %>).dialog({
                title: 'Alert',
                modal: true,
                width: '30%',
                buttons: [{
                    text: "OK",
                    click: function () {
                        $(<%=dvAlertDialog.ClientID %>).dialog("close");
                    }
                }],
                close: function () {
                    $(this).dialog("close");
                    $(this).dialog("destroy");
                    parent.location.href = '../../login.aspx';
                    return false;
                }
            });
        }


    </script>
    <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        $(document).ready(function () {

            $("select").on("change", function () {
                if ($("select").not(this).children("option[value='" + $(this).val() + "']:selected").length > 0) {
                    alert("You have already selected this option")
                    $(this).find("option[value=0]").prop("selected", true)
                    return false;
                }
            });
            var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
            if (flgExerciseStatus == 2) {
                $("#btnSaveExit").show();
            }
        });
        function fnExitExercise() {
            window.location.href = "../Main/ExerciseMain.aspx";
        }

    </script>
    <script type="text/javascript">

        function fnMakeStringForSave() {
            var ExerciseID = $("#ConatntMatter_hdnExerciseID").val();
            var rspExerciseId = $("#ConatntMatter_hdnRSPExerciseID").val();
            //   alert('A')
            var objDetail = new Array();


            $('textarea[flg=1]').each(function () {
                var responseText = $(this).val();
                var quesId = $(this).attr("QuesId");
                var rspDetId = $(this).attr("RspDetId");

                var dataArray = new Array();
                dataArray = [{
                    RspDetID: rspDetId, QstId: quesId, RspExerciseId: rspExerciseId, ActualAnswer: responseText
                }];
                objDetail.push(dataArray[0]);
            });

            // alert('B')
            for (var ques = 0; ques < $("#tblMain").find("div[IsQues=1]").length; ques++) {
                var quesId = $($("#tblMain").find("div[IsQues=1]")[ques]).attr("QuesId");
                var rspDetId = $($("#tblMain").find("div[IsQues=1]")[ques]).attr("rspDetId");
                var selectedValues = "";
                for (var i = 0; i < $($("#tblMain").find("div[IsQues=1]")[ques]).find("input:checked").length; i++) {
                    var val = $($($("#tblMain").find("div[IsQues=1]")[ques]).find("input:checked")[i]).val();
                    if (selectedValues == "") {
                        selectedValues = val;
                    }
                    else {
                        selectedValues += "^" + val;
                    }
                }
                //  alert('C')
                if (selectedValues != "") {
                    var sText = "";
                    if ($("textarea[flg=2][quesId='" + quesId+"']").length > 0) {
                        sText = encodeURI($("textarea[flg=2][quesId='" + quesId +"']").val());
                    }
                    var dataArray = new Array();
                    dataArray = [{
                        RspDetID: rspDetId, QstId: quesId, RspExerciseId: rspExerciseId, ActualAnswer: selectedValues + "|" + sText
                    }];
                    objDetail.push(dataArray[0]);
                }
            }
            //   alert('D')
            return objDetail;
        }
        $("input[type='radio']").on("change", function () {
            //fnshowDependentQstn(this);
            $("input[type='radio']").removeClass("RadioBackgrouncolor");

        });
        $("input[type='checkbox']").on("change", function () {
            //fnshowDependentQstn(this);
            $("input[type='checkbox']").removeClass("RadioBackgrouncolor");

        });
        function fnCheckValidationForRadio(Direction) {
            var chkRadioFlag = true;
            $("input:radio").each(function () {
                var name = $(this).attr("name");
                //alert("name=" + name)
                var $checked = $("input:radio[name=" + name + "]:checked").length;
                //   alert($checked)
                if ($checked == 0 && Direction==2) {
                    fnShowDialog("Please select one option.")
                    $("input:radio[name=" + name + "]").eq(0).focus();
                    $("input:radio[name=" + name + "]").eq(0).addClass("RadioBackgrouncolor");
                    document.getElementById("btnNext").disabled = false;
                    chkRadioFlag = false;
                    return false;
                }

            });

            return chkRadioFlag;

        }
        function fnCheckValidationForCheckbox(Direction) {
            var chkCheckboxFlag = true;

            $("input:checkbox").each(function () {
                var name = $(this).attr("name");
                var MaxQstnSelected = $(this).attr("MaxQstnSelected");
                // alert("MaxQstnSelected=" + MaxQstnSelected)
                var $checked = $("input:checkbox[name=" + name + "]:checked").length;
                // alert($checked)
                if ($checked == 0 && Direction == 2) {
                    fnShowDialog("Please select the options.")
                    $("input:checkbox[name=" + name + "]").eq(0).focus();
                    $("input:checkbox[name=" + name + "]").eq(0).addClass("RadioBackgrouncolor");
                    document.getElementById("btnNext").disabled = false;
                    chkCheckboxFlag = false;
                    return false;
                }
                if (($checked < MaxQstnSelected) && Direction == 2) {
                    fnShowDialog("Please select " + MaxQstnSelected + " options.")
                    $("input:checkbox[name=" + name + "]").eq(0).focus();
                    document.getElementById("btnNext").disabled = false;
                    chkCheckboxFlag = false;
                    return false;
                }
                if ($checked > MaxQstnSelected) {
                    fnShowDialog("Please select " + MaxQstnSelected + " options.")
                    $("input:checkbox[name=" + name + "]").eq(0).focus();
                    document.getElementById("btnNext").disabled = false;
                    chkCheckboxFlag = false;
                    return false;
                }

            });
            return chkCheckboxFlag;

        }
    </script>

    <script type="text/javascript">
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        var TotalQuestions = 0; var BandID = 0;
        $(document).ready(function () {
            TotalQuestions = parseInt($("#ConatntMatter_hdnTotalQuestions").val());
            BandID = $("#ConatntMatter_hdnBandID").val();
            var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
            //alert(flgExerciseStatus)
            if (flgExerciseStatus < 2) {
                
                f1();

                eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 5000);
            } else {
                $("#theTime").hide();
                if (document.getElementById("ConatntMatter_hdnPageNmbr").value <=1) {
                    document.getElementById("btnNext").style.display = "inline-block";
                    document.getElementById("btnPrevious").style.display = "none";
                }
                
            }
        })
        
        function f1() {
            $(document).ready(function () {
                //function FnUpdateTimer() {
                if (IsUpdateTimer == 0) { return; }
                SecondCounter = parseInt(document.getElementById("ConatntMatter_hdnCounter").value);
                if (SecondCounter < 0) {
                    IsUpdateTimer = 0;
                    fnShowDialog("Your Time is over now")
                    counter = 0;
                    fnSaveData(2, "", 2, 1);
                    return;
                }

                SecondCounter = SecondCounter - 1;
                hours = Math.floor(SecondCounter / 3600);
                Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
                Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);

                //Minutes = parseInt(SecondCounter / 60);
                //HourCounter = parseInt(Minutes / 60);
                //Seconds = SecondCounter - (Minutes * 60);

                if (Seconds < 10 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds < 10 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds > 9 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + "0" + Minutes + ":" + Seconds;
                }
                else if (Seconds > 9 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + Minutes + ":" + Seconds;
                }
                document.getElementById("ConatntMatter_hdnCounter").value = SecondCounter;

                if (((hours * 60) + Minutes) == 5 && Seconds == 0) {

                    $("#dvDialog")[0].innerHTML = "<center>Your Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " After that your window will be closed automatically.</center>";
                    $("#dvDialog").dialog({
                        title: 'Alert',
                        modal: true,
                        width: '30%',
                        buttons: [{
                            text: "OK",
                            click: function () {
                                $("#dvDialog").dialog("close");
                            }
                        }]
                    });

                    //   document.getElementById("dvDialog").innerHTML = "<center>Your Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " After that your window will be closed automatically.</center>";
                }

                counter++;
                counterAutoSaveTxt++;
                if (counter == 5) {//Auto Time Update
                    counter = 0;
                    fnUpdateElapsedTime();
                    //counter = 1;
                }
               
                if (SecondCounter == 0) {
                    // alert("Level Complete");

                    fnUpdateElapsedTime();
                    // fnAutoSaveText(2);
                    counter = 0;
                    IsUpdateTimer = 1;
                    fnShowDialog("Your Time is over now");
                    var strRet = fnMakeStringForSave();
                    fnSaveData(2, strRet, 2, 1)
                    //alert("Your Time is over now")
                    counter = 0;
                    // var inLoginid1 = document.getElementById("ConatntMatter_hdnLoginID").value;
                    // window.location.href = "../Exercise/ExerciseMain.aspx?intLoginID=" + inLoginid1;
                    return false;
                }
                // }
                setTimeout("f1()", 1000);

                if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 1) {
                    document.getElementById("btnPrevious").style.display = "none";
                }
            });



            /* if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 2) {
                 document.getElementById("btnNext").value = "Submit";
             }
             else {
                 document.getElementById("btnNext").value = "Next";
             }*/

        }

        var eventStartMeetingTimer; var flgOpenGotoMeeting = 0;
        function fnStartMeetingTimer() {

            //$("#loader").show();
            if (flgOpenGotoMeeting == 0) {
                var RspExerciseID = $("#ConatntMatter_hdnRSPExerciseID").val();
                var MeetingDefaultTime = $("#ConatntMatter_hdnMeetingDefaultTime").val();
                PageMethods.fnStartMeetingTimer(RspExerciseID, MeetingDefaultTime, function (result) {
                    $("#loader").hide();
                    if (result.split("|")[0] == "1") {
                        alert("Error-" + result.split("|")[1]);
                    } else {
                        var IsMeetingStartTimer = result.split("|")[1];
                        var MeetingRemainingTime = result.split("|")[2];
                        var PrepRemainingTime = result.split("|")[5];
                        if (IsMeetingStartTimer == 1) {
                            window.clearInterval(sClearTime);
                            clearTimeout(sClearTime);
                            flgOpenGotoMeeting = 1;
                            window.clearInterval(eventStartMeetingTimer);
                            clearTimeout(eventStartMeetingTimer);
                            document.getElementById("ConatntMatter_hdnCounter").value = MeetingRemainingTime;
                            if (MeetingRemainingTime > 0) {
                                $("#ConatntMatter_hdnPhase1Status").val("1");
                                IsUpdateTimer = 1;
                                f1();
                            }
                            if (MeetingRemainingTime == 0) {

                                //$("#btnSubmit").removeAttr("disabled");
                                //$("#btnSubmit").prop("disabled", false);
                                //$("#btnSubmit").removeClass("btn-cancel").addClass("btn-submit");
                                window.clearInterval(sClearTime);
                                clearTimeout(sClearTime);
                            }
                        } else {
                            if (PrepRemainingTime <= 0) {
                                flgOpenGotoMeeting = 1;
                                window.clearInterval(eventStartMeetingTimer);
                                clearTimeout(eventStartMeetingTimer);
                            }
                            document.getElementById("ConatntMatter_hdnCounter").value = PrepRemainingTime < 0 ? 0 : PrepRemainingTime;
                        }

                    }
                }, function (result) {
                    $("#loader").hide();
                    alert("Error-" + result._message);
                });
            } else {
                window.clearInterval(eventStartMeetingTimer);
                clearTimeout(eventStartMeetingTimer);
            }
        }

        function fnUpdateElapsedTime() {
            var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
            PageMethods.fnUpdateTime(RspexerciseId, fnUpdateElapsedTimeSuccess, fnUpdateElapsedTimeFailed);
        }
        function fnUpdateElapsedTimeSuccess(result) {

        }
        function fnUpdateElapsedTimeFailed(result) {
            //    alert(result._message);
        }


        function fnPageLoad() {
            if (SecondCounter > -1) {
                setInterval(function () { FnUpdateTimer() }, 1000);
            }
        }
        // document.onload = fnPageLoad();
   
        function fnValidateTextAreas(Direction) {
            var isValid = true;
            if (Direction == 1) {
                return true;
            }
            $('textarea').each(function () {
                var responseText = $(this).val();
                if (responseText.trim().length == 0) {
                    $(this).focus();
                    fnShowDialog("Please provide your rationale for the options selected.");
                    document.getElementById("btnNext").disabled = false;

                    isValid = false;
                    return isValid
                }
            });

            return isValid;
        }


        function fnShowDialog(msg) {
            $("#dvDialog").html(msg)
            $("#dvDialog").dialog({
                title: "Confirmation:",
                modal: true,
                width: "auto",
                height: "auto",
                option: function () {
                    $("div[aria-describedby='dvDialog']").find("button.ui-dialog-titlebar-close").hide();
                },
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "OK": function () {
                        $(this).dialog('close');
                    }
                }
            })
        }

        function fnNext() {
            //  alert("1")
            var Direction = 2;
            var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
            document.getElementById("btnNext").disabled = true;
            if (flgExerciseStatus != 2) {
                if (fnCheckValidationForRadio(2) == false) {

                    return false;
                }
                if (fnCheckValidationForCheckbox(2) == false) {

                    return false;
                }

                //if (fnValidateTextAreas(2) == false) {
                //   return false;
                //}
                //  debugger;

                //fnUpdateElapsedTime();
                //   alert("2")
                var Status = 1;

                var strRet = fnMakeStringForSave();
                //    alert(strRet)
                //    alert("11")

                $(window).scrollTop(0);
                if (document.getElementById("ConatntMatter_hdnPageNmbr").value == TotalQuestions) {
                    Status = 2
                    //alert(strRet)
                    $("#dvDialog").html("Are you sure you have completed this exercise ?<br/>Click OK if you have completed. Please note you will not be able to resume once you click OK.<br/>Click Cancel if you have NOT completed and need to go back to complete.")
                    $("#dvDialog").dialog({
                        title: "Confirmation:",
                        modal: true,
                        width: "auto",
                        height: "auto",
                        option: function () {
                            $("div[aria-describedby='dvDialog']").find("button.ui-dialog-titlebar-close").hide();
                        },
                        close: function () {
                            $(this).dialog('destroy');
                        },
                        buttons: {
                            "OK": function () {
                                $(this).dialog('close');
                                fnSaveData(Status, strRet, Direction, 0);
                            },
                            "Cancel": function () {
                                $(this).dialog('close');
                                document.getElementById("btnNext").disabled = false;
                            }
                        }
                    })
                    //if (window.confirm()) {

                    //}
                    //else {

                    //}
                }
                else {
                    document.getElementById("dvLoadingImg").style.display = "block";
                    //  alert("22")
                    fnSaveData(Status, strRet, Direction, 0)
                }
            } else {
                document.getElementById("dvLoadingImg").style.display = "block";
                var PgNmbr = document.getElementById("ConatntMatter_hdnPageNmbr").value
                if (Direction == 2) {
                    PgNmbr = parseInt(PgNmbr, 10) + 1
                }
                else {
                    PgNmbr = parseInt(PgNmbr, 10) - 1
                }
                // alert("PgNmbr=" + PgNmbr)
                if (PgNmbr <= TotalQuestions) {
                    var ExerciseID = document.getElementById("ConatntMatter_hdnExerciseID").value;
                    var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
                    var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
                    PageMethods.fnGetStatement(RspexerciseId, ExerciseID, PgNmbr, flgExerciseStatus, TotalQuestions, BandID,
                        function (result) {
                            if (result.split("@")[0] == "1") {
                                document.getElementById("ConatntMatter_hdnPageNmbr").value = PgNmbr;
                                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("@")[1];

                                document.getElementById("btnNext").disabled = false;
                                document.getElementById("dvLoadingImg").style.display = "none";


                                if (document.getElementById("ConatntMatter_hdnPageNmbr").value == TotalQuestions) {
                                    document.getElementById("btnNext").style.display = "none";
                                    document.getElementById("btnPrevious").style.display = "inline-block";
                                }
                                else if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 1) {
                                    document.getElementById("btnNext").style.display = "inline-block";
                                    document.getElementById("btnPrevious").style.display = "none";
                                }
                                else if (document.getElementById("ConatntMatter_hdnPageNmbr").value > 1) {
                                    document.getElementById("btnNext").style.display = "inline-block";
                                    document.getElementById("btnPrevious").style.display = "inline-block";
                                }
                                else {
                                    document.getElementById("btnNext").value = "Next";
                                }
                            }
                        },
                        function (result) {

                        })
                }
            }

        }

        function fnPrevious() {
            //fnUpdateElapsedTime();
            var Direction = 1;
            var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
            if (flgExerciseStatus != 2) {
                if (fnCheckValidationForRadio(1) == false) {

                    return false;
                }
                if (fnCheckValidationForCheckbox(1) == false) {

                    return false;
                }

               // if (fnValidateTextAreas(1) == false) {
                //    return false;
                //}
                var Status = 1;
                var strRet = fnMakeStringForSave();

               
                
                fnSaveData(Status, strRet, Direction, 0)
            } else {
                $(window).scrollTop(0);
                document.getElementById("dvLoadingImg").style.display = "block";
                var PgNmbr = document.getElementById("ConatntMatter_hdnPageNmbr").value
                if (Direction == 2) {
                    PgNmbr = parseInt(PgNmbr, 10) + 1
                }
                else {
                    PgNmbr = parseInt(PgNmbr, 10) - 1
                }
                // alert("PgNmbr=" + PgNmbr)
                if (PgNmbr <= TotalQuestions) {
                    var ExerciseID = document.getElementById("ConatntMatter_hdnExerciseID").value;
                    var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
                    var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
                    PageMethods.fnGetStatement(RspexerciseId, ExerciseID, PgNmbr, flgExerciseStatus, TotalQuestions, BandID,
                        function (result) {
                            if (result.split("@")[0] == "1") {
                                document.getElementById("ConatntMatter_hdnPageNmbr").value = PgNmbr;
                                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("@")[1];

                                document.getElementById("btnNext").disabled = false;
                                document.getElementById("dvLoadingImg").style.display = "none";

                                

                                if (document.getElementById("ConatntMatter_hdnPageNmbr").value == TotalQuestions) {
                                    document.getElementById("btnNext").style.display = "none";
                                    document.getElementById("btnPrevious").style.display = "inline-block";
                                }
                                else if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 1) {
                                    document.getElementById("btnNext").style.display = "inline-block";
                                    document.getElementById("btnPrevious").style.display = "none";
                                }
                                else if (document.getElementById("ConatntMatter_hdnPageNmbr").value > 1) {
                                    document.getElementById("btnNext").style.display = "inline-block";
                                    document.getElementById("btnPrevious").style.display = "inline-block";
                                }
                                else {
                                    document.getElementById("btnNext").value = "Next";
                                }
                            }
                        },
                        function (result) {

                        })
                } 
            }
        }


        function fnSaveData(Status, objDetail, Direction, flgTimeOver) {
            objDetail = objDetail == "" ? [] : objDetail;
            var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
            var PgNmbr = document.getElementById("ConatntMatter_hdnPageNmbr").value
            PageMethods.spUpdateResponsesForSJT(RspexerciseId, Status, PgNmbr, objDetail, flgTimeOver, fnUpdateResponsesForSJTSuccess, fnUpdateResponsesForSJTFailed, Direction + "^" + Status);
        }

        function fnUpdateResponsesForSJTSuccess(result, strRep) {
            if (result.split("^")[0] == "1") {
                // alert("Success")
                //window.location.href=""
                var ExerciseID = document.getElementById("ConatntMatter_hdnExerciseID").value;
                var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
                var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
                var PgNmbr = document.getElementById("ConatntMatter_hdnPageNmbr").value
                
                var Direction = strRep.split("^")[0]
                var Status = strRep.split("^")[1]
                if (Status == 2) {
                    fnShowDialog("Your responses have been submitted successfully");
                    window.location.href = "../Exercise/ExerciseMain.aspx";
                    return false;
                }

                if (Direction == 2) {
                    PgNmbr = parseInt(PgNmbr, 10) + 1
                }
                else {
                    PgNmbr = parseInt(PgNmbr, 10) - 1
                }
               // alert("PgNmbr=" + PgNmbr)
                if (PgNmbr <= TotalQuestions) {
                    PageMethods.fnGetStatement(RspexerciseId, ExerciseID, PgNmbr, flgExerciseStatus, TotalQuestions, BandID,
                        function (result) {
                            if (result.split("@")[0] == "1") {
                                document.getElementById("ConatntMatter_hdnPageNmbr").value = PgNmbr;
                                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("@")[1];

                                document.getElementById("btnNext").disabled = false;
                                document.getElementById("dvLoadingImg").style.display = "none";

                                if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 1) {
                                    document.getElementById("btnPrevious").style.display = "none";
                                }
                                else {
                                    document.getElementById("btnPrevious").style.display = "inline-block";
                                }

                                if (document.getElementById("ConatntMatter_hdnPageNmbr").value == TotalQuestions) {
                                    document.getElementById("btnNext").value = "Submit";
                                }
                                else {
                                    document.getElementById("btnNext").value = "Next";
                                }
                            }
                        },
                        function (result) {

                        })
                }
                else { window.location.href = "../Exercise/ExerciseMain.aspx"; }

            }
        }
        function fnUpdateResponsesForSJTFailed(result) {

        }

        function fnPlayVideo(ctrl) {
            var videoUrl = $(ctrl).attr('VideoUrl');

            $("#dvVideo")[0].innerHTML = "<center><video id='video' width='400' height='300' autoplay controls controlsList='nodownload'><source src='" + videoUrl + "' type='video/mp4'></video></center>";
            $("#dvVideo").dialog({
                title: 'Video',
                modal: true,
                width: 'auto',
                buttons: [{
                    text: "Close",
                    click: function () {
                        $("#dvVideo").dialog("close");
                    }
                }],
                close: function (event) {
                    $("#video")[0].pause();
                }
            });
        }

        function fnCaseExercise() {
            window.location.href = "CaseStudyInstructions_Technical2.aspx?RspID=" + $("#ConatntMatter_hdnRspID").val() + "&ExerciseID=" + $("#ConatntMatter_hdnExerciseID").val() + "&intLoginID=" + $("#ConatntMatter_hdnLoginID").val();
            //$("#divCaseStudy").dialog({
            //    title: 'Case Study ',
            //    modal: true,
            //    width: '80%',
            //    height: '500',
            //    buttons: [{
            //        text: "Close",
            //        click: function () {
            //            $("#divCaseStudy").dialog("close");
            //        }
            //    }],
            //    close: function (event) {
            //        $("#divCaseStudy").dialog("destroy");
            //    }
            //});
        }

    </script>
    <script type="text/javascript">
        function fnLogout() {
            fnUpdateElapsedTime();
            window.location.href = "../Login.aspx";
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime">Time Left<br />
        00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Technical Case Study</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="clearfix mb-2" id="dvMain" runat="server"></div>
    <div class="text-center">
        <input type="button" id="btnPrevious" value="Previous" onclick="fnPrevious()" class="btns btn-cancel" />
        
        <input type="button" id="btnNext" value="Next" onclick="fnNext()" class="btns btn-submit" />
        <input type="button" style="display: None" id="btnSaveExit" value="Exit" onclick="fnExitExercise()" class="btns btn-submit" />
     <input type="button" style="float:right" id="btnCaseStudy" value="Go to Case Study" onclick="fnCaseExercise()" class="btns btn-submit" />
   
    </div>

    <div id="dvLoadingImg" class="loader_bg">
        <div class="loader"></div>
    </div>
    <div id="dvDialog" style="display: none"></div>
    <div id="dvAlertDialog" style="display: none" runat="server"></div>
    <div id="dvVideo" style="display: none"></div>

    
       <div id="divCaseStudy"  style="display: none">
            <div class="section-title">
        <h3 class="text-center">Instructions for Participants</h3>
        <div class="title-line-center"></div>
    </div>

        <div class="row">
        <%-- <div class="col-md-4">
            <div class="about-img-one">
                <img src="../../Images/instruction.jpg" />
            </div>
        </div>--%>
        <div class="col-md-12">
            <div class="info-about mt-2">
                <p>
                    In the following case study, you will be presented with a scenario related to a fictitious organization. 
Your task is to read through the case study carefully, paying attention to the challenges faced by the 
organization. Based on the details provided in the case study, you will be asked to select the most 
appropriate course of action for addressing the identified issues.
                </p>

                 <div class="section-title">
        <h3 class="text-center">Case Study: Gupta Auto Dealership</h3>
        <div class="title-line-center"></div>
    </div>

                <p>
                    Gupta Auto, a 65-year-old dealership with a rich legacy, has been a trusted name in its region for 
decades. Located in a thriving IT hub that has witnessed significant business growth in recent years, the 
dealership should ideally be experiencing increased service volumes. However, Gupta Auto is grappling 
with stagnation in service business for the past three years, leading to rising overhead costs and 
declining profitability.
                </p>

                <p><strong>Key Issues:</strong></p>

                <ol>
                    <li>Low Net Promoter Score (25): The dealership's Net Promoter Score (NPS) of 25 falls well below 
the industry benchmark, highlighting dissatisfaction with the quality of service and overall 
customer experience. Customers frequently complain about delays in service, lack of 
responsiveness, and poor issue resolution, all of which contribute to declining customer loyalty.</li>

                    <li>Poor Online Reputation (Google Rating: 3.0): Gupta Auto’s online presence has suffered, with a 
Google rating of 3.0 out of 5. Negative reviews often criticize the dealership for long service 
times, lack of communication, and inadequate customer support. In today's digital-driven world, 
such a reputation severely hinders the dealership’s ability to attract new customers and grow its 
business.
                    </li>
                    <li>Low Technical Support Efficiency (Rework Rate: 35%): Gupta Auto is facing a 35% rework rate in 
service repairs due to unstructured technical assistance and troubleshooting procedures. The 
lack of clear escalation protocols and expert guidance for complex issues has led to extended 
service times, averaging 3.5 days beyond estimates, resulting in customer frustration and higher 
service costs.
                    </li>
                    <li>Insufficient Skill Development & Training (Training Completion Rate: 40%): The dealership’s 
service team is hindered by inadequate skill development programs, with only 40% of employees 
completing technical and soft-skill training. This has led to extended service times and customer 
complaints about poor communication and lack of technical proficiency.</li>

                    <li>Operational Inefficiencies & Poor Dealership Management (Service Backlog: 30%): Gupta Auto is 
facing inefficiencies due to a lack of standardized processes. The service department has a 30% 
backlog, with issues often carried over daily. The absence of performance management systems 
has led to inconsistent service delivery, missed targets, and delayed customer commitments. 
Additionally, low service bay utilization (60% vs. the industry standard of 85%) is further 
exacerbating the problem.
                    </li>
                </ol>

                <p>
                    These challenges have led to a stagnant service business, low customer satisfaction, and declining 
profitability. Despite the potential for growth in the IT hub, Gupta Auto is struggling to meet customer 
expectations, resulting in poor retention and a damaged reputation. The Territory Manager (TM) has 
been called upon frequently to intervene, addressing both technical and service-related complaints 
during visits.
                </p>

                <p>The core challenge now lies in identifying the root causes behind these issues and implementing a targeted, effective strategy for improvement.</p>

            </div>
        </div>
    </div>
     </div>

    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMeetingDefaultTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeLeft" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPDetID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspIDStr" runat="server" Value="0" />
    <asp:HiddenField ID="hdnQstnCntr" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdnPhase1Status" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTotalQuestions" runat="server" Value="0" />
    <asp:HiddenField ID="hdnBandID" runat="server" Value="0" />
     <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />
    <input id="hdnSaveType" type="hidden" size="2" name="hdnSaveType" runat="server" />
    <input id="hdnPageNmbr" type="hidden" size="2" name="hdnPageNmbr" runat="server" />
    <input id="hdnDirection" type="hidden" size="2" name="hdnDirection" runat="server" />
    <input id="hdnResult" type="hidden" name="hdnResult" runat="server" />
    <input id="hdnStatusValue" type="hidden" name="hdnStatusValue" runat="server" />
    <asp:Button ID="btnSaveASP" Style="visibility: hidden" runat="server" Text="Save"></asp:Button>

</asp:Content>


