<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Site.master" AutoEventWireup="false" CodeFile="CaseStudy_CFT_Panel.aspx.vb" Inherits="Data_Cohort1_CaseStudy_CaseStudy_CFT_Panel" %>

      

 
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
          <%--  var ExerciseID = '<%=ExerciseID%>'
            var ExerciseType = '<%=ExerciseType%>'
            var TimeAlloted = '<%=TimeAlloted%>'
            var RspID = '<%=RspID%>'
            window.location.href = "CaseStudy_Business1.aspx?ExerciseID=" + ExerciseID + "&RspId=" + RspID + "&ExerciseType=" + ExerciseType + "&TimeAlloted=" + TimeAlloted;--%>

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

        function fnSaveData() {
            var RspexerciseId = document.getElementById("ConatntMatter_hdnRSPExerciseID").value;
            PageMethods.spUpdateResponsesForSJT(RspexerciseId, function (result) {
                window.location.href = "../Exercise/ExerciseMain.aspx";
            }, function (result) {
                alert(result._message);
            });
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


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Instructions</h3>
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

            <ul>
                <li>Candidates will be required to prepare a 4-5 slide presentation on the allocated case scenario given
                    below within 30 minutes.
                </li>

                <li>The presentation time is to be limited to 20 minutes with 10 minutes of Q&A between the CFT Panel
                    (TVSM) and the Candidate
                </li>
                <li>The presentation should aim to address the key topics/ questions given as part of the Case Scenario

                </li>
            </ul>

             <div class="section-title">
        <h3 class="text-center">Case Scenario</h3>
        <div class="title-line-center"></div>
    </div>

            <p>ABC Motors is a leading two-wheeler company in India, recognized for its innovative design, fuel
                efficiency, and affordability. Despite being a big player in the market and having a strong brand
                recognition, the company faces service-related challenges in Tier 2 & Tier 3 cities. These cities
                contribute to <strong>35% of total sales</strong> and experience a disproportionate level of
                <strong>customer dissatisfaction.</strong>
                These challenges hinder company's goal of achieving a 15% market share in these regions. Currently,
                ABC Motors holds only an 8% market share in these regions.</p>

            <p>One of the primary challenges is the limited-service network coverage. ABC Motors currently
                operates only 15 service centres in these regions, significantly trailing Rival Motors' network of 40
                centres. This disparity results in delays in service delivery, forcing many customers to travel long
                distances for routine maintenance and repairs. The lack of accessibility has led to increasing
                customer dissatisfaction and a higher risk of customer attrition. The current Net Promoter Score
                (NPS) in these regions stands at 25, significantly below the industry benchmark of 50. Customers
                have cited poor communication, long wait times, and lack of follow-ups as key pain points. </p>

            <p>Please prepare a 4-5 slide presentation that addresses these challenges. The proposal should outline
                a strategic plan to expand the service network efficiently and implement customer engagement
                initiatives to boost satisfaction and loyalty. The presentation will be followed by a 10-minute Q&A
                session with the panel.</p>



            <div class="section-title">
                <h3 class="text-center">Sample Guiding Questions for the CFT Panel</h3>
                <div class="title-line-center"></div>
            </div>

           
       <h6><strong>Competency: </strong> Customer Experience</h6>
        <ol start="1">
        <li>Given the low Net Promoter Score (NPS) and customer complaints about poor communication, how do you plan to
            address these pain points in the short-term while expanding the service network?</li>
        <li>How would you ensure that your customer engagement initiatives not only increase satisfaction but also
            foster long-term loyalty in a market with such high customer attrition?</li>
    </ol>

    <h6><strong>Competency: </strong>Service Technical Support</h6>
    <ol start="3">
        <li>Considering the current service network and the need to expand it, how would you ensure the consistency of
            technical support across multiple service centres in Tier 2 and Tier 3 cities?</li>
        <li>How would you assess the skill gaps in the current technical support team, and what steps would you take to
            ensure they are equipped to handle the increased volume of service requests after network expansion?</li>
    </ol>

    <h6><strong>Competency: </strong> Talent Development</h6>
    <ol start="5">
        <li>With the expansion of service centres, there will be a need for additional staff. How and how many do you
            plan to hire and at what expertise level, train, and retain talent to support this expansion while ensuring
            quality service?</li>
        <li>What kind of talent development programs would you implement to enhance the capabilities of service centre
            staff, particularly in Tier 2 and Tier 3 cities? What will the initial training focus on?</li>
    </ol>

    <h6><strong>Competency: </strong>Commercial Acumen</h6>
    <ol start="7">
        <li>Considering the limited-service network and the challenges posed by customer attrition, how
            would you balance the need for service centre expansion with controlling operational costs?</li>
        <li>What strategies would you implement to ensure that the expansion of service centers
            delivers a positive ROI, and how would you assess the financial feasibility of opening new
            centers in Tier 2 and Tier 3 cities?
        </li>
    </ol>

    <h6><strong>Competency: </strong> Service Planning</h6>
    <ol start="9">
        <li>How can ABC Motors design and execute service campaigns to build customer trust and
            drive engagement in Tier 2 & Tier 3 cities? What key metrics should ABC Motors track to
            evaluate the effectiveness of these campaigns?
        </li>
        <li>With the planned expansion of 20 new service centres, how should ABC Motors optimize its
            parts and inventory management system to ensure seamless operations and reduce wait
            times?
        </li>
    </ol>

    <h6><strong>Competency: </strong>Digital Dexterity</h6>
    <ol start="11">
        <li>How can ABC Motors utilize customer feedback and service data to identify trends, prioritize
            service improvements, and enhance the Net Promoter Score (NPS) in Tier 2 & Tier 3 cities?</li>
        <li>Considering the service accessibility challenges in Tier 2 & Tier 3 cities, how can ABC Motors
            integrate advanced diagnostic tools and digital platforms to enhance service efficiency and
            customer communication?</li>
    </ol>

    <h6><strong>Competency: </strong>Dealership Management</h6>
    <ol start="13">
        <li>Considering the challenges faced by dealers in Tier 2 & Tier 3 cities, how can ABC Motors
            collaborate with its dealership network to identify revenue-generating opportunities and
            optimize operational efficiency to enhance dealer profitability without compromising
            customer satisfaction?</li>
        <li>How can ABC Motors expand their service network while ensuring that dealerships are
            strategically located, operationally efficient, and capable of meeting the company's goal of
            increasing market share to 15% in these regions?</li>
    </ol>
 

        </div>
    </div>
    </div>

    <div class="text-center mb-2">
        <input type="button" id="btnSubmit" runat="server" value="Close Exercise" class="btns btn-submit" onclick="fnSaveData()" />
    </div>
    <div id="dvDialog" style="display: none"></div>
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
     <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />
</asp:Content>
