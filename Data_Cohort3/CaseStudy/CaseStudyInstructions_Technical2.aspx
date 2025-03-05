<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="false" CodeFile="CaseStudyInstructions_Technical2.aspx.vb" Inherits="Set1_CaseStudy_CaseStudyInstructions" %>

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
             window.location.href = "CaseStudy_Technical2.aspx?ExerciseID=" + ExerciseID + "&RspId=" + RspID + "&ExerciseType=" + ExerciseType + "&TimeAlloted=" + TimeAlloted;

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
        
        <div class="col-md-12">
            <div class="info-about mt-2">
               

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


    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseStatus" runat="server" Value="0" />
     <asp:HiddenField ID="hdnMeetingDefaultTime" runat="server" Value="0" />
     <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />

    <div class="text-center">
        <%--<a href="###" id="btnDownloadTemplate" runat="server" class="btns btn-submit" onclick="fnDownloadTemplates()">Download Presentation and Excel Templates</a>--%>
          <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click"/>
     
        <input type="button" id="btnSubmit" runat="server" value="Start" class="btns btn-submit" onclick="fnMSG()" />

    </div>
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

