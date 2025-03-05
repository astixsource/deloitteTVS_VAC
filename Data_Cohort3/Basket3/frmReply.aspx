<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReply.aspx.cs" Inherits="frmReply" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,Chrome=1" />
    <title></title>
    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/Site.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" type="text/css" />
    <%--<link href="../../CSS/InboxSite.css" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        table.Financials-tbl {
            width: 60% !important;
        }

            table.Financials-tbl > tbody > tr > td:first-child {
                text-align: left;
            }

            table.Financials-tbl > tbody > tr > td:last-child {
                width: 100px;
                text-align: center;
            }

        body {
            font-weight: 300;
            font-size: .85rem !important;
            font-weight: normal;
        }

        .panel {
            position: relative;
        }

        ul.nav-tabs {
            display: none;
        }

        /*.nav-tabs {
            position: fixed;
            top: 39px;
            left: 10px;
            width: 100%;
            background: #fff;
        }

        .nav-tabs > li {
            margin-bottom: -1px;
        }

            .nav-tabs > li > a.nav-link {
                background: #d9edf7;
                color: #31708f;
                margin-right: 5px;
                border: 1px solid #bce8f1;
                position: relative;
            }

                .nav-tabs > li > a.nav-link::after {
                    content: "";
                    background: #4285F4;
                    height: 3px;
                    position: absolute;
                    width: 100%;
                    left: 0px;
                    top: -1px;
                    transition: all 250ms ease 0s;
                    transform: scale(0);
                }

                .nav-tabs > li > a.nav-link.active {
                    color: #044d91;
                }

                    .nav-tabs > li > a.nav-link.active::after,
                    .nav-tabs > li > a.nav-link:hover::after {
                        transform: scale(1);
                    }

        .tab-nav > li > a.nav-link::after {
            background: #21527d none repeat scroll 0% 0%;
            color: #fff;
        }*/

        .tab-content {
            padding: 15px;
        }

        /*.tab-content > .tab-panel {
                margin-top: 30px;
            }

        .fade {
            display: none;
        }

        .show {
            display: block !important;
        }*/

        table.mailtable {
            border-collapse: collapse;
            border-spacing: 0;
            margin-bottom: 20px;
        }

            table.mailtable > tbody > tr > td,
            .tab-panel > .mailbodydv {
                padding: 2px 6px;
            }

                table.mailtable > tbody > tr > td:nth-child(1) {
                    width: 90px;
                    font-weight: 700;
                }

        .mail-signature-block {
            display: inline-block !important;
            min-width: 315px;
        }

        p.mail-signature-block > img,
        p > img {
            float: right !important;
            width: 50px !important;
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

        table#Financials-tbl > tbody > tr > td:first-child {
            text-align: left !important;
        }
    </style>

    <script src="../../Scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="../../Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <%--  <script src="../../Scripts/validation.js" type="text/javascript"></script>--%>
    <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        function fnShowDialog(msg) {
            $("#dvDialog").html(msg)
            $("#dvDialog").dialog({
                title: "Alert!",
                modal: true,
                width: "auto",
                height: "auto",
                option: function () {
                    $("div[aria-describedby='dvDialog']").find("button.ui-dialog-titlebar-close").hide();
                },
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "OK": function () {
                        $(this).dialog('close');
                    }
                }
            })
        }
        var _HtmlLength = 0;
        function fnSaveUserFeedback() {
            //debugger;


            if (parent.$('input[name="ddlPrority"]:checked').length == "0") {
                fnShowDialog("Please select priority for this mail");
                parent.$('#ddlPrority input').eq(0).focus();
                return false;
            }

            $("#dvDialog").html("Are you sure this is your final response to this email? Once submitted, you won’t be able to make any changes.")
            $("#dvDialog").dialog({
                title: "Confirmation:",
                modal: true,
                width: "auto",
                height: "auto",
                option: function () {
                    $("div[aria-describedby='dvDialog']").find("button.ui-dialog-titlebar-close").hide();
                },
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "Yes": function () {
                        $(this).dialog('close');
                        var MailPriorty = parent.$('input[name="ddlPrority"]:checked').val()
                        // var MailPriorty = parent.$("input[id='ddlPrority']:checked").val(); //parent.$("#ddlPrority").val();
                        var RspID = $("#hdnRspID").val();
                        var RspMailInstanceID = $("#hdnRspMailInstanceID").val();
                        //var FeedbackMailText = $("#txtBody").html();
                        var FeedbackMailText = $("#txtBody").val();
                        var MailFrom = $("#lblFrom").html();
                        var MailSubject = $("#txtSubject").val();
                        var MailTOID = $("#txtTo").val();
                        var MailCCID = $("#txtCc").val();
                        var MailBCC = $("#txtBCC").val();

                        if (MailTOID == "") {
                            fnShowDialog("Email To field should not be empty!");
                            return false;
                        }
                        var flgMailResponseType = $("#hdnflgType").val();
                        var spnAttachments = $("#tdUpload").find("span");
                        var strAttachments = "";
                        for (var i = 0; i < spnAttachments.length; i++) {
                            var ids = $(spnAttachments[i]).attr("val");
                            strAttachments += ids + "|";
                        }
                        if (_HtmlLength == $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length) {
                            fnShowDialog("Please add reply text first!");
                            document.getElementById('HtmlEditorExtender1_ExtenderContentEditable').focus();
                            return false;
                        }
                        document.getElementById("dvLoadingImg").style.display = "block";
                        PageMethods.fnSaveUsermailFeedback(RspID, RspMailInstanceID, FeedbackMailText, MailFrom, MailSubject, MailTOID, MailCCID, MailBCC, flgMailResponseType, strAttachments, MailPriorty, fnSuccess, fnFail);

                    },
                    "No": function () {
                        $(this).dialog('close');
                        document.getElementById("btnNext").disabled = false;
                    }
                }
            })

        }

        function fnSaveUserFeedbackAutoSave(flgAutoSave) {
            //debugger;

            //alert("MK");
            //return false;
            var MailPriorty = parent.$("#ddlPrority").val();
            MailPriorty = MailPriorty == 0 ? 4 : MailPriorty;
            var RspID = $("#hdnRspID").val();
            var RspMailInstanceID = $("#hdnRspMailInstanceID").val();
            var UserMailResponseID = $("#hdnUserMailResponseID").val();
            //var FeedbackMailText = $("#txtBody").html();
            var FeedbackMailText = $("#txtBody").val();
            var MailFrom = $("#lblFrom").html();
            var MailSubject = $("#txtSubject").val();
            var MailTOID = $("#txtTo").val();
            var MailCCID = $("#txtCc").val();
            var MailBCC = $("#txtBCC").val();
            var flgMailResponseType = $("#hdnflgType").val();
            var spnAttachments = $("#tdUpload").find("span");
            var strAttachments = "";
            for (var i = 0; i < spnAttachments.length; i++) {
                var ids = $(spnAttachments[i]).attr("val");
                strAttachments += ids + "|";
            }
            //if (_HtmlLength == $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length) {
            //    alert("Please add reply text first!");
            //    document.getElementById('HtmlEditorExtender1_ExtenderContentEditable').focus();
            //    return false;
            //}
            //document.getElementById("dvLoadingImg").style.display = "block";
            if (_HtmlLength != $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length) {
                PageMethods.fnSaveUsermailFeedback(RspID, RspMailInstanceID, $("#HtmlEditorExtender1_ExtenderContentEditable").html(), MailFrom, MailSubject, MailTOID, MailCCID, flgMailResponseType, strAttachments, MailPriorty, fnSuccessAuto);
            }
        }

        function fnSuccessAuto(result) {
            if (result.split("^")[1] == "1") {
                document.getElementById("hdnUserMailResponseID").value = result.split("^")[0];
            }
        }


        function fnSuccess(result) {
            document.getElementById("dvLoadingImg").style.display = "none";
            if (result.split("^")[1] == "1") {
                parent.fnUpdateStatus();
                fnShowDialog("Mail Sent Successfully.");
                parent.fnCloseQuestion();
            }
            else {
                fnShowDialog(result.split("^")[0]);
            }
            //  return false;
        }
        function fnFail(result) {
            document.getElementById("dvLoadingImg").style.display = "none";
        }

    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            var snjittblW = $("table#Sanjittbl-1").width(), snjittblCol = $("table#Sanjittbl-1 tr").find("th").length
            var snjittblW2 = $("table#Sanjittbl-2").width(), snjittblCol2 = $("table#Sanjittbl-2 tr").find("th").length
            var Financials = $("table#Financials-tbl").width(), FinancialsCol = $("table#Financials-tbl tr").find("td").length
            $("table#Sanjittbl-1 tr th").css({
                width: snjittblW / snjittblCol + "%"
            });
            $("table#Sanjittbl-2 tr th").css({
                width: snjittblW2 / snjittblCol2 + "%"
            });
            $("table#Financials-tbl tr td").css({
                width: Financials / FinancialsCol + "%"
            });

            $("#dvLoadingImg").hide();
            $("#tdUpload").html("");
            Sys.Application.add_load(function () {
                // Get the Editor Div by Class Name. 
                var htmlEditorBox = $('.ajax__html_editor_extender_container');
                htmlEditorBox.attr("style", "width:100%; background:#FFF");
            });
            parent.$("#ddlPrority option[value=0]").prop("selected", true);
            $("#txtBody").css("height", $(window).height() - 170 + "px");
            //document.getElementById('HtmlEditorExtender1_ExtenderContentEditable').focus();
            //_HtmlLength = $("#txtBody").val().length;
        });

        window.onload = function () {
            setTimeout(function () {
                document.getElementById('HtmlEditorExtender1_ExtenderContentEditable').focus();
                _HtmlLength = $("#HtmlEditorExtender1_ExtenderContentEditable").text().trim().length;
            }, 1000);
        };
    </script>
