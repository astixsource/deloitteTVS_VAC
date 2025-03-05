<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminMenu.aspx.cs" Inherits="Admin_Setting_AdminMenu" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
<script type="text/javascript">
        $(function () {
            $('#threebtns').css({
                "margin-top": ($(window).height() - $("#threebtns").outerHeight()) / 2 - $("nav.navbar").outerHeight() + "px"
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
	<div class="row absolute-center" id="threebtns">
		<div class="col-md-3"  id="divManageProcess" runat="server">
			<asp:LinkButton ID="lnkProcess" runat="server" class='btn-one w-100 m-3' OnClick="lnkProcess_Click">Manage Process</asp:LinkButton>
		</div>
		  <div class="col-md-3" id="divStartOrientationMeeting" runat="server" style="display:none">
            <a href='../MasterForms/frmGetParticipantListAgAssessor.aspx?flgcallfrom=2' class='btn-one w-100 m-3'>Start Orientation Meeting</a>
        </div>
		<div class="col-md-3">
			<asp:LinkButton ID="lnkDC" runat="server" class='btn-one w-100 m-3' OnClick="lnkDC_Click">View Participant DC Status</asp:LinkButton>
		</div>
<div class="col-md-3">
            <a href='../MasterForms/frmGetParticipantListForMarkAsComplete.aspx?flgcallfrom=2' class='btn-one w-100 m-3'>Mark Exercises As Completed</a>
        </div>
 <div class="col-md-3">
            <a href='../MasterForms/frmWashUp.aspx' class='btn-one w-100 m-3'>Integration Session</a>
        </div>
 <div class="col-md-3">
            <a href='../MasterForms/frmParticipantReportEditor.aspx' class='btn-one w-100 m-3'>Report Preparation</a>
        </div>
 <div class="col-md-3">
           <a href='../MasterForms/frmGetExperiencePageResponse.aspx' class='btn-one w-100 m-3'>Download Participant Experience Responses.</a>
        </div>

			<div class="col-md-3">
			<asp:LinkButton ID="lnkCaseStudyReports" runat="server" class='btn-one w-100 m-3' OnClick="lnkCaseStudyReports_Click">Download CaseStudy Reports</asp:LinkButton>
		</div>

		<%--<div class="col-md-3">
			<asp:LinkButton ID="lnkStatus" runat="server" class='btn-one w-100 m-3' OnClick="lnkReport_Click">Database & Reports</asp:LinkButton>
		</div>--%>
		<div class="w-100"></div>
		<div id="dvErrorMsg" runat="server"></div>
	</div>
    <asp:HiddenField ID="hdnLogin" runat="server" />
</asp:Content>
