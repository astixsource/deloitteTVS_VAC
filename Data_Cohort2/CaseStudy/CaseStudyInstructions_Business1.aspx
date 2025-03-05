<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="false" CodeFile="CaseStudyInstructions_Business1.aspx.vb" Inherits="Set1_CaseStudy_CaseStudyInstructions" %>

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
       

        <div class="col-md-12">
           

            <div class="section-title">
        <h3 class="text-center">Case Study</h3>
        <div class="title-line-center"></div>
    </div>
            <h4 class="text-decoration-underline fw-bold">Background:</h4>

            <p>
                Global Motors, a leading automotive dealership with a strong reputation in vehicle sales, has been facing 
                persistent challenges in its service business across multiple territories. Despite recent expansions into new 
                locations, the service department continues to underperform, affecting customer satisfaction, 
                operational efficiency, and revenue growth. While vehicle sales have remained strong, service revenue 
                has not kept pace, and customer retention beyond the warranty period remains a major issue. A 
                significant portion of customers opt for third-party service providers after their free service period ends, 
                leading to revenue leakage. The absence of structured engagement programs, lack of personalized followups, and inadequate upselling of value-added services have further contributed to this decline.
            </p>
            <p>
                Operational inefficiencies across service centers are another major concern. Some locations struggle with 
                technician shortages, leading to service delays and customer dissatisfaction, while others have 
                underutilized capacity due to poor demand forecasting. The absence of real-time tracking tools causes 
                delays in diagnostics, spare parts procurement, and service completion, ultimately increasing vehicle 
                turnaround time. Additionally, outdated manual job card systems result in frequent miscommunication, 
                duplicate work, and process inefficiencies, further slowing down operations.
            </p>

            <p>
                Resistance to digital transformation and process standardization has worsened the situation. Many 
                technicians and service advisors are hesitant to adopt digital tools due to a lack of training and familiarity 
                with new technology. While some territories have piloted digital solutions for appointment scheduling 
                and service tracking, others continue to rely on legacy paper-based processes, leading to inconsistent 
                execution and performance disparities across locations. The lack of a centralized CRM system means that 
                customer feedback, follow-ups, and service history tracking are not effectively managed, resulting in 
                missed revenue opportunities. Furthermore, without real-time performance dashboards, it is difficult to 
                compare the efficiency of different territories, identify best practices, and make data-driven decisions.
            </p>
            <p>
                Workforce capability gaps and employee engagement challenges further impact service quality and 
                business outcomes. High attrition rates among technicians and service advisors have led to skill shortages, 
                making it difficult to maintain service standards across multiple territories. Training programs for frontline 
                staff are limited, which results in poor customer handling, ineffective complaint resolution, and weak 
                upselling of additional services. Many service advisors lack motivation due to an absence of structured 
                incentives, leading them to focus solely on basic servicing rather than actively promoting high-margin 
                service packages. The workforce also struggles to adapt to new performance expectations, as there is no 
                clear framework for continuous learning and skill enhancement.
            </p>
            <p>
                Growing competition from multi-brand service centers, third-party workshops, and emerging doorstep 
                service startups has further intensified pressure on Global Motors' service business. Competitors are 
                attracting price-sensitive customers with lower costs, faster turnaround times, and transparent pricing 
                models through digital platforms. As customer expectations continue to evolve, Global Motors' service 
                department struggles to match the level of convenience and flexibility offered by these alternative service 
                providers. While marketing efforts have been successful in increasing customer footfall at service centers, 
                the lack of capacity planning and inefficient service workflows have made it difficult to convert these visits 
                into long-term customer relationships.
            </p>
            <p>
                As an Area Manager (AM), responsible for overseeing multiple service territories, your role requires close 
                coordination with Territory Managers (TMs) to ensure alignment with business objectives and the 
                successful implementation of strategies that improve service business outcomes while maintaining 
                operational excellence.
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
        <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click"/>
        <input type="button" id="btnSubmit" runat="server" value="Start" class="btns btn-submit" onclick="fnMSG()" />

    </div>
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

