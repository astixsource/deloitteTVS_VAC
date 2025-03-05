<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmRolePlayExternal.aspx.vb" Inherits="frmRolePlayExternal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
     <script type="text/javascript">
         $(function () {
             $(".user_nav").hide();
         });
    </script>
</asp:Content>
<asp:Content ID="ContentTimer" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
        <div class="section-title">
            <h3 class="text-center">External Role Play</h3>
            <div class="title-line-center"></div>
        </div>
  
     <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">The Situation</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Quality Inspection Report</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Consultant Report</a></li>
        <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Your Task </a></li>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <h4 class="small-heading">The  Situation</h4>
            <p>The Company has a strong commitment to quality and a good track record of compliance with ‘Good Manufacturing Practice’. However, the recent Quality Inspection report has highlighted many slippages. The Global Auditor of H Automotive has requested an immediate meeting to review the situation.</p>
            
            <p>At the same time an investigation has been started to establish the cause of the problem. You had consulted Brigham & Armstrong Process Engineering Consultants for resolution of the slippages. The preliminary report has been shared, which you need to review. </p>
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <h4 class="small-heading">QUALITY INSPECTION REPORT - PRELIMINARY</h4>
            <p>Based on the visit made by the team of 3 quality inspectors to the manufacturing plant:  </p>
           
            <ul>
                <li><b style="font-weight: bold;">Automotive Product Division –</b> The agreed 3% error rate laid down in the manuals for all production line standards has not been met.  Error rates currently vary from 3% to 8%, depending on the complexity of the production and assembly process.  Although products are produced reasonably quickly, there are too many faults in the area of production quality.  Quality control checks are not carried out regularly and there is a lack of adequate implementation when they do take place.</li>
                <li><b style="font-weight: bold;">Non-Automotive Product Division –</b>Final assembly does not adhere to procedures laid down in their manuals and skips out several process steps in an attempt to produce the product faster.  This results in increasing error rates.  There are in fact 15 procedural short-cuts taken that could have serious consequences on safety standards.  Quality control inspectors simply overlooked faults to boost production figures.</li>
                <li><b style="font-weight: bold;">Safety Technologies Division –</b> There is a lack of supervision.  Quality control spot checks are not carried out at the factory as per agreed standards laid out in the manual.  For example, one batch in 20 is checked on the assembly line- instead of one in 10.</li>
            </ul>
            <p>The findings suggest concern regarding the quality control procedures in all three factories and requires attention to improve or enhance the monitoring of standards as soon as possible. This report is a follow up after the 6 months’ correction period following our earlier assessment. </p>
        </div>
        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <h4 class="small-heading">SUMMARY REPORT - BRIGHAM & ARMSTRONG PROCESS ENGINEERING CONSULTANTS PLC</h4>
            <ul>
                <li><b style="font-weight: bold;">Automotive Product Division -</b> Factory workers are more concerned with bonus targets than with providing quality products.  This means that on average, for example, 23% of brakes are produced which have misaligned discs.<br>
                    <b style="font-weight: bold;"><u>Suggestion:</u></b> H Automotive could explore installing robotic quality checking system to ensure sufficient quality standards. The cost of the Robotic system is approximately £200,000 but it would mean redundancies. Alternatively, a new bonus scheme, which places equal emphasis on quantity and quality could be investigated.  This would not have the significant up-front costs, but profits long-term would be less than the initial solution.</li>
                <li><b style="font-weight: bold;">Non-Automotive Product Division -</b> The final Assembly is completing the finished product slowly in many cases.  Although the process flow is correct and component parts on different production lines are produced in the right quantity, final assembly cannot produce the finished article at the optimum speed.  For example, Batteries are produced in sufficient numbers, but too quickly for final assembly.  This means that there are approximately 10,000 Battery packs in storage waiting to be used.<br>
                   <b style="font-weight: bold;"><u>Suggestion:</u></b> H Automotive could explore option of increasing the numbers of workers on final assembly. However, we are given to understand that Human Resources Recruitment Policy may be restrictive on external hiring. Alternately, you could invest in training existing staff, to replace those that have left. The training of existing staff is costlier and could also take upto 8 months which can be a problem given that H Automotive has 6 months only to ensure improvement in assembly process.</li>
                <li> <b style="font-weight: bold;">Safety Technologies Division -</b> Workers tend to operate independently from supervisors and there is very little interaction between the two groups.  Supervisors typically occupy offices above the production floor performing administration type work and rarely check up on what is happening on the shop floor.  Workers do not report errors or difficulties to their superiors for fear of punishment.<br>
                   <b style="font-weight: bold;"><u>Suggestion:</u></b> H Automotive could implement a self-directed team approach and allow workers to have more control over the process as well as be responsible for continuous improvement initiatives. This system has been implemented earlier in another division and seems to be working well. Alternatively, Supervisors can be asked to spend more time on the ground and keep a check on the workers progress and solve their issues/errors. </li>
            </ul>
        </div>
        <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <h4 class="small-heading">Your Task</h4>
            
            <p>As GM – UK Operations, you are responsible to oversee H Automotive’s UK production and exports. You have been asked to meet with the Global Auditor, James Smith, and explain to him what remedial action you plan to take to guarantee quality in the future. </p>
           
        </div>

       

    </div>
</asp:Content>

