<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmSBROwnership.aspx.vb" Inherits="frmSBR_Quality" %>

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
        <h3 class="text-center">Instructions for Participant</h3>
        <div class="title-line-center"></div>
    </div>
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">The Situation</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Team Member</a></li>
         <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Annual Appraisal 2018-19</a></li>
         <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Annual Appraisal 2019-20</a></li>
         <li><a class="nav-link" href="#CSTab-5" role="tab" data-toggle="tab">Score</a></li>
         <%--<li><a class="nav-link" href="#CSTab-6" role="tab" data-toggle="tab">Your Response</a></li>--%>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <h4 class="small-heading">Timing</h4>
            <p>
               Preparation and response: 30 mins
            </p>
            <h4 class="small-heading">The  Situation</h4>
            <p>The Director Operations has just informed you that he had received the attached email from one of your team members, Jack Willis. Jack was seemingly quite upset at the lack of his career progression in spite of good performance over last 2/3 years. </p>
            <p>Spurred by this conversation, The Director Operations had also held some skip level meetings with the Production and Quality teams where the respective managers are also feeling that many in the team are getting disengaged as they are doing repetitive work and find lack of opportunity. Further, teams also seem to believe that there is no recognition of their efforts and talents and they are not developing any new skills in line with their aspirations.</p>
            <p>The Director Operations feels that this is one of the many reasons for the dipping employee engagement levels.</p>
          
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <h4 class="small-heading">Input from Team Member</h4>
            <p>To introduce myself, I am Jack, part of the Marketing team. I have been with H Automotive for about 5 years and have been performing at all assigned duties with full diligence. </p>
            <p>I am writing to you as Alan is not currently with H Automotive. Last year, during the performance appraisal discussion, Alan and my Manager had committed to me sponsorship for a Management program at an IvyLeague College. I was told that I would have been promoted, if not for the business slump at that time. This year again I have been given the same communication.</p>
            <p>I would like to bring to your note that my appraisal scores have all been excellent. The last 2 reports are attached for your reference. In spite of putting in my best performance consistently, I feel the organization is not recognising my efforts.  When I had joined H Automotive, it was with high hopes along with confidence in the organization’s repute. But today, when I compare myself to some of my friends in other organizations, I am feeling that I may have made a mistake.</p>
            <p>I am not sure whether I should have reached out to you but I had tried multiple times to fix a meeting with Alan but unfortunately he could not make time before his exit. </p>
          
        </div>
         <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <h4 class="small-heading">Team Member Appraisal For 2018-19</h4>
            <div class="text-center">
                <img src="../../Images/lvl11-SRBO-tb3.jpg" class="w-100" />
            </div>         
        </div>
         <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <h4 class="small-heading">Annual Appraisal Form 2019-20</h4>
            <div class="text-center">
                <img src="../../Images/lvl11-SRBO-tb4.jpg" class="w-100"  />
            </div>
        </div>
         <!-- Tab panes 5-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-5">
            <h4 class="small-heading">Employee Engagement Score</h4>
            <div class="text-center">
                <img src="../../Images/lvl11-SRBO-tb5I.jpg" class="w-50 img-thumbnail pull-left" />
                <img src="../../Images/lvl11-SRBO-tb5II.jpg" class="w-50 img-thumbnail pull-left" />
            </div>          
        </div>
        <%--<div role="tabpanel" class="tab-pane fade" id="CSTab-6">
               <h4 class="small-heading">Your Response</h4>
            <p>You need to share -</p>
              <div class="clearfix bg-light" id="dvMain" runat="server"></div>

              <div class="text-center mb-3">
                    <input type="button" id="btnNext" class="btns btn-cancel"  value="Submit" onclick="fnNext()">
                </div>
        </div>--%>
        
    </div>
</asp:Content>

