<%@ Page Title="" Language="C#" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="true" CodeFile="frmThankYou.aspx.cs" Inherits="frmThankYou" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="Css/bootstrap.min.css" rel="stylesheet" />
    <link href="Css/style.css" rel="stylesheet" />
    <style type="text/css">
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .outer {
            width: 100%;
            height: 100%;
            display: table;
            box-sizing: border-box;
            margin-bottom: 0;
            padding: 0;
        }

        .inner {
            display: table-cell;
            vertical-align: middle;
            text-align: center;
            padding: 0 16px;
        }

        .icon {
            padding: 14pt;
            color: #009032 !important;
            border: 6px solid #009032;
            width: 84px;
            display: inline-block;
            border-radius: 50%;
        }
    </style>
    <script type="text/javascript">
        function fnLogout() {
            window.location.href = "Login.aspx";
        }
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        $(document).ready(function () {
            $("#rolehead").hide();
        })
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="jumbotron outer">
        <div class="section inner">
            <h2 class="icon"><span class="glyphicon glyphicon-ok"></span></h2>

            <p style="margin-top: 15pt;text-align:center"><em>Thanks! You have successfully completed your all exercises.</em></p>
            <p style="text-align:center">Please close the browser before you leave the system.</p>
            <div style="margin: 20pt 0; text-align: center;">
                <asp:Button ID="btnCLose" CssClass="btn btn-success" runat="server" Text="Close" OnClick="btnCLose_Click" />
            </div>
        </div>
    </div>
</asp:Content>

