<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmChangePassword.aspx.cs" Inherits="frmChangePassword" %>


<!DOCTYPE html>
<html>
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=10,IE=edge,chrome=1">
    <link href="../Images/favicon1.png" rel="shortcut icon" type="image/x-icon" />

    <title>Assessment</title>
    <!-- Latest compiled and minified CSS -->
    <link href="Images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <!-- Latest compiled and minified CSS -->
    <link href="CSS/font-awesome.css" rel="stylesheet" type="text/css" />
    <link href="CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="CSS/jquery-ui.css" rel="stylesheet" type="text/css">
    <link href="CSS/style.css" rel="stylesheet" type="text/css" />

    <!-- Latest compiled and minified JS -->
    <script src="Scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="Scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="Scripts/changepwd.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(window).on("load resize", function () {
            $("img.bg-img").hide();
            var $url = $("img.bg-img").attr("src");
            $('.full-background').css('backgroundImage', 'url(' + $url + ')');

            $(".login-img").css({
                "margin-top": ($(window).height() - $(".login-img").outerHeight()) / 2 + "px"
            });
            $('.loginfrm').css({
                "margin": ($(window).height() - $(".loginfrm").outerHeight()) / 2 + "px auto 0"
                //"margin-left": ($(window).width() - $(".loginfrm").outerWidth()) * 3 / 4 + "px"
            });
        });
    </script>
    <!-- WARNING: Respond.js doesn't work if you view the page via file: -->
    <!--[if lt IE 9]>
  <script src="Scripts/html5shiv.min.js"></script>
  <script src="Scripts/respond.min.js"></script>
<![endif]-->
</head>
<body>
    <form id="form1" runat="server">
        <div class="full-background">
            <img src="Images/login_bg.jpg" class="bg-img" />
        </div>
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <div class="login-img">
                        <img src="Images/TVS_Logo_shadow.svg" class="w-100" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="loginfrm cls-4">
                        <div class="login-box">
                            <div class="login-box-msg">
                                <h3 class="title">Change Password</h3>
                                <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>
                            </div>
                            <div class="login-box-body clearfix">
                                <div class="mb-2">
                                    <label class="form-label">Username</label>
                                    <input name="txtUserName" type="text" id="txtUserName" runat="server" class="form-control" disabled="disabled" />
                                    <span id="RequiredFieldValidator1" style="color: Red; display: none;">*</span>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label">Old Password</label>
                                    <input name="txtOldPassword" type="password" id="txtOldPassword" class="form-control" style="display: inline;" />
                                    <span id="RequiredFieldValidator4" style="color: Red; display: none;">*</span>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label">New Password</label>
                                    <input name="txtNewPassword" type="password" id="txtNewPassword" class="form-control" style="display: inline;" />
                                    <span id="RequiredFieldValidator2" style="color: Red; display: none;">*</span><span id="spanNewPassword"></span>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label">Confirm New Password</label>
                                    <input name="txtConfirmPassword" type="password" id="txtConfirmPassword" class="form-control" style="display: inline;" />
                                    <span id="RequiredFieldValidator3" style="color: Red; display: none;">*</span><span id="spanConfirmPassword"></span>
                                </div>
                                <div class="pt-3">
                                    <input type="button" name="SubmitBtn" value="Submit" id="ctl00_SubmitBtn" class="btns btn-submit w-100" />
                                    <div id="ctl00_ValidationSummary1" class="label label-danger labeldanger"></div>
                                </div>
                                <%-- <div class="bottom-text">
                                    <span class="forgotpwd">Read New Password<a href="#" onclick="fnNewPwd()"> Instruction</a>?</span>
                                </div>--%>
                            </div>
                        </div>
                        <div class="login-box alt">
                            <div class="toggle"></div>
                        </div>

                        <div class="login-box"></div>
                    </div>
                </div>
            </div>
        </div>
        <div id="dvNewPwd">
            <ul class="normal-list">
                <p><b>Passwords must, at minimum, contain the following: </b></p>
                <li>Passwords must consist of at least ten (10) characters </li>
                <li>An uppercase alphabetical character (e.g., A-Z) </li>
                <li>A lowercase alphabetical character (e.g., a-z) </li>
                <li>A special character (e.g., !, $, @, %) </li>
                <li>Two (2) numerical digits (e.g., 0-9) </li>
                <li>Passwords must not start or end with a number</li>
            </ul>
        </div>
        <input type="hidden" id="hdnRes" runat="server" name="hdnRes">
        <input type="hidden" id="hdnIsDistributor" value="0" runat="server" />
        <input type="hidden" id="hdnShowLaterButton" value="0" runat="server" />
    </form>
</body>
</html>
