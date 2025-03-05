<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="false" CodeFile="CaseStudyInstructions_Business1.aspx.vb" Inherits="Set1_CaseStudy_CaseStudyInstructions" %>

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
    
        function fnNextDiv() {
            $("#dvCaseInstruction").hide();
            IsUpdateTimer = 1;
            $("#dvCaseBody").show();
            $("#theTime").show();
            f1();
        }
        function fnBackDiv() {
            IsUpdateTimer = 0;
            $("#dvCaseBody").hide();
            $("#dvCaseInstruction").show();
            $("#theTime").hide();
        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime">Time Left : 
        00: 00: 00</time>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">

    <div class="row">

        <div class="col-md-12">

            <div class="info-about mt-2">
                
                <div id="dvCaseBody">
                    <div class="section-title">
                        <h3 class="text-center">Case Study</h3>
                        <div class="title-line-center"></div>
                    </div>
                    <h4 class="text-decoration-underline fw-bold">Background:</h4>

                    <p>
                        Global Motors, an established automotive dealership with over 40 years of experience, has been facing 
substantial challenges in its service department. While the company has always been known for its robust 
sales operations, its service department has been underperforming for several years. Despite the overall 
strong reputation of the dealership, customer satisfaction ratings for the service department consistently
below industry standards, and the team is struggling with low morale.
                    </p>

                    <p>
                        The service department is working with outdated systems, relying heavily on manual processes for 
customer service tracking, appointment scheduling, and diagnostics. Many of the service technicians are 
used to working with legacy systems and are reluctant to adopt any new tools, especially those that 
require significant upskilling. The department has not yet transitioned to using digital platforms for 
customer engagement, leading to communication gaps and slow response times. Additionally, there’s no 
CRM system in place, and customer feedback is mainly captured through informal channels such as word-of-mouth or occasional surveys that do not capture comprehensive insights.
                    </p>

                    <p>
                        While there has been some investment in digital tools in other parts of the dealership, the service team’s 
resistance to adopting these tools has led to operational inefficiencies and stagnation. Technicians are 
often overburdened, handling multiple tasks simultaneously, and without any structured process to 
streamline their workflow. As a result, they frequently miss key details, leading to poor diagnostics and 
delays in service delivery.
                    </p>

                    <p>
                        Despite these challenges, there’s resistance within the management team to implement large-scale 
changes. The senior management is hesitant to make drastic investments, fearing that they will not see 
immediate returns. Instead, they are seeking cost-effective solutions that can incrementally improve 
performance and drive profitability without disrupting the existing operations. The dealership is already 
in the process of launching a new marketing campaign aimed at attracting customers to the service 
department, but there’s little focus on improving internal operations to ensure that the service 
department can handle the increase in demand.
                    </p>

                    <p>
                        In addition to these challenges, Global Motors has recently expanded its business into new locations. The 
company is under pressure to maintain profitability across all locations while managing the complexities 
of scaling up operations. The service department has been receiving increasing pressure from the 
marketing department to ensure that customer experience and service delivery align with the growing 
brand presence. At the same time, employees are feeling stretched and overwhelmed by the rapid pace 
of change.
                    </p>

                     
                </div>
            </div>
        </div>
    </div>
     <div class="text-center mb-2">
        <%--<a href="###" id="btnDownloadTemplate" runat="server" class="btns btn-submit" onclick="fnDownloadTemplates()">Download Presentation and Excel Templates</a>--%>
        <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click"/>
        <input type="button" id="btnSubmit" runat="server" value="Start" class="btns btn-submit" onclick="fnMSG()" />

    </div>
    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseStatus" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMeetingDefaultTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />
   
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

