<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Welcome.aspx.vb" Inherits="Data_Information_Welcome" %>

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

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Welcome to TVSM Virtual Development Centre</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="text-center">
                <img src="../../Images/welcome.jpg" class="img-thumbnail" />
            </div>
        </div>
        <div class="col-md-6">
            <div class="mt-4">
                <p><b>Dear TVSM Colleague,</b></p>
                <p>Welcome to the Virtual Development Centre 2023!</p>
                <p>This is a virtual process that requires you to undergo a mix of simulated and non simulated exercises. Please begin by choosing your preferred date and time slot to go through the Virtual Development Centre.  Upon choosing your preferred slot, you will receive an email that details out the next steps to be taken to go ahead with the process.</p>
                <p>Thank you!</p>
                <div class="text-center mt-4">
                    <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Next" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

