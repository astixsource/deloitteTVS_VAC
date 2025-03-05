<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
     <noscript>
    JavaScript is disabled in your browser.
</noscript>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <title>Assessment</title>
    <link href="Images/EYlogo.ico" rel="shortcut icon" type="image/x-icon" />
    <!-- Latest compiled and minified CSS -->
    <link href="CSS/font-awesome.css" rel="stylesheet" type="text/css" />
    <link href="CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="CSS/jquery-ui.css" rel="stylesheet" type="text/css">
    <link href="CSS/style.css" rel="stylesheet" type="text/css" />

    <!-- Latest compiled and minified JS -->
    <script src="Scripts/jquery.min-3.6.0.js" type="text/javascript"></script>
    <script src="Scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="Scripts/login.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.addEventListener("visibilitychange", function () {
            if (document.hidden) {
                console.log("User switched tab or minimized browser");
                // Send an alert or log this event
            } else {
                console.log("User is back on the tab");
            }
        });

        function enterFullscreen() {
            let elem = document.documentElement;
            let requestMethod = elem.requestFullscreen || elem.mozRequestFullScreen || elem.webkitRequestFullscreen || elem.msRequestFullscreen;

            if (requestMethod) {
                requestMethod.call(elem);
            } else {
                console.warn("Fullscreen mode is not supported by this browser.");
            }
        }
        $(window).on("load resize", function () {
            $("img.bg-img").hide();
            var $url = $("img.bg-img").attr("src");
            $('.full-background').css('backgroundImage', 'url(' + $url + ')');

            $('.loginfrm').css({
                "margin-top": ($(window).height() - ($(".loginfrm").outerHeight() + 50)) / 2 + "px",
                "margin-left": ($(window).width() - $(".loginfrm").outerWidth()) * 1 / 6 + "px"
            });

            $('input[type="text"], input[type="password"]').focus(function () {
                $(this).data('placeholder', $(this).attr('placeholder')).attr('placeholder', '');
            }).blur(function () {
                $(this).attr('placeholder', $(this).data('placeholder'));
            });
        });
    </script>
    <script type="text/javascript">
        function ShowRunningAssesments() {
            fnReset();

            $(<%=dvAlertDialog.ClientID %>).dialog({
                title: 'Alert',
                modal: true,
                width: '40%',
                buttons: [{
                    text: "OK",
                    click: function () {
                        $(<%=dvAlertDialog.ClientID %>).dialog("close");
                    }
                }]
            });
        }

        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };

        function fnReset() {
            document.getElementById("<%=txtUserName.ClientID %>").value = "";
            document.getElementById("<%=txtPwd.ClientID %>").value = "";
            document.getElementById("<%=txtUserName.ClientID %>").focus();
            return false;
        }

        function fnValidate() {
            document.getElementById("<%=hdnRes.ClientID %>").value = screen.availWidth + "*" + screen.availHeight;
            if (document.getElementById("<%=txtUserName.ClientID %>").value == "") {
                document.getElementById("<%=lblloginmsg.ClientID %>").innerText = "User Name can't be blank";
                document.getElementById("<%=txtUserName.ClientID %>").focus();
                return false;
            }
            if (document.getElementById("<%=txtPwd.ClientID %>").value == "") {
                document.getElementById("<%=lblloginmsg.ClientID %>").innerText = "Password can't be blank";
                document.getElementById("<%=txtPwd.ClientID %>").focus();
                return false;

            }
        }

    </script>

    <!-- WARNING: Respond.js doesn't work if you view the page via file: -->
    <!--[if lt IE 9]>
  <script src="Scripts/html5shiv.min.js"></script>
  <script src="Scripts/respond.min.js"></script>
<![endif]-->
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="scrLogin"></asp:ScriptManager>
        <div class="full-background">
            <img src="Images/login_bg.jpg" alt="background" class="bg-img">
        </div>


        <div class="wrapper">
            <div class="main-header">
                <div class="container">
                    <!-- Logo -->
                    <a href="#" class="logo">
                        <!-- logo for regular state and mobile devices -->
                        <span class="logo-lg">
                            <asp:Image ID="imgLogo1" runat="server" ImageUrl="~/Images/deloitte.svg" title="logo" />
                        </span></a>
                    <div class="navbar-right">
                        <span class="logo">
                            <asp:Image ID="imgLogo2" runat="server" ImageUrl="~/Images/TVS_Logo.svg" title="logo" />
                        </span>
                    </div>
                </div>
            </div>
            <div class="container-fluid">
                <%--login section start here--%>
                <div class="loginfrm cls-4">
                    <div class="login-box">
                        <div class="login-box-msg">
                            <h3 class="title">Login To</h3>
                        </div>
                        <div class="login-box-body clearfix">
                            <div class="input-group frm-group-txt">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fa fa-user"></i></span>
                                </div>
                                <input type="text" class="form-control" placeholder="user name" id="txtUserName" runat="server" autocomplete="off" />
                            </div>
                            <div class="input-group frm-group-txt">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fa fa-lock"></i></span>
                                </div>
                                <input type="password" class="form-control" placeholder="password" id="txtPwd" runat="server" autocomplete="off" />
                            </div>
                            <div class="text-center">
                                <asp:Label ID="lblloginmsg" runat="server" class="text-danger font-weight-bold"></asp:Label>
                            </div>

                            <div class="bottom-text text-right mb-3">
                                <span class="forgotpwd">Forgot <a href="#" onclick="fnForgotPwd()">Password</a>?</span>
                            </div>
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit w-100" Text="Login" OnClick="btnSubmit_Click" />
                        </div>
                    </div>
                    <div class="login-box"></div>
                </div>
            </div>
        </div>

        <div id="dvForgotPwd" class="dvhide">
            <div class="form-group pl-4 pr-4">
                <div class="cls_title">Enter Your Username</div>
                <div class="frm-group-txt" data-validate="Enter username">
                    <input type="text" placeholder="Username" id="txtUsernameForForgotPassword" maxlength="100" runat="server" name="Username" class="form-control" />
                    <span class="custom-focus-input" data-placeholder="&#xe008;"></span>
                </div>
            </div>
            <div class="text-center mt-3 mb-2">
                <input type="button" id="btnSendResetLink" value="Reset Password" class="btns btn-submit btns-small" onclick="fnSendResetLink()" />
            </div>
        </div>

        <div id="dvAlertDialog" style="display: none" runat="server"></div>
        <asp:HiddenField ID="hdnRes" runat="server" />
       <input type="hidden" id="csrfToken" name="csrfToken" value="<%= Session["CsrfToken"] %>" />
   
    </form>


</body>
</html>
