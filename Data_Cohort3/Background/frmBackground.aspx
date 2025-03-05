<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmBackground.aspx.vb" Inherits="frmBackground" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .ui-dialog .ui-dialog-content {
            overflow-x: hidden !important;
        }
    </style>
    <%-- <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>--%>
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
        //hdnCounterRunTime
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
                        //   alert("Your preparation time is over. Please click on Go To Meetings to start your discussion with Assessor");
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
                        //   alert("Your preparation time is over. Please click on Go To Meetings to start your discussion with Assessor");
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
        function fnGoToMeeting() {

            //if (isPrepTimeFinished == "1") {

            //    alert("You have more preparation time left. You can click on Start Meeting upon completion of your pre defined preparation time")
            //    return false;
            //}
            //else {
            fnUpdateActualStartEndTime(1, 3);
            isPrepTimeFinished = 0;

            TimerText = "Discussion Time Left : ";

            document.getElementById("theTime").innerHTML = TimerText + ":00:00:00";
            IsUpdateTimer = 0;
            eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 3000);
            var MeetingURL = document.getElementById("ConatntMatterRight_hdnGoToMeetingURL").value;
            //  window.open(MeetingURL)
            //  }
            $("#btnSubmit").attr("disabled", false);
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

<asp:Content ID="ContentTimer" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime" class="fst-color">Time Left
        00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="border border-dark p-2">
            Discussion as coachee: 10 minutes
            <br />
            Discussion as coach : 10 minutes                      
        </div>
        <div class="section-title">
            <h3 class="text-center">MotorTek  India Ltd - Background</h3>
            <div class="title-line-center"></div>
        </div>
        <div class="w-25">&nbsp;</div>
        <%--  <input type="button" id="btnGoToMeeting" class="btns btn-submit sm" value="Start Meeting" onclick="fnGoToMeeting()" style="display:none" />--%>
    </div>

    <!-- Nav tabs -->
    <ul class="nav nav-tabs pt-2" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">Introduction</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Core Values</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Organisation Structure</a></li>
        <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Market Share</a></li>
        <li><a class="nav-link" href="#CSTab-5" role="tab" data-toggle="tab">Dealer Distribution</a></li>
        <li><a class="nav-link" href="#CSTab-6" role="tab" data-toggle="tab">Changing Landscape</a></li>
        <li><a class="nav-link" href="#CSTab-7" role="tab" data-toggle="tab">Future of MotorTek</a></li>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <p>MotorTek  India Ltd, (MIL) made its initial foray into India in 1983 as an Indo-Japan  joint-venture. In August 1998, it became a 100% subsidiary of MotorTek Co. Ltd.  (MCL), Japan.</p>
            <p>It  is currently, the third largest motorcycle company in the country with a  revenue of 18,000 crores. The vision of the organization is to stay one among  the top three automotive manufacturers in India and one among the top five in  Asia. </p>
            <p>They  have a product range of 7 motorbikes and 9 scooters of which 2 are premium  motorbikes and one is an electric scooter. The product portfolio includes  Sports models such as Blue-Core Technology enabled motorbikes and Fuel Injected  models. </p>
            <p>MotorTek&rsquo;s  manufacturing facilities comprise two state of the art plants at Nasik  (Maharashtra) and Kanchipuram (Tamil Nadu). The infrastructure at these plants  supports production of two-wheelers, and parts for the domestic as well as  overseas markets. Through a combination of innovative product development and  effective customer service, the company has grown to become one of the trusted  brands in India. </p>
            <p>MotorTek  is highly customer-driven and has a country-wide network of over 2,200 customer  touch-points including 500 plus dealers.</p>
            <p>MIL  is a 100% subsidiary of MCL and functions as the regional headquarters and  corporate control body of India business operations for MCL. MIL is responsible  for Corporate Planning &amp; Strategy, Business Planning &amp; Business  Expansion and Quality &amp; Compliance Assurance of MotorTek Co. Ltd. MIL  supports MCL to market and sell its motorcycles &amp; scooters in domestic as  well as export markets.</p>
            <p>MotorTek Research  &amp; Development Pvt. Ltd. (MRDL) is a 100% subsidiary of MIL and has been  established to provide R&amp;D and Product development services to MIL for its  domestic as well as export markets.</p>
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <p>The  motor industry has become increasingly competitive with several players  struggling to compete for market share. Indeed, some of the larger  manufacturers in the country have faded away over the last 25 years.  There is a concern amongst those that remain  that their future is by no&nbsp;means assured and that there is no room for  complacency if they need to thrive in this market. </p>
            <p>MotorTek  is driven by its values of <strong>&ldquo;Quality</strong>&rdquo; and <strong>&ldquo;Innovation&rdquo; </strong>to retain  its brand promise and market position. </p>
            <p><strong>Values  of the organisation</strong></p>
            <ol>
                <li><strong>Customer Centricity: </strong>The  organisation is committed to producing innovative, easy to handle,  environment-friendly products, backed by reliable customer service. It invests  in extensive research and development to anticipate customer needs and deliver  innovative and quality products.</li>
                <li><strong>Innovation: </strong>The  company has always believed in technology driven solutions and thus engages in  honing and sustaining its cutting-edge technology by constantly benchmarking  against international leaders.</li>
                <li><strong>Quality Orientation</strong>:  Focus on quality has resulted in the organisation adopting TQM- Total Quality  Management. This has enabled the team to not only focus on results but also on  the process.</li>
                <li><strong>People: </strong>The organisation is  investing heavily on building capabilities to realize its vision and at the  same time improving job satisfaction of employees.</li>
            </ol>
        </div>
        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <ol>
                <li>MotorTek India Ltd (MIL) is  headed by Ashish Malhotra, the Chairman.</li>
                <li>Gautam  Venkatesh, the Managing Director is responsible for 7 core departments. Each  department is led by the respective Department Head.
                    <div class="text-center">
                        <img src="../../Images/mt-background-1.jpg" class="img-thumbnail mb-3" />
                    </div>
                </li>
                <li>MotorTek Research &amp; Development Pvt. Ltd.  (MRDL) is headed by Sanjeev Ghani, the Managing Director.
                    <div class="text-center">
                        <img src="../../Images/mt-background-2.jpg" class="img-thumbnail" />
                    </div>
                </li>
            </ol>
        </div>
        <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <p>The  Indian market for two-wheelers is quite substantial, with around 220 million  vehicles on the road. &nbsp;With around 16 million units sold every year, it is  one of the world&rsquo;s largest. Three in every ten two wheelers sold in the country  are used ones. So, there are thriving new and used 2-wheeler markets as  well. </p>
            <p>MotorTek has 4 major  competitors – TruMobile, Nakamura, Puritzo and Argent. Their market share for  the current year is given below.</p>
            <div class="text-center">
                <img src="../../Images/mt-background-3.jpg" class="img-thumbnail w-75" />
            </div>
        </div>
        <!-- Tab panes 5-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-5">
            <%--<h4 class="small-heading">Dealer  Distribution</h4>--%>
            <ol>
                <li>MotorTek dealer network is  made up of a series of franchised dealerships, which vary from  single&nbsp;sites to multisite dealerships with 5-6 outlets.&nbsp; Although the  franchises are independent operators,&nbsp;they are required to abide by  certain policy and procedural guidelines laid down by MIL.</li>
                <li>Currently, MotorTek has  around 500 dealers spread out across the country, as indicated by the table  below, which&nbsp;also shows the dispersion of competitor dealerships across  India.</li>
                <li>Dealer outlets vary in size  and activity.&nbsp; Main dealers offer sales, servicing, and parts  operations,&nbsp;whilst other dealerships are smaller and tend to focus mainly  on retail sales.&nbsp;</li>
            </ol>
            <h4 class="small-heading">Sales  Across Regions</h4>
            <ol>
                <li>As the dealer outlets vary  across the country in terms of size, the number of units they sell  also&nbsp;varies. In addition, there are different trends across the  country.</li>
                <li>Given below is the  graph showing the sales across 4 regions for MotorTek in the last 12 months 
	               <div class="text-center">
                       <img src="../../Images/mt-background-4.jpg" class="img-thumbnail w-75" />
                   </div>
                </li>
            </ol>
            <p>MotorTek  has been concerned about sales specifically in the EAST region as it is low  compared to other regions. Whilst they understand that there can be differences  across geographies, there is a need to understand the possible reasons and take  measures to improve sales in that region. </p>
        </div>
        <!-- Tab panes 6-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-6">
           <%-- <h4 class="small-heading">Changing  Landscape of the Automobile Industry</h4>--%>
            <p>The  automotive industry is drastically changing due to the following triggers:</p>
            <p><strong>Digitization </strong>Digital commerce technologies are disrupting  the automobile industry by unlocking greater efficiencies, personalization, and  cost savings.  Automobiles,  today, are safer, user-friendly and comes with several features that improve  their value and usefulness for automobile owners.&nbsp;Modern automobiles can  offer much more than driving/riding one from one point to another, just like  modern cell phones can perform more than just a call.</p>
            <p><strong>Sustainability</strong> With the human impact on climate causing harmful effects on the environment,  every industry is turning towards more environmentally friendly technology.  &nbsp;Electric vehicles are gaining immense popularity nowadays all over the  world&nbsp;to contribute to the cause. Governments are working towards creating  the infrastructure/electric charging platforms to facilitate the change, along  with offering subsidies, wherever necessary.</p>
            <p><strong>Customer  Preferences</strong> OEMs are responding to the new  dimensions of mobility (connected, autonomous, shared and electric), new forms  of ownership and an increased environmental focus.</p>
            <p><strong>Supply  Chain Architecture</strong> The Indian automotive  supplier base is currently not too diversified for majority of components. This  was to drive volume-based price efficiencies. However, this strategy is highly  exposed to risks arising from disruptions in geographies that supply key auto  components. Hence, organisations are currently evaluating the supply chain  architecture and its vulnerabilities against external factors.</p>
        </div>
        <!-- Tab panes 7-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-7">
           <%-- <h4 class="small-heading">Future  of MotorTek</h4>--%>
            <p>With  the landscape of the automobile industry changing drastically, MotorTek must  transform itself to sustain and grow in this dynamic and competitive market.  Here are some initiatives the organisation is working on.</p>
            <p><strong>Premiumization</strong> The focus is shifting towards creating premium  bikes to improve margins across both domestic and global markets. With the  launch of the two premium bikes the organisation has earned some reasonable  dividends. Today, two-wheelers are becoming an aspirational object and there  are two-wheelers more expensive than some luxury vehicles in the market today.  The company wants to capitalize on the trend.</p>
            <p><strong>Electric Vehicles:</strong> The India E-Bike market was valued at USD 1.02  million in 2020, and it is expected to reach&nbsp;USD 2.08 million by 2026,  projecting CAGR of 12.69 % during the forecast period. (2021-2026). The company  has launched a product last year to foray into this segment and continues to  invest a lot in Research and Development to improvise its products in this  domain.</p>
            <p><strong>Connected 2 wheelers:</strong> As the automotive industry veers towards  digitization, coupled with smart phone connectivity, it  has contributed to several use cases for  connected two wheelers that include road and vehicle monitoring, driver  behaviour analysis, SOS calls, smart helmets, theft protection, vehicles  prognostics and health management.  Since  all these features are aligned to the safety and convenience of the two-wheeler  owners, the company cannot ignore them.</p>
            <p><strong>Market Expansion:</strong> The organisation is  one of the top three automotive manufactures in India and has a relative strong  footage in international business, especially in Asian markets, capitalizing on  the expertise developed in the areas of manufacturing, technology and marketing  for better margins is crucial.</p>
        </div>

    <div class="text-center mt-3 pb-4">
        <input type="button" id="btnSubmit" class="btns btn-cancel" disabled value="Close Exercise" onclick="fnSubmit()">
    </div>
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

