<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSentMailBox.aspx.cs" Inherits="frmSentMailBox" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <!-- viewport meta to Content-Type -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <!-- viewport meta to reset Web-app inital scale -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="grey" />

    <!-- viewport meta to reset iPhone inital scale -->
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0," />

    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <%--<link href="../../CSS/InboxSite.css" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .hiddenCol {
            display: none;
        }

        #divpopup {
            overflow: hidden;
        }

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
            background: #004074;
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
    <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });

        $(document).ready(function () {
            parent.fnEndLoading();
            $("#dvInbox").css("height", $(window).height() - ($(".navbar, .header").height() + 110) + "px");
            $('#GrdInbox tr').css("cursor", "pointer");
            $("#iFrameReplyMail").attr("height", $(window).height() - 50 + "px");
            $("#dvFadeForProcessing").hide();
            parent.fnEndLoading();
        });

        function fnSuccess(result) {
            if (parseInt(result) == 1) {
                $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].cells[3].innerHTML = "<img src='../../Images/Icons/ReadImg.png'/>";
                $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].style.fontWeight = "";
                $('#GrdInbox tr')[parseInt($("#hdnRowIndex").val().trim())].setAttribute("ReadStatus", "Read");
            }
        }

        //function fnOpenMailBody(id, tID) {
        //    //debugger;
        //    var DivId = "dv" + id;
        //    document.getElementById('dvMailBody').innerHTML = "";
        //    var htm = document.getElementById(DivId).innerHTML;
        //    document.getElementById('dvMailBody').innerHTML = htm;

        //    $(".modal").show();
        //    $("#dvAction").css({ "display": "none", "text-align": "right", "margin-top": "10pt", "padding": "0 10pt" });
        //    $("#hdnUserMailResponseID").val(id);
        //}

        function fnOpenMailBody(id, tID) {
            var DivId = "dv" + id;
            var htm = document.getElementById(DivId).innerHTML;
            $("#hdnMailOrderNo").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[8].innerHTML);
            $("#hdnMailFrom").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[10].innerHTML);
            $("#hdnSubject").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[6].innerHTML);
            $("#hdnCc").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[9].innerHTML);
            $("#hdnTo").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[5].innerHTML);
            $("#hdnRspMailInstanceID").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[0].innerHTML);
            $("#hdnExerciseMultiMailID").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[1].innerHTML);
            $("#hdnPriorty").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[13].innerHTML);
          
            $("#hdnBCC").val($('#GrdInbox')[0].rows[tID.parentNode.rowIndex].cells[14].innerHTML);
            

            PageMethods.fnSetSentBody(htm, function (result) {
                document.getElementById("iFrameReplyMail").src = "frmReplyFromSend.aspx?RspID=" + $("#hdnRspID").val() + "&RspMailInstanceID=" + $("#hdnRspMailInstanceID").val() + "&MailFrom=" + $("#hdnMailFrom").val()
                    + "&MailSubject=" + $("#hdnSubject").val() + "&To=" + $("#hdnTo").val() + "&Cc=" + $("#hdnCc").val() + "&MailOrderNo=" + $("#hdnMailOrderNo").val() + "&MailPriorty=" + $("#hdnPriorty").val() + "&MailDesc=&flgType=4" + "&ParentUserMailResponseId=" + id + "&BCC=" + $("#hdnBCC").val();


                $('#dvReplyMail').css({ "display": "block", "overflow": "hidden" });

            })

            return false;
        }

        function fnCloseQuestion() {
            document.getElementById("iFrameReplyMail").src = "";
            $('#dvReplyMail').css("display", "none");
        }
        function fnDeleteEmail(uMailRspId, status) {
            var cnfrm = confirm("Do you want to delete this mail ?");
            if (cnfrm) {
                PageMethods.fnMarkDeleteStatus(uMailRspId, status, fnCheckDelSuccess);
            }
        }

        function fnCheckDelSuccess(result) {
            if (parseInt(result) == 1) {
                $("#dvFadeForProcessing").show();
                fnGetEmail();
            }
        }

        function AddParameter(form, name, value) {
            var $input = $("<input />").attr("type", "hidden")
                .attr("name", name)
                .attr("value", value);
            form.append($input);
        }

        function fnOpenreplyPage(flgType) {


            var $form = $("<form/>").attr("id", "data_form")
                .attr("action", "frmNewReply.aspx")
                .attr("method", "post")
                .attr("target", "_blank");
            $("body").append($form);

            //Append the values to be send
            AddParameter($form, "RspID", $("#hdnRspID").val());
            AddParameter($form, "UserMailResponseID", $("#hdnUserMailResponseID").val());
            AddParameter($form, "flgType", flgType);

            //Send the Form

            $form[0].submit();

            return false;
        }

        function fnGetEmail() {
            var RspexerciseId = document.getElementById("hdnRSPExerciseID").value;

            PageMethods.fnGetStringHTML(RspexerciseId, function (result) {
                $("#dvFadeForProcessing").hide();
                $('#dvReplyMail').css({ "display": "none" });
                $("#tbody1")[0].innerHTML = result;
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    $('#dvReplyMail').css({ "display": "none" });
                }
            );
        }

        function IframeHide(par) {
            parent.hideShowIframe(par);
        }

        function closePopup() {
            $('.modal').fadeOut(300);
            $('.modal').hide();
        }

        function fnPageLoad() {
            if (SecondCounter > -1) {
                setInterval(function () { FnUpdateTimer() }, 1000);
            }
        }
        function fnAutoSaveText() {
            var RspMailInstanceID = $("#hdnRspMailInstanceID").val();
            var MailOrderNo = $("#hdnMailOrderNo").val();
            if ($('#dvReplyMail').css("display").toLocaleLowerCase() == "block") {
                if (parseInt(RspMailInstanceID) > 0 && parseInt(MailOrderNo) > 0) {
                    document.getElementById('iFrameReplyMail').contentWindow.fnSaveUserFeedbackAutoSave(2);
                }
            }
        }
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        function FnUpdateTimer() {
            if (IsUpdateTimer == 0) { return; }
            SecondCounter = document.getElementById("hdnCounter").value;
            if (SecondCounter < 0) {
                IsUpdateTimer = 0;
                return;
            }
            SecondCounter = SecondCounter - 1;
            hours = Math.floor(SecondCounter / 3600);
            Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
            Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);

            //Minutes = parseInt(SecondCounter / 60);
            //HourCounter = parseInt(Minutes / 60);
            //Seconds = SecondCounter - (Minutes * 60);

            if (Seconds < 10 && Minutes < 10) {
                parent.parent.document.getElementById("theTime").innerHTML = "Left Time:0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
            }
            else if (Seconds < 10 && Minutes > 9) {
                parent.parent.document.getElementById("theTime").innerHTML = "Left Time:0" + hours + ":" + Minutes + ":" + "0" + Seconds;
            }
            else if (Seconds > 9 && Minutes < 10) {
                parent.parent.document.getElementById("theTime").innerHTML = "Left Time:0" + hours + ":" + "0" + Minutes + ":" + Seconds;
            }
            else if (Seconds > 9 && Minutes > 9) {
                parent.parent.document.getElementById("theTime").innerHTML = "Left Time:0" + hours + ":" + Minutes + ":" + Seconds;
            }
            document.getElementById("hdnCounter").value = SecondCounter;
            counter++;
            // counterAutoSaveTxt++;
            if (counter == 10) {//Auto Time Update
                counter = 0;
                //SecondCounter = 30;
                //alert("hello");
                fnUpdateElapsedTime();
                //counter = 1;
            }
            //if (counterAutoSaveTxt == 40) {//Auto Text Save
            //counter = 0;
            // fnAutoSaveText();
            //counter = 1;
            //  }
            if (SecondCounter == 0) {
                counter = 0;
                IsUpdateTimer = 0;
                fnUpdateElapsedTime();
                fnAutoSaveText();
                alert("Your Time is over now");
                fnCheck()
                //window.location.href = "frmExerciseMain_New.aspx?intLoginID=" + document.getElementById("hdnLoginID").value;
            }
        }

        function fnCheck() {
            var flgExerciseStatus = 2;
            //var aa = confirm("Are you sure you have completed this Inbox exercise ? Click OK if you have completed. Please note you will not be able to resume once you click OK.\n Click Cancel if you have NOT completed and need to go back to complete.");
            //if (aa) {
            IsUpdateTimer = 0;
            PageMethods.fnSpINBasetExerciseDone(flgExerciseStatus, fnSpINBasetExerciseDoneSuccess, fnSpINBasetExerciseDoneFailed);
            //}
        }
        function fnSpINBasetExerciseDoneSuccess(result) {
            alert("Your Exercise submitted successfully");
            parent.frames.location.href = "../Main/frmExerciseMain.aspx";
        }
        function fnSpINBasetExerciseDoneFailed(result) {
            alert(result._message);
        }

        function fnUpdateElapsedTime() {
            var RspexerciseId = document.getElementById("hdnRSPExerciseID").value;
            PageMethods.fnUpdateTime1(RspexerciseId, fnUpdateElapsedTimeSuccess, fnUpdateElapsedTimeFailed);
        }
        function fnUpdateElapsedTimeSuccess(result) {

        }
        function fnUpdateElapsedTimeFailed(result) {
            //alert(result._message);
        }


    </script>
