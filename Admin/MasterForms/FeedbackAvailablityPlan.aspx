<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="FeedbackAvailablityPlan.aspx.cs" Inherits="FeedbackAvailablityPlan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }

            table th {
                color: #ffffff;
                padding: 4px;
                font-size: 11.4pt;
                font-weight: bold;
                text-align: center;
                background-color: #005D9B;
                border: 1px solid #bbbbbb;
            }

            table td {
                color: #000000;
                padding: 2px;
                font-size: 12px;
                border: 1px solid #bbbbbb;
                height: 26px;
                text-align: center;
            }
    </style>
    <style>
        .clsOpen {
            cursor: pointer;
            background-color: #ffffff;
        }

        .clsPast {
            background-color: #D8D8D8;
        }

        .ui-state-hover1 {
            background: #f1ff91 !important;
        }

        .clsBlock {
            cursor: pointer;
            background-color: #FBE12D;
        }

        .clsBlockAndMapped {
            cursor: default;
            color: #ffffff;
            background-color: #8080C0;
        }

         .clsBlockAndMappedFeedback {
            cursor: default;
            color: #ffffff;
            background-color: #f07800;
        }
         .clsBlockSelected {
            cursor: default;
            color:#ffffff;
            background-color: yellow;
        }
          .clsBlockSubmitted {
            cursor: default;
            color:#ffffff;
            background-color: orange;
        }

        .clsBlockAndExtended {
            background-color: #00BB00;
        }

        .clsBlockAndExtended-bottom {
            border-bottom-color: #00BB00;
        }

        .clsBlockAndExtendedAndMapped {
            color: #ffffff;
            background-color: #8000FF;
        }

        .clsBlockAndExtendedAndMapped-bottom {
            border-bottom-color: #8000FF;
        }

        .clslegend {
            padding: 2px;
            width: 10px;
            min-height: 10px;
        }

        .clslegendlbl {
            font-weight: bold;
            padding-left: 5px;
            padding-right: 10px;
            text-align: left;
            min-height: 10px;
        }
    </style>
    <script>
        var IsChecked = 0;
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            //$("#ConatntMatter_divStatus").css("height", $(window).height() - 230);
            //alert($("table.clstbl > tbody").height());
            //$("td.clsmaindivdroppable1").css("height", $("table.clstbl > tbody").height());
            fnGetDetail();
            //setInterval(function () { fnUpdateDateTime(); }, 1000);
        });

        function fnGetDetail() {
            $("#dvFadeForProcessing").show();
            var LoginId = $("#ConatntMatter_hdnLogin").val();
            var CycleId = $("#ConatntMatter_ddlCycle").val();
            PageMethods.fnGetDetail(LoginId, CycleId, function (result) {
                $("#ConatntMatter_divStatus")[0].innerHTML = result.split("|")[1];
                if (result.split("|")[0] != "") {
                    var tbl = $.parseJSON(result.split("|")[0]);
                    var strHTML = "";
                    if (tbl.length > 0) {
                        strHTML += "<div style='border-bottom:1px solid #bbbbbb;width:100%;display:table;font-weight:bold;color:black'><div style='display:table-cell;width:100%'>Participant</div></div>";
                        for (var i in tbl) {
                            var ParticipantName = tbl[i]["ParticipantName"];
                            var ParticipantAssessorMappingId = tbl[i]["ParticipantAssessorMappingId"];
                            //var FeedbackMeetingStatus = tbl[i]["FeedbackMeetingStatus"];
                            var MeetingSlotTime = tbl[i]["MeetingSlotTime"];
                            var MeetingId = tbl[i]["MeetingId"];
                            var AssessorMail = tbl[i]["AssessorMail"];
                            var AssessorName = tbl[i]["AssessorName"];
                            var AssesseeMail = tbl[i]["AssesseeMail"];
                            var AssesseeSecondaryMail = tbl[i]["AssessessSecondaryEmailID"];
                            var AssessorSecondaryMail = tbl[i]["AssessorSecondaryEmailID"];

                            var MeetingStartTime = tbl[i]["MeetingStartTime"];
                            var BEIUserName = tbl[i]["BEIUserName"]
                            var BEIPwd = tbl[i]["BEIPassword"]
                            var flgScheduleType = tbl[i]["flgScheduleType"]
                            if (MeetingId > 0) {
                                $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").attr("flgBlocked", "1");
                                $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").attr("flgLocked", "1");
                                $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").removeClass("clsdivdroppable");
                                $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").removeClass("clsOpen");
                                if (flgScheduleType == 1) {
                                    $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").addClass("clsBlockAndMapped");
                                } else {
                                    $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").addClass("clsBlockAndMappedFeedback");
                                }
                                $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']").html("<div style='display:table;width:100%;position:relative;text-align:left;padding-left:5px'  MeetingId='" + MeetingId + "' pid='" + ParticipantAssessorMappingId + "' ><div style='display:table-cell;width:100%'>" + ParticipantName + "</div></div>");
                                var ctrl = $("table.clstbl tbody").find("td[dd='" + MeetingStartTime + "'][hr='" + MeetingSlotTime.split(":")[0] + "'][mm='" + MeetingSlotTime.split(":")[1] + "']")
                                fnChangeAvailablityOnLoad(ctrl[0], flgScheduleType);
                            }
                            else {
                                strHTML += "<div style='display:table;width:100%;position:relative' AssessorMail='" + AssessorMail + "' AssessorName='" + AssessorName + "'  AssesseeMail='" + AssesseeMail + "' AssesseeName='" + ParticipantName + "'  AssesseeSecondaryMail = '" + AssesseeSecondaryMail + "' AssessorSecondaryMail='" + AssessorSecondaryMail + "' BEIUserName='" + BEIUserName + "' BEIPwd='" + BEIPwd + "'  class='clsdivdraggable' MeetingId='" + MeetingId + "' pid='" + ParticipantAssessorMappingId + "' ><div style='display:table-cell;width:100%'>" + ParticipantName + "</div></div>";
                            }
                        }
                        $(".clsmaindivdroppable1").html(strHTML);

                        fnMakeDraggableDropable();

                    }
                }
                $("#dvFadeForProcessing").hide();
            }, fnFailed);
        }
        function fnChangeAvailablityUncheck(ctrl, trIndx, pid,dd) {
            var trBackIndx = trIndx;
            var trForIndx = trIndx;
            var totTR = $("table.clstbl tbody tr").length;
            $(ctrl).closest("td").attr("flgblocked", "0");
            var countBuffer = $("#ConatntMatter_hdnSlotBufferNo").val();
            if ($("table.clstbl tr").find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").droppable.length > 0) {
                $("table.clstbl tr").find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").droppable("option", "disabled", false);
            }
            $("table.clstbl").find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").removeClass("clsPast");
            $("table.clstbl").find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").attr("flgblocked", "0");
            $("table.clstbl").find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").attr("pid", "0");
            
            /*
            for (var i = 1; i < countBuffer; i++) {
                trBackIndx--;
                trForIndx++;
                if ($("table.clstbl tr").eq(trIndx - 3).length > 0) {
                    if ($("table.clstbl tr").eq(trIndx - 3).find("td[iden='Action'][dd='" + dd + "']").find("div.clsdivdraggable").length == 0) {
                        if ($("table.clstbl tr").eq(trBackIndx).length > 0) {
                            if ($("table.clstbl tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").length > 0) {

                                $("table.clstbl tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").removeClass("clsPast");
                                if ($("table.clstbl tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").droppable.length > 0) {
                                    $("table.clstbl tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").droppable("option", "disabled", false);
                                }
                                $("table.clstbl tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").attr("pid", "0");
                            }
                        }
                    }
                }
                if ($("table.clstbl tr").eq(trIndx + 3).length > 0) {
                    if ($("table.clstbl tr").eq(trIndx + 3).find("td[iden='Action'][dd='" + dd + "']").find("div.clsdivdraggable").length == 0) {
                        if ($("table.clstbl tr").eq(trForIndx).length > 0); {
                            if ($("table.clstbl tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").length > 0) {
                                $("table.clstbl tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").removeClass("clsPast");
                                if ($("table.clstbl tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").droppable.length > 0) {
                                    $("table.clstbl tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").droppable("option", "disabled", false);
                                }
                                $("table.clstbl tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "'][pid='" + pid + "']").attr("pid", "0");
                            }
                        }
                    }
                }
            }
            */

            var $TR = $("table.clstbl tbody td[iden='Action'][dd='" + dd + "'][flgLocked=0]");
            $.each($TR,function () {
                if ($(this).find("div.clsdivdraggable").length> 0) {
                    var trBackIndx = parseInt($(this).closest("tr").index());
                    var trForIndx = trBackIndx;
                    var pid = $(this).find("div.clsdivdraggable").attr("pid");
                    for (var i = 1; i < 3; i++) {
                        trBackIndx--;
                        trForIndx++;
                        if ($("table.clstbl tbody tr").eq(trBackIndx).length > 0) {
                            if ($("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").length > 0) {
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsPast");
                                var oldpid = $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").is("[pid]") ? $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid") : 0;
                                if (oldpid == 0) {
                                    $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid", pid);
                                }
                                if ($("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").droppable.length > 0) {
                                    $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").droppable("option", "disabled", true);
                                }
                            }
                        }
                        if ($("table.clstbl tbody tr").eq(trForIndx).length > 0) {
                            if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").length > 0) {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsPast");
                                var oldpid = $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").is("[pid]") ? $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid") : 0;
                                if (oldpid == 0) {
                                    $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid", pid);
                                }

                                if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").droppable.length > 0) {
                                    $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").droppable("option", "disabled", true);
                                }
                            }
                        }
                    }
                }
            });
        }

        function fnChangeAvailablityOnLoad(ctrl, flgScheduleType) {
            try {
                var countBuffer =flgScheduleType==1?3: $("#ConatntMatter_hdnSlotBufferNo").val();
                var dd = $(ctrl).attr("dd");
                // $("#ConatntMatter_divStatus").find("div.clsdivdraggable,div.clsdivdraggabled").each(function () {
                var trBackIndx = $(ctrl).closest("tr").index();
                var trForIndx = $(ctrl).closest("tr").index();
                for (var i = 1; i < countBuffer; i++) {
                    trBackIndx--;
                    trForIndx++;
                    if ($("table.clstbl tbody tr").eq(trBackIndx).length > 0) {
                        if ($("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").length > 0) {
                            if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgLocked") == "1" && $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgBlocked") == "1") {
                                //$("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsBlockAndMapped");
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsdivdroppable");
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsOpen");
                            } else {
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsdivdroppable");
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsOpen");
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsPast");
                            }
                            $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd=" + dd + "]").attr("flgLocked", "1");
                            $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd=" + dd + "]").attr("flgBlocked", "1");
                            $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd=" + dd + "]").removeAttr("iden");
                            $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsdivdroppable");
                            $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsOpen");
                        }
                    }
                    if ($("table.clstbl tbody tr").eq(trForIndx).length > 0) {
                        if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").length > 0) {
                            if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgLocked") == "1" && $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgBlocked") == "1") {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsBlockAndMapped");
                            } else {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsdivdroppable");
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").removeClass("clsOpen");
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsPast");
                            }

                            $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgLocked", "1");
                            $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgBlocked", "1");
                            $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").removeAttr("iden");
                        }
                    }
                }
                //});

            } catch (err) { }
            // fnMakeDraggableDropable();
        }
        function fnChangeAvailablity(ctrl) {
            try {
                var countBuffer = $("#ConatntMatter_hdnSlotBufferNo").val();
                var dd = $(ctrl).attr("dd");
                var pid = $(ctrl).find("div.clsdivdraggable").attr("pid");
                // $("#ConatntMatter_divStatus").find("div.clsdivdraggable,div.clsdivdraggabled").each(function () {
                var trBackIndx = $(ctrl).closest("tr").index();
                var trForIndx = $(ctrl).closest("tr").index();
                for (var i = 1; i < countBuffer; i++) {
                    trBackIndx--;
                    trForIndx++;
                    if ($("table.clstbl tbody tr").eq(trBackIndx).length > 0) {
                        if ($("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").length > 0) {
                            if ($("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgLocked") == "1" && $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgBlocked") == "1") {
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsBlockAndMapped");
                            } else {
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsPast");
                            }
                            var oldpid = $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").is("[pid]") ? $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid") : 0;
                            if (oldpid == 0) {
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid", pid);
                            }
                            if ($("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").droppable.length > 0) {
                                $("table.clstbl tbody tr").eq(trBackIndx).find("td[iden='Action'][dd='" + dd + "']").droppable("option", "disabled", true);
                            }

                        }
                    }
                    if ($("table.clstbl tbody tr").eq(trForIndx).length > 0) {
                        if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").length > 0) {
                            if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgLocked") == "1" && $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("flgBlocked") == "1") {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsBlockAndMapped");
                            } else {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").addClass("clsPast");
                            }
                            var oldpid = $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").is("[pid]") ? $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid") : 0;
                            if (oldpid == 0) {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").attr("pid", pid);
                            }
                            if ($("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").droppable.length > 0) {
                                $("table.clstbl tbody tr").eq(trForIndx).find("td[iden='Action'][dd='" + dd + "']").droppable("option", "disabled", true);
                            }
                        }
                    }
                }
                //});

            } catch (err) { }
            // fnMakeDraggableDropable();
        }


        function fnMakeDraggableDropable() {
            $(".clsdivdraggable").draggable({
                start: function (event, ui) {
                    $(ui.helper).css({ width: "100px", background: "#e4ecef", padding: "4px", "text-align": "left", cursor: "move" });
                    $(this).data("startingScrollTop", window.pageYOffset);
                },
                drag: function (event, ui) {
                    var st = parseInt($(this).data("startingScrollTop"));
                    ui.position.top -= st;
                },
                appendTo: "body",
                helper: "clone",
                cursor: "move",
                revert: "invalid"
            });
            //border-bottom:1px solid #000;text-align:left;padding: 1px;
            $(".clsdivdroppable").droppable({
                over: function (event, ui) {
                },
                hoverClass: "ui-state-hover1",
                drop: function (event, ui) {
                    //$("body").css("overflow", "auto");
                    var ctrl = $(ui.draggable).closest("td")[0];
                    var pid = 0;
                    var trIndx = 0;
                    var dd = 0;
                    if ($(this).children().length < 1) {
                        if ($(ui.draggable).closest("tr").is("[tr_index]")) {
                            pid = $(ui.draggable).attr("pid");
                            trIndx = parseInt($(ui.draggable).closest("tr").attr("tr_index"));
                            dd = $(ui.draggable).closest("td").attr("dd");
                        }
                        $(ui.draggable).css({ top: 0, left: 0, background: "transparent", width: "100%", "text-align": "left", "border": "none", "font-size": "7.9pt", "padding": "0px" }).appendTo(this);
                        $(this).find("div.clsdivdraggable").find("div").eq(1).hide();
                        $(this).find("div.clsdivdraggable").find("div").eq(2).hide();
                        $(this).attr("flgBlocked", "1");
                        $(this).attr("flgLocked", "0");
                        fnChangeAvailablity(this);
                        if (pid > 0) {
                            fnChangeAvailablityUncheck(ctrl, trIndx, pid, dd);
                        }

                    } else {
                        var pid = $(ui.draggable).attr("pid");
                        var trIndx = parseInt($(ui.draggable).closest("tr").attr("tr_index"));
                        var dd = $(ui.draggable).closest("td").attr("dd");
                        var ctrl = $(ui.draggable).closest("td")[0];
                        if ($(this).find("div[pid=" + pid + "]").length == 0) {
                            if ($(".clsmaindivdroppable1").find("div[pid=" + $(this).children().eq(0).attr("pid") + "]").length == 0) {
                                $(this).children().eq(0).removeAttr("style").appendTo($(".clsmaindivdroppable1"));
                                $(ui.draggable).css({ top: 0, left: 0, background: "transparent", width: "100%", "text-align": "left", "border": "none", "font-size": "7.9pt", "padding": "0px" }).appendTo(this);
                                $(this).attr("flgBlocked", "1");
                                $(this).attr("flgLocked", "0");

                                if (pid > 0) {
                                    fnChangeAvailablityUncheck(ctrl, trIndx, pid, dd);
                                }
                            } else {
                                $(this).children().eq(0).remove();
                            }
                        }
                    }
                }
            });

            $(".clsmaindivdroppable1").droppable({
                over: function (event, ui) {
                    //var $this = $(this);
                },
                hoverClass: "ui-state-hover1",
                drop: function (event, ui) {
                    var ctrl = $(ui.draggable).closest("td")[0];
                    var pid = $(ui.draggable).attr("pid");
                    var dd = $(ui.draggable).closest("td").attr("dd");
                    var trIndx = parseInt($(ui.draggable).closest("tr").attr("tr_index"));
                    if ($(ui.draggable).parents(".clsmaindivdroppable1").length == 0) {
                        $(ui.draggable).css({ top: 0, left: 0, "display": "table", "width": "100%" }).appendTo(this);
                        $(this).find("div.clsdivdraggable").find("div").eq(1).css("display", "table-cell");
                        $(this).find("div.clsdivdraggable").find("div").eq(2).css("display", "table-cell");
                        if (pid > 0) {
                            fnChangeAvailablityUncheck(ctrl, trIndx, pid, dd);
                        }
                    } else {
                        return false;
                    }
                }
            });
        }
        function fnUpdateDateTime() {
            var d = new Date();
            var strdate = d.getDate() + " " + MonthArr[d.getMonth()] + ", " + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
            $("#divDateTime").html(strdate);
        }

        function fnSave() {
            var ArrDataSaving = []; var ArrDataMails = [];
            $("#ConatntMatter_divStatus").find("div.clsdivdraggable").each(function () {
                if ($(this).closest("td").attr("flgLocked") == 0 && $(this).closest("td").attr("flgBlocked") == 1) {
                    ArrDataSaving.push({ ParticipantAssessorMappingId: $(this).attr("pid"), AssesseMeetingLink: "", AssessorMeetingLink: "", MeetingSlotTime: $(this).closest("td").attr("hr") + ":" + $(this).closest("td").attr("mm"), MeetingStartTime: $(this).closest("td").attr("dd"), MeetingId: $(this).attr("MeetingId"), flgCreated: 0, MeetingStatus: "", AssessorMail: $(this).attr("AssessorMail"), AssessorName: $(this).attr("AssessorName"), AssesseeMail: $(this).attr("AssesseeMail"), AssesseeName: $(this).attr("AssesseeName"), AssessorSecondaryMailID: $(this).attr("AssessorSecondaryMail"), AssesseeSecondaryMailID: $(this).attr("AssesseeSecondaryMail"), BEIUserName: $(this).attr("BEIUserName"), BEIPwd: $(this).attr("BEIPwd") });
                }
            });
            if (ArrDataSaving.length == 0) {
                alert("No Meeting Schedule!")
                return false;
            }
            $("#dvFadeForProcessing").show();
            PageMethods.fnSave(ArrDataSaving, $("#ConatntMatter_hdnLogin").val(), fnSave_Success, fnFailed);
        }

        function fnSave_Success(result) {
            $("#dvFadeForProcessing").hide();
            if (result.split("|")[0] == "0") {
                var tbl = $.parseJSON(result.split("|")[1]);
                var strHTML = "";
                if (tbl.length > 0) {
                    var style = "border-left: 1px solid #A0A0A0; border-bottom: 1px solid #A0A0A0;font-family:arial narrow;font-size:9pt;";
                    strHTML += "Kindly find below Feedback Schedule status for each participant.</br> If there is an error against any participant to schedule a Feedback meeting,Kindly try again for the highlighted participant to schedule a Feedback meeting</br></br>";
                    strHTML += ("<table cellpadding='2' cellspacing='0' style='font-family:arial narrow;font-size:8.5pt;border-right: 1px solid #A0A0A0; border-top: 1px solid #A0A0A0;text-align:center;width:100%'><thead>");
                    strHTML += ("<tr bgcolor='#26a6e7'>");
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Sr.No</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Participant Name</th>";
                    strHTML += "<th  style='" + style + ";color:#fff;text-align:left;padding:3px'>Meeting Status</th>";
                    strHTML += ("</tr></thead><tbody>");
                    for (var i in tbl) {
                        var ParticipantAssessorMappingId = tbl[i]["ParticipantAssessorMappingId"];
                        var MeetingStatus = tbl[i]["MeetingStatus"];
                        var flgCreated = tbl[i]["flgCreated"];
                        var ParticipantName = tbl[i]["AssesseeName"];
                        var strColor = "";
                        if (flgCreated == 1) {
                            var divs = $("#ConatntMatter_divStatus div.clsdivdraggable").filter("div[pid=" + ParticipantAssessorMappingId + "]");
                            if (divs.length > 0) {
                                $(divs).closest("td").removeAttr("iden");
                                $(divs).css("cursor", "default");
                                $(divs).closest("td").css("cursor", "default");
                                $(divs).closest("td").attr("flgLocked", "1");
                                $(divs).closest("td").attr("flgBlocked", "1");
                                $(divs).closest("td").addClass("clsBlockAndMappedFeedback");
                                $(divs).closest("td").droppable("option", "disabled", true);
                                $(divs).draggable("option", "disabled", true);
                            }
                        } else {
                            strColor = "bgcolor='#ffbbbb'";
                        }
                        strHTML += ("<tr " + strColor + ">");
                        strHTML += "<td  style='" + style + ";text-align:center;padding:3px'>" + (eval(i) + 1) + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + ParticipantName + "</td>";
                        strHTML += "<td  style='" + style + ";text-align:left;padding:3px'>" + MeetingStatus + "</td>";
                        strHTML += ("</tr>");
                    }
                    strHTML += ("</tbody></table>");
                }
                $("#dvAlert")[0].innerHTML = strHTML;
                $("#dvAlert").dialog({
                    title: "Alert!",
                    modal: true,
                    width: "750",
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div id="divDateTime" style="text-align: right; padding-bottom: 3px; font-size: 12px; font-weight: bold; margin-top: -12px;"></div>
    <div id="divLegend" style="padding-bottom: 3px;">
        
         <div class="row">
             <div class="col-sm-6">
             <table style="width: 100%">
            <tr>
                <td class="clsPast clslegend"></td>
                <td class="clslegendlbl" style="width: 20%;">Past / Holiday</td>
                <td class="clsBlockAndMapped clslegend"></td>
                <td class="clslegendlbl" style="width: 25%;">Submitted BEI Slot</td>
                <td class="clsBlockAndMappedFeedback clslegend"></td>
                <td class="clslegendlbl" style="width: 30%;">Submitted Feedback Slot</td>
            </tr>
        </table>
                 </div>
        <label for="ac" style="width:9%;font-weight:bold">Select Batch :</label>
        <div class="col-sm-4">
            <asp:DropDownList runat="server" ID="ddlCycle" CssClass="form-control" style="height:auto;padding:0" onchange="fnGetDetail()" >
            </asp:DropDownList>
        </div>
        <div class="col-2 offset-1">
        </div>
    </div>
    </div>
    <div class="row mb-1">
        <div id="divStatus" runat="server" style="overflow-y: auto;" class="col-8 pr-0"></div>
        <div id="divAssesseContainer" runat="server" style="overflow-y: auto;" class="col-4 pl-0">
            <table style="width: 100%">
                <tr>
                    <th id="thPartiId">Participant List</th>
                </tr>
                <tr>
                    <td class="clsmaindivdroppable1" style="vertical-align: top; text-align: left; padding-left: 5px;height:430px"></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="divButton" style="text-align: center;">
        <a href="#" onclick="fnSave()" style="padding: 4px 20px;" class="btns btn-submit">Submit</a>
        <a href="frmParticipantFeedbackStatus.aspx" style="padding: 4px 20px;" class="btns btn-submit">Back</a>

    </div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvFadeForProcessing" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnSlotBufferNo" Value="2" runat="server" />
</asp:Content>
