<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Site.master" AutoEventWireup="false" CodeFile="CaseStudyInstructions_Business1.aspx.vb" Inherits="Set1_CaseStudy_CaseStudyInstructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">


    <script type="text/javascript">      
        function fnMSG() {

            //$("#dvDialog").html("Are you sure you have download the template, If Yes, then click on 'Yes' button, if No, Please, download the templates first");
            //$("#dvDialog").dialog({
            //    modal: true,
            //    title: "Alert",
            //    width: '50%',
            //    maxHeight: 'auto',
            //    minHeight: 150,
            //    buttons: {
            //        "Yes": function () {
            var ExerciseID = '<%=ExerciseID%>'
            var ExerciseType = '<%=ExerciseType%>'
            var TimeAlloted = '<%=TimeAlloted%>'
            var RspID = '<%=RspID%>'
            window.location.href = "CaseStudy_Business1.aspx?ExerciseID=" + ExerciseID + "&RspId=" + RspID + "&ExerciseType=" + ExerciseType + "&TimeAlloted=" + TimeAlloted;

            //            $(this).dialog("close");
            //        },
            //        "No": function () {
            //            fnDownloadTemplates()
            //            $(this).dialog("close");
            //        }
            //    },
            //    close: function () {
            //        $(this).dialog("close");
            //        $(this).dialog("destroy");
            //    }
            //});

        }

        function download_files(files) {
            function download_next(i) {
                if (i >= files.length) {
                    return;
                }
                var a = document.createElement('a');
                a.href = files[i].download;
                a.target = '_parent';
                // Use a.download if available, it prevents plugins from opening.
                if ('download' in a) {
                    a.download = files[i].filename;
                }
                // Add a to the doc for click to work.
                (document.body || document.documentElement).appendChild(a);
                if (a.click) {
                    a.click(); // The click method is supported by most browsers.
                } else {
                    $(a).click(); // Backup using jquery
                }
                // Delete the temporary link.
                a.parentNode.removeChild(a);
                // Download the next file with a small timeout. The timeout is necessary
                // for IE, which will otherwise only download the first file.
                setTimeout(function () {
                    download_next(i + 1);
                }, 500);
            }
            // Initiate the first download.
            download_next(0);
        }

    </script>
    <script>
        // Here's a live example that downloads three test text files:
        function fnDownloadTemplates() {
            download_files([
                { download: "../../Templates/CaseStudy_Financials.xlsx", filename: "CaseStudy_Financials.xlsx" },
                { download: "../../Templates/CaseStudy_Template.pptx", filename: "CaseStudy_Template.pptx" },

            ]);
        };
    </script>

    <script>
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        var TotalQuestions = 0; var BandID = 0;
        $(document).ready(function () {
                f1();
                eventStartMeetingTimer = setInterval("fnStartMeetingTimer()", 5000);
        })
        function f1() {
            $(document).ready(function () {
                //function FnUpdateTimer() {
                if (IsUpdateTimer == 0) { return; }
                SecondCounter = parseInt(document.getElementById("ConatntMatter_hdnCounter").value);
                if (SecondCounter < 0) {
                    IsUpdateTimer = 0;
                    $("#dvDialog").html("Your Time is over now");
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
                    counter = 0;
                    document.getElementById("theTime").innerHTML = "Time Left: 00:00:00";
                   // fnSaveData(2, "", 2, 1);
                    return;
                }

                SecondCounter = SecondCounter - 1;
                hours = Math.floor(SecondCounter / 3600);
                Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
                Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);

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
                   // fnUpdateElapsedTime();
                    //counter = 1;
                }

                if (SecondCounter == 0) {
                    // alert("Level Complete");

                    //fnUpdateElapsedTime();
                    // fnAutoSaveText(2);
                    counter = 0;
                    IsUpdateTimer = 1;
                    $("#dvDialog").html("Your Time is over now");
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
                    document.getElementById("theTime").innerHTML = "Time Left: 00:00:00";
                    //alert("Your Time is over now")
                    counter = 0;
                    // var inLoginid1 = document.getElementById("ConatntMatter_hdnLoginID").value;
                    // window.location.href = "../Main/frmExerciseMain.aspx?intLoginID=" + inLoginid1;
                    return false;
                }
                // }
                setTimeout("f1()", 1000);

            });


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
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime">Time Left<br />
        00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
   
    <div class="row">
        <%-- <div class="col-md-4">
            <div class="about-img-one">
                <img src="../../Images/instruction.jpg" />
            </div>
        </div>--%>

        <div class="col-md-12">
            <div class="info-about mt-2">
               
            </div>
              <div class="section-title">
        <h3 class="text-center">Case Study</h3>
        <div class="title-line-center"></div>
    </div>
            <h4 class="text-decoration-underline fw-bold">Background:</h4>

            <p>
                MotoMax, a leading manufacturer and retailer of two-wheelers in India, has established a strong presence 
    across various regions of the country. Recently, the company has made significant efforts to expand its 
    operations into tier-2 and tier-3 cities. Despite this growth, MotoMax has been facing several operational 
    and customer-related challenges, particularly in the service business.
            </p>
            <p>
                The company has maintained strong sales in the vehicle segment, but the service department’s 