</head>
<body>
    <form id="form1" runat="server" spellcheck="false">
        <ajaxToolkit:ToolkitScriptManager runat="server" ID="scriptManager1" EnablePageMethods="true">
        </ajaxToolkit:ToolkitScriptManager>
        <div style="background: #E9EDF1; padding: 0 10px;">
            <table width="100%" border="0" cellspacing="0" cellpadding="2" bgcolor="#E9EDF1">
                <tr>
                    <td rowspan="5" width="5%" align="center">
                        <input type="button" name="a" id="a" value="Send" onclick="fnSaveUserFeedback();" style="height: 95px;" />
                    </td>
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
                        <input type="button" name="a" id="BCC" value="Bcc" style="min-width: 86px;" />
                    </td>
                    <td>
                        <input type="text" name="aa" id="txtBCC" style="width: 100%; border: 1px solid #9D9FA1;"
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
                <tr style="display: none;">
                    <td colspan="3">
                        <table>
                            <tr>
                                <td>
                                    <label class="file-upload">
                                        <span><strong>Select File</strong></span>
                                        <input type="file" name="fileUPD" id="fileUPD" runat="server" onchange="fnUploadFIle(this)" />
                                    </label>

                                </td>
                                <td id="tdUpload"></td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>
            <asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" Style="width: 100%; height: auto;" spellcheck="false"></asp:TextBox>

            <ajaxToolkit:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" EnableSanitization="false">
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
            </ajaxToolkit:HtmlEditorExtender>

            <div style="display: none" id="dvbodyFront">
                <div id="dvbody" runat="server" style="padding: 5px 10px; border: 1px solid #9D9FA1;">
                    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="1">
                        <%--View 0--%>
                        <asp:View ID="View0" runat="server">
                            <div class="text-center">Please click on the Mail Name to view.</div>
                        </asp:View>

                        <asp:View ID="View1" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">
                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>DWM Issue Resolution and Enhancing Customer Satisfaction </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Dealer Manager/Supervisor - DWM and Customer Satisfaction (Priority: 1) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are facing some difficulties with the DWM (Dealer Work Management) system, and it's affecting the overall service quality. Please assist us in resolving this as soon as possible. Additionally, we need to address the recent customer complaints effectively to improve satisfaction scores. I would appreciate any solutions or strategies you can suggest.</p>
                            <p>Best regards,</p>
                            <p>Dealer Manager</p>

                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View2" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Dealer Performance Metrics and Market Intelligence</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Area Manager/NSM - Market Intelligence and Reporting (Priority: 2) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>Please analyze the latest dealer performance data and include an assessment of market trends that may affect our service operations. We need more detailed reports on customer complaints, specifically any recurring issues that might need broader solutions. Please ensure the reports are submitted by the end of the week. Kindly share your approach to create the report by end of the day.</p>
                            <p>Best regards,</p>
                            <p>Area Manager</p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View3" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Conflict Among Dealer Team and Upcoming Service Training </td>
                            </tr>

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Dealer Owner - Conflict Resolution and Team Training (Priority: 3) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are facing internal conflicts among our dealer team, which is affecting service performance. Could you help in navigating this conflict? Suggest what can be done to improve both team morale and customer satisfaction.</p>
                            <p>Best regards,</p>
                            <p>Dealer Owner</p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View4" runat="server">
                    <div class="tab-panel">

                        <table class="mailtable">

                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Review and Improvement of Service Training Programs </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Head Office/Section Heads - Service Training Program Review (Priority: 4) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We need your feedback on the current service training program. Please assess the effectiveness of the training delivered to the service teams and suggest any improvements. I would also appreciate any data on how well our teams are implementing the learnings to enhance customer experience and resolve complaints.</p>
                            <p>Please share a plan by end of the day on how to will you collect the feedback and what questions will you ask?</p>
                            <p>Best regards,</p>
                            <p>Head Office Section Head</p>
                        </div>
                    </div>
                </asp:View>
                    </asp:MultiView>
                </div>
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
         <div id="dvDialog" style="display:none"></div>
        <div id="dvLoadingImg" class="loader-outerbg">
            <div class="loader"></div>
        </div>
    </form>
</body>
</html>
