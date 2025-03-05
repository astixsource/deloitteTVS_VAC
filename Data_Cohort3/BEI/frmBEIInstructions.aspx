<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmBEIInstructions.aspx.vb" Inherits="Set1_BEI_frmBEIInstructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
   <%-- <script type="text/javascript">
        function preventBack() { window.history.forward(); }

        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
    </script>--%>

    <script type="text/javascript">
        

        $(document).ready(function () {
            var navbarh = ($("nav.navbar").outerHeight());
            $('.main-box').css({
                "min-height": $(window).height() - (navbarh + 22),
                'margin-top': navbarh
            });

            $("#panellogout, #panelback, #panelhome").hide();
            $("#imgLogo2").css("margin-right", "110px");

            fnStartMeetingTimer(1);
            eventStartMeetingTimer = setInterval("fnStartMeetingTimer(1)", 5000);

            var PrepStatus = $("#ConatntMatter_hdnPrepStatus").val();
            var MeetingStatus = $("#ConatntMatter_hdnMeetingStatus").val();
            if (PrepStatus == 0 && MeetingStatus == 0) {
                PrepStatus = PrepStatus == 0 ? 1 : PrepStatus;
                MeetingStatus = MeetingStatus == 0 ? 1 : MeetingStatus;
                fnUpdateActualStartEndTime(PrepStatus, MeetingStatus);
            }

        });
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        var TimerText = "Time Left : ";
        var isPrepTimeFinished = 1;
        $(document).ready(function () {
            //fnStartMeetingTimer();

        });

        function f1() {

            //function FnUpdateTimer() {
            if (IsUpdateTimer == 1) {
                if (parseInt(document.getElementById("ConatntMatter_hdnCounter").value) == 0) {
                    TimerText = "Time Left ";
                    flgOpenGotoMeeting = 1;
                    isPrepTimeFinished = 0;
                    IsUpdateTimer = 0;
                    document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
                    // clearTimeout(sClearTime);
                    window.clearInterval(sClearTime);
                    clearTimeout(sClearTime);
                    window.clearInterval(eventStartMeetingTimer);
                    clearTimeout(eventStartMeetingTimer);
                    //  alert("Your discussion time is over, Kindly click on 'End Exercise' button to complete your exercise");
                    $("#btnSubmit").attr("disabled", false);
                    return false;
                } else {
                    // fnGoToMeeting();
                }
            }
            if (IsUpdateTimer == 0) { return; }
            SecondCounter = parseInt(document.getElementById("ConatntMatter_hdnCounter").value);
            // alert(SecondCounter)
            if (SecondCounter < 0) {
                IsUpdateTimer = 0;
                return;
            }

            SecondCounter = SecondCounter - 1;
            SecondCounter = SecondCounter < 0 ? 0 : SecondCounter;
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
            }

            counter++;
            counterAutoSaveTxt++;
            if (counter == 10) {//Auto Time Update
                counter = 0;
              //  fnUpdateElapsedTime();
                //counter = 1;
            }
            if (counterAutoSaveTxt == 30) {//Auto Text Save
                counterAutoSaveTxt = 0;
                // var strRet = fnMakeStringForSave();
                //fnSaveData(1, 0)
            }
            if (SecondCounter == 0) {
                if (parseInt(document.getElementById("ConatntMatter_hdnCounter").value) == 0 && parseInt(document.getElementById("ConatntMatter_hdnCounterRunTime").value) == 0) {
                    window.clearInterval(sClearTime);
                    clearTimeout(sClearTime);
                    window.clearInterval(eventStartMeetingTimer);
                    clearTimeout(eventStartMeetingTimer);
                    document.getElementById("theTime").innerHTML = "Meeting Over";
                    //  alert("Your discussion time is over, Kindly click on 'End Exercise' button to complete your exercise");
                    fnUpdateElapsedTime();
                    $("#btnSubmit").attr("disabled", false);
                    return false;
                }
                else {
                    IsUpdateTimer = 0;
                    counter = 0;
                    //fnUpdateElapsedTime();
                    return false;
                }
            }
            // }
            sClearTime = setTimeout("f1()", 1000);

        }

        var sClearTime;
        function fnUpdateElapsedTime() {
            var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
            // alert(RspexerciseId)
            PageMethods.fnUpdateTime(RspexerciseId, fnUpdateElapsedTimeSuccess, fnUpdateElapsedTimeFailed);
        }
        function fnUpdateElapsedTimeSuccess(result) {

        }
        function fnUpdateElapsedTimeFailed(result) {
            //    alert(result._message);
        }
        function fnGoToMeeting() {
            fnUpdateActualStartEndTime(1, 3);
            isPrepTimeFinished = 0;
            TimerText = "Time Left : ";
            document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
            IsUpdateTimer = 0;
            //eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 3000);
            var MeetingURL = document.getElementById("ConatntMatter_hdnGoToMeetingURL").value;
            window.open(MeetingURL)
            $("#btnSubmit").attr("disabled", false);
        }



        function fnUpdateActualStartEndTime(UserTypeID, flgAction) {
            $("#loader").show();
            var RspExerciseID = $("#ConatntMatter_hdnRSPExerciseID").val();
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
        var eventStartMeetingTimer; var flgOpenGotoMeeting = 0; var eventStartMeetingTimerCloseAdmin;
       


        function fnStartMeetingTimer(flg) {
            var RspExerciseID = $("#ConatntMatter_hdnRSPExerciseID").val();
            var MeetingDefaultTime = $("#ConatntMatter_hdnMeetingDefaultTime").val();
            PageMethods.fnStartMeetingTimer(RspExerciseID, MeetingDefaultTime, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "1") {
                    //alert("Error-" + result.split("|")[1]);
                } else {
                    var IsMeetingStartTimerAdmin = result.split("|")[1];
                    var MeetingRemainingTime = result.split("|")[2];
                    var flgMeetingStatusP = result.split("|")[3];
                    var flgMeetingStatusA = result.split("|")[4];
                    var flgMeetingStatusE = result.split("|")[5];
                    document.getElementById("ConatntMatter_hdnCounter").value = MeetingRemainingTime;
                    if (flgMeetingStatusP == 1 && flgMeetingStatusA == 1 && flgMeetingStatusE == 1 && flg == 1) {
                          $("#tdTime").css("display", "table-cell");
                        $("#theTime").removeAttr("title");
                        flgOpenGotoMeeting = 1;
                        window.clearInterval(eventStartMeetingTimer);
                        clearTimeout(eventStartMeetingTimer);
                        document.getElementById("ConatntMatter_hdnCounter").value = MeetingRemainingTime;
                        IsUpdateTimer = 1;
                        f1();
                        if (MeetingRemainingTime > 0) {
                            eventStartMeetingTimerCloseAdmin = setInterval("fnStartMeetingTimer(2)", 5000);
                        }
                    } else if (flgMeetingStatusE > 1) {
                        fnSubmit();
                         $("#tdTime").css("display", "table-cell");
                         $("#theTime")[0].innerHTML = "Meeting Over";
                         $("#btnGotoMeeting").hide();
                        try {
                            window.clearInterval(eventStartMeetingTimerCloseAdmin);
                            clearTimeout(eventStartMeetingTimerCloseAdmin);
                        } catch (err) { }
                    } else if (flg == 2) {
                        if (MeetingRemainingTime == 0) {
                            document.getElementById("ConatntMatter_hdnCounter").value = 0;
                            window.clearInterval(eventStartMeetingTimerCloseAdmin);
                            clearTimeout(eventStartMeetingTimerCloseAdmin);
                        }
                    } else {
                        var strMeetingStatus = "";
                        if (flgMeetingStatusE == 1) {
                            strMeetingStatus = "Meeting Started by Ey Admin\n";
                        } else {
                            strMeetingStatus = "Meeting Not Started by Ey Admin\n";
                        }
                        if (flgMeetingStatusA == 1) {
                            strMeetingStatus += "Meeting Started by Developer\n";
                        } else {
                            strMeetingStatus += "Meeting Not Started by Developer\n";
                        }
                        if (flgMeetingStatusP == 1) {
                            strMeetingStatus += "Meeting Started by Participant\n";
                        } else {
                            strMeetingStatus += "Meeting Not Started by Participant\n";
                        }
                        $("#theTime")[0].innerHTML = "Meeting To Start";
                        $("#theTime").attr("title", strMeetingStatus);
                    }
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }
    </script>

    <script type="text/javascript">
        function fnSubmit() {

            //if ($("#chkConfirmation").prop("checked") == false) {
            //    alert("Please click on the checkbox to give the confirmation")
            //    return false;
            //}
            var ExerciseID = $("#ConatntMatter_hdnExerciseID").val();
            var RspExerciseId = $("#ConatntMatter_hdnRSPExerciseID").val();
            var Status = 2;
            PageMethods.fnSubmitBEI(RspExerciseId, ExerciseID, Status, 0, fnSubmitSuccess, fnSubmitFailed);
        }

        function fnSubmitSuccess(result) {
            if (result.split("^")[0] == "1") {
                //   alert("Your time is over now");
                window.location.href = "../Main/frmExerciseMain.aspx";
            }
            else {
                alert("Some techical error. " + result.split("^")[1]);
            }

        }
        function fnSubmitFailed(result) {
            result.split("^")[1]
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime">Time Left : 00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">BEHAVIOURAL EVENT INTERVIEW</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="section-content">
        <p>1. This is an Interview exercise.</p>
        <p>2. Please click on the ‘Go To MEETING” button below. You will be directed to a waiting room and will be admitted when the Developer is ready for your discussion.</p>
        <div class="text-center mt-4 mb-4">
            <input type="button" class="btns btn-submit" value="Go To Meeting" id="btnGotoMeeting" onclick="fnGoToMeeting()" /></div>
        <p>3. Once you have completed the Interview, please click on the below check box and confirm completion of this exercise.</p>
        <p>4. When you click on “CONFIRM”, you will be re-directed to the Homepage, where you may wait till your next exercise is activated.</p>
    </div>
    <div class="text-center">
        <input type="checkbox" id="chkConfirmation" />
        I confirm that my Behavioural Event Interview has been completed 
    </div>
    <div class="text-center mt-4" style="display:none">
        <a href="##" id="btnCloseExercise" class="btns btn-cancel" onclick="fnSubmit()">Confirm</a>
    </div>

    <div id="dvDialog" style="display: none"></div>

    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeLeft" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />

    <asp:HiddenField ID="hdnFileCntr" runat="server" Value="0" />

    <asp:HiddenField ID="hdnCounterRunTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnGoToMeetingURL" runat="server" Value="0" />
    <asp:HiddenField ID="hdnPrepStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMeetingStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMeetingDefaultTime" runat="server" Value="0" />
</asp:Content>

