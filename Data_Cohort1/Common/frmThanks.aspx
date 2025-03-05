<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmThanks.aspx.vb" Inherits="frmThanks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
      <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript">
        function fnLogout() {
            window.location.href = "Login.aspx";
        }
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        $(function () {
            $('.middle-cont').css({
                "margin-top": ($(window).height() - $(".middle-cont").outerHeight()) / 2 - ($(".navbar").outerHeight() + 30) + "px"
            });
        });
		
		

    </script>
	<script type="text/javascript">
        $(document).ready(function ()
        {
            $("#rolehead").css("display", "none");
			 $("#liBackground").css("display", "none");
			
        })
       
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="middle-cont">
        <div class="text-center">
            <h2 class="icon4thanku"><span class="fa fa-check"></span></h2>
        </div>
        <h5 class="text-center mt-4"><em>You have completed your Assessment. Please close the browser before you leave the system.</em></h5>
        <h5 class="text-center"></h5>
        <%--<div class="text-center m-4">
            <asp:Button ID="btnCLose" CssClass="btns btn-submit" runat="server" Text="Close" OnClick="btnCLose_Click" />
        </div>--%>
    </div>
</asp:Content>

