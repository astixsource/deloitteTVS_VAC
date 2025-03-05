<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmGetParticipantListAgAssessor.aspx.cs" Inherits="Admin_Evidence_frmGetParticipantListAgAssessor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">   
     <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script> 
    <style type="text/css">
        /*.no-close .ui-dialog-titlebar-close {  display: none;}*/
        .bg-blue{
            background:#194597;
font-size:9pt !important;
        }
        .ui-dialog{
            z-index:10000 !important;
        }
    </style>
    <script type="text/javascript">
        function fnStartMeeting(sender) {
            var MeetingLink = $(sender).attr("AssessorMeetingLink");
            var flgIsJoin = $(sender).closest("tr").attr("flg");
            var RspExerciseID = $(sender).attr("rspexerciseid");
RspExerciseID =RspExerciseID==""?"0":RspExerciseID ;
            var meetingid = $(sender).attr("meetingid");
            if (meetingid == "0") {
                alert("Meeting Link Not Available");
                return false;
            }
            var Exerciseid = $(sender).closest("tr").attr("Exerciseid");
            var RspId = $(sender).closest("tr").attr("RspId");
            var MeetingScheduledStartTime = $(sender).closest("tr").attr("meetingscheduledstarttime");
            if (flgIsJoin == 1) {
                if (MeetingLink == "") {
                    alert("Orientation Meeting Link Not Available");
                    return false;
                }
                window.open(MeetingLink, "_blank");
                return false;
            }
            var flg = 1;
            var gotousername = $(sender).attr("gotousername");
            var gotopassword = $(sender).attr("gotopassword");
            var flgType = 1;
            var UserTypeID = 2;
            var flgAction = 3;
            if ($(sender).html().trim() == "End Meeting") {
                flgAction = 4;
                flgType = 2;
            } else if ($(sender).html().trim() == "Resume Meeting") {
                flgAction = 3;
                flgType = 3;
            }
           
            var FlgCallFrom = $("#ConatntMatter_hdnFlgCallFrom").val();
             if (Exerciseid == "500" || Exerciseid == "-1") {
                fnUpdateActualStartEndTime(sender, UserTypeID, flgAction, RspExerciseID, Exerciseid, gotousername, gotopassword, meetingid, flgType, RspId, MeetingScheduledStartTime,MeetingLink);
            } else {
                if (RspExerciseID == "0" && Exerciseid!=3) {
                    alert("Participant has not started his exercise yet!");
                    return false;
                 }
                 if (RspExerciseID == "0" && Exerciseid == 3) {
                     fnCreateGDExercises(UserTypeID, flgAction, RspExerciseID, Exerciseid,RspId, MeetingScheduledStartTime);
                 }
                 else {
                     window.parent.location.href = "../../Admin/Evidence/frmAsseesorRating.aspx?str=" + RspExerciseID + "&BandId=1&flgCallFrom=1&flgAssessorType=" + flg;
                 }
                
//fnUpdateActualStartEndTime(sender, UserTypeID, flgAction, RspExerciseID, Exerciseid, gotousername, gotopassword, meetingid, flgType, RspId, MeetingScheduledStartTime,MeetingLink);
            }
        }
        function fnUpdateActualStartEndTime(sender, UserTypeID, flgAction, RspExerciseID, Exerciseid, gotousername, gotopassword, meetingid, flgType, RspId, MeetingScheduledStartTime,MeetingLink) {
            if (flgAction == 4) {
                var sconfirm = confirm("Are you sure to close the meeting?");
                if (sconfirm == false) {
                    return false;
                }
            }
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            var CycleID = $("#ConatntMatter_ddlCycleName").val();
            PageMethods.fnUpdateActualStartEndTime(RspExerciseID,Exerciseid, UserTypeID, flgAction, gotousername, gotopassword, meetingid, flgType,RspId,LoginId,CycleID,MeetingScheduledStartTime, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "1") {
                    alert("Error-" + result.split("|")[1]);
                } else {
                    fnEnableExerciseAutomatically();
                    if (flgType == 1 || flgType == 3) {
                        window.open(MeetingLink);
                    } else {
                        alert("Meeting Ended successfully");
                        //$(sender).closest("td").find("a.clsaction").eq(0).closest("td").html("Discussion Over");
                    }
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }

        function fnCreateGDExercises(UserTypeID, flgAction, RspExerciseID, Exerciseid,RspId, MeetingScheduledStartTime) {
            
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            var CycleID = $("#ConatntMatter_ddlCycleName").val();
            PageMethods.fnCreateGDExercises(RspExerciseID, Exerciseid, UserTypeID, flgAction, RspId, LoginId, CycleID, MeetingScheduledStartTime, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "1") {
                    alert("Error-" + result.split("|")[1]);
                } else {
                    window.parent.location.href = "../../Admin/Evidence/frmAsseesorRating.aspx?str=" + result.split("|")[1] + "&BandId=1&flgCallFrom=1&flgAssessorType=1";
                   
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
                var CycleID = $("#ConatntMatter_ddlCycleName").val();
                PageMethods.fnGetParticipantDetails(CycleID, LoginId, 2, function (result) {
                    if (result != "") {
                        var sData = $.parseJSON(result);
                        var tbl = sData.Table;
                        fnSetMeetingStatus(tbl);
                        //var tbl = sData.Table1;
                        //fnSetMeetingStatus(tbl);
                    }
                }, function (result) { });

            } catch (err) { }
        }
        function fnSetMeetingStatus(tbl) {
            if (tbl.length > 0) {
                for (var i in tbl) {
                    var RspExerciseID = tbl[i]["RspExerciseID"];
                    var ParticipantId = tbl[i]["ParticipantId"];
                    var ExerciseID = tbl[i]["ExerciseID"];
                    var MeetingActualStartTime = tbl[i]["Time"];
                    var sStatus = tbl[i]["Status"];
                    var flgShowLink = tbl[i]["flgShowLink"];
                    var MeetingButtonName = tbl[i]["MeetingButtonName"];
                    var flgShowLink = tbl[i]["flgShowLink"];
                    var TooltipText = tbl[i]["ToolTipText"];
                    TooltipText = TooltipText == null ? "" : TooltipText;

                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a").attr("rspexerciseid", RspExerciseID)
                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("td[iden='mstatus']").html(sStatus);
                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("td").eq(1).html(MeetingActualStartTime);
                    var flg = tbl[i]["IsJoinMeet"];
                    var flgrule = tbl[i]["flgRule"];
                    var stitle = (MeetingButtonName == "Participant Not Completed" || MeetingButtonName == "Meeting Upcoming") ? TooltipText.replace(/,/g, "\n") : "";
                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).closest("td").attr("title", stitle);
                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).attr("flg", flg);
                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").attr("flgrule", flgrule);
                    $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").attr("flgShowLink", flgShowLink);
                    if (flgShowLink == 1) {

                        $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).prop("disabled", false);
                        $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).removeClass("disabled").addClass("btn-primary");
                        $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).html(MeetingButtonName);
                        if (flgrule == 3) {
                            $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(1).show();
                        } else if (flgrule == 4) {
                            $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(1).hide();
                        }
                        if (ExerciseID == -1) {
                            $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).hide();
                            if (MeetingButtonName != "Start Meeting") {
                                $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).show();
                            }
                        }
                        // var d = new Date(MeetingActualStartTime);
                        //$("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("td[iden='mast']").html(d.toLocaleString());
                    } else {
                        $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).removeClass("btn-primary").addClass("disabled");
                        $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).html(MeetingButtonName);
                        if (flgrule == 6 || flgrule == 5) {
                            $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("td.cellaction").html(MeetingButtonName);
                            $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").hide();
                        }
                        if (ExerciseID == -1) {
                            $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).hide();
                            if (MeetingButtonName == "Meeting Over") {
                                $("#tblEmp tr[participantid='" + ParticipantId + "'][exerciseid=" + ExerciseID + "]").find("a.clsaction").eq(0).show();
                            }
                        }
                    }
                }
            }
        }

        $(document).ready(function () {
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            $("#loader").show();
            var CycleID = $("#ConatntMatter_ddlCycleName").val();
            $("#ConatntMatter_ddlCycleName").on("change", function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                //$('#btnSave').hide();
                var LoginId = $("#ConatntMatter_hdnLoginId").val();
                var CycleID = $("#ConatntMatter_ddlCycleName").val();
                $("#loader").show();
                PageMethods.fnGetParticipantDetails(CycleID, LoginId, 1, fnGetDisplaySuccessData, fnGetFailed);
            });
            PageMethods.fnGetParticipantDetails(CycleID, LoginId, 1, fnGetDisplaySuccessData, fnGetFailed);
        });
        

        function fnGetDisplaySuccessData(result) {

            $("#loader").hide();

            $("#ConatntMatter_dvMain")[0].innerHTML = result;

            //---- this code add by satish --- //
            if ($("#tblEmp").length > 0) {

                $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");

                var wid = $("#tblEmp").width(), thead = $("#tblEmp").find("thead").eq(0).html();
                $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid) + "px;'><thead>" + thead + "</thead></table>");
                $("#tblEmp").css({ "width": wid, "min-width": wid });
                for (i = 0; i < $("#tblEmp").find("th").length; i++) {
                    var th_wid = $("#tblEmp").find("th")[i].clientWidth;
                    $("#tblEmp_header, #tblEmp").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                }
                $("#tblEmp").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");
                var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                $('#dvtblbody').css({
                    'height': $(window).height() - (nvheight + secheight + fgheight + 90),
                    'overflow-y': 'auto',
                    'overflow-x': 'hidden'
                });
            }
        }
        function fnGetFailed(result) {
            alert(result._message);
        }
        function fnOpenWashupMeeting() {
            alert("Hi")
            //setTimeout(function () {
            //    window.parent.$("#divWashupbutton").show();
            //}, 1000);
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
        function fnShowPopDialog() {
            $("#dvDialog").html("alert");
            $("#dvDialog").dialog({
                title:"Alert!",
                dialogClass: "no-close",
                buttons: [{
                    text: "OK", click: function () {
                        $(this).dialog("close");
                    }
                }]

            })
        }

        function fnSHowCR(ParticipantId,DCType) {
            $("#dvDialog").dialog({
                title: "CAREER REFLECTION PROFILE",
                width: $(window).width()-240,
                height:$(window).height(),
                open: function () {
                    var sHeight = $(window).height() - 130; 
                    var url = "../../"+DCType+"/PreDC/frmCareerReflection.aspx?flgcallfrom=1&EmpNodeID=" + ParticipantId;
                    $("#dvDialog")[0].innerHTML = "<iframe id=\"Iframefrm\" src='" + url + "' style=\"height: " + sHeight + "px; width: 100%; background-color: #fff\" frameborder=\"0\" name=\"Iframefrm\"  ></iframe>";
                },
                close:function(){
                    $(this).dialog("destroy");
                },
                buttons: [{
                    text: "Close", click: function () {
                        $(this).dialog("close");
                    }
                }]

            })
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Upcoming Meetings</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch :</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycleName" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            </asp:DropDownList>
        </div>
    </div>
    <div id="dvMain" runat="server"></div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <div id="loader" class="loader-outerbg" style="display: none">
        <div class="loader"></div>
    </div>
      <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField runat="server" ID="hdnRoleId" value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" value="0" />
     <asp:HiddenField ID="hdnFlgCallFrom" Value="0" runat="server" />
</asp:Content>


