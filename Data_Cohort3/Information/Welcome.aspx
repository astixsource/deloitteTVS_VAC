<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/SiteInstruction.master" AutoEventWireup="false" CodeFile="Welcome.aspx.vb" Inherits="Data_Information_Welcome" %>

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
    <h3 class="text-center">Welcome to TVS Competency Development Centre</h3>
    <div class="title-line-center"></div>
</div>
<p>Dear All,</p>
<p>Welcome to TVS Competency Development Centre.</p>
<p>Thank you for taking the time to participate in this assessment. </p>
<p>We’ve designed a series of exercises tailored to gauge your functional competencies, reflecting real-life, day-to-day challenges you encounter in your role. These tasks will be evaluated by trained professionals, providing valuable input for your development journey. This assessment is an opportunity to gain meaningful insights into your current skill set—both for your present role and future career aspirations. </p>
<p>We request you to make most of this opportunity and attempt each exercise with utmost sincerity and candidness.</p>
<p>As the next step, upon completion, you will receive a personalized report outlining your key strengths and potential development areas, helping you access tailored learning opportunities to grow your career at TVS.</p>

<p class="font-weight-bold">Regards</p>
<p class="font-weight-bold">TVS Leadership</p>
    <div class="text-center mt-2">
        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Next" />
    </div>
</asp:Content>

