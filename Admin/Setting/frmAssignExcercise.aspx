<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmAssignExcercise.aspx.cs" Inherits="frmAssignExcercise" ValidateRequest="false" %>

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

        .jqte {
            margin: 0px !important;
        }

        .ui-dialog {
            z-index: 1200 !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#loader").hide();
            //$("#ddlAssessor").html($("#ConatntMatter_hdnAssessorMstr").val());

            var d = new Date();

            if ($("#ConatntMatter_hdnRoleId").val() == 1) {
                $("#divBtnscontainer a").eq(0).hide();
            }

            //$(".clsDate").datepicker({
            //    dateFormat: 'dd-M-yy',
            //    changeMonth: true,
            //    changeYear: true,
            //    showOn: "button",
            //    buttonImage: "../../images/calender.jpg",
            //    buttonImageOnly: true,
            //    buttonText: "Select date",
            //    onSelect: function (d, el) {
            //        fnGetStatus();
            //    }
            //});

            $("#ConatntMatter_ddlCycle").on("change", function () {
                $("#divBtnscontainer").hide();
                var CycleId = $("#ConatntMatter_ddlCycle").val();
                fnGetStatus(CycleId);
            });
            //   $("#ConatntMatter_ddlCycle").find('option[value="1"]').attr('selected', 'true')
            var SelectedCycleId = 0;
            if ($("#ConatntMatter_ddlCycle").val() === "") {
                SelectedCycleId = 0

            }
            else
                SelectedCycleId = $("#ConatntMatter_ddlCycle").val();

            fnGetStatus(SelectedCycleId);


        });

        function fnGetStatus(CycleId) {
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLogin").val();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            //var CycleDate = $("#txtDate").val();

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


        function fnAssignAssessor(ctrl) {
            $("#ddlAssessor").val($(ctrl).closest("td").attr("AssessorId"));

            $("#divAssessor").dialog({
                title: 'Please Assign the Assessor :',
                resizable: false,
                height: "340",
                width: 750,
                modal: true,
                buttons: {
                    "Save": function () {
                        var RSPExId = $(ctrl).closest("td").attr("RSPExerciseId");
                        var AssessorId = $("#ddlAssessor").val();
                        var loginId = $("#ConatntMatter_hdnLogin").val();
                        var td_id = $(ctrl).closest("td").attr("id");

                        if (AssessorId != "0") {
                            $("#loader").show();
                            PageMethods.fnAssignAssessor(RSPExId, AssessorId, loginId, fnAssignAssessorSuccess, fnFail, td_id);
                            $(this).dialog("close");
                        }
                        else {
                            alert("Please Select the Assessor ! ");
                        }
                    },
                    "Cancel": function () {
                        $(this).dialog("close");
                    }
                }
            });
        }

        function fnViewCaseStudyAnswer(ctrl) {
            $("#loader").show();
            PageMethods.fnViewCaseStudyAnswr($(ctrl).closest("tr").attr("EmpNodeId"), fnViewScore_pass, fnFail, 3);
        }

        function fnViewBEIRemarks(ctrl) {
            $("#loader").show();
            PageMethods.fnViewBEIRemarks($(ctrl).closest("tr").attr("EmpNodeId"), fnViewScore_pass, fnFail, 2);
        }



        function fnViewScore(ctrl) {
            $("#loader").show();
            PageMethods.fnViewScore($(ctrl).closest("tr").attr("EmpNodeId"), fnViewScore_pass, fnFail, 1);
        }

        function fnViewScore_pass(res, val) {
            if (res.split("^")[0] == "0") {

                $("#divScore").html(res.split("^")[1]);
                var Title = "";
                if (val == 1) {
                    Title = "View Score";
                }
                else if (val == 2) {
                    Title = "View Remarks";
                }
                else if (val == 3) {
                    Title = "Case Study Answer";
                }

                $("#divScore").dialog({
                    title: Title,
                    resizable: false,
                    height: "580",
                    width: 1000,
                    modal: true,
                });
            }
            else {
                alert("Due to some technical error, we are unable to process your request !");
            }
            $("#loader").hide();
        }

        function fnFail(err) {
            $("#loader").hide();
            alert("Due to some technical error, we are unable to complete your request !");
        }

        function fnAssignAssessorSuccess(res, td_id) {
            $("#loader").hide();
            if (res.split("^")[0] == "1") {
                alert("Due to some technical error, we are unable to process your request !");
            }
            else {
                var style = "";
                switch (res.split("^")[1]) {
                    case "1":
                        style = "color: #ffffff; background-color: #ff0000;";
                        break;
                    case "2":
                        style = "color: #000000; background-color: #ff9b9b;";
                        break;
                    case "3":
                        style = "color: #000000; background-color: #80ff80;";
                        break;
                    case "4":
                        style = "color: #000000; background-color: #8080ff;";
                        break;
                    case "5":
                        style = "color: #ffffff; background-color: #8000ff;";
                        break;
                    case "6":
                        style = "color: #ffffff; background-color: #0000a0;";
                        break;
                    default:
                        style = "color: #000000; background-color: transparent;";
                        break;
                }

                if (res.split("^")[3] == "1") {
                    var td = $("#tbl_Status").find("td[id='" + td_id + "']").eq(0);
                    td.attr("style", style);
                    td.find("a").eq(0).attr("style", style);
                    td.find("a").eq(0).html(res.split("^")[2]);
                }
                else {
                    var td = $("#tbl_Status").find("td[id='" + td_id + "']").eq(0);
                    td.attr("style", style);
                    td.html(res.split("^")[2]);
                }
            }
        }

        function fnCheckUncheck(ctrl, flg) {
            if ($(ctrl).is(":checked")) {
                $("#tbl_Status tbody").find("input[type='checkbox'][flg='" + flg + "']").prop("checked", true);
            }
            else {
                $("#tbl_Status tbody").find("input[type='checkbox'][flg='" + flg + "']").prop("checked", false);
            }
        }

        function fnDownloadData(flg) {
            var ArrDataSaving = [];
            $("#tbl_Status tbody").find("input[type='checkbox'][flg='" + flg + "']:checked").each(function () {
                //window.open("../../Report/" + $(this).attr("doc"), "_blank");
                ArrDataSaving.push({ ID: $(this).closest("tr").attr("EmpNodeId"), Val: $(this).attr("doc") });
            });

            if (ArrDataSaving.length != 0) {
                PageMethods.fnRpt(ArrDataSaving, $("#ConatntMatter_hdnLogin").val(), flg, fnRptSuccess, fnFail, flg);
            }
            else {
                alert("Please select the Report/s for download !");
            }
        }

        function fnRptSuccess(res, flg) {
            if (res.split('^')[0] == "1") {
                alert("Due to some technical reasons, we are unable to download the Reports !");
            }
            else {
                var strPath = flg == 1 ? "Raw/" : "Final/"
                window.open("../../Reports/" + strPath + res.split('^')[1], "_blank");
            }
        }



        function fnObjectiveScorecard() {
            var Emp = "";
            $("#tbl_Status tbody").find("input[type='checkbox'][flg=1]").each(function () {
                if ($(this).is(":checked")) {
                    Emp += "^" + $(this).closest("tr").attr("EmpNodeId");
                }
            });

            if (Emp != "") {
                //   $("#ConatntMatter_hdnScoreCardType").val("1");
                $("#ConatntMatter_hdnSelectedEmp").val(Emp.substring(1));
                $("#ConatntMatter_btnObjectiveScore").click();
            }
            else {
                alert("Please select the Report/s for Objective Score download !");
            }
        }


        function fnScorecard() {
            var Emp = "";
            $("#tbl_Status tbody").find("input[type='checkbox'][flg=1]").each(function () {
                if ($(this).is(":checked")) {
                    Emp += "^" + $(this).closest("tr").attr("EmpNodeId");
                }
            });

            if (Emp != "") {
                $("#ConatntMatter_hdnScoreCardType").val("1");
                $("#ConatntMatter_hdnSelectedEmp").val(Emp.substring(1));
                $("#ConatntMatter_btnScore").click();
            }
            else {
                alert("Please select the Report/s for Score download !");
            }
        }

        function fnNewScorecard() {
            var Emp = "";
            $("#tbl_Status tbody").find("input[type='checkbox']").each(function () {
                if ($(this).is(":checked")) {
                    Emp += "^" + $(this).closest("tr").attr("EmpNodeId");
                }
            });

            if (Emp != "") {
                $("#ConatntMatter_hdnScoreCardType").val("2");
                $("#ConatntMatter_hdnSelectedEmp").val(Emp.substring(1));
                $("#ConatntMatter_btnScore").click();
            }
            else {
                alert("Please select the Report/s for Score download !");
            }
        }

        function fnSubmitFeedbackstatus(sender) {
            var flg = $(sender).is(":checked") == true ? 1 : 0;
            var msg = flg == 1 ? "Are you sure you want to submit participant feedback?" : "Are you sure you want to delete participant feedback?";
            var con = confirm(msg);
            if (con) {
                PageMethods.fnSubmitParticipantFeedbackstatus(flg, $(sender).attr("empnodeid"), $("#ConatntMatter_hdnLogin").val(), function (result) {
                    if (result.split("^")[0] == "0") {
                        alert("Action Taken Successfully");
                        $(sender).closest("td").html("Yes");
                    } else {
                        alert("Error-" + result.split("^")[1]);
                    }
                }, function (result) {
                    alert("Error-" + result._message);
                });
            } else {
                if (flg == 1) {
                    $(sender)[0].checked = false;
                }
                else {
                    $(sender)[0].checked = true;
                }
            }
        }

        function fnSubmitPenPicturestatus(sender) {
            $("#txtPenPicture").val($(sender).closest("td").find("div.clsPenpicture").html());
            $("#divAssessor").dialog({
                title: 'Pen-Picture Status:',
                height: "450",
                width: "900",
                modal: true,
                open: function () {
                    $('.textEditor').jqte();
                },
                close: function () {
                    $('.textEditor').jqte("destroy");
                    $(this).dialog("destroy");
                },
                buttons: {
                    "Submit": function () {
                        var loginId = $("#ConatntMatter_hdnLogin").val();
                        var strData = $("#txtPenPicture").val().trim();
                        if (strData.length == 0) {
                            alert("Pen-Picture can not be blank!");
                            $("#txtPenPicture").focus();
                        }
                        var msg = "Are you sure you want to submit pen-picture?";
                        var con = confirm(msg);
                        if (con) {
                            PageMethods.fnSubmitPenPictureFeedback(1, $(sender).attr("empnodeid"), $("#ConatntMatter_hdnLogin").val(), strData, function (result) {
                                if (result.split("^")[0] == "0") {
                                    //alert("Action Taken Successfully");
                                    $("#divAssessor").dialog("close");
                                    if ($("#ConatntMatter_hdnRoleId").val() == "1") {
                                        var str = "<a href='###' style='text-decoration:underline;color:blue'  empnodeid='" + $(sender).attr("empnodeid") + "'  onclick='fnSubmitPenPicturestatus(this)'>View</a><div class='clsPenpicture' style='display:none'>" + strData + "</div>";
                                    }
                                    else {
                                        var str = "<a href='###' style='text-decoration:underline;color:blue'  empnodeid='" + $(sender).attr("empnodeid") + "'  onclick='fnViewPenStatus(this)' >View</a><div class='clsPenpicture' style='display:none'>" + strData + "</div>";
                                    }
                                    $(sender).closest("td").html(str);
                                }
                            }, function (result) {
                                alert("Error-" + result._message);
                            });
                        }
                    },
                    "Cancel": function () {
                        $("#divAssessor").dialog("close");
                    }
                }
            });

        }
        function fnViewPenStatus(sender) {
            $("#divAssessor").html("<div>" + $(sender).closest("td").find("div.clsPenpicture").html() + "</div>")
            $("#divAssessor").dialog({
                title: 'Pen-Picture Status:',
                height: "450",
                width: "900",
                modal: true,
                close: function () {
                    $(this).dialog("destroy");
                },
                buttons: {
                    "Close": function () {
                        $(this).dialog("close");
                    }
                }
            });
        }


        function fnGetMeetingMOM(sender) {
            var RSPExerciseid = $(sender).closest("td").attr("RSPExerciseId");
            var BEIUsername = $(sender).closest("tr").attr("BEIUserName");
            var BEIPassword = $(sender).closest("tr").attr("BEIPassword");
            var MeetingId = $(sender).closest("tr").attr("MeetingId");
            var MeetingStartDate = $(sender).closest("tr").attr("MeetingStartTime");
            var flgMeetingType = 1;
            $("#loader").show();
            $.ajax({
                url: "../../WebService.asmx/fnGetMeetingMOM",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{RSPExerciseid:' + RSPExerciseid + ',MeetingId:' + MeetingId + ',MeetingStartDate:' + JSON.stringify(MeetingStartDate) + ',BEIUsername:' + JSON.stringify(BEIUsername) + ',BEIPassword:' + JSON.stringify(BEIPassword) + ',flgMeetingType:' + flgMeetingType + '}',
                success: function (response) {
                    $("#loader").hide();
                    if (response.d.split("|")[0]==1) {
                        alert('Error-' + response.d.split("|")[1]);
                    } else {
                        if (response.d == "") {
                            alert("Meeting minutes still not available.");
                        } else if (response.d == "NA") {
                            $(sender)[0].href = "###";
                            $(sender).removeAttr("onclick");
                            $(sender).html("Meeting Not Recorded");
                            $(sender).attr("title", "Meeting Not Recorded By Developer");
                            alert("Meeting Not Recorded By Developer.");
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

    <div class="section-title clearfix" style='margin: 0px'>
        <h3 class="text-center">Participant Status Report</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch :-</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycle" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            </asp:DropDownList>
        </div>
    </div>
    <%-- <table id="tblCalendar" class="mb-2">
        <tr>
            <td><b>Cycle Date :</b></td>
            <td>
                <input type="text" class="clsDate" readonly="readonly" id="txtDate" />
            </td>
        </tr>
    </table>--%>

    <%--<div id="divLegend" runat="server" style="overflow-y: auto; padding-bottom: 10px;"></div>--%>
    <div id="divStatus" runat="server"></div>

    <div id="divBtnscontainer" style="display: none">
        <div class="text-center d-flex">
            <a href="../MasterForms/AvailablityPlan.aspx" class="btns btn-submit">Manage Scheduling</a>
            <a href="#" onclick="fnScorecard();" class="btns btn-submit">Download Scorecard</a>
            <a href="#" onclick="fnObjectiveScorecard();" class="btns btn-submit">Download Objective Scores</a>
            <a href="#" onclick="fnDownloadData(1);" class="btns btn-submit">Download Raw Report</a>
            <a href="#" onclick="fnDownloadData(2);" class="btns btn-submit">Download Final Report</a>
        </div>
    </div>

    <div id="divAssessor" style="display: none;">
        <table style="width: 100%;">
            <tr>
                <td>
                    <textarea rows="20" cols="80" style="min-height: 260px; width: 100%" id="txtPenPicture" class='textEditor'></textarea>
                </td>
            </tr>
        </table>
    </div>
    <div id="divScore" style="display: none;"></div>

    <asp:Button ID="btnScore" runat="server" Text="" OnClick="btnScoreCard_Click" Style="display: none" />
    <asp:Button ID="btnObjectiveScore" runat="server" Text="" OnClick="btnObjectiveScore_Click" Style="display: none" />
    <asp:HiddenField ID="hdnSelectedEmp" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnAssessorMstr" runat="server" />
    <asp:HiddenField ID="hdnScoreCardType" runat="server" />
    <asp:HiddenField ID="hdnRoleId" runat="server" />
</asp:Content>
