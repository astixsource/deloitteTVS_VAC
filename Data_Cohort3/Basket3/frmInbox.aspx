<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInbox.aspx.cs" Inherits="frmInbox" ValidateRequest="false"
    EnableEventValidation="false" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <!-- viewport meta to Content-Type -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <!-- viewport meta to reset Web-app inital scale -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="grey" />

    <!-- viewport meta to reset iPhone inital scale -->
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0," />

    <link href="../../CSS/font-awesome.css" rel="stylesheet" />
    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        body {
            overflow: hidden;
        }

        .inbox-title {
            background: #0076A8;
            color: #FFF;
            position: relative;
            padding-left: 30px !important;
            padding: 7px;
        }

            .inbox-title > img.mail-icon {
                width: 16px;
                height: 16px;
                position: absolute;
                top: 14px;
                left: 6px;
            }

        .mail-row-default {
            color: #202124;
            background: rgba(255,255,255,0.902);
            font-weight: 600;
            cursor: pointer;
        }

        .replymail-title {
            padding: 5px;
            background: #DFDFDF;
            border-bottom: 1px solid #959595;
            margin-top: 5px;
        }

        .dvddlPrority {
            font-size: 1rem;
            text-align: center;
            margin: 0 auto;
            width: 215px;
        }

        table#ddlPrority > tbody > tr > td > label {
            padding: 0 6px;
        }

        table.dvAction-table {
            width: 100%;
            margin-bottom: 0;
            border-bottom: 1px solid #849ab0;
            background: #0076A8;
        }

            table.dvAction-table > tbody > tr > td {
                padding: 7px 10px;
                text-align: left;
                white-space: nowrap;
            }

                table.dvAction-table > tbody > tr > td > a {
                    font-weight: bold;
                    color: #FFF;
                }

        .table-sm th {
            padding: .3rem .75rem;
            font-size: 0.8rem;
        }

        .btn-xs {
            padding: .15rem .5rem !important;
            font-size: .775rem !important;
        }

        .btn-exit {
            padding: 0 .5rem;
            float: right;
            font-size: 1.5rem;
            font-weight: 700;
            line-height: 1;
            color: #FFF;
            text-shadow: 0 1px 0 #fff;
            opacity: .85;
            cursor: pointer
        }

        .clsRowBgColor {
            background-color: #fff8c4;
        }

        table#GrdInbox > tbody > tr {
            cursor: pointer;
        }

        a.btns, .btns {
            background: #fff;
            color: #959595;
            border: none;
            margin-right: 5px;
            text-align: center;
            padding: 10px 20px;
            position: relative;
            display: inline-block;
            border-radius: 3px;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            text-decoration: none;
            outline: none;
            -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            -webkit-transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

            a.btns:hover, .btns:hover {
                color: #8b8b8b;
                text-decoration: none;
                -webkit-box-shadow: 0 7px 14px rgba(0, 0, 0, 0.18), 0 5px 5px rgba(0, 0, 0, 0.12);
                -moz-box-shadow: 0 7px 14px rgba(0, 0, 0, 0.18), 0 5px 5px rgba(0, 0, 0, 0.12);
                box-shadow: 0 7px 14px rgba(0, 0, 0, 0.18), 0 5px 5px rgba(0, 0, 0, 0.12);
            }

            .btns.btn-submit {
                color: #fff;
                background-color: #26890d;
                border: 2px solid #26890d;
            }

                .btns.btn-submit:hover {
                    background-color: #43b02a;
                    border: 2px solid #43b02a;
                    color: #000 !important;
                }
    </style>

    <script src="../../Scripts/jquery.min-3.6.0.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="../../Scripts/validation.js" type="text/javascript"></script>
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
        document.onmousedown = disableclick;
        status = "Right Click Disabled";
        function disableclick(event) {
            if (event.button == 2) {
                //     alert(status);
                return false;
            }
        }
        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
    </script>


    <script type="text/javascript">
        $(document).ready(function () {
            parent.screenTop(0, 0);
            $("#panellogout,#panelback").hide();
            //$("#ddlPrority").css({"display": "inline-block"});

            $("#dvInbox").css({
                "height": $(window).height() - 190 + "px",
                "overflow": "auto"
            });
            $("#dvMailBody").css({
                "height": $(window).height() - 45 + "px",
                "overflow": "auto",
                "background": "#FFF"
            });
            $("#iFrameReplyMail").css({
                "height": $(window).height() - 50 + "px",
                'overflow': 'hidden'
            });
            $(".ajax__html_editor_extender_texteditor").css();
            parent.fnEndLoading();
            $('#GrdInbox tr').css("cursor", "pointer");

            GrdRowcnt = $('#GrdInbox tr').length;
            $('#GrdInbox').find('td').html(function () { // for every paragraph in container
                if (this.cellIndex > 1) {
                    if (this.cellIndex == 5) {
                        //debugger;
                        if ($(this).html().length > 45) {
                            $(this).attr("title", $(this).html());
                            var content = $(this).html().split('');
                            var cutLength = 45;

                            anterior = content.slice(0, cutLength).join('');
                            $(this).html(anterior + "....");
                        }
                    }
                    else if (this.cellIndex == 6) {
                        if ($(this).html().length > 81) {
                            $(this).attr("title", $(this).html());
                            var content = $(this).html().split('');
                            var cutLength = 81;

                            anterior = content.slice(0, cutLength).join('');
                            $(this).html(anterior + "....");
                        }
                    }
                }
            });

           
        });

        var eventStartMeetingTimer; var flgOpenGotoMeeting = 0;
        function fnStartMeetingTimer() {

            //$("#loader").show();
            if (flgOpenGotoMeeting == 0) {
                var RspExerciseID = $("#hdnRSPExerciseID").val();
                var MeetingDefaultTime = 0;// $("#ConatntMatter_hdnMeetingDefaultTime").val();
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
                            document.getElementById("hdnCounter").value = MeetingRemainingTime;
                            
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
                            document.getElementById("hdnCounter").value = PrepRemainingTime < 0 ? 0 : PrepRemainingTime;
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
        function fnSuccess(result) {
            if (parseInt(result) == 1) {
                $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].cells[3].innerHTML = "<img src='../../Images/Icons/ReadImg.png'/>";
                $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].style.fontWeight = "";
                $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].setAttribute("ReadStatus", "Read");
            }
        }

        function fnUpdateStatus() {
            $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].cells[3].innerHTML = "<img src='../../Images/Icons/ReadImg.png'/>";
            $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].style.fontWeight = "";
            $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].setAttribute("ReadStatus", "Read");
            $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].setAttribute("flgPriorty", $("input[name='ddlPrority']:checked").val());
            $($('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())]).css("cursor", "default !important;");
            $($('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())]).find("td").removeAttr("onclick");
            $('#dvMailBodyPop').hide();
        }

        function fnRowHighlight(tID) {

            var RspMailInstanceID = $('#GrdInbox tr')[tID.parentNode.rowIndex].cells[0].innerHTML;
            var RSPExerciseID = $("#hdnRSPExerciseID").val();
            var flgMailHighlight = 0;
            var trIndex = tID.parentNode.rowIndex;
            if ($('#GrdInbox tr').eq(tID.parentNode.rowIndex).hasClass("clsRowBgColor") == true) {
                flgMailHighlight = 0
                $($('#GrdInbox tr')[trIndex]).removeClass("clsRowBgColor");
            }
            else {
                flgMailHighlight = 1
                $($('#GrdInbox tr')[trIndex]).addClass("clsRowBgColor");
            }
            PageMethods.fnUpdateMultiMailflgReadLater(RSPExerciseID, RspMailInstanceID, flgMailHighlight, fnUpdateSuccess, fnUpdateFailed, trIndex + "^" + flgMailHighlight);
        }


        function fnUpdateSuccess(result, tID) {
            if (result == "1") {
                if (tID.split("^")[1] == "0") {
                    $($('#GrdInbox tr')[tID.split("^")[0]]).removeClass("clsRowBgColor")
                }
                else {
                    $($('#GrdInbox tr')[tID.split("^")[0]]).addClass("clsRowBgColor")
                }

            }
        }
        function fnUpdateFailed(result) {

        }

        var flgPriorty = 0;
        function fnOpenMailBody(tID) {
            if ($("#hdnIndexNo").val() == -1) {

                $("#hdnIndexNo").val(tID.parentNode.rowIndex);

            }
            else {

                $("#hdnIndexNo").val(tID.parentNode.rowIndex);


            }

            //$('#GrdInbox tr')[tID.parentNode.rowIndex]
            $("#hdnRspMailInstanceID").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[0].innerHTML);
            $("#hdnExerciseMultiMailID").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[1].innerHTML);
            $("#hdnRowIndex").val(tID.parentNode.rowIndex);
            flgPriorty = $('#GrdInbox tr')[tID.parentNode.rowIndex].getAttribute("flgpriorty");
            
            $("#dvAction").removeAttr("style").attr("style", "display:block");
            if ($('#GrdInbox tr')[tID.parentNode.rowIndex].getAttribute("ReadStatus") == "Unread") {
                PageMethods.fnMarkReaddStatus(parseInt($("#hdnRspMailInstanceID").val().trim()), 1, fnSuccess);
            }

            var MailOrderNo = $('#GrdInbox tr')[tID.parentNode.rowIndex].cells[9].innerHTML;


            //  debugger;

            $("#hdnMailOrderNo").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[9].innerHTML);
            $("#hdnMailFrom").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[12].innerHTML);
            $("#hdnSubject").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[13].innerHTML);
            $("#hdnCc").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[10].innerHTML);
            $("#hdnTo").val($('#GrdInbox tr')[tID.parentNode.rowIndex].cells[11].innerHTML);
            // $("#Iframe3")[0].src = "frmMailBody.aspx?getActiveIndex=" + id;
            $.ajax({
                url: "frmMailBody.aspx?getActiveIndex=" + MailOrderNo,
                type: "Post",
                datatype: "text",
                success: function (data) {
                    //debugger;
                    //$("#dvframe3").html($($(data)[9].innerHTML)[4].innerHTML);
                    $("#dvMailBody").html(data);
                    $("#dvMailBodyPop").show();
                    $('.btn-exit1').on('click', function () {
                        $("#dvMailBody").html("");
                        $('#dvMailBodyPop').hide();
                    });

                    
                }
            });


            //$('#lblID').html(id);
        }

        function fnOpenreplyPageOLD(flgType) {
            $("input[name='ddlPrority'][value='" + flgPriorty + "']").prop("checked", true);
            //$("#ddlPrority").find("input[value='" + flgPriorty +"']").prop("selected", true);
            document.getElementById("iFrameReplyMail").src = "frmBasketQues.aspx?ExerciseID=" + $("#hdnExerciseID").val() + "&MultiMailQstnID=" + $("#hdnExerciseMultiMailID").val() + "&RSPExerciseID=" + $("#hdnRSPExerciseID").val() + "&RspMailInstanceID=" + $("#hdnRspMailInstanceID").val();
            $('#dvReplyMail').css({ "display": "block", "overflow": "hidden" });
            $('.btn-exit1').on('click', function () {
                $('#dvReplyMail').css("display", "none");
            });

            return false;
        }

        function fnOpenreplyPage(flgType) {
            $("input[name='ddlPrority']").prop("checked", false);
            //$("input[name='ddlPrority'][value='" + flgPriorty + "']").prop("checked", true);
            //$("#ddlPrority").find("input[value='2']").prop("selected", true);
            document.getElementById("iFrameReplyMail").src = "frmReply.aspx?RspID=" + $("#hdnRspID").val() + "&RspMailInstanceID=" + $("#hdnRspMailInstanceID").val() + "&MailFrom=" + $("#hdnMailFrom").val()
                + "&MailSubject=" + $("#hdnSubject").val() + "&To=" + $("#hdnTo").val() + "&Cc=" + $("#hdnCc").val() + "&MailOrderNo=" + $("#hdnMailOrderNo").val() + "&MailDesc=&flgType=" + flgType;


            $('#dvReplyMail').css({ "display": "block", "overflow": "hidden" });

            $('.btn-exit').on('click', function () {
                $("#dvMailBody").html("");
                $('#dvReplyMail').css("display", "none");
            });

            return false;
        }

        function fnCloseQuestion() {
            $("#dvMailBody").html("");
            $("#iFrameReplyMail")[0].src = "about:blank";
            document.getElementById("iFrameReplyMail").src = "about:blank";
            $('#dvReplyMail').css("display", "none");
            //$("#ddlPrority option[value=0]").prop("checked", true);
        }

        function fnSaveQuestion() {
            fnCloseQuestion();
            $('#dvMailBodyPop').hide();
        }

        function AddParameter(form, name, value) {
            var $input = $("<input />").attr("type", "hidden")
                .attr("name", name)
                .attr("value", value);
            form.append($input);
        }

        function printDiv() {
            //Get the HTML of div
            // var divElements = document.getElementById("dvMailBody").innerHTML;
            var divToPrint = document.getElementById('dvMailBody');
            var popupWin = window.open('', '_blank');
            popupWin.document.open();
            popupWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</html>');
            popupWin.document.close();


        }

        function fnAutoSaveText() {
            var RspMailInstanceID = $("#hdnRspMailInstanceID").val();
            var MailOrderNo = $("#hdnMailOrderNo").val();
            if ($('#dvReplyMail').css("display").toLocaleLowerCase() == "block") {
                if (parseInt(RspMailInstanceID) > 0 && parseInt(MailOrderNo) > 0) {
                    document.getElementById('iFrameReplyMail').contentWindow.fnSaveUserFeedbackAutoSave(2);
                }
            }
        }


        function fnRspSimplecaseUPDAnswersSuccess(result) {

        }
        function fnRspSimplecaseUPDAnswersFailed(result) {
            //alert(result._message);
        }

        function fnUpdateElapsedTime() {
            var RspexerciseId = document.getElementById("hdnRSPExerciseID").value;
            PageMethods.fnUpdateTime1(RspexerciseId, fnUpdateElapsedTimeSuccess, fnUpdateElapsedTimeFailed);
        }
        function fnUpdateElapsedTimeSuccess(result) {

        }
        function fnUpdateElapsedTimeFailed(result) {
            //alert(result._message);
        }

        function fnPageLoad() {
            if (SecondCounter > -1) {
                setInterval(function () { FnUpdateTimer() }, 1000);
            }
        }

        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        function FnUpdateTimer() {
            if (IsUpdateTimer == 0) { return; }

            SecondCounter = document.getElementById("hdnCounter").value;
            if (SecondCounter <= 0) {
                IsUpdateTimer = 0;
                counter = 0;
                alert("Your Time is over now.");
                PageMethods.fnSpINBasetExerciseDone(2, 1, fnSpINBasetExerciseDoneSuccess, fnSpINBasetExerciseDoneFailed);
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
                parent.parent.document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
            }
            else if (Seconds < 10 && Minutes > 9) {
                parent.parent.document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + Minutes + ":" + "0" + Seconds;
            }
            else if (Seconds > 9 && Minutes < 10) {
                parent.parent.document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + "0" + Minutes + ":" + Seconds;
            }
            else if (Seconds > 9 && Minutes > 9) {
                parent.parent.document.getElementById("theTime").innerHTML = "Time Left: 0" + hours + ":" + Minutes + ":" + Seconds;
            }
            document.getElementById("hdnCounter").value = SecondCounter;
            counter++;
            // counterAutoSaveTxt++;
            if (counter == 5) {//Auto Time Update
                counter = 0;
                //SecondCounter = 30;
                //alert("hello");
                fnUpdateElapsedTime();
                //counter = 1;
            }
            /*  if (counterAutoSaveTxt == 40) {//Auto Text Save
              counter = 0;
               fnAutoSaveText();
              counter = 1;
                }*/

            if (((hours * 60) + Minutes) == 15 && Seconds == 0) {
                //customnotify('Alert', 'You have only 15:00 mins remaining. You can click on Final Submit to complete the exercise. After that you will not be able to make any changes.', "");
                $("#divDialogBody")[0].innerHTML = "<center>You have only 15:00 mins remaining. </br> You can click on Final Submit to complete the exercise. After that you will not be able to make any changes.</center>";
                $("#dvDialog").show();
            }

            if (((hours * 60) + Minutes) == 5 && Seconds == 0) {
                //customnotify('Alert', 'You have only 05:00 mins remaining. On completion of your time, your responses will be auto saved and you will be directed to the Homepage.', "");
                $("#divDialogBody")[0].innerHTML = "<center>You have only 05:00 mins remaining. </br> On completion of your time, your responses will be auto saved and you will be directed to the Homepage.</center>";
                $("#dvDialog").show();
            }

            if (SecondCounter == 0) {
                counter = 0;
                IsUpdateTimer = 0;
                fnUpdateElapsedTime();
                fnAutoSaveText();
                alert("Your Time is over now");
                PageMethods.fnSpINBasetExerciseDone(2, 1, fnSpINBasetExerciseDoneSuccess, fnSpINBasetExerciseDoneFailed);
                //window.location.href = "frmExerciseMain_New.aspx?intLoginID=" + document.getElementById("hdnLoginID").value;
            }
        }
        function fnCloseModal() {
            $("#dvDialog").hide();
        }
        function fnShowDialog(msg) {
            $("#dvDialog1").html(msg)
            $("#dvDialog1").dialog({
                title: "Confirmation:",
                modal: true,
                width: "auto",
                height: "auto",
                option: function () {
                    $("div[aria-describedby='dvDialog1']").find("button.ui-dialog-titlebar-close").hide();
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
        function fnCheck() {
            $.ajax({
                url: "../../WebService.asmx/fnValidateUserInboxStatus",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: "{'RspExerciseID':'" + document.getElementById("hdnRSPExerciseID").value + "'}",
                dataType: "json",
                success: function (data) {

                    $("#dvDialog1").html("Please ensure you have responded to all emails. No changes will be done after final submit")
                    $("#dvDialog1").dialog({
                        title: "Confirmation:",
                        modal: true,
                        width: "auto",
                        height: "auto",
                        option: function () {
                            $("div[aria-describedby='dvDialog1']").find("button.ui-dialog-titlebar-close").hide();
                        },
                        close: function () {
                            $(this).dialog('destroy');
                        },
                        buttons: {
                            "Yes": function () {
                                $(this).dialog('close');
                                var flgExerciseStatus = 2;

                               // IsUpdateTimer = 0;
                                //   alert("here")
                                PageMethods.fnSpINBasetExerciseDone(flgExerciseStatus, 0, fnSpINBasetExerciseDoneSuccess, fnSpINBasetExerciseDoneFailed);
                            },
                            "No": function () {
                                $(this).dialog('close');
                            }
                        }
                    })
                },
                error: function (xhr) {
                    //alert("Error-" + xhr.responseText);
                    return false;
                }
            });

        }
        $(document).ready(function () {
            var PrepStatus = $("#ConatntMatter_hdnPrepStatus").val();
            var MeetingStatus = $("#ConatntMatter_hdnMeetingStatus").val();
            var flgExerciseStatus = $("#ConatntMatter_hdnExerciseStatus").val();
            //if (PrepStatus == 0 && MeetingStatus == 0) {
            //    PrepStatus = PrepStatus == 0 ? 1 : PrepStatus;
            //    MeetingStatus = MeetingStatus == 0 ? 1 : MeetingStatus;
            //    fnUpdateActualStartEndTime(PrepStatus, MeetingStatus);
            //}
            if (flgExerciseStatus < 2) {
                eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 5000);
            }
        });
        function fnSpINBasetExerciseDoneSuccess(result) {
            fnShowDialog("Your responses have been submitted successfully");
            parent.frames.location.href = "../Exercise/ExerciseMain.aspx?intLoginID=" + document.getElementById("hdnLoginID").value;
        }
        function fnSpINBasetExerciseDoneFailed(result) {
            fnShowDialog("Oops! Something went wrong. Please try again.");
        }
        function fnback() {
            parent.frames.location.href = "../frmBasket_Instructions.aspx?ExerciseID=" + document.getElementById("hdnExerciseID").value + "&ElapsedTimeMin=" + document.getElementById("hdnTimeElapsedMin").value + "&ElapsedTimeSec=" + document.getElementById("hdnTimeElapsedSec").value + "&TotalTime=" + document.getElementById("hdnExerciseTotalTime").value + "&RspID=" + document.getElementById("hdnRspID").value + "&BandID=1&ExerciseType=" + document.getElementById("hdnExerciseID").value + "&intLoginID=" + document.getElementById("hdnLoginID").value;
        }

    </script>

    <script type="text/javascript">

        document.addEventListener('DOMContentLoaded', function () {
            if (Notification.permission !== "granted") {
                Notification.requestPermission();
            }
        });
        function customnotify(title, desc, url) {

            if (Notification.permission !== "granted") {
                Notification.requestPermission();
            }
            else {
                var notification = new Notification(title, {
                    icon: '../../Images/LT-logo.png',
                    body: desc,
                });

                /* Remove the notification from Notification Center when clicked.*/
                //notification.onclick = function () {
                //    window.open(url);
                //};

                /* Callback function when the notification is closed. */
                notification.onclose = function () {
                    //console.log('Notification closed');
                };
            }
        }
    </script>
</head>
<body onload="fnPageLoad()">
    <%--oncontextmenu="return false"--%>
    <form id="Inbox" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="inbox-title">
                    <img src="../../Images/Icons/Inbox-icon.png" class="mail-icon" />
                    Inbox
                </div>
                <table id="Table1" class="table table-sm mb-0" style="background: #f1f1f1;" >
                    <tr valign="middle">
                        <th scope="col" style="width: 4.5%;">&nbsp;</th>
                        <th scope="col" style="width: 1%;">&nbsp;</th>
                        <th scope="col" style="width: 25.5%; text-align: left;">From</th>
                        <th scope="col" style="width: 40%; text-align: left;">Subject</th>
                        <th scope="col" style="width: 14%; text-align: left;">Receiving Date</th>
                        <th scope="col" style="width: 14%; text-align: left;">Receiving Time</th>
                    </tr>
                </table>
                <div id="dvInbox">
                    <table id="GrdInbox" class="table table-hover">
                        <tbody id="tbody1" runat="server">
                        </tbody>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div id="dvMailBodyPop" style="display: none" class="modal">
             <div id="dvAction" runat="server" class="bg-light d-flex flex-nowrap p-1 border-bottom">
                <div class="p-1" >
                    <button type="button" id="Answer"  class="btn btn-outline-primary btn-sm" onclick="fnOpenreplyPage(2);"><i class="fa fa-reply mr-6"></i>&nbsp;Answer</button>
                </div>
                <div class="p-1 ml-auto">
                    <button type="button" id="exit" class="btn btn-outline-primary btn-sm btn-exit1"><i class="fa fa-times"></i></button>
                </div>
            </div>
            <div id="dvMailBody" class="bg-white p-3"></div>


        </div>
        <div class="text-center p-1" style="background: #CFCFCF;bottom:0px; position:fixed;width:100%">
            <input type="button" value="Back" style="display: none" onclick="fnback()" class="btns btn-cancel" />
<table style='width:100%'><tr>
<td style='text-align:left;font-size:9pt;'>•	Once you have responded to all emails, please click the submit button to complete the exercise.<br/>•	Your responses will auto submit after the 60 minutes have completed.<br />•	Please ensure you go through all emails in the time provided</td><td style='width:22%'><input type="button" value="Submit" onclick="fnCheck()" class="btns btn-submit" /></td>
</tr></table>
            
            
        </div>

        <div id="dvReplyMail" class="modal" style="display: none;background:#FFFFFF" title="Reply">
            <div class="bg-light p-1 border-bottom">
                <div class="p-1" id="dvBackBtn">
                    <button type="button" class="btn btn-outline-primary btn-sm" onclick="fnCloseQuestion()"><i class="fa fa-arrow-left mr-6"></i>&nbsp;Back</button>
                </div>
                 <div style="display:inline-block;float:right;margin:8px">
                            
                                <table style="width:100%">
                                    <tr>
                                        <td style="padding:3px;vertical-align:top">
                                            <b>Select Priority : </b>
                                        </td>
                                        <td>
                                            <div class="dvddlPrority">
                                            <asp:RadioButtonList ID='ddlPrority' runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="1">Low</asp:ListItem>
                                    <asp:ListItem Value="2">Medium</asp:ListItem>
                                    <asp:ListItem Value="3">High</asp:ListItem>
                                               
                                </asp:RadioButtonList>
                                                 </div>
                                        </td>
                                    </tr>
                                </table>
                                
                                

                           
                        </div>

            </div>
             <iframe frameborder="0" src="" id="iFrameReplyMail" width="100%" height="95%"  style="vertical-align: middle;"> Please wait...</iframe>
        </div>

        <asp:HiddenField runat="server" ID="hdnRspID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnExerciseMultiMailID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnRspMailInstanceID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnMailOrderNo" Value="0" />
        <asp:HiddenField runat="server" ID="hdnMailFrom" Value="" />
        <asp:HiddenField runat="server" ID="hdnSubject" Value="" />
        <asp:HiddenField runat="server" ID="hdnCc" Value="" />
        <asp:HiddenField runat="server" ID="hdnTo" Value="" />
        <asp:HiddenField runat="server" ID="hdnRowIndex" Value="0" />
        <asp:HiddenField runat="server" ID="hdnIndexNo" Value="-1" />
        <asp:HiddenField runat="server" ID="hdnGrdRowcnt" Value="0" />

        <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
        <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
        <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
        <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
        <asp:HiddenField ID="hdnTimeLeft" runat="server" Value="0" />
        <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnRSPDetID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnPrepStatus" runat="server" Value="0" />
        <asp:HiddenField ID="hdnMeetingStatus" runat="server" Value="0" />
        <asp:HiddenField ID="hdnExerciseStatus" runat="server" Value="0" />
        
        <div id="dvDialog" style="display: none; width: 340px;margin:40px 30%" class="modal" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document" style="width: auto; margin: 0px">
                <div class="modal-content" style="padding: 2px;">
                    <div class="modal-header" style="padding: 2px">
                        <h7>Alert</h7>
                    </div>
                    <div class="modal-body" style="padding: 2px; padding-top: 0px; height: auto; overflow-y: auto; background: #CFCFCF;" id="divDialogBody">
                    </div>
                    <div class="modal-footer" style="padding: 8px 30px 6px 5px">
                        <button type="button" data-backdrop="static" data-keyboard="false" class="btn btn-primary orange" onclick="fnCloseModal()">OK</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="dvDialog1" style="display: none" ></div>
        <div id="dvAlertDialog" style="display: none" runat="server"></div>
    </form>
</body>
</html>
