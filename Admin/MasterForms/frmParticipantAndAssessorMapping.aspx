<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmParticipantAndAssessorMapping.aspx.cs" EnableEventValidation="false" Inherits="Admin_MasterForms_frmParticipantAndAssessorMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%--<script src="https://code.jquery.com/jquery-3.4.1.js"></script>--%>
    <style>
        tr.clstrgdmapped > td{
            background-color:#f5f5f5;
        }

    </style>
    <script>
        var StoreList = [];
        $(document).ready(function () {
            fnDSEList();
        });
        var MappingStatus = 0;
        function fnDSEList() {
            var CycleId =$("#ConatntMatter_ddlCycle").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            var CycleDate = $("#ConatntMatter_ddlCycle option:selected").attr("CycleDate");
            $("#anchorbtn_other").hide();
            $("#anchorbtn_gd").hide();
            if (CycleId == 0) {
                
                $("#ConatntMatter_divdrmmain").show();
               
                $("#anchorbtn_other").hide();
                $("#ConatntMatter_divdrmmain")[0].innerHTML = "";
                return false;
            }
            $("#dvFadeForProcessing").show();
            PageMethods.fngetdata(CycleId, CycleDate, function (result) {
                $("#dvFadeForProcessing").hide();
                $("#divBTNS").hide();
                if (result.split("|")[0] == "2") {
                    alert("Error-" + result.split("|")[1]);
                } else if (result == "") {
                    $("#ConatntMatter_divdrmmain")[0].innerHTML = "No Participant Found!!!";
                }
                else {
                   
                    $("#ConatntMatter_divdrmmain").show();
                    $("#anchorbtn_other").show();
                    $("#ConatntMatter_divdrmmain")[0].innerHTML = result.split("|")[0];

                    var MappingStatus = result.split("|")[1];
                    if (MappingStatus != "") {
                        if (parseInt(MappingStatus) > 2) {
                            $("#anchorbtn_other").hide();
                            $("#spnmeeting")[0].innerHTML = MappingStatus == "0" ? "Mapping Not Done" : (MappingStatus == "2" ? "Mapping Done" : "Meeting Created");
                        }
                        else if (parseInt(MappingStatus) == 1) {
                            $("#anchorbtn_other").show();
                            $("#spnmeeting")[0].innerHTML = "Mapping Partially Done";
                        }
                        else {
                            $("#spnmeeting")[0].innerHTML = MappingStatus == "0" ? "Mapping Not Done" : (MappingStatus == "2" ? "Mapping Done" : "Meeting Created");
                        }
                        if (MappingStatus == 3) {
                            $("#tbldbrlist").find("select").prop("disabled", true);
                        }
                    }
                    
                    //---- this code add by satish --- //
                    $("#ConatntMatter_divdrmmain").prepend("<div id='tblheader'></div>");
                    if ($("#tbldbrlist").length > 0) {
                        var wid = $("#tbldbrlist").width(), thead = $("#tbldbrlist").find("thead").eq(0).html();
                        $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                        $("#tbldbrlist").css({ "width": wid, "min-width": wid });

                        for (i = 0; i < $("#tbldbrlist").find("th").length; i++) {
                            var th_wid = $("#tbldbrlist").find("th")[i].clientWidth;
                            $("#tblEmp_header, #tbldbrlist").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                        }
                        $("#tbldbrlist").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                        //var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                        $('#dvtblbody').css({
                            'height': $(window).height() - 380,
                            'overflow-y': 'auto',
                            'overflow-x': 'hidden'
                        });
                        $("#divBTNS").show();


                        $(".mergerow").closest('tr').find('td').css('border-top', '2px solid black');
                        //$(".mergerow").closest('tr').find('td').css('border-top-width', 'thik');

                    }
                   
                    //---- end code --- //

                }
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    alert("Error-" + result._message);
                }
            )
        }

        function fnFixTblHeader(flg) {
            if (flg == 2) {
                $("#ConatntMatter_divdrmmainGD").prepend("<div id='tblheaderGD'></div>");
                if ($("#tbldbrlistGD").length > 0) {
                    var wid = $("#tbldbrlistGD").width(), thead = $("#tbldbrlistGD").find("thead").eq(0).html();
                    $("#tblheaderGD").html("<table id='tblEmp_headerGD' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tbldbrlistGD").css({ "width": wid, "min-width": wid });

                    for (i = 0; i < $("#tbldbrlistGD").find("th").length; i++) {
                        var th_wid = $("#tbldbrlistGD").find("th")[i].clientWidth;
                        $("#tblEmp_headerGD, #tbldbrlistGD").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tbldbrlistGD").css("margin-top", "-" + ($("#tblEmp_headerGD")[0].offsetHeight) + "px");

                    var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                    $('#dvtblbodyGD').css({
                        'height': $(window).height() - (nvheight + secheight + fgheight + 190),
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                    $("#divBTNS").show();
                }
            } else {
                $("#ConatntMatter_divdrmmain").prepend("<div id='tblheader'></div>");
                if ($("#tbldbrlist").length > 0) {
                    var wid = $("#tbldbrlist").width(), thead = $("#tbldbrlist").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tbldbrlist").css({ "width": wid, "min-width": wid });

                    for (i = 0; i < $("#tbldbrlist").find("th").length; i++) {
                        var th_wid = $("#tbldbrlist").find("th")[i].clientWidth;
                        $("#tblEmp_header, #tbldbrlist").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tbldbrlist").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                    var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                    $('#dvtblbody').css({
                        'height': $(window).height() - (nvheight + secheight + fgheight + 355),
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                    $("#divBTNS").show();


                    $(".mergerow").closest('tr').find('td').css('border-top', '2px solid black');
                    //$(".mergerow").closest('tr').find('td').css('border-top-width', 'thik');
                    $("#anchorbtn_other").show();
                    $("#anchorbtn_gd").hide();
                }
            }
        }

     

    </script>



    <script>

        //for saving 


        function fnSave(flg) {

            var flgvalid = true;
            var IsCnt = 0;
            var flgStatus = 1;

            var CycleId = $("#ConatntMatter_ddlCycle").val();
            var CycleDate = $("#ConatntMatter_ddlCycle option:selected").attr("CycleDate");

            var ArrDataSaving = []; var ArrDataMails = [];

         
            // if (flg == 1) {
            var cntOneTonOne = 0; var OldParticipantCycleMappingId = 0; var startTime = ""; var timeselected = 0;
            $("#ConatntMatter_divdrmmain").find("#tbldbrlist tbody tr").each(function () {
                if ($(this).find("#ddlassessor").val() > 0) {
                    var IsLeadAssessor = 0; 
                    if (OldParticipantCycleMappingId != $(this).attr("ParticipantCycleMappingId")) {
                        timeselected = 0;
                        if ($(this).find("#ddltimeslot").val() != "0") {
                            timeselected = 1;
                            startTime = $(this).attr("cycledate") + " " + $(this).find("#ddltimeslot").val();
                            startTime = startTime.replace(/-/g, "/");
                            startTime = new Date(startTime);
                        } 
                    }
                    if (timeselected == 1) {
                        var Hours = startTime.getHours();
                        var Minutes = startTime.getMinutes();
                        Minutes = Minutes == "" ? "00" : Minutes;
                        var sstime = Hours.toString().trim() + ":" + Minutes.toString().trim();
                        ArrDataSaving.push({ ParticipantCycleMappingId: $(this).attr("ParticipantCycleMappingId"), AssessorCycleMappingId: $(this).find("#ddlassessor option:selected").attr("AssessorCycleMappingId"), ParticipantId: $(this).attr("ParticipantId"), AssessorId: $(this).find("#ddlassessor").val(), IsLeadAssessor: IsLeadAssessor, ExerciseId: $(this).attr("ExerciseId"), ExerciseName: $(this).attr("ExerciseName"), AssesseMeetingLink: "", AssessorMeetingLink: "", MeetingId: "0", MeetingStartTime: CycleDate + " " + sstime, PreTime: $(this).attr("PreTime"), AssessorTime: $(this).attr("AssessorTime"), AssessorMail: $(this).find("#ddlassessor option:selected").attr("AssessorEmailId"), AssessorName: $(this).find("#ddlassessor option:selected").attr("AssessorName"), AssesseeMail: $(this).attr("participantemailid"), AssesseeName: $(this).attr("participantname"), BEIUserName: $(this).find("#ddlassessor option:selected").attr("BEIUserName"), BEIPwd: $(this).find("#ddlassessor option:selected").attr("BEIPassword"), flgCreated: 0, MeetingStatus: '', gdid: 0, PRStartTime: "00:00" });
                        cntOneTonOne++;
                        OldParticipantCycleMappingId = $(this).attr("ParticipantCycleMappingId");
                        var PrepTime = $(this).attr("PreTime");
                        var AssessorTime = $(this).attr("AssessorTime");
                        var stime = parseInt(PrepTime) + parseInt(AssessorTime);
                        startTime = new Date(startTime);
                        startTime = new Date(startTime.getTime() + stime * 60000);
                    } else {
                        IsCnt++;
                        ArrDataSaving.push({ ParticipantCycleMappingId: $(this).attr("ParticipantCycleMappingId"), AssessorCycleMappingId: 0, ParticipantId: $(this).attr("ParticipantId"), AssessorId: 0, IsLeadAssessor: 0, ExerciseId: $(this).attr("ExerciseId"), ExerciseName: $(this).attr("ExerciseName"), AssesseMeetingLink: "", AssessorMeetingLink: "", MeetingId: "0", MeetingStartTime: CycleDate + " 00:00", PreTime: "0", AssessorTime: '0', AssessorMail: '', AssessorName: $(this).find("#ddlassessor").val() == "0" ? "" : $(this).find("#ddlassessor option:selected").text(), AssesseeMail: $(this).attr("participantemailid"), AssesseeName: $(this).attr("participantname"), BEIUserName: '', BEIPwd: '', flgCreated: 0, MeetingStatus: 'Mapping Pending', gdid: 0, PRStartTime: "00:00" });
                    }
                    
                } else {
                    IsCnt++;
                    ArrDataSaving.push({ ParticipantCycleMappingId: $(this).attr("ParticipantCycleMappingId"), AssessorCycleMappingId: 0, ParticipantId: $(this).attr("ParticipantId"), AssessorId: 0, IsLeadAssessor: 0, ExerciseId: $(this).attr("ExerciseId"), ExerciseName: $(this).attr("ExerciseName"), AssesseMeetingLink: "", AssessorMeetingLink: "", MeetingId: "0", MeetingStartTime: CycleDate + " 00:00", PreTime: "0", AssessorTime: '0', AssessorMail: '', AssessorName: $(this).find("#ddlassessor").val() == "0" ? "" : $(this).find("#ddlassessor option:selected").text(), AssesseeMail: $(this).attr("participantemailid"), AssesseeName: $(this).attr("participantname"), BEIUserName: '', BEIPwd: '', flgCreated: 0, MeetingStatus: 'Mapping Pending', gdid: 0, PRStartTime: "00:00" });
                }
            });

         
            if (flgvalid == false) {
                return false;
            }
            if (ArrDataSaving.length == 0) {
                alert("No Meeting Schedule!")
                return false;
            }
            if ($("#tbldbrlist tbody tr").length == cntOneTonOne) {
                flgStatus = 2;
            }

            if (ArrDataSaving.length == 0) {
                alert("No Mapping Selected!")
                return false;
            }
            //$.extend(ArrDataSaving, ArrDataSavingGD);
            $("#dvFadeForProcessing").show();
            PageMethods.fnSave(ArrDataSaving, $("#ConatntMatter_hdnLoginId").val(), CycleId, flgStatus, fnSave_Success, fnFailed, flgStatus);
        }
        function fnRemoveAssessorMapping(sender,flg) {
            if ($(sender).is(":checked") == false) {
                $(sender).closest("tr").attr("gdid", "0");
                $(sender).closest("tr").attr("assessorid", "0");
                $(sender).closest("tr").attr("assessorcyclemappingid", "0");
                $(sender).closest("tr").find("td").eq(2).html("");
                $(sender).closest("tr").find("td").eq(3).html("");
                $(sender).closest("tr").find("td").eq(4).html("");
                $(sender).closest("tr").removeClass("clstrgdmapped");
            }
        }
        function fnSave_Success(result, flgStatus) {
            $("#dvFadeForProcessing").hide();
            if (result.split("|")[0] == "0") {
                var tbl = $.parseJSON(result.split("|")[1]);
                var strHTML = "";
                if (tbl.length > 0) {

                    var style = "border-left: 1px solid #A0A0A0; border-bottom: 1px solid #A0A0A0;font-family:arial narrow;font-size:9pt;";
                    strHTML += "Kindly find below Schedule status for each participant.</br>";
                    strHTML += ("<table cellpadding='2' cellspacing='0' style='font-family:arial narrow;font-size:8.5pt;border-right: 1px solid #A0A0A0; border-top: 1px solid #A0A0A0;text-align:center;width:100%'><thead>");
                    strHTML += ("<tr bgcolor='#26a6e7'>");
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Sr.No</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Participant Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Assessor Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Exercise Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Exercise Time</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Mapping Status</th>";
                    strHTML += ("</tr></thead><tbody>");
                    //MeetingStartTime
                    var flgvalid = true;
                    var Oldparticipantcyclemappingid = 0;
                    var cnt = 1;
                    for (var i in tbl) {
                        var ParticipantAssessorMappingId = 0;// tbl[i]["ParticipantAssessorMappingId"];
                        var MeetingStatus = tbl[i]["MeetingStatus"];
                        var flgCreated = tbl[i]["flgCreated"];
                        var ParticipantName = tbl[i]["AssesseeName"];
                        var AssessorName = tbl[i]["AssessorName"];
                        var MeetingStartTime = tbl[i]["MeetingStartTime"];
                        var ExerciseName = tbl[i]["ExerciseName"];
                        var assessorid = tbl[i]["AssessorId"];
                        var meetingid = tbl[i]["MeetingId"];
                        var AssessorCycleMappingId = tbl[i]["AssessorCycleMappingId"];
                        
                        var gdid = tbl[i]["gdid"];
                        var strColor = "";
                        if (flgCreated == 0) {
                            flgvalid = false
                        }
                        var participantcyclemappingid = tbl[i]["ParticipantCycleMappingId"];
                        //if (Oldparticipantcyclemappingid != participantcyclemappingid) {
                           // if (assessorid > 0) {
                                strHTML += ("<tr " + strColor + ">");
                                strHTML += "<td  style='" + style + ";text-align:center;padding:3px'>" + cnt + "</td>";
                                strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + ParticipantName + "</td>";
                                strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + AssessorName + "</td>";
                                strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + ExerciseName + "</td>";
                                strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStartTime + "</td>";
                                strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStatus + "</td>";
                                strHTML += ("</tr>");
                                cnt++;
                            //}
                        //}
                        Oldparticipantcyclemappingid = participantcyclemappingid;
                    }
                    if (flgvalid == true) {
                        $("#spnmeeting")[0].innerHTML = flgStatus == "2" ? "Mapping Done" : "Mapping Partially Done";
                    } else {
                        $("#spnmeeting")[0].innerHTML = "Mapping Partially Done";
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
                        //fnDSEList();
                    },
                    buttons: {
                        "OK": function () {
                            $(this).dialog('close');
                        }
                    }
                })
            }
            else {
                $("#dvAlert")[0].innerHTML = "Oops! Something went wrong. Please try again.</br>Error:" + result.split("|")[1];
                $("#dvAlert").dialog({
                    title: "Error:",
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

        function fnFailed(result) {
            alert("Oops! Something went wrong. Please try again.");
            $("#dvFadeForProcessing").hide();
        }

        
        function fnSaveFinalData() {
            var tbl = $("#tbldbrlist").find('select');
            if (tbl.length == 0) {
                alert("Kindly Select Assessor first!!!");
                return false;
            }
            $("#dvDialog")[0].innerHTML = "Are you sure you have selected the correct developer for each participant?"
            $("#dvDialog").dialog({
                width: "385",
                modal: true,
                title: "Confirmation:",
                buttons: {
                    "Yes": function () {
                        $(this).dialog('close');
                        var personIds = "";
                        var arrDSENodeID = new Array();
                        for (var i = 0; i < tbl.length; i++) {
                            var flgMapped = tbl.eq(i).closest("tr").attr("flgMapped");
                            var flgMeeting = tbl.eq(i).closest("tr").attr("flgMeeting");
                            if (flgMeeting == 0 && flgMapped == 0) {
                                if (tbl.eq(i).closest("tr").find("select option:selected").val() != "0") {
                                    var ParticipantAssessorMappingId = tbl.eq(i).closest("tr").attr("ParticipantAssessorMappingId");
                                    var ParticipantCycleMappingId = tbl.eq(i).closest("tr").attr("ParticipantCycleMappingId");
                                    var AssessorCycleMappingId = tbl.eq(i).closest("tr").attr("AssessorCycleMappingId");
                                    var ParticipantId = tbl.eq(i).closest("tr").attr("ParticipantId");
                                    var AssessorId = tbl.eq(i).closest("tr").attr("AssessorId");
                                    var IsLeadAssessor = tbl.eq(i).closest("tr").attr("IsLeadAssessor");
                                    var ExerciseId = tbl.eq(i).closest("tr").attr("ExerciseId");
                                    var AssesseMeetingLink = '';
                                    var AssessorMeetingLink = '';
                                    var MeetingSlotTime = tbl.eq(i).closest("tr").attr("MeetingSlotTime");
                                    var MeetingStartTime = tbl.eq(i).closest("tr").attr("MeetingStartTime");
                                    var MeetingId = 0;


                                    //var ParticipantCycleMappingId = tbl.eq(i).closest("tr").find("select option:selected").val();


                                    arrDSENodeID.push({ ParticipantAssessorMappingId: ParticipantAssessorMappingId, ParticipantCycleMappingId: ParticipantCycleMappingId, AssessorCycleMappingId: AssessorCycleMappingId, ParticipantId: ParticipantId, AssessorId: AssessorId, IsLeadAssessor: IsLeadAssessor, ExerciseId: ExerciseId, AssesseMeetingLink: AssesseMeetingLink, AssessorMeetingLink: AssessorMeetingLink, MeetingSlotTime: MeetingSlotTime, MeetingStartTime: MeetingStartTime, MeetingId: MeetingId });
                                }
                            }
                        }
                        if (arrDSENodeID.length == 0) {
                            alert("Action is not completed as you have not mapped any new Developer!");
                            return false;
                        }
                        var LoginId = $("#ConatntMatter_hdnLoginId").val();
                        $("#dvFadeForProcessing").show();
                        PageMethods.fnParticipantAssessorMapping(LoginId, arrDSENodeID, function (result) {
                            $("#dvFadeForProcessing").hide();
                            if (result.split("|")[0] == "2") {
                                alert("Some Technical Error,Please contact to Technical Team Or Try again later!!")
                            } else {
                                alert("Mapped Successfully!!");
                                fnDSEList();
                                $("#divBTNS").hide();
                            }
                        },
                            function (result) {
                                $("#dvFadeForProcessing").hide();
                                alert(result._message)
                            }
                        )
                    },
                    "No": function () {
                        $(this).dialog('close');
                    }
                }
            });

        }

    </script>



    <script type="text/javascript">
        var OldActive = 1;
        function fnShowDataAssigned(X) {
            var CycleID = $("#ConatntMatter_ddlCycle").val();

            if (CycleID == 0) {
                alert("Please select the Cycle Name");
                $("#ConatntMatter_ddlCycle").eq(0).focus();
                return false;
            }
            //    alert(CycleID)
            var chkFlag = $("#hdnChkFlag").val();

            if (chkFlag == 1) {

                $("#dvDialog")[0].innerHTML = "You have taken an action against the participant but did not saved."
                $("#dvDialog").dialog({
                    width: "450",
                    modal: true,
                    title: "Alert",
                    buttons:
                        {
                            "Ok": function () {
                                $(this).dialog('close');
                            }
                        }
                });


                $("#tablist").find("a.active").removeClass("active");
                $("#tablist").find("a").eq(OldActive - 1).addClass("active");
                return false;
            }

            OldActive = X;
            if (X == 1)   ////// other
            {
                //alert('tab1');
                //$("#anchorbtn_other").show()
                $("#divgrpfilter").hide();
                //     fnDSEList();
                $("#ConatntMatter_divdrmmain").show();
                $("#ConatntMatter_divdrmmainGD").hide();
                $("#ConatntMatter_divdrmmainPR").hide();
                if (MappingStatus < 3) {
                    $("#anchorbtn_other").show();
                    $("#anchorbtn_gd").hide();
                }
                //fnFixTblHeader(1);
                //$("#tblEmp tbody tr").hide();
                //$("#tblEmp  tbody tr[flgactive=1]").css("display", "table-row")

            }
            else if (X == 2)  ///// group discussion
            {
                //alert('tab2');
                $("#divgrpfilter").show();
                //$("#anchorbtn_gd").show()
                // fngroupdiscussion();
                $("#ConatntMatter_divdrmmain").hide();
                $("#ConatntMatter_divdrmmainGD").show();
                $("#ConatntMatter_divdrmmainPR").hide();
               // $("#lblSlotTime")[0].innerHTML="Discussion Time :";
                $(".clsGD").show();
                $(".clsPR").hide();
                //fnFixTblHeader(2);
                //$("#tblEmp tbody tr").hide();
                //$("#tblEmp  tbody tr[flgactive=0]").css("display", "table-row")
                if (MappingStatus < 3) {
                    $("#anchorbtn_gd").show();
                    $("#anchorbtn_other").hide();
                }
            }
            else if (X == 3)  ///// group discussion
            {
                //alert('tab2');
                $("#divgrpfilter").show();
                //$("#anchorbtn_gd").show()
                // fngroupdiscussion();
                $("#ConatntMatter_divdrmmain").hide();
                $("#ConatntMatter_divdrmmainGD").hide();
                $("#ConatntMatter_divdrmmainPR").show();
                $(".clsGD").hide();
                $(".clsPR").show();
                //$("#lblSlotTime")[0].innerHTML="PR Time :";
                //fnFixTblHeader(2);
                //$("#tblEmp tbody tr").hide();
                //$("#tblEmp  tbody tr[flgactive=0]").css("display", "table-row")
                if (MappingStatus < 3) {
                    $("#anchorbtn_gd").show();
                    $("#anchorbtn_other").hide();
                }
            }
            else {
                //$("#tblEmp  tbody tr").css("display", "table-row")
            }
            $("#tablist").find("a.active").removeClass("active");
            $("#tablist").find("a").eq(OldActive - 1).addClass("active");
            //PageMethods.fnDisplayParticpantAgCycle(CycleID, X, fnGetDisplaySuccessData, fnGetFailed, X);

        }

        function fnChangeAssessor(sender) {
            var participantcyclemappingid = $(sender).closest("tr").attr("participantcyclemappingid");
            $(sender).closest("tbody").find("tr[participantcyclemappingid='" + participantcyclemappingid + "']").find("select#ddlassessor").find("option[value=" + $(sender).val() + "]").prop("selected", true);
        }
        function fnChangeTimeSlot(sender) {
            var timeslot = $(sender).val();
            var participantcyclemappingid = $(sender).closest("tr").attr("participantcyclemappingid");
            $(sender).closest("tbody").find("tr[participantcyclemappingid='" + participantcyclemappingid + "']").find("select#ddltimeslot").find("option[value=" + $(sender).val() + "]").prop("selected", true);
        }
        function fnChangeTimeSlotPRP(sender) {
            var timeslot = $(sender).val();
            if (timeslot != "0") {
                var gdid = $("#ConatntMatter_ddlPR").val();
                if ($("#tbldbrlistPR tbody").find("tr[gdid='" + gdid + "']").length > 0) {
                    if ($("#tbldbrlistPR tbody").find("tr[gdid='" + gdid + "']").find("td").eq(2).html().trim() != timeslot) {
                        alert("Sorry,PRP Time can not be changed as you have already assigned this time slot for this PRP,if you want then unmapped the assessor first from the list first.");
                        timeslot = $("#tbldbrlistPR tbody").find("tr[gdid='" + gdid + "']").find("td").eq(2).html().trim();
                        $("#ConatntMatter_ddltimePR option[value='" + timeslot + "']").prop("selected", true);
                    }
                }
            }
        }
        function fnChangeGD(sender) {
            $("#ConatntMatter_ddltime option[value='0']").prop("selected", true);
            $("#ConatntMatter_ddlassessor option[value='0']").prop("selected", true);
        }
        function fnChangePR(sender) {
            $("#ConatntMatter_ddltimePR option[value='0']").prop("selected", true);
            $("#ConatntMatter_ddlassessorPR option[value='0']").prop("selected", true);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Participant and Assessor Mapping</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="form-group row" >
        <label for="ac" class="col-sm-2 col-form-label">Select Cycle :</label>
        <div class="col-sm-4">
            <asp:DropDownList runat="server" ID="ddlCycle" onchange="fnDSEList()" CssClass="form-control">
            </asp:DropDownList>
        </div>

        <div class="col-sm-4 offset-1">
            <table style="width: 100%; background-color: burlywood" cellpadding="2">
                <tr>
                    <td>Meeting Status :</td>
                    <td id="spnmeeting" style="text-align: left"></td>
                </tr>
            </table>
        </div>
    </div>
   

    <div class="body-content">
      
        <!-- Tab panes -->
             <div id="divdrmmain" runat="server" style="min-height:370px"></div>
    </div>


    <div class="text-center" id="divBTNS" style="display: none;">
        <a href="###" class="btns btn-submit" onclick="return fnSave(1)" id="anchorbtn_other" style="display: none">Save Mapping</a>
    </div>
    <div style="font-size:11pt">
        <b>Note : </b><i>Assessment will open for participant 2 hours before start of Client Conversation time mentioned above
</i>
    </div>

    <div id="dvDialog" style="display: none"></div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvFadeForProcessing" class="loader_bg">
        <div class="loader"></div>
    </div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMenuId" Value="0" />
</asp:Content>

