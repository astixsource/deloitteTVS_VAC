<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmParticipantFeedbackStatus.aspx.cs" Inherits="frmParticipantFeedbackStatus" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-te-1.4.0.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-te-1.4.0.min.js"></script>
    <style>
        .jqte_editor, .jqte_source {
    padding: 10px;
    background: #FFF;
    min-height: 260px;
    max-height: 900px;
    overflow: auto;
    outline: none;
    word-wrap: break-word;
    -ms-word-wrap: break-word;
    resize: vertical;
}
        .jqte{
            margin:0px !important;
        } 
        .ui-dialog { z-index: 1200 !important ;}
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#loader").hide();
            //$("#ddlAssessor").html($("#ConatntMatter_hdnAssessorMstr").val());
           
            var d = new Date();
            
            if ($("#ConatntMatter_hdnRoleId").val() == 1) {
                $("#divBtnscontainer a").eq(0).hide();
            } 
              fnGetStatus();
        });

        function fnGetStatus() {
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLogin").val();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            var CycleId = $("#ConatntMatter_ddlCycle").val();
            PageMethods.frmGetStatus(LoginId, CycleId, RoleId, function (result) {
                $("#loader").hide();
                $("#ConatntMatter_divStatus")[0].innerHTML = result;
                 $("#tblbody").scrollLeft(0);

                $("#ConatntMatter_divStatus").prepend("<div id='tblheader'></div>"), $("#tbl_Status").wrap("<div id='tblbody'></div>");
                if ($("#tbl_Status").length > 0) {
                    $("#divBtnscontainer").show();
                    var wid = $("#tbl_Status").width(), thead = $("#tbl_Status").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tbl_Status").css({ "width": wid, "min-width": wid });

                    for (i = 0; i < $("#tbl_Status").find("th").length; i++) {
                        var th_wid = $("#tbl_Status").find("th")[i].offsetWidth;
                        $("#tblEmp_header").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tbl_Status").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");
                    $("#tblheader").css("width", $("#tblbody")[0].clientWidth);

                     $("#tblbody").scroll(function () {
                        $("#tblheader").scrollLeft(this.scrollLeft);
                    });
                    $('#tblbody').css({
                        'height': $(window).height() - ($(".navbar").outerHeight() + 250),
                        "margin-bottom": "20px",
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                }

              
            }, fnFail);
        }


        
        function fnFail(err) {
            $("#loader").hide();
            alert("Due to some technical error, we are unable to complete your request !");
        }

        function fnGetMeetingMOM(sender) {

            var MeetingId = $(sender).closest("tr").attr("FeedbackMeetingId");
            var RSPExerciseid = $(sender).closest("tr").attr("ParticipantAssessorMappingId");
            var MeetingStartDate = $(sender).closest("tr").attr("MeetingDate");
            var BEIUsername = $(sender).closest("tr").attr("BEIUserName");
            var BEIPassword = $(sender).closest("tr").attr("BEIPassword");
            var flgMeetingType = 2;
            $("#loader").show();
            $.ajax({
                url: "../../WebService.asmx/fnGetMeetingMOM",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{RSPExerciseid:' + RSPExerciseid + ',MeetingId:' + MeetingId + ',MeetingStartDate:' + JSON.stringify(MeetingStartDate) + ',BEIUsername:' + JSON.stringify(BEIUsername) + ',BEIPassword:' + JSON.stringify(BEIPassword) + ',flgMeetingType:' + flgMeetingType + '}',
                success: function (response) {
                    $("#loader").hide();
                    if (response.d.split("|")[0] == 1) {
                        alert('Error-' + response.d.split("|")[1]);
                    } else {
                        if (response.d == "") {
                            alert("Meeting minutes still not available.");
                        } else if (response.d == "NA") {
                            alert("Meeting Not Recorded By Developer.");
                            $(sender)[0].href = "###";
                            $(sender).removeAttr("onclick");
                            $(sender).html("Meeting Not Recorded");
                            $(sender).attr("title", "Meeting Not Recorded By Developer");
                        } else {
                            $(sender)[0].href = response.d;
                            $(sender).attr("target", "_blank");
                            $(sender).removeAttr("onclick");
                            window.open(response.d, "_blank");
                        }
                    }
                },
                error: function (msg) {
                    $("#loader").hide();
                    alert('Error-' + msg.statusText);
                }
            });
        }

        function fnStartMeeting(sender) {
            var MeetingId = $(sender).closest("tr").attr("FeedbackMeetingId");
            var ParticipantAssessorMappingId = $(sender).closest("tr").attr("ParticipantAssessorMappingId");
            var MeetingDate = $(sender).closest("tr").attr("MeetingDate");
            var BEIUsername = $(sender).closest("tr").attr("BEIUserName");
            var BEIPassword = $(sender).closest("tr").attr("BEIPassword");
            if ($(sender).html().trim() == "Start Meeting" || $(sender).html().trim() == "Resume Meeting") {
                if ($(sender).attr("iden") == "1") {
                    $(sender).html("End Meeting");
                    $(sender).css("color:blue");
                    $(sender).closest("td").find("a[iden=2],span").show();
                    fnSetMeetingStatus(sender, 1, MeetingId, ParticipantAssessorMappingId, MeetingDate, BEIUsername, BEIPassword);
                }
               
            }
            else {
                fnSetMeetingStatus(sender, 2, MeetingId, ParticipantAssessorMappingId, MeetingDate, BEIUsername, BEIPassword);
            }
        }

        function fnSetMeetingStatus(sender, flgMeeting, MeetingId, ParticipantAssessorMappingId, MeetingDate, BEIUsername, BEIPassword) {
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            $("#loader").show();
            PageMethods.fnStartMeeting(ParticipantAssessorMappingId, flgMeeting, MeetingId, MeetingDate,BEIUsername,BEIPassword,function (result) {
                $("#loader").hide();
                if (result == "0") {
                    if (flgMeeting == 2) {
                        alert("Meeting Finished Successfully");
                        $(sender).closest("td").find("a[iden=2],span").hide();
                        $(sender).html("Meeting Finished");
                        $(sender).removeAttr("onclick");
                        $(sender).removeAttr("href");
                        fnGetStatus(1);
                    } else {
                        $(sender).removeAttr("href");
                    }
                } else {
                    alert("Error-" + result.split("^")[1]);
                }
            }, fnFail);
        }
    </script>

    <style type="text/css">
        table.table {
            border-collapse: collapse;
            font-size: .75rem;
        }

        td.clslegendlbl {
            padding-right: 10px;
            font-size: 10px;
            font-weight: bold;
        }

        #tblCalendar img {
            width: auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div id="loader" class="loader_bg">
        <div class="loader"></div>
    </div>

     <div class="section-title clearfix" style='margin:0px'> 
        <h3 class="text-center">Participant Feedback Status</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="form-group row">
        <label for="ac" class="col-sm-2 col-form-label">Select Batch :</label>
        <div class="col-sm-4">
            <asp:DropDownList runat="server" ID="ddlCycle" onchange="fnGetStatus()" CssClass="form-control">
            </asp:DropDownList>
        </div>
        <div class="col-3 offset-1">
        </div>
    </div>
    <div id="divStatus" runat="server"></div>
    <div id="divBtnscontainer" class="text-center" style="display:none">
        <a href="../MasterForms/FeedbackAvailablityPlan.aspx" class="btns btn-submit">Manage Feedback Scheduling</a>
    </div>
    <div id="divAssessor" style="display: none;">
        <table style="width: 100%;" >
            <tr>
                <td>
                    <textarea rows="20" cols="80" style="min-height:260px;width:100%" id="txtPenPicture" class='textEditor'></textarea>
                </td>
            </tr>
        </table>
    </div>
    <div id="divScore" style="display: none;"></div>

    <asp:HiddenField ID="hdnSelectedEmp" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnAssessorMstr" runat="server" />
    <asp:HiddenField ID="hdnScoreCardType" runat="server" />
    <asp:HiddenField ID="hdnRoleId" runat="server" />
</asp:Content>
