<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="frmSessionExpire.aspx.vb" Inherits="frmSessionExpire" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="Scripts/jquery.min-3.6.0.js"></script>
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
		
        function fnGoToLogin()
        {
            
            window.location.href = "../../Login.aspx";
        }
        

    </script>
	<script type="text/javascript">
        $(document).ready(function ()
        {
            $("#panellogout,#panelback,#panelhome").hide();
           // $("#imgLogo2").css("margin-right", "60px");
			
        })
       
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="middle-cont" style="margin-top:100px">
        <div class="text-center">
           <%-- <h2 class="icon4thanku"><span class="fa fa-check"></span></h2>--%>
        </div>
        <h5 class="text-center mt-4"><em>Your session has been expired. Please click on the below button to login it again.</em></h5>
       
        <div class="text-center m-4">
           <input type="button" id="btnGoToSession" Class="btns btn-submit" onclick="fnGoToLogin()" value="Click here to login" />
        </div>
    </div>
</asp:Content>