</head>
<body onload="fnPageLoad()">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="inbox-title">
                    <img src="../../Images/Icons/SentItems-icon.png" style="vertical-align: middle; margin: -2px 2px 0;" />
                    <span>Sent</span>
                </div>
                <table id="Table1" class="table table-sm mb-0" style="background: #f1f1f1;">
                    <tr>
                        <%--<td class="hiddenCol" scope="col">RspMailInstanceID</td>--%>
                        <th scope="col" style="width: 2%;">
                            <img src="../../Images/Icons/attachementIcon.png" title="Attachment" />
                        </th>
                        <th scope="col" style="width: 30%;">To</th>
                        <th scope="col" style="width: 46%;">Subject</th>
                        <th scope="col" style="width: 25%;">Sent Date</th>
                        <th scope="col" style="width: 2%;">&nbsp;</th>
                        <%--<td scope="col" class="hiddenCol">MailOrderNo</td>
                        <td scope="col" class="hiddenCol">Cc</td>
                        <td scope="col" class="hiddenCol">From</td>--%>
                    </tr>
                </table>
                <div id="dvInbox" style="overflow-x: hidden; overflow-y: auto;">
                    <table id="GrdInbox" class="table table-hover">
                        <tbody id="tbody1" runat="server">
                        </tbody>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div id="dvReplyMail" class="modal" style="display: none;" title="Reply">
            <div class="replymail-title clearfix">
                <span class="btn btn-xs btn-success" title="Back" onclick="fnCloseQuestion()">← Back</span>
            </div>
            <iframe frameborder="0" src="" id="iFrameReplyMail" width="100%" style="vertical-align: middle;"></iframe>
        </div>

        <div style="right: 0; display: none; position: fixed; background-color: #E3EFFF; bottom: 0px; font-weight: bold; height: 50px; border: 1px solid black;" id="dvMsg">
        </div>
        <div id="dvFadeForProcessing" class="loader-outerbg" style="display: none;">
            <div class="loader"></div>
        </div>

        <asp:HiddenField runat="server" ID="hdnRspID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnExerciseMultiMailID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnRspMailInstanceID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnMailOrderNo" Value="0" />
        <asp:HiddenField runat="server" ID="hdnMailFrom" Value="" />
        <asp:HiddenField runat="server" ID="hdnSubject" Value="" />
        <asp:HiddenField runat="server" ID="hdnCc" Value="" />
        <asp:HiddenField runat="server" ID="hdnTo" Value="" />
        <asp:HiddenField runat="server" ID="hdnRowIndex" Value="0" />
        <asp:HiddenField runat="server" ID="hdnUserMailResponseID" Value="0" />
        <asp:HiddenField runat="server" ID="hdnIndexNo" Value="-1" />
        <asp:HiddenField runat="server" ID="HdnId" Value="" />
        <asp:HiddenField runat="server" ID="hdnPriorty" Value="0" />

        <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
        <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
        <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
        <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
        <asp:HiddenField ID="hdnTimeLeft" runat="server" Value="0" />
        <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
        <asp:HiddenField runat="server" ID="hdnBCC" Value="" />
    </form>
</body>
</html>
