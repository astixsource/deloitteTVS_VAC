<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmThanks.aspx.vb" Inherits="frmThanks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script type="text/javascript">
        function fnLogout() {
            window.location.href = "Login.aspx";
        }
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="conatnt-wrap">
        <h4 align="center" style="margin-top: 50pt;"><b>Thanks! You have successfully completed all exercises.</b></h4>
        <h5 align="center" style="margin-top: 30pt;"><b>Please close the browser before you leave the system.</b></h5>
    </div>
    <%--<div style="margin: 20pt 0; text-align: center;">
        <asp:Button ID="btnCLose" CssClass="btn btn-success" runat="server" Text="Close" OnClick="btnCLose_Click" />
    </div>--%>
</asp:Content>

