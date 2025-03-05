<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReplyFromSend.aspx.cs" Inherits="frmReply" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,Chrome=1" />
    <title></title>
    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        body {
            overflow: hidden;
            font-size: .8rem;
        }

        .inbox-title {
            background: #C0DCFF;
            position: relative;
            padding: 7px;
        }

            .inbox-title > img.mail-icon {
                width: 16px;
                height: 16px;
                position: absolute;
                top: 14px;
                left: 6px;
            }

        .mail-row-default {
            color: #202124;
            background: rgba(255,255,255,0.902);
            font-weight: 600;
            cursor: pointer;
        }

        .replymail-title {
            padding: 5px;
            border-bottom: 1px solid #849ab0;
            background: #C0DCFF;
            margin-top: 5px;
        }

        table.dvAction-table {
            width: 100%;
            margin-bottom: 0;
            border-bottom: 1px solid #849ab0;
            background: #C0DCFF;
        }

            table.dvAction-table > tbody > tr > td {
                padding: 7px 10px;
                text-align: left;
                white-space: nowrap;
            }

                table.dvAction-table > tbody > tr > td > a {
                    font-weight: bold;
                    color: #194597;
                }

        .table-sm th {
            padding: .3rem .75rem;
            font-size: 0.8rem;
        }

        .btn-xs {
            padding: .15rem .5rem !important;
            font-size: .775rem !important;
        }

        .btn-exit {
            padding: 0 .5rem;
            float: right;
            font-size: 1.5rem;
            font-weight: 700;
            line-height: 1;
            color: #000;
            text-shadow: 0 1px 0 #fff;
            opacity: .5;
            cursor: pointer
        }

        .mail-signature-block {
            display: inline-block !important;
            min-width: 315px;
        }

            .mail-signature-block > img {
                float: right;
                width: 50px;
            }

        .valign-b {
            vertical-align: middle !important;
            background: #F2DBDB;
        }

        .table > thead > tr > th {
            vertical-align: bottom;
            background: #cfcfcf;
            color: #0371c0;
            text-align: center;
            font-size: 9.5pt;
        }
    </style>

    <script src="../../Scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="../../Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        var _HtmlLength = 0;
        function fnSaveUserFeedback() {
            //debugger;
            var RspID = $("#hdnRspID").val();
            var RspMailInstanceID = $("#hdnRspMailInstanceID").val();
            //var FeedbackMailText = $("#txtBody").html();
            var FeedbackMailText = $("#txtBody").val();
            var MailFrom = $("#lblFrom").html();
            var MailSubject = $("#txtSubject").val();
            var MailTOID = $("#txtTo").val();
            var MailCCID = $("#txtCc").val();
            var MailPriorty = $("#hdnPriorty").val();
            var MailBCC = $("#txtBcc").val();
            var ParentUserMailResponseId = $("#hdnParentUserMailResponseId").val();

            if (MailTOID == "") {
                alert("Email To field should not be empty!");
                return false;
            }
            var flgMailResponseType = "5";// $("#hdnflgType").val();
            var spnAttachments = $("#tdUpload").find("span");
            var strAttachments = "";

            for (var i = 0; i < spnAttachments.length; i++) {
                var ids = $(spnAttachments[i]).attr("val");
                strAttachments += ids + "|";
            }
            if (_HtmlLength == $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length) {
                alert("Please add reply text first!");
                document.getElementById('HtmlEditorExtender1_ExtenderContentEditable').focus();
                return false;
            }
            parent.$("#dvFadeForProcessing").show();
            PageMethods.fnSaveUsermailFeedback(RspID, RspMailInstanceID, FeedbackMailText, MailFrom, MailSubject, MailTOID, MailCCID, MailBCC,flgMailResponseType, strAttachments, ParentUserMailResponseId, MailPriorty, fnSuccess, fnFail);
        }
        function fnSaveUserFeedbackAutoSave(flgAutoSave) {
            //debugger;
            var RspID = $("#hdnRspID").val();
            var ParentUserMailResponseId = $("#hdnParentUserMailResponseId").val();
            var RspMailInstanceID = $("#hdnRspMailInstanceID").val();
            var UserMailResponseID = $("#hdnUserMailResponseID").val();
            var FeedbackMailText = $("#txtBody").val();
            var MailFrom = $("#lblFrom").html();
            var MailSubject = $("#txtSubject").val();
            var MailTOID = $("#txtTo").val();
            var MailCCID = $("#txtCc").val();
            var MailPriorty = $("#hdnPriorty").val();
            var flgMailResponseType = $("#hdnflgType").val();
            var spnAttachments = $("#tdUpload").find("span");
            var strAttachments = "";
            for (var i = 0; i < spnAttachments.length; i++) {
                var ids = $(spnAttachments[i]).attr("val");
                strAttachments += ids + "|";
            }

            if (_HtmlLength != $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length) {
                PageMethods.fnSaveUsermailFeedback(RspID, RspMailInstanceID, $("#HtmlEditorExtender1_ExtenderContentEditable").html(), MailFrom, MailSubject, MailTOID, MailCCID, flgMailResponseType, strAttachments, ParentUserMailResponseId, MailPriorty, fnSuccessAuto);
            }
        }
        function fnSuccessAuto(result) {
            if (result.split("^")[1] == "1") {
                var UserMailResponseID = document.getElementById("hdnUserMailResponseID").value;
                if (parseInt(UserMailResponseID) == 0) {
                    document.getElementById("hdnUserMailResponseID").value = result.split("^")[0];
                }
            }
        }
        function fnSuccess(result) {
            if (result.split("^")[1] == "1") {
                alert("Mail Sent Successfully.");
                parent.fnGetEmail();
            }
            else {
                alert(result.split("^")[0]);
                parent.$("#dvFadeForProcessing").hide();
            }
            //  return false;
        }
        function fnFail(result) {
            alert(result);
            //return false;
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#tdUpload").html("");
            Sys.Application.add_load(function () {
                // Get the Editor Div by Class Name. 
                var htmlEditorBox = $('.ajax__html_editor_extender_container');
                htmlEditorBox.attr("style", "width:100%; background:#FFF");
            });
            $("#txtBody").css("height", $(window).height() - 165 + "px");
            $("#txtBody").focus();

            var Priorty = document.getElementById("hdnPriorty").value;
            var PText = "";
            if (Priorty == "3")
            {
                PText = "High";
            }
            else if (Priorty == "2")
            {
                PText = "Medium";
            }
            else if (Priorty == "1")
            {
                PText = "Low";
            }
            $("#dvPrioty").html("<strong>Priority :- </strong>" + PText)
        });
        window.onload = function () {
            setTimeout(function () {
                document.getElementById('HtmlEditorExtender1_ExtenderContentEditable').focus();
                _HtmlLength = $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length;
            }, 1000);
        };
    </script>
    <script type="text/javascript">
        function xyz(elem, par) {
            IframeHide(par);
        }

        function IframeHide(par) {

            document.getElementById("dvbodyFront").style.display = "none";
            document.getElementById("dvShowRouteDetails").style.display = "block";
            if (par == "ReviewOfCorbenSchoolExpansion")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/34. Review of Corben School Expansion email attachment.htm";
            else if (par == "BudgetStatusAnalysisVitlar")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/19.BudgetStatusAnalysisVitlar_email_attachment.htm";
            else if (par == "Budgets")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/16.Budgets _email_attachment.htm";
            else if (par == "Project_List_Attachment")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/16.  Project_List_Attachment_2012.02.15.htm";
            else if (par == "Financial_Model")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/16.Financial_Model_email_attachment.htm";
            else if (par == "Freshroom.comRatingSystem")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/11.  Freshroom.com Rating System email attachment.htm";
            else if (par == "Kiva_Canyon_Market_Research_Executive_Summary")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/2. Kiva_Canyon_Market_Research_Executive_Summary.htm";
            else if (par == "BoulderAssocCaseStudy.pdf")
                document.getElementById("ifShowRouteDetails").src = "Email Attachments/htmlize/31.Boulder_Assoc_Case_Study_email_attachment.htm";
        }

        function ClosePopUp() {
            document.getElementById("dvShowRouteDetails").style.display = "none";
            document.getElementById("dvbodyFront").style.display = "none";
        }

    </script>
