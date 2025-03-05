<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Data_Cohort1/MasterPage/Site.master" CodeFile="frmThanksForCareerReflection.aspx.cs" Inherits="Generalist_PreDC_frmThanksForCareerReflection" %>
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
        function fncloseExit() {
            window.location.href = "frmThanksForCR.aspx";
        }

        function fnShowPop(flg) {
            var strMsg = "";
            if (flg == 1) {
                strMsg = "This completes your Pre-VDC process. Please log in on the day of your VDC to go through the same. All the best!";
            } else {
                strMsg = "Please go through the Peer Role Play Preparation Material that was emailed to you in order to complete your Pre VDC process.";
            }

            $("#dvDialog")[0].innerHTML = strMsg;
            $("#dvDialog").dialog({
                title: "Alert!",
                modal: true,
                width: "450",
                height: "auto",
                open: function () {
                    var LoginId = $("#ConatntMatter_hdnLogin").val();
                    PageMethods.spMarkPRPRead(LoginId,flg, function (result) { }, function () { });
                },
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "OK": function () {
                        $(this).dialog('close');
                    }
                }
            });
        }
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
                <p>Thank you for submitting your Career Reflection Form</p>
                <p>Please confirm that you have read the Peer Role Play Preparation Material</p>
                <table>
                    <tr>
                        <td class="p-1">
                            <label><input type="radio" name="rdoconfirm" value="1" onclick="fnShowPop(1)" /> Yes,I have</label>
                        </td>
                        <td class="p-1">
                            <label><input type="radio" name="rdoconfirm" value="2" onclick="fnShowPop(2)" /> No,I have Not</label>
                        </td>
                    </tr>
                </table>
                <div class="text-center mt-4">
                    <input type="button" id="btnSubmit" onclick="fncloseExit()" class="btns btn-submit" value="Close & Exit" />
                </div>
            </div>
        </div>
    </div>
     <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField ID="hdnLogin" runat="server" />
   </asp:Content>
