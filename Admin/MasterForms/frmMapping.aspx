<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmMapping.aspx.cs" Inherits="Mapping" validateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script>
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            $("#ConatntMatter_dvMain").css("height", $(window).height() - 270);
            //$("#dvloader").hide();
            fnGetMapping();
        });

        function fnGetMapping() {
            var flg = $("#ConatntMatter_ddlUser").val();
            var batch = $("#ConatntMatter_ddlBatch").val();

            $("#dvloader").show();
            PageMethods.fnGetEntries(batch, flg, fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#ConatntMatter_dvMain").html(res.split("^")[0]);
            $("#tblMapping").find("select").each(function () {
                if (parseInt($(this).attr("defval")) > 0 && $("#ConatntMatter_ddlUser").val() == "1") {
                    $(this).append("<option value='" + $(this).attr("defval") + "'>" + $(this).attr("EmpName") + "</option>");
                }
                $(this).val($(this).attr("defval"));
            });

            if (res.split("^")[1] == "1") {
                $("#tblMapping").find("select").prop("disabled", true);
                if ($("#ConatntMatter_ddlUser").val() == "1") {
                    $("#tblMapping").find("th:last").remove();
                    $("#tblMapping").find("tbody").eq(0).find("tr").each(function () {
                        $(this).find("td:last").remove()
                    });
                }
                $("#btnSubmit").hide();
            }
            else {
                $("#btnSubmit").show();
            }

            $("#dvloader").hide();
        }
        function fnRemoveMapping(ctrl) {
            var user = $(ctrl).closest("tr").find("select").eq(0).attr("defval");
            $("#divDialog").html("<span style='font-size:22px; font-weight: 600; color: #666;'>Do you want keep this Slot ?</span>");
            $("#divDialog").dialog({
                title: "Remove the Mapping :",
                resizable: false,
                height: "auto",
                width: "50%",
                modal: true,
                buttons: {
                    "Yes": function () {
                        if (user == "0") {
                            alert("This Slot is already vacant !");
                            $("#divDialog").dialog('close');
                        }
                        else {
                            fnRemoveSlot(ctrl, 1);
                        }
                    },
                    "No": function () {
                        fnRemoveSlot(ctrl, 0);
                    }
                }
            });
        }
        function fnRemoveSlot(ctrl, flg) {
            var CycleId = $("#ConatntMatter_ddlBatch").val();
            var SeqNo = $(ctrl).closest("tr").find("select").eq(0).attr("seq");
            var tbl = [];
            var flgtoKeepSlot = flg;
            var login = $("#ConatntMatter_hdnLogin").val();
            
            $("#tblMapping").find("select").each(function () {
                tbl.push({
                    'SeqNo': $(this).attr("seq"),
                    'EmpNodeID': $(this).val()
                });
            });

            $("#dvloader").show();
            PageMethods.fnRemoveSlot(CycleId, SeqNo, tbl, flgtoKeepSlot, login, fnRemoveSlot_pass, fnfail, flgtoKeepSlot);
        }
        function fnRemoveSlot_pass(res, flgtoKeepSlot) {
            if (res.split("^")[0] == "0") {
                if (flgtoKeepSlot == "1") {
                    alert("Slot vacant successfully !");
                    $("#divDialog").dialog('close');
                    fnGetMapping();
                }
                else {
                    if (res.split("^")[1] == "0") {
                        alert("Slot removed successfully !");
                        $("#divDialog").dialog('close');
                        fnGetMapping();
                    }
                    else {
                        $("#divDialog").dialog('close');
                        fnResetMeeting();
                    }
                }
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request !");
            }
        }
        function fnResetMeeting() {
            var CycleId = $("#ConatntMatter_ddlBatch").val();
            var LoginId = $("#ConatntMatter_hdnLogin").val();
            $.ajax({
                type: "POST",
                url: "frmScheduleMeeting.aspx/fnSave",
                data: "{LoginId:'" + LoginId + "',CycleId:'" + CycleId + "'}",
                contentType: "application/json; charset=utf-8",
                datatype: "json",
                async: "true",
                success: function (response) {
                    var myObject = response.d;
                    fnGetMapping();
                    fnCreateMeeting(myObject);
                },
                error: function (response) {
                    alert("Due to some technical reasons, we are unable to create meeting. Please re-create the meeting !");
                }
            });
        }
        function fnCreateMeeting(result) {
            if (result.split("|")[0] == "0") {
                var tbl = $.parseJSON(result.split("|")[1]);
                var strHTML = "";
                if (tbl.length > 0) {
                    var style = "border-left: 1px solid #A0A0A0; border-bottom: 1px solid #A0A0A0;font-family:arial narrow;font-size:9pt;";
                    strHTML += "Kindly find below Schedule status for each participant.</br> If there is an error against any participant to schedule meeting,Kindly try again for that participant to schedule a meeting</br></br>";
                    strHTML += ("<table cellpadding='2' cellspacing='0' style='font-family:arial narrow;font-size:8.5pt;border-right: 1px solid #A0A0A0; border-top: 1px solid #A0A0A0;text-align:center;width:100%'><thead>");
                    strHTML += ("<tr bgcolor='#26a6e7'>");
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Sr.No</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Participant Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Developer Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Exercise Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Exercise Time</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Meeting Status</th>";
                    strHTML += ("</tr></thead><tbody>");
                    var oldAssesseeName = ""; var cntrow = 0; var IsAllMeetingCreated = 1;
                    for (var i in tbl) {
                        var ParticipantAssessorMappingId = 0;
                        var MeetingStatus = tbl[i]["MeetingStatus"];
                        var AssesseeName = tbl[i]["ParticipantName"];
                        var AssessorName = tbl[i]["AssessorName"];
                        var MeetingStartTime = tbl[i]["MeetingStartTime"];
                        var ExerciseName = tbl[i]["ExerciseName"];
                        var Role = tbl[i]["Role"];
                        var strColor = "";
                        var rowspancnt = 1;//Role == 3 ? 5 : 5;
                        strHTML += ("<tr>");

                        // if (oldAssesseeName != AssesseeName) {
                        strHTML += "<td  style='" + style + ";text-align:center;padding:3px' rowspan='" + rowspancnt + "'>" + (eval(cntrow) + 1) + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px' rowspan='" + rowspancnt + "'>" + AssesseeName + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px' rowspan='" + rowspancnt + "'>" + AssessorName + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + ExerciseName + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStartTime + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStatus + "</td>";
                        cntrow++;
                        //} else {
                        //    strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + ExerciseName + "</td>";
                        //    strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStartTime + "</td>";
                        //    strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStatus + "</td>";
                        //}
                        strHTML += ("</tr>");
                        if (MeetingStatus != "Meeting Scheduled") {
                            IsAllMeetingCreated = 0;
                        }

                        oldAssesseeName = AssesseeName;
                    }
                    strHTML += ("</tbody></table>");
                }
                $("#dvAlert")[0].innerHTML = strHTML;
                $("#dvAlert").dialog({
                    title: "Alert!",
                    modal: true,
                    width: "750",
                    height: "450",
                    close: function () {
                        $(this).dialog('destroy');
                        //window.location.reload();
                    },
                    buttons: {
                        "OK": function () {
                            $(this).dialog('close');
                        }
                    }
                })
            }
            else {
                $("#dvAlert")[0].innerHTML = result.split("|")[1];
                $("#dvAlert").dialog({
                    title: result.split("|")[1] == 1 ? "Error:" : "Alert!",
                    modal: true,
                    width: "auto",
                    height: "auto",
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
        }

        function fnSaveMapping() {
            var flg = $("#ConatntMatter_ddlUser").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var tbl = [];
            var login = $("#ConatntMatter_hdnLogin").val();
            var flgValidate = 0, ArrEmp = [];

            $("#tblMapping").find("select").each(function () {
                if ($(this).val() != "0") {
                    tbl.push({
                        'SeqNo': $(this).attr("seq"),
                        'EmpNodeID': $(this).val()
                    });
                    if (ArrEmp.indexOf($(this).val()) == -1) {
                        ArrEmp.push($(this).val());
                    }
                    else {
                        if (flgValidate == 0) {
                            flgValidate = 1;
                            alert("Repeated Entries not allowed !");
                        }
                    }
                }
                else {
                    if (flgValidate == 0) {
                        flgValidate = 1;
                        alert("Please select the User for " + $(this).closest("td").prev().html() + " !");
                    }
                }
            });
            
            if (flgValidate == 0) {
                $("#dvloader").show();
                PageMethods.fnSave(batch, flg, tbl, login, fnSave_pass, fnfail);
            }
        }
        function fnSave_pass(res) {
            if (res == "0") {
                alert("Mapping saved successfully !");
				fnGetMapping();
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request !");
            }
        }
        function fnfail() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">User Mapping</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-inline mb-3 d-flex">
        <label for="ac" class="col-form-label mr-3">Select Batch</label>
        <div class="input-group">
            <asp:DropDownList ID="ddlBatch" runat="server" CssClass="form-control" onchange="fnGetMapping();">
            </asp:DropDownList>
        </div>
        <label for="ac" class="col-form-label mr-3" style="padding-left: 50px;">Select User</label>
        <div class="input-group">
            <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-control" style="width:200px;" onchange="fnGetMapping();">
                <%--<asp:ListItem Value="1">Participant</asp:ListItem>--%>
                <asp:ListItem Value="2">Developer</asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <div id="dvMain" runat="server" style="width:60%; margin:0 auto;"></div>
    <div class="text-center">
        <input type="button" id="btnSubmit" value="Save Mapping" onclick="fnSaveMapping()" class="btns btn-cancel" />
    </div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="divDialog" style="display: none"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <asp:HiddenField ID="hdnUserlst" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
</asp:Content>
