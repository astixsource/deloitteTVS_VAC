<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/SiteManager.master" AutoEventWireup="false" CodeFile="frmManagerAssessmentBackground.aspx.vb" Inherits="Admin_Evidence_frmManagerAssessmentBackground" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
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
        $(document).ready(function () {
            $("#rolehead").css("display", "none");
            $("#liBackground").css("display", "none");
           
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Manager Assessment Instruction and Background</h3>
        <div class="title-line-center"></div>
    </div>
    <p>Dear Manager,</p>
    <p>As part of the 'TVS Competency Development Initiative' we are pleased to invite you to participate in the evaluation of your direct report, by filling out the ‘Manager Assessment Form’. While providing your feedback, please assess the extent to which the given question applies to the individual you are rating within the context of the provided set of questions. Your feedback is essential for accurately evaluating their competencies and supporting their professional development.</p>

    <p class="font-weight-bold">Regards</p>
    <p class="font-weight-bold">TVS Leadership</p>
    <div class="text-center mt-2">
        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Next" OnClick="btnSubmit_Click" />
    </div>
</asp:Content>

