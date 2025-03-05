<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmBasket_Scenario.aspx.vb" Inherits="Set1_Basket_frmBasket_Instructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .hilight_date {
            border: 2px solid transparent;
            border-radius: 20px;
            display: inline-block;
            padding: 1px 4px;
            -moz-border-radius: 20px;
            -webkit-border-radius: 20px;
            -khtml-border-radius: 30px;
        }

            .hilight_date.red {
                border-color: #ff0000 !important;
            }

            .hilight_date.green {
                border-color: #009219 !important;
            }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#panelback").hide();
            //$("#imgLogo2").css("margin-right", "100px");
        });
    </script>
    <script type="text/javascript">
        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
    </script>

    <script type="text/javascript">
        $("#panelLogout").hide();
    </script>


    <script type="text/javascript">
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        $(document).ready(function () {
            //f1();
        });

        function f1() {

            //function FnUpdateTimer() {
            if (IsUpdateTimer == 0) { return; }
            SecondCounter = parseInt(document.getElementById("ConatntMatter_hdnCounter").value);
            // alert(SecondCounter)
            if (SecondCounter <= 0) {
                IsUpdateTimer = 0;


                return;
            }

            SecondCounter = SecondCounter - 1;
            hours = Math.floor(SecondCounter / 3600);
            Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
            Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);


            if (Seconds < 10 && Minutes < 10) {
                document.getElementById("theTime").innerHTML = "Time Left:0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
            }
            else if (Seconds < 10 && Minutes > 9) {
                document.getElementById("theTime").innerHTML = "Time Left:0" + hours + ":" + Minutes + ":" + "0" + Seconds;
            }
            else if (Seconds > 9 && Minutes < 10) {
                document.getElementById("theTime").innerHTML = "Time Left:0" + hours + ":" + "0" + Minutes + ":" + Seconds;
            }
            else if (Seconds > 9 && Minutes > 9) {
                document.getElementById("theTime").innerHTML = "Time Left:0" + hours + ":" + Minutes + ":" + Seconds;
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
            if (counter == 10) {//Auto Time Update
                counter = 0;
                fnUpdateElapsedTime();
                //counter = 1;
            }
            if (counterAutoSaveTxt == 30) {//Auto Text Save
                counterAutoSaveTxt = 0;
                // var strRet = fnMakeStringForSave();
                //fnSaveData(1, 0)
            }
            if (SecondCounter == 0) {

                IsUpdateTimer = 0;
                fnUpdateElapsedTime();
                counter = 0;
                //  alert("Your time is over now. In next 5 mints your call will be started with your Assessor");
                //    window.location.href = "../Main/frmExerciseMain.aspx?intLoginID=" + inLoginid1;
                return false;
            }
            // }
            setTimeout("f1()", 1000);

        }



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


        function fnPageLoad() {
            if (SecondCounter > -1) {
                setInterval(function () { FnUpdateTimer() }, 1000);
            }
        }
        // document.onload = fnPageLoad();
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <%--<time id="theTime">Time Left 00: 00: 00</time>--%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="d-flex justify-content-between align-items-center">
        <div class="p-2">&nbsp;</div>
        <div class="section-title">
            <h3 class="text-center">Situation</h3>
            <div class="title-line-center"></div>
        </div>

        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Go to inbox" />
    </div>
    <div class="section-content">
        <h4 class="middle-title">THE ORGANIZATION</h4>
        <p>Reliable Steels Industries was formed in 2000 in India by 3 passionate partners from the Metals and Mining Industry. They started this with all their earnings, with a deep passion to serve the Steel industry.</p>
        <p>Reliable has 10 plants in India, with 20,000 employees. They have been a high profit and high growth organization and among the top 3 in India and Top 10 globally.</p>
        <p>In the last decade, their growth has increased by the manufacturing of a steel product, which finds major market in developed countries.</p>
        <div class="row">
            <div class="col-md-12">
                <h4 class="middle-title">The Role</h4>
                <p>You are <strong>Roshan Singh</strong> and the Vice President and Plant Head for the largest plant of Reliable Steels Industries. You have joined 2 years back to take this role and you earlier worked with another competitor based out of India.</p>
                <p>Today is 14th March 2024. You were on your annual one-week leave till yesterday. You have resumed at 1 pm today. On your way to work, you receive a call from your reporting manager Sunil Parihar that you are required to represent your organization, along with one of your partners, at the Indian Steel Organization Annual Conference. The conference begins tomorrow and you will need to take the last flight out tonight. You will be out of office for the next 4 days. Essentially this gives you 3-4 hours at work today to work on pending things from the last week and to also clear any actions for this week.</p>
                <p>Supriya, who also supports you as &amp; when required, has left the following mails at your desk for your appropriate action. The emails have been left in no particular order.</p>
            </div>
        </div>
         <div class="row">
            <div class="col-md-4">
                 <div class="about-img-one">
                <img src="../../Images/Set2_Calender.png" class="img-thumbnail" />
            </div>
                <p>Official Holidays [7th March, 24th March, 25th March]</p>
            </div>
        </div>

          <div class="row">
            <div class="col-md-6">
                <h4 class="middle-title">ORGANIZATION CHART</h4>
                 <div class="text-center">
                <img src="../../Images/Set2_OrgChart.png" class="img-thumbnail" />
            </div>
        
            </div>
        </div>

    </div>
    <div class="text-center">
        <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click" />
    </div>
    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeLeft" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