performance has been not up to the mark. Service revenues, especially those derived from after-sales 
services like Annual Maintenance Contracts (AMCs), have not kept pace with the growth in vehicle sales. 
A large number of customers opt for third-party service providers once their warranty period expires, 
which has led to substantial revenue leakage. This issue is more pronounced in tier-2 and tier-3 cities, 
where local multi-brand service providers are emerging as strong competitors. While some regions have 
made attempts to sell AMCs and upsell high-margin services like extended warranties, the approach has 
been inconsistent and lacks a standard process. This results in missed revenue opportunities and weak 
customer retention.
            </p>

            <p>
                Additionally, there is a significant variation in service quality across regions, with some areas offering 
               superior service experiences while others are struggling with delayed service times, low customer 
               satisfaction, and poor follow-up. These regional disparities stem from issues such as insufficient technician 
availability, outdated service processes, and inadequate training for service advisors and technicians. 
These challenges have resulted in inconsistent customer experiences and have affected long-term 
customer loyalty and retention.

            </p>

            <p>
                The competition from third-party service providers has become more intense, especially in emerging 
markets where customers are price-sensitive and looking for faster, more convenient service options. 
These competitors are able to offer lower costs, quicker turnaround times, and transparent pricing 
models, posing a serious threat to MotoMax’s service revenue growth. In addition, MotoMax’s service 
centers are perceived as less flexible compared to these alternative providers, which further complicates 
the company’s efforts to build strong, long-term customer relationships in these markets.
            </p>


            <p>
                Operational inefficiencies are also a major concern. Some regions suffer from technician shortages, 
leading to delays in service delivery, while others are unable to fully utilize their service capacity due to 
poor demand forecasting. There is a lack of digital tools for real-time tracking of service progress, 
customer feedback, and spare parts procurement, which results in bottlenecks and delays. Additionally, 
the reliance on outdated manual processes, such as paper-based job cards, increases the chances of 
miscommunication, duplicated efforts, and operational inefficiencies.
            </p>

            <p>
                Employee engagement is another critical issue. High attrition rates among technicians and service advisors 
have led to skill shortages, making it difficult to maintain service standards and manage customer 
relationships effectively. The lack of structured training programs and professional development 
opportunities for frontline employees has contributed to poor customer handling, inadequate complaint 
resolution, and weak upselling practices. Furthermore, many service advisors and technicians are not 
incentivized to promote value-added services, which has resulted in a missed opportunity to drive revenue 
from upselling and AMC sales.

            </p>

            <p>
                There is also a significant digital transformation gap. While some regions have begun adopting digital tools 
for appointment scheduling and service tracking, many locations still rely on manual, outdated processes. 
This inconsistency in digital adoption across regions results in significant performance disparities and 
hinders data-driven decision-making. Without centralized systems for tracking service history, customer 
feedback, and performance metrics, it is challenging to make informed decisions about where 
improvements are needed and how to optimize service delivery across multiple regions.
            </p>
            <p>
                Additionally, MotoMax is facing difficulties in building a consistent brand image for its after-sales service. 
While the company has a solid reputation for its vehicles, the service experience has not matched 
customer expectations. This has impacted customer retention, especially as service customers are more 
likely to explore third-party options after their warranty period expires. To address this, the company must 
prioritize creating a strong, unified service experience that aligns with its brand values and drives 
customer loyalty across all regions. 
            </p>

            <p>
                As an RM at MotoMax, you are expected to drive operational and strategic improvements across multiple 
territories while ensuring profitability and growth in the service business. Your success will be measured 
by your ability to implement scalable solutions that address the outlined challenges and contribute to 
long-term service excellence and customer loyalty.
            </p>


        </div>
    </div>
     <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseStatus" runat="server" Value="0" />
     <asp:HiddenField ID="hdnMeetingDefaultTime" runat="server" Value="0" />
     <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />
    <div class="text-center mb-2">
        <%--<a href="###" id="btnDownloadTemplate" runat="server" class="btns btn-submit" onclick="fnDownloadTemplates()">Download Presentation and Excel Templates</a>--%>
        <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click" />
        <input type="button" id="btnSubmit" runat="server" value="Start" class="btns btn-submit" onclick="fnMSG()" />

    </div>
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

