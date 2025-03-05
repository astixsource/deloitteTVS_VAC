<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/LeftPanel.master" AutoEventWireup="false" CodeFile="frmFactFinding.aspx.vb" Inherits="Level12_FactFinding_frmFactFinding" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
     <style type="text/css">
        .ui-dialog .ui-dialog-content {
            overflow-x: hidden !important;
        }
    </style>
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#li_5").hide();

        });
    </script>

     <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        var TimerText = "Preparation Time Left : ";
        var isPrepTimeFinished = 1;
        f1();
       // hdnCounterRunTime
        function f1() {
            $(document).ready(function () {
                //function FnUpdateTimer() {
                var LngID = $("#hdnLngID").val();
                if (IsUpdateTimer == 1) {
                    if (parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value) == 0 && parseInt(document.getElementById("ConatntMatterRight_hdnCounterRunTime").value) == 0) {

                        TimerText = "Discussion Time Left : ";

                        flgOpenGotoMeeting = 1;
                        isPrepTimeFinished = 0;
                        IsUpdateTimer = 0;
                        document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
                        // clearTimeout(sClearTime);
                        window.clearInterval(sClearTime);
                        clearTimeout(sClearTime);
                        window.clearInterval(eventStartMeetingTimer);
                        clearTimeout(eventStartMeetingTimer);
                        alert("Your discussion time is over, Kindly click on 'Close Exercise' button to complete your exercise");
                     //   debugger;
                        $("#btnSubmit").attr("disabled", false);
                        return false;
                    } else if (parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value) == 0 && parseInt(document.getElementById("ConatntMatterRight_hdnCounterRunTime").value) > 0) {

                        TimerText = "Discussion Time Left : ";

                        document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
                        isPrepTimeFinished = 0;
                        IsUpdateTimer = 0;
                        window.clearInterval(sClearTime);
                        clearTimeout(sClearTime);
                        document.getElementById("ConatntMatterRight_hdnCounter").value = document.getElementById("ConatntMatterRight_hdnCounterRunTime").value;
                        document.getElementById("ConatntMatterRight_hdnCounterRunTime").value = 0;
                        fnUpdateActualStartEndTime(1, 2);
                        //  alert("Your preparation time is over. Please click on Go To Meetings to start your discussion with Assessor");
                        alert("Your preparation time is over. Please join the Microsoft teams invite to have a discussion with Assessor");

                        fnGoToMeeting();
                        eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 3000);
                        return false;
                    }
                }
                if (IsUpdateTimer == 0) { return; }
                SecondCounter = parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value);
                if (SecondCounter <= 0) {
                    IsUpdateTimer = 0;
                    //alert("Your Time is over now")
                    counter = 0;
                    //(2, "", 2, 1);
                    return;
                }
                SecondCounter = SecondCounter - 1;
                hours = Math.floor(SecondCounter / 3600);
                Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
                Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);

                if (Seconds < 10 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds < 10 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds > 9 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + "0" + Minutes + ":" + Seconds;
                }
                else if (Seconds > 9 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + Minutes + ":" + Seconds;
                }
                document.getElementById("ConatntMatterRight_hdnCounter").value = SecondCounter;

                //var TotalSecond = parseInt(document.getElementById("ConatntMatterRight_hdnExerciseTotalTime").value);
                //document.getElementById("ConatntMatterRight_hdnTimeElapsedSec").value = TotalSecond - SecondCounter;

                if (((hours * 60) + Minutes) == 5 && Seconds == 0) {
                    //  alert("hi")
                    $("#dvDialog")[0].innerHTML = "<center>Your Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " .</center>";
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
                if (counter == 10) {//Auto Time Update
                    counter = 0;
                    fnUpdateElapsedTime();
                    //counter = 1;
                }

                if (SecondCounter == 0) {
                    if (parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value) == 0 && parseInt(document.getElementById("ConatntMatterRight_hdnCounterRunTime").value) > 0) {
                        document.getElementById("ConatntMatterRight_hdnCounter").value = document.getElementById("ConatntMatterRight_hdnCounterRunTime").value;
                        document.getElementById("ConatntMatterRight_hdnCounterRunTime").value = 0;
                        // alert("Level Complete");

                        TimerText = "Discussion Time Left : ";

                        document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
                        IsUpdateTimer = 0;
                        isPrepTimeFinished = 0;
                        fnUpdateElapsedTime();
                        fnUpdateActualStartEndTime(1, 2);

                        //  alert("Your preparation time is over. Please click on Go To Meetings to start your discussion with Assessor");
                        alert("Your preparation time is over. Please join the Microsoft teams invite to have a discussion with Assessor");
                        fnGoToMeeting();
                        eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 3000);
                        counter = 0;
                        return false;
                    } else if (parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value) == 0 && parseInt(document.getElementById("ConatntMatterRight_hdnCounterRunTime").value) == 0) {
                        flgOpenGotoMeeting = 1;
                        window.clearInterval(sClearTime);
                        clearTimeout(sClearTime);
                        window.clearInterval(eventStartMeetingTimer);
                        clearTimeout(eventStartMeetingTimer);
                        document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
                        alert("Your discussion time is over, Kindly click on 'Close Exercise' button to complete your exercise");
                        fnUpdateElapsedTime();
                        $("#btnSubmit").attr("disabled", false);
                        return false;
                    }
                    else {
                        IsUpdateTimer = 0;
                        counter = 0;
                        fnUpdateElapsedTime();
                        return false;
                    }
                }
                // }
                sClearTime = setTimeout("f1()", 1000);

            });

        }
        var sClearTime;
        function fnUpdateElapsedTime() {
            var RspexerciseId = document.getElementById("ConatntMatterRight_hdnRSPExerciseID").value;
            var TotTimeElapsedSec = document.getElementById("ConatntMatterRight_hdnTimeElapsedSec").value
            PageMethods.fnUpdateTime(RspexerciseId, TotTimeElapsedSec, fnUpdateElapsedTimeSuccess, fnUpdateElapsedTimeFailed);
        }
        function fnUpdateElapsedTimeSuccess(result) {

        }
        function fnUpdateElapsedTimeFailed(result) {
            //    alert(result._message);
        }
        function fnGoToMeeting()
        {

            if (isPrepTimeFinished == "1") {

                alert("You have more preparation time left. You can click on Start Meeting upon completion of your pre defined preparation time")
                return false;
            }
            else {
                fnUpdateActualStartEndTime(1, 3);
                isPrepTimeFinished = 0;

                TimerText = "Discussion Time Left : ";

                document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
                IsUpdateTimer = 0;
                eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 3000);
                var MeetingURL = document.getElementById("ConatntMatterRight_hdnGoToMeetingURL").value;
                $("#btnSubmit").attr("disabled", false);
                window.open(MeetingURL)
            }
           
        }

        function fnSubmit() {
            //  window.location.href = "../Main/frmExerciseMain.aspx";

            var ExerciseID = $("#ConatntMatterRight_hdnExerciseID").val();
            var RspExerciseId = $("#ConatntMatterRight_hdnRSPExerciseID").val();
            $("#dvDialog").html("Are you sure you have completed this exercise ?<br />Click OK if you have completed. <br />Click Cancel if you have NOT completed and join Microsoft teams to start your meeting.");
            $("#dvDialog").dialog({
                modal: true,
                title: "Alert",
                width: '55%',
                maxHeight: 'auto',
                minHeight: 150,
                buttons: {
                    "Ok": function () {

                        PageMethods.fnSubmit(ExerciseID, RspExerciseId, fnSubmitSuccess, fnUpdateResponsesFailed);
                        $(this).dialog("close");
                    },
                    "Cancel": function () {
                        $(this).dialog("close");
                    }
                },
                close: function () {
                    $(this).dialog("close");
                    $(this).dialog("destroy");
                }
            });
        }
        function fnSubmitSuccess(result) {

            if (result.split("^")[0] == "1") {

                window.location.href = "../Exercise/ExerciseMain.aspx?MenuId=6";

            }
        }
        function fnUpdateResponsesFailed(result) {
            alert(result.split("^")[1])
        }

        function fnPageLoad() {
            if (SecondCounter > -1) {
                setInterval(function () { FnUpdateTimer() }, 1000);
            }
        }

        $(document).ready(function () {
            var PrepStatus = $("#ConatntMatterRight_hdnPrepStatus").val();
            var MeetingStatus = $("#ConatntMatterRight_hdnMeetingStatus").val();
            if (PrepStatus == 0 && MeetingStatus == 0) {
                PrepStatus = PrepStatus == 0 ? 1 : PrepStatus;
                MeetingStatus = MeetingStatus == 0 ? 1 : MeetingStatus;
                fnUpdateActualStartEndTime(PrepStatus, MeetingStatus);
            }
        });

        function fnUpdateActualStartEndTime(UserTypeID, flgAction) {
            $("#loader").show();
            var RspExerciseID = $("#ConatntMatterRight_hdnRSPExerciseID").val();
            PageMethods.fnUpdateActualStartEndTime(RspExerciseID, UserTypeID, flgAction, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "1") {
                    alert("Error-" + result.split("^")[1]);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }
        var eventStartMeetingTimer; var flgOpenGotoMeeting = 0;
        function fnStartMeetingTimer() {

            //$("#loader").show();
            if (flgOpenGotoMeeting == 0) {
                var RspExerciseID = $("#ConatntMatterRight_hdnRSPExerciseID").val();
                var MeetingDefaultTime = $("#ConatntMatterRight_hdnMeetingDefaultTime").val();
                PageMethods.fnStartMeetingTimer(RspExerciseID, MeetingDefaultTime, function (result) {
                    $("#loader").hide();
                    if (result.split("|")[0] == "1") {
                        alert("Error-" + result.split("|")[1]);
                    } else {
                        var IsMeetingStartTimer = result.split("|")[1];
                        var MeetingRemainingTime = result.split("|")[2];
                        window.clearInterval(sClearTime);
                        clearTimeout(sClearTime);
                        if (IsMeetingStartTimer == 1) {
                            flgOpenGotoMeeting = 1;
                            window.clearInterval(eventStartMeetingTimer);
                            clearTimeout(eventStartMeetingTimer);
                            document.getElementById("ConatntMatterRight_hdnCounter").value = MeetingRemainingTime;
                            if (MeetingRemainingTime > 0) {
                                IsUpdateTimer = 1;
                                f1();
                            }
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
        // document.onload = fnPageLoad();
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" Runat="Server">
     <time id="theTime" class="fst-color">Time Left
        00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatterRight" runat="Server">
    <div class="d-flex justify-content-between align-items-center mb-3">
       <%-- <div class="border border-dark p-2">
            Preparation time: 5 mins<br />
            Discussion time : 60 mins                     
        </div>--%>
        <div class="section-title">
            <h3 class="text-center">Fact Finding Participant Instruction</h3>
            <div class="title-line-center"></div>
        </div>
        <div class="p-2">&nbsp;</div>
        <input type="button" id="btnGoToMeeting" class="btns btn-submit sm" value="Start Meeting" onclick="fnGoToMeeting()" />
    </div>
    <h4 class="small-heading">Time:</h4>
    <table class="mailtable">
        <tr>
            <td>5 minutes</td>
            <td> to read Instructions</td>
        </tr>
        <tr>
            <td>15 minutes</td>
            <td>for Fact Finding Exercise Discussion with Assessor </td>
        </tr>
        <tr>
            <td>45 minutes</td>
            <td>for Behaviour Event Interview (BEI) with Assessor</td>
        </tr>
    </table>
    <h4 class="small-heading">Introduction</h4>
    <p>This fact finding exercise helps to determine your ability to research information, to make decisions and present those decisions. As GM Operations, you are responsible for production, warehousing and distribution. A short description of a situation has been provided to you demanding your immediate decision. </p>
    <p>To enable you to reach your decision, An Information Supplier (Assessor) will answer any questions you wish to ask about the situation. The Information Supplier has a considerable amount of information, which you can obtain by asking specific questions. If you ask general questions, you will be advised to make them more specific.</p>
    <p><b>Fact finding exercise timings:</b></p>
    <table class="mailtable">
        <tr>
            <td>5 minutes</td>
            <td> Read the brief and prepare your questions.</td>
        </tr>
        <tr>
            <td valign='top'>10 minutes</td>
            <td valign='top'>Interview the Information Supplier to obtain the information you require which will help you to make a decision. You may terminate the interview before the end of the 10 minutes if you so wish. Before the end of the time period, you should review the data you have collected and arrive at a decision.<br />Present your decision and the reasons behind it. </td>
        </tr>
        <tr>
            <td>5 minutes</td>
            <td>Question/Feedback by Assessor</td>
        </tr>
    </table>
    <h4 class="small-heading">The Situation</h4>
    <p>Trevor Bishop is the Marketing Manager of H Automotive. He telephoned you (few minutes ago) demanding that Peter Stevens, the Warehouse Foreman, is immediately and severely disciplined.  Your secretary took the call while you were in a meeting and told him that you would get back to him with your response to his request. </p>
      <div class="text-center pb-4">
      
        <input type="button" id="btnSubmit" class="btns btn-cancel" disabled value="Close Exercise" onclick="fnSubmit()">
    </div>


    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnCounterRunTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeLeft" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnGoToMeetingURL" runat="server" Value="0" />
    <div id="dvDialog" style="display: none"></div>

    <asp:HiddenField ID="hdnPrepStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMeetingStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMeetingDefaultTime" runat="server" Value="0" />

    <div id="loader" class="loader-outerbg" style="display: none">
        <div class="loader"></div>
    </div>
</asp:Content>