</head>
<body>
    <form id="form1" runat="server" spellcheck="false">
        <ajaxToolkit:ToolkitScriptManager runat="server" ID="scriptManager1" EnablePageMethods="true">
        </ajaxToolkit:ToolkitScriptManager>
        <div style="background: #E9EDF1; padding: 0 10px;">
            <div id="dvPrioty" style="text-align:center"></div>
            <table width="100%" border="0" cellspacing="0" cellpadding="2" bgcolor="#E9EDF1">
                <tr>
                    <%--<td rowspan="5" width="5%" align="center">
                        <input type="button" name="a" id="a" value="Send" onclick="fnSaveUserFeedback();" style="height: 124px;" />
                    </td>--%>
                    <td width="5%">
                        <input type="button" name="a" id="b" value="From" style="min-width: 86px;" />
                    </td>
                    <td align="left">
                        <label id="lblFrom" runat="server">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" name="a" id="c" value="To" style="min-width: 86px;" />
                    </td>
                    <td>
                        <input type="text" name="aa" id="txtTo" style="width: 100%; border: 1px solid #9D9FA1;" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" name="a" id="d" value="Cc" style="min-width: 86px;" />
                    </td>
                    <td>
                        <input type="text" name="aa" id="txtCc" style="width: 100%; border: 1px solid #9D9FA1;"
                            runat="server" />
                    </td>
                </tr>
                 <tr>
                    <td>
                        <input type="button" name="a" id="d" value="Bcc" style="min-width: 86px;" />
                    </td>
                    <td>
                        <input type="text" name="aa" id="txtBcc" style="width: 100%; border: 1px solid #9D9FA1;"
                            runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>Subject
                    </td>
                    <td>
                        <input type="text" name="aa" id="txtSubject" style="width: 100%; border: 1px solid #9D9FA1;"
                            runat="server" />
                    </td>
                </tr>
            </table>

            <%--<asp:TextBox ID="txtBody" Enabled="false" runat="server" TextMode="MultiLine" Style="width: 100%; height: auto"></asp:TextBox>--%>
            <div id="divmailcontainer" style="background-color:#fff" runat="server"></div>
          <%--  <ajaxToolkit:HtmlEditorExtender ID="HtmlEditorExtender1"  runat="server"  EnableSanitization="false">
                <Toolbar>
                    <ajaxToolkit:Undo />
                    <ajaxToolkit:Redo />
                    <ajaxToolkit:Bold />
                    <ajaxToolkit:Italic />
                    <ajaxToolkit:Underline />
                    <ajaxToolkit:StrikeThrough />
                    <ajaxToolkit:Subscript />
                    <ajaxToolkit:Superscript />
                    <ajaxToolkit:JustifyLeft />
                    <ajaxToolkit:JustifyCenter />
                    <ajaxToolkit:JustifyRight />
                    <ajaxToolkit:JustifyFull />
                    <ajaxToolkit:InsertOrderedList />
                    <ajaxToolkit:InsertUnorderedList />
                    <ajaxToolkit:CreateLink />
                    <ajaxToolkit:UnLink />
                    <ajaxToolkit:RemoveFormat />
                    <ajaxToolkit:SelectAll />
                    <ajaxToolkit:UnSelect />
                    <ajaxToolkit:Delete />
                    <ajaxToolkit:Cut />
                    <ajaxToolkit:Copy />
                    <ajaxToolkit:Paste />
                    <ajaxToolkit:BackgroundColorSelector />
                    <ajaxToolkit:ForeColorSelector />
                    <ajaxToolkit:FontNameSelector />
                    <ajaxToolkit:FontSizeSelector />
                    <ajaxToolkit:Indent />
                    <ajaxToolkit:Outdent />
                    <ajaxToolkit:InsertHorizontalRule />
                    <ajaxToolkit:HorizontalSeparator />
                </Toolbar>
            </ajaxToolkit:HtmlEditorExtender>--%>
        </div>
        <div style="display: none" id="dvbodyFront">
            <div id="dvbody" runat="server" style="background: #E9EDF1; padding: 5px 0px; border: 1px solid #9D9FA1;">
            </div>
        </div>

        <div id="dvShowRouteDetails" align="center" class="white_contentRouteDetails" style="display: none; overflow: hidden">
            <img src="Images/close.png" height="30px" width="30px" alt="" onclick="ClosePopUp()" style="float: right; cursor: pointer" />
            <iframe frameborder="0" src="" id="ifShowRouteDetails" width="100%" height="450px" style="vertical-align: middle; overflow: hidden; background-color: White"></iframe>
        </div>

        <asp:HiddenField runat="server" ID="hdnMailOrderNo" Value="0" />
        <asp:HiddenField runat="server" ID="hdnRspID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnExerciseMultiMailID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnRspMailInstanceID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnMailFrom" Value="" />
        <asp:HiddenField runat="server" ID="hdnSubject" Value="" />
        <asp:HiddenField runat="server" ID="hdnCc" Value="" />
        <asp:HiddenField runat="server" ID="hdnTo" Value="" />
        <asp:HiddenField runat="server" ID="hdnflgType" Value="0" />
        <asp:HiddenField runat="server" ID="hdnPriorty" Value="0" />
        <asp:HiddenField runat="server" ID="hdnParentUserMailResponseId" Value="0" />
    </form>
</body>
</html>
