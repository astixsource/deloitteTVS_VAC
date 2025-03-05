<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmScheduleMeeting.aspx.cs" Inherits="Mapping" validateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script>
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            $("#ConatntMatter_dvMain").css("height", $(window).height() - 280);
            //$("#dvloader").hide();
            fnGetMapping();
        });

        function fnGetMapping() {
            var batch = $("#ConatntMatter_ddlBatch").val();

            $("#dvloader").show();
            PageMethods.fnGetEntries(batch, fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#ConatntMatter_dvMain").html(res);
            $("#tblMapping").find("select").each(function () {
                $(this).html($("#ConatntMatter_hdnUserlst").val());
                $(this).val($(this).attr("defval"));
            });

            //var MappingStatus = result.split("|")[1];
            //if (MappingStatus != "") {
            //    if (parseInt(MappingStatus) > 2) {
            //        $("#btnSubmit").hide();
            //        $("#spnmeeting")[0].innerHTML = MappingStatus == "0" ? "Mapping Not Done" : (MappingStatus == "2" ? "Mapping Done" : "Meeting Created");
            //    }
            //    else if (parseInt(MappingStatus) == 1) {
            //        $("#btnSubmit").show();
            //        $("#spnmeeting")[0].innerHTML = "Mapping Partially Done";
            //    }
            //    else {
            //        $("#spnmeeting")[0].innerHTML = MappingStatus == "0" ? "Mapping Not Done" : (MappingStatus == "2" ? "Mapping Done" : "Meeting Created");
            //    }
            //}

            $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");
            if ($("#tblScheduling").length > 0) {
                var wid = $("#tblScheduling").width(), thead = $("#tblScheduling").find("thead").eq(0).html();
                $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered bg-white table-sm clsTarget' style='width:" + (wid - 1) + "px;margin:0'><thead class='thead-light text-center'>" + thead + "</thead></table>");
                $("#tblScheduling").css({ "width": wid, "min-width": wid });

                for (i = 0; i < $("#tblScheduling").find("th").length; i++) {
                    var th_wid = $("#tblScheduling").find("th")[i].clientWidth;
                    $("#tblEmp_header, #tblScheduling").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                }
                $("#tblScheduling").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                $('#dvtblbody').css({
                    'height': $(window).height() - 355,
                    'overflow-y': 'auto',
                    'overflow-x': 'hidden'
                });
            }

            $("#dvloader").hide();
        }
        function fnfail(result) {
            alert("Error:"+result._message);
            $("#dvloader").hide();
        }
        function fnSaveMapping() {
            var flg = $("#ConatntMatter_hdnFlg").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var VacantParticipantSlot = $("#ConatntMatter_ddlBatch option:selected").attr("VacantParticipantSlot");
            var VacantAssessorSlot = $("#ConatntMatter_ddlBatch option:selected").attr("VacantAssessorSlot");
            if (parseInt(VacantAssessorSlot) > 0) {
                var strMsg = "Batch Mapping with Assessor is pending for this batch!"
                alert(strMsg)
                return false;
            }
            if (parseInt(VacantParticipantSlot) > 0) {
                var scon =confirm("Are you sure to create meeting for this batch as No of Participant Slots (" + VacantParticipantSlot + ") are still vacant?");
                if (scon == false) {
                    return false;
                }
            }
            
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
                PageMethods.fnSave(login,batch, fnSave_pass, fnfail);
            }
        }

        function fnSave_pass(result) {
            $("#dvloader").hide();
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
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Assessor Name</th>";
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
                if (IsAllMeetingCreated == 1) {
                    $("#btnSubmit").hide();
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
                $("#dvAlert")[0].innerHTML =result.split("|")[1];
                $("#dvAlert").dialog({
                    title: result.split("|")[1]==1?"Error:":"Alert!",
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


        function fnSendMail() {
            var sconfirm = confirm("Are you sure to send mail again?");
            if (sconfirm == false) {
                return false;
            }
           
            var batch = $("#ConatntMatter_ddlBatch").val();
            if (batch == "0") {
                alert("Select Batch First!");
                $("#ConatntMatter_ddlBatch").focus();
                return false;
            }
            $("#dvloader").show();
            PageMethods.fnSendICSFIleToUsers(batch, function (result) {
                $("#dvloader").hide();
                alert(result);
            }, fnfail);
        }
        
    </script>
    <style>
        #ConatntMatter_dvMain {
            overflow:auto;
        }

        #tblScheduling th {
            vertical-align: middle;
        }

        #tblScheduling tbody tr:nth-child(1) td:nth-child(1),
        #tblScheduling td.cls-5 {
            width: 12%;
        } 
        

        #tblScheduling td.cls-3,
        #tblScheduling td.cls-8,
        #tblScheduling td.cls-9,
        #tblScheduling td.cls-10,
        #tblScheduling td.cls-11,
        #tblScheduling td.cls-12,
        #tblScheduling td.cls-13 {
            width:7%;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
        }

        .cls-bg-gray{
            background: #ccc;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Schedule Meeting</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-inline mb-3 d-flex">
        <label for="ac" class="col-form-label mr-3">Select Batch</label>
        <div class="input-group">
            <asp:DropDownList ID="ddlBatch" runat="server" CssClass="form-control" onchange="fnGetMapping();">
            </asp:DropDownList>
        </div>
        <div class="input-group ml-auto">
        </div>
    </div>

    <div id="dvMain" runat="server"></div>
    <div class="text-center">
        <input type="button" id="btnSubmit" value="Schedule Meeting" onclick="fnSaveMapping()" class="btns btn-cancel" />
        <%--<input type="button" id="btnSendMail" value="Send Orientaion Mail If Not Recieved" onclick="fnSendMail()" class="btns btn-cancel" />--%>
    </div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <asp:HiddenField ID="hdnUserlst" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
</asp:Content>
