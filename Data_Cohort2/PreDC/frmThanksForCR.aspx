<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" CodeFile="frmThanksForCR.aspx.cs" Inherits="Generalist_PreDC_frmThanksForCareerReflection" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="row" style="padding-top:50px;padding-left:100px">
        <div class="col-md-2">
            <div class="text-center">
                <img src="../../Images/ThankYou.png" class="img-thumbnail" />
            </div>
        </div>
        <div class="col-md-6">
            <div class="mt-4">
                <p style="font-size:19px">You may exit the system and login on the date of your assessment.</p>
            </div>
        </div>
    </div>
     <div id="dvDialog" style="display: none"></div>
   </asp:Content>
