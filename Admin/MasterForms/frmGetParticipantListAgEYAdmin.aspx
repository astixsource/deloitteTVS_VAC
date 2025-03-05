<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmGetParticipantListAgEYAdmin.aspx.cs" Inherits="frmGetParticipantListAgEYAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">    
    <style type="text/css">
        .bg-blue{
            background:#194597;
        }
        td.clsProgress{
            background-color:#fffacc;
        }
        td.clsNotStarted{
            background-color:#bfbfff;
        }
        td.clsNotApplicable{
            background-color:lightgray;
        }
        
         td.clsCompleted{
            background-color:#d2f4dc;
        }
    </style>
    <script type="text/javascript">
        function fnStartMeeting(sender) {
            var MeetingLink = "";
            var RspExerciseID = $(sender).attr("RspExerciseID");
            var EmpNodeId = $(sender).closest("tr").attr("participantid");
            var ExcerciseId = $(sender).closest("td").attr("ExerciseId");
            var meetingid = 0;
            var gotousername = "";
            var gotopassword = "";
            var UserTypeID = 2;
            var flgAction = 3;
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
           
            var CycleID = $("#ConatntMatter_hdnCycleId").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            // fnUpdateActualStartEndTime(sender, UserTypeID, flgAction, RspExerciseID, gotousername, gotopassword, meetingid);
            window.parent.location.href = "../../Admin/Evidence/Rating_Admin.aspx?str=" + RspExerciseID + "&BandId=1&RoleId=" + RoleId + "&cycleid=" + CycleID + "&LoginID=" + LoginId + "&EmpNodeId=" + EmpNodeId + "&ExerciseId=" + ExcerciseId;
        }
        function fnFinalRating(sender) {
            var RspExerciseID = $(sender).attr("RspExerciseID")
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            window.location.href = "Evidence/FinalRating_Admin.aspx?str=" + RspExerciseID + "&BandId=1&RoleId=" + RoleId;
        }
        function fnUpdateActualStartEndTime(sender, UserTypeID, flgAction, RspExerciseID, gotousername, gotopassword, meetingid) {
            $("#loader").show();
            PageMethods.fnUpdateActualStartEndTime(RspExerciseID, UserTypeID, flgAction, gotousername, gotopassword, meetingid, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "1") {
                    alert("Error-" + result.split("^")[1]);
                    
                } else {
                    fnEnableExerciseAutomatically();
                    window.open(result);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }

        function fnFail(err) {
            alert("Due to some technical error, we are unable to process your request !");
        }

        $(document).ready(function () {
            //fnEnableExerciseAutomatically();
            setInterval("fnEnableExerciseAutomatically()", 10000);
        });

        function fnEnableExerciseAutomatically() {
            try {
                var LoginId = $("#ConatntMatter_hdnLoginId").val();
                var CycleID = $("#ConatntMatter_hdnCycleId").val();
                PageMethods.fnGetParticipantDetails(CycleID, LoginId, 2, function (result) {
                    if (result != "") {
                        var tbl = $.parseJSON(result);
                        if (tbl.length > 0) {
                            for (var i in tbl) {
                                var ParticipantId = tbl[i]["ParticipantId"];
                                var Activity = tbl[i]["Activity"];
                                var ExerciseID = tbl[i]["ExerciseId"];
                                var sTime = tbl[i]["Time"];
                                var $Cells = $("#tblEmp tr[participantid='" + ParticipantId + "'][activity='" + Activity + "'][exerciseid='" + ExerciseID + "']").find("td");
                                if ($Cells.length > 0) {
                                    $Cells.eq(1).html(sTime);
                                }
                                $.each(tbl[i], function (Key, Value) {
                                    if (Key.split("^").length > 1) {
                                        if (Value != null && Value != "") {
                                           
                                            var sData = Value;
                                            var StatusText = ""; var flgShowLink = "0"; var ButtonName = "";
                                            var RspExerciseId = "0"; var StatusId = "0";
                                            var ExerciseID = Key.split("^")[1];
                                            if (sData != "")
                                            {
                                                RspExerciseId = sData.split('^')[0];
                                                StatusId = sData.split('^')[1];
                                                StatusText = sData.split('^')[2];
                                                flgShowLink = sData.split('^')[3];
                                                ButtonName = sData.split('^')[4];
                                            }
                                            var bgclassName = "";
                                            if (StatusId == "0")
                                            {
                                                if (StatusText != "") {
                                                    bgclassName = "clsNotStarted";
                                                }
                                                else {
                                                    bgclassName = "clsNotApplicable";
                                                }
                                            }

                                            else if (StatusId == "1")
                                            {
                                                bgclassName = "clsProgress";
                                            }
                                            else
                                            {
                                                bgclassName = "clsCompleted";
                                            }
                                            
                                            var $Cell = $("#tblEmp tr[participantid='" + ParticipantId + "'][activity='" + Activity + "'][exerciseid='" + ExerciseID + "']").find("td[exerciseid=" + ExerciseID + "]");
                                            if ($Cell.length > 0) {
                                                $Cell.removeClass("clsNotStarted").removeClass("clsProgress").removeClass("clsUpcoming").addClass(bgclassName);
                                                $Cell.attr("title", StatusText);
                                                if (flgShowLink == "1") {
                                                    $Cell.html("<a href='###' onclick='fnStartMeeting(this)' rspexerciseid='" + RspExerciseId + "'  class='btn btn-primary' style='padding:0px 4px;font-size:8pt' >" + ButtonName + "</a>");
                                                }
                                                else {
                                                    if (StatusId == "2" && Activity != "Preparation") {
                                                        $Cell.html("<i class=\"fa fa-download\" aria-hidden='true' rspexerciseid='" + RspExerciseId + "'  onclick='fnDownloadCue(this)' style='font-size:10pt' ></i>");
                                                    }
                                                    else {
                                                        $Cell.html(StatusText);
                                                    }
                                                }
                                                StatusText = "";
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                }, function (result) { });

            } catch (err) { }
        }

        function fnDownloadCue(sender) {
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            var RSPExerciseid = $(sender).attr("rspexerciseid");
            window.open("frmDownloadExcel.aspx?flg=1&LoginId=" + LoginId + "&RSPExerciseid=" + RSPExerciseid)
        }

        $(document).ready(function () {
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            $("#loader").show();
            //var cycleid = $("#ConatntMatter_hdnCycleId").val();
            //$("#ConatntMatter_ddlCycleName option[value='" + cycleid + "']").prop("selected", true);
            //$("#ConatntMatter_ddlCycleName").on("change", function () {
            //    $("#ConatntMatter_dvMain")[0].innerHTML = "";
            //    $('#btnSave').hide();
            //    var CycleID = $("#ConatntMatter_ddlCycleName").val();
            //    $("#loader").show();
            //    PageMethods.fnGetParticipantDetails(CycleID, LoginId, 1, fnGetDisplaySuccessData, fnGetFailed);
            //});

            var CycleID = $("#ConatntMatter_hdnCycleId").val();
            $("#loader").show();
            PageMethods.fnGetParticipantDetails(CycleID, LoginId, 1, fnGetDisplaySuccessData, fnGetFailed);
        });
        

        function fnGetDisplaySuccessData(result) {

            $("#loader").hide();

            $("#ConatntMatter_dvMain")[0].innerHTML = result;
            $("#dvlegends").hide();
            //---- this code add by satish --- //
            if ($("#tblEmp").length > 0) {
                $("#dvlegends").show();
                $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");

                var wid = $("#tblEmp").width(), thead = $("#tblEmp").find("thead").eq(0).html();
                $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm bg-white mb-0' style='width:" + (wid) + "px;'><thead>" + thead + "</thead></table>");
                $("#tblEmp").css({ "width": wid, "min-width": wid });
                for (i = 0; i < $("#tblEmp").find("th").length; i++) {
                    var th_wid = $("#tblEmp").find("th")[i].clientWidth;
                    $("#tblEmp_header, #tblEmp").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                }
                $("#tblEmp").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");
                var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                $('#dvtblbody').css({
                    'height': $(window).height() - (nvheight + secheight + fgheight + 105),
                    'overflow-y': 'auto',
                    'overflow-x': 'hidden',
                    'border': '1px solid #bbb'
                });
            }

        }
        function fnGetFailed(result) {
            alert(result._message);
        }
        function fnShowA3Sheetpage() {
            var LoginID = $("#ConatntMatter_hdnLoginId").val();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            $("#loader").show();
            var CycleID = $("#ConatntMatter_hdnCycleId").val();
            window.parent.$("#hheader").closest("div").hide();
            window.location.href = "frmA3Sheet.aspx?LoginID=" + LoginID + "&RoleId=" + RoleId + "&flgCallType=1&cycleid=" + CycleID;
            window.parent.$("#divWashupbutton").show();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    
  <%-- <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch :</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycleName" runat="server" CssClass="form-control" AppendDataBoundItems="true">
               
            </asp:DropDownList>
        </div>
    </div>--%>

    <div id="dvMain" runat="server"></div>
    <div id="dvlegends" style="display:none;margin-top:5px;padding-right:115px;width:100%;text-align:right"><table style="display:inline;font-size:8pt"><tr><td><b>Legends : </b></td><td class="clsNotStarted" style="width:25px;height:20px;border:1px solid #bbb"></td><td> Not Started  </td><td class="clsNotApplicable" style="width:25px;height:20px;border:1px solid #bbb"></td><td> Not Applicable  </td><td class="clsProgress" style="width:25px;height:20px;border:1px solid #bbb"></td><td> In Progress  </td><td class="clsCompleted" style="width:25px;height:20px;border:1px solid #bbb"></td><td> Completed</td></tr></table></div>
    <div style="text-align:right"><input type="button" value="Washup Discussion" onclick="fnShowA3Sheetpage()" class="btn btn-primary" /></div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <div id="loader" class="loader-outerbg" style="display: none">
        <div class="loader"></div>
    </div>
      <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField runat="server" ID="hdnRoleId" value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" value="0" />
    
</asp:Content>


