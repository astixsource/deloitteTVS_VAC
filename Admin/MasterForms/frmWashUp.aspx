<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmWashUp.aspx.cs" Inherits="Mapping" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
 <link href="../../CSS/jquery-te-1.4.0.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-te-1.4.0.min.js"></script>
    <script>
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        function whichButton(event) {
            if (event.button == 2)//RIGHT CLICK
            {
                alert("Not Allow Right Click!");
            }
        }
        function noCTRL(e) {
            var code = (document.all) ? event.keyCode : e.which;
            var msg = "Sorry, this functionality is disabled.";
            if (parseInt(code) == 17) //CTRL
            {
                alert(msg);
                window.event.returnValue = false;
            }
        }
        function isNumberKeyNotDecimal(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
        function Tooltip(container) {
            // Tooltip only Text
            $(container).hover(function () {
                // Hover over code
                var title = $(this).attr('title');
                if (title != '' && title != undefined) {
                    $(this).data('tipText', title).removeAttr('title');
                    $('<p class="customtooltip"></p>')
                        .html(title)
                        .appendTo('body')
                        .fadeIn('slow');
                }
            }, function () {
                // Hover out code
                $(this).attr('title', $(this).data('tipText'));
                $('.customtooltip').remove();
            }).mousemove(function (e) {
                var mousex = e.pageX + 20; //Get X coordinates
                var mousey = e.pageY + 10; //Get Y coordinates
                $('.customtooltip')
                    .css({ top: mousey, left: mousex })
            });
        }
    </script>
    <script>
        $(document).ready(function () {
            $("#btnSubmit,#btnSave").hide();
            $("#dvloader").hide();
            document.getElementById("theTime").innerHTML = "";
            if ($("#ConatntMatter_hdnflgSave").val() == "0") {
                $("#btnSubmit").val("Final Submit");
            }

            fnGetMapping();
        });

        function fnParticipant(ctrl) {
            $("#dvEmp").html('');
            $("#dvCompetencyCriteria").html('');
            
            $("#dvScore").html('');
            $("#dvExcersiceBlock").hide();
            $("#txtCmptncyComments").val("");
            $("#btnSubmit,#btnSave").hide();
            $("#ConatntMatter_dvBtns").find('a.active').removeClass('active');
            $(ctrl).addClass('active');
            $("#ConatntMatter_hdnSeqNo").val($(ctrl).attr("ind"));
            $("#ConatntMatter_ddlCompetency").val('0');
            $("#dvExcersice").html('');
            if ($(ctrl).attr("ind") == "0") {
                $("#dvExcersiceBlock").hide();
            }
            else {
                $("#dvExcersiceBlock").show();
            }

            fnGetMapping();
        }
        var MeetingId = 0; var MeetingId = 0; var BEIUsername = ""; var BEIPassword = ""; var MeetingLink = "";
        function fnChangeBatch() {
            document.getElementById("theTime").innerHTML = "";
            var batch = $("#ConatntMatter_ddlBatch").val();
            MeetingId = $("#ConatntMatter_ddlBatch option:selected").attr("MeetingId");
            var NumberOfParticipants = $("#ConatntMatter_ddlBatch option:selected").attr("NumberOfParticipants");
            BEIUsername = $("#ConatntMatter_ddlBatch option:selected").attr("BEIUsername");
            BEIPassword = $("#ConatntMatter_ddlBatch option:selected").attr("BEIPassword");
            MeetingLink = $("#ConatntMatter_ddlBatch option:selected").attr("MeetingLink");
            $("#btnWashup").hide();
            $("#btnWashup1").hide();

            if (batch != 0) {
                //document.getElementById("theTime").innerHTML = "Meeting to start";
                $("#btnWashup").show();
                $("#btnWashup1").show();
                //$("#ConatntMatter_hdnCounter").val($("#ConatntMatter_ddlBatch option:selected").attr("remainingsec"));

            }
            $("#ConatntMatter_hdnSeqNo").val("0");
            var sbbtns = "";
            sbbtns += ("<a href='#' class='btn btn-primary btn-sm active' style='padding:.10rem 1.0rem !important;' ind='0' onclick='fnParticipant(this);'>Compiled</a>");
            for (var i = 0; i < NumberOfParticipants; i++) {
                sbbtns += ("<a href='#' class='btn btn-primary btn-sm' ind='" + (i + 1) + "' style='margin-left:15px;padding:.10rem 1.0rem !important;' onclick='fnParticipant(this);'>P" + (i + 1) + "</a>");
            }
            $("#ConatntMatter_dvBtns").html(sbbtns);

            fnGetMapping();
        }

        function fnCopyMeetingLink() {

            if (MeetingId == "" || MeetingId == "0") {
                alert("Meeting Not Available!");
                return false;
            }

            var input = document.body.appendChild(document.createElement("input"));
            input.value = MeetingLink;
            input.focus();
            input.select();
            document.execCommand('copy');
            input.parentNode.removeChild(input);
            alert("Link copied");
            //$("#dvAlert")[0].innerHTML = "Link copied";
            //$("#dvAlert").dialog({
            //    title:"Alert!",
            //    modal: true,
            //    close: function () {
            //        $(this).html("");
            //        $(this).dialog('destroy');
            //    },
            //    buttons: {
            //        "OK": function () {
            //            $(this).dialog('close');
            //        }
            //    }
            //})
        }

        function fnGetMapping() {
            var batch = $("#ConatntMatter_ddlBatch").val();
            var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
            $("#dvShowHideCol").hide();
            $("#dvShowHideCol label").hide();
            $("#dvloader").show();
            $("#txtCmptncyComments").val("");
            SeqNo = SeqNo == "" ? 0 : SeqNo;
            
            $("#ConatntMatter_ddlExercises").val(0);
            PageMethods.fnGetEntries(batch, SeqNo, fnGetEntries_pass, fnfail, SeqNo);

        }
        function fnGetEntries_pass(res, SeqNo) {
            $("#dvEmp").html('');
            $("#dvScore").html('');
            $("#dvCompetencyCriteria").html('');
            $("#btnSubmit,#btnSave").hide();
            $("#txtCmptncyComments").val("");
            $("#txtCmptncyComments").prop("disabled", true);
            $(".clscompcoments").hide();
            if (res.split("|")[0] == "0") {
                $("#dvEmp").html(res.split("|")[1]);
                $("#dvCompetencyCriteria").html(res.split("|")[7]);
                $("#dvScore").html(res.split("|")[2]);
                $("#ConatntMatter_hdnEmp").val(res.split("|")[3]);
                if (SeqNo > 0) {
                    $("#txtCmptncyComments").val(res.split("|")[6]);
                }
                flgSubmit = res.split("|")[5];
                if (res.split("|")[1] == "" && res.split("|")[1] == "") {
                    $("#dvScore").css("height", "200px");
                    $("#dvScore").html("No Record Found !");
                }
                else {
                    $("#dvScore").css("height", "auto");
                    if (res.split("|")[1] != "" && SeqNo != "0") {
                        $("#btnSubmit,#btnSave").show();
                    }
                }
               

                if ($("#tblEmp_Compiled").length > 0) {
                    $("#dvShowHideCol").show();
                    $("#dvShowHideCol label").show();
                    $("#btnRecalculateScore").show();
                }
                //alert(flgSubmit);
                if (flgSubmit == 2) {
                    $("#btnWashup1").hide();
                    $("#btnSubmit,#btnSave").hide();
                    $("#theTime").hide();
                    $("#txtCmptncyComments").prop("disabled", true);
                    $(".clscompcoments").eq(1).hide();
                    $("#btnRecalculateScore").hide();
                }

                if ($("#tblEmp").length > 0) {
                    $("#btnRecalculateScore").hide();
                    $("#dvShowHideCol").show();
                    $("#dvShowHideCol label").hide();
                    $(".clscompcoments").show();
                    if (flgSubmit == 0) {
                        $("#txtCmptncyComments").prop("disabled", false);
                    } else {
                        $(".clscompcoments").eq(1).hide();
                    }
                }

                fnInitialize(SeqNo);

                if (SeqNo != "0") {
                    $("td.clsovscore").html($("#tblEmp").find("td[excersiceid='99'][flgedit='0']").html())
                    $("#dvScore").removeClass("col-12").addClass("col-6");
                    if (res.split("|")[4] != "") {
                        //$("#tblEmp").find("th").eq(0).html("<img src='../../Files/" + res.split("|")[4] + "' style='width: auto; height: 80px; cursor:pointer;' onclick='fnShowImg(this);'/>");
                    }
                    else {
                        //$("#tblEmp").find("th").eq(0).html("<img src='../../Files/person.png' style='width: auto; height: 80px;'/>");
                    }
                } else {
                    $("#dvScore").removeClass("col-6").addClass("col-12");
                }
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request !\nError:" + res.split("|")[1]);
            }
            $("#dvloader").hide();
        }

        function fnShowHideCol(sender) {
            if ($(sender).val() == 1) {
                if ($(sender).is(":checked")) {
                    $("#tblEmp_Compiled").find("th.clsCol-4,th.clsCol-5,th.clsCol-6,th.clsCol-7,td.cls-4,td.cls-5,td.cls-6,td.cls-7").css("display", "table-cell");
                } else {
                    $("#tblEmp_Compiled").find("th.clsCol-4,th.clsCol-5,th.clsCol-6,th.clsCol-7,td.cls-4,td.cls-5,td.cls-6,td.cls-7").hide();
                }
            }
            else if ($(sender).val() == 2) {
                if ($(sender).is(":checked")) {
                    $("#tblEmp_Compiled").find("th.clsCol-8,th.clsCol-9,th.clsCol-10,td.cls-8,td.cls-9,td.cls-10").css("display", "table-cell");
                } else {
                    $("#tblEmp_Compiled").find("th.clsCol-8,th.clsCol-9,th.clsCol-10,td.cls-8,td.cls-9,td.cls-10").hide();
                }
            }
            else if ($(sender).val() == 3) {
                if ($(sender).is(":checked")) {
                    $("#tblEmp_Compiled").find("th.clsCol-11,th.clsCol-12,th.clsCol-13,td.cls-11,td.cls-12,td.cls-13").css("display", "table-cell");
                } else {
                    $("#tblEmp_Compiled").find("th.clsCol-11,th.clsCol-12,th.clsCol-13,td.cls-11,td.cls-12,td.cls-13").hide();
                }
            }
        }
        function fnInitialize(SeqNo) {
            $("#tblEmp").find("td[flgedit='1']").each(function () {
                if ($(this).html() != "NA") {
                    var score = $(this).html();
                    var flgAOSAODColor = $(this).attr("flgAOSAODColor");
                    if (flgAOSAODColor == 1)
                        $(this).addClass("cls-score-green");
                    else if (flgAOSAODColor == 2)
                        $(this).addClass("cls-score-yellow");
                    else if (flgAOSAODColor == 3)
                        $(this).addClass("cls-score-red");

                    if (flgSubmit != 2) {
                        $(this).html("<i class='fa fa-minus-circle pointer clstoremove' onclick='fnMinusScore(this);'></i><span class='clsScore'>" + score + "</span><i class='fa fa-plus-circle pointer clstoremove' onclick='fnAddScore(this);'></i>");
                    }
                }
                else {
                    $(this).addClass("cls-bg-gray");
                    $(this).html("");
                }
            });


            $("#tblEmp").find("td[flgedit='0'][excersiceid=-2]").each(function () {
                if ($(this).html() != "NA") {
                    var CompetencyId = $(this).attr("competencyid");
                    var flgAOSAODColor = $(this).attr("flgAOSAODColor");
                    var score = $(this).html();
                    if (flgAOSAODColor == 1) {
                        $(this).addClass("cls-score-green");
                        $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-green");
                    }
                    else if (flgAOSAODColor == 2) {
                        $(this).addClass("cls-score-yellow");
                        $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-yellow");
                    }
                    else if (flgAOSAODColor == 3) {
                        $(this).addClass("cls-score-red");
                        $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-red");
                    }
                    if (flgSubmit != 2) {
                         $(this).html("<i class='fa fa-minus-circle pointer clstoremove' onclick='fnMinusScore(this);'></i><span class='clsScore'>" + score + "</span><i class='fa fa-plus-circle pointer clstoremove' onclick='fnAddScore(this);'></i>");
                    }
                }
                else {
                    $(this).addClass("cls-bg-gray");
                    $(this).html("");
                }
            });
            var cls = "cls-bg-gray";
            $("#tblEmp").find("td[flgedit='0'][excersiceid=99][flgScoreEnable=1]").each(function () {

                if ($(this).html() != "NA") {
                    var Score = $(this).text();
                    if (parseFloat(Score) <= 2.5) {
                        $(this).addClass("cls-score-red");
                        cls = "cls-score-red";
                    }
                    else if (parseFloat(Score) >= 2.51 && parseFloat(Score) <= 2.99) {
                        $(this).addClass("cls-score-green");
                        cls = "cls-score-green";
                    }
                    else if (parseFloat(Score) >= 3 && parseFloat(Score) <= 5) {
                        $(this).addClass("cls-score-darkgreen");
                        cls = "cls-score-darkgreen";
                    }
                }
                else {
                    $(this).addClass("cls-bg-gray");
                    $(this).html("");
                }
            });

            $("#tblEmp").find("td.cls-4").each(function () {
                var flgAOSAODColor = $(this).attr("flgAOSAODColor");
                if (flgAOSAODColor == 1) {
                    $(this).addClass("cls-score-green");
                }
                else if (flgAOSAODColor == 2) {
                    $(this).addClass("cls-score-yellow");
                }
                else if (flgAOSAODColor == 3) {
                    $(this).addClass("cls-score-red");
                }
                //if (SeqNo > 0 && flgSubmit != 2) {
                //    $(this).html("<span>" + $(this).html() + "</span><span style='font-size:10pt;margin-left:5px;cursor:pointer' class='clstoremove' onclick='fnShowColorPopUp(this)'>&#128678;</span>")
                //}
            });

            $("#tblEmp_Compiled").find("th.clsCol-4,th.clsCol-5,th.clsCol-6,th.clsCol-7,td.cls-4,td.cls-5,td.cls-6,td.cls-7").hide();
            $("#tblEmp_Compiled").find("th.clsCol-8,th.clsCol-9,th.clsCol-10,td.cls-8,td.cls-9,td.cls-10").hide();
           // $("#tblEmp_Compiled").find("th.clsCol-11,th.clsCol-12,th.clsCol-13,td.cls-11,td.cls-12,td.cls-13").hide();
            $("#tblEmp_Compiled").find("td[empnodeid=-1]").eq(2).html("Group Average");

            $("#tblEmp_Compiled").find("td[flgedit='0'][excersiceid!=99]").each(function () {
                if ($(this).html() != "NA") {
                    var flgAOSAODColor = $(this).attr("flgAOSAODColor");
                    if (flgAOSAODColor == 1) {
                        $(this).addClass("cls-score-green");
                        $(this).css("background-color", "#D2F4DC");
                    }
                    else if (flgAOSAODColor == 2) {
                        $(this).addClass("cls-score-yellow");
                        $(this).css("background-color", "#FFFACC");
                    }
                    else if (flgAOSAODColor == 3) {
                        $(this).addClass("cls-score-red");
                        $(this).css("background-color", "#ffd9d7");
                    }
                }
                else {
                    $(this).addClass("cls-bg-gray");
                    $(this).html("");
                }
            });


            for (var i = 0; i < $("#tblEmp_Compiled tbody tr").length - 4; i++) {
                var $Cells = $("#tblEmp_Compiled tbody tr").eq(i).find("td[flgedit='0'][excersiceid='0'][competencyid='0']")



                //RLG
                if ($Cells.eq(1).html() != "NA") {
                    var flgAOSAODColor = $Cells.eq(1).text();
                    if (flgAOSAODColor == 1) {
                        $Cells.eq(1).addClass("cls-score-darkgreen");
                        $Cells.eq(1).css("background-color", "#84e19f");
                    }
                    else if (flgAOSAODColor == 2) {
                        $Cells.eq(1).addClass("cls-score-green");
                        $Cells.eq(1).css("background-color", "#D2F4DC");
                    }
                    else if (flgAOSAODColor == 3) {
                        $Cells.eq(1).addClass("cls-score-red");
                        $Cells.eq(1).css("background-color", "#ffd9d7");
                    }

                    $Cells.eq(1).html("");
                }
                else {
                    $Cells.eq(1).addClass("cls-bg-gray");
                    $Cells.eq(1).html("");
                }

            }

            /*
            $("#tblEmp_Compiled").find("td[flgedit='0'][excersiceid=99]").each(function () {
                if ($(this).html() != "NA") {
                    var flgAOSAODColor = $(this).attr("flgAOSAODColor");
                    if (flgAOSAODColor == 1) {
                        $(this).addClass("cls-score-darkgreen");
                        $(this).css("background-color", "#84e19f");
                    }
                    else if (flgAOSAODColor == 2) {
                        $(this).addClass("cls-score-green");
                        $(this).css("background-color", "#D2F4DC");
                    }
                    else if (flgAOSAODColor == 3) {
                        $(this).addClass("cls-score-red");
                        $(this).css("background-color", "#ffd9d7");
                    }

                }
                else {
                    $(this).addClass("cls-bg-gray");
                    $(this).html("");
                }
            });
            */


            $("#tblEmp_Compiled").find("td[empnodeid=-1]").css({
                "background-color": "#000000",
                "border-color": "#000000",
                "font-weight": "bold"
            });

            $("#tblEmp_Compiled").find("th").css("background", "#a5a5a5");
            $("#tblEmp_Compiled").find("th[competencyid=8],th[competencyid=3]").css({
                "background-color": "#376091",
                "color": "#ffffff",
            });

            $("#tblScore th,#tblExerciseWiseAvgScore th,#tblAssessorMstr th").css({
                "background-color": "#ffc000",
            });


            //$("#tblEmp_Compiled").find("td[empnodeid=-1]").css("border-color", "#000000");
            //$("#tblEmp_Compiled").find("td[empnodeid=-1]").css("border-color", "#000000");
            $("#tblEmp_Compiled").find("td[empnodeid=-1]").each(function () {
                if ($(this).text() != "") {
                    if ($(this).text() == "Group Average") {
                        $(this).css({
                            "color": "#ffffff",
                        })
                    } else {
                        $(this).css({
                            "background-color": "#ffff00",
                        })
                    }
                }

            });



            $("#tblScore").find("tbody").eq(0).find("tr").each(function () {
                var color = $(this).attr("color");
                var competencyid = $(this).attr("competencyid");
                if ($(this).find("td").eq(1).html() != "NA") {
                    //var flgAOSAODColor = $(this).find("td").eq(1).attr("flgAOSAODColor");
                    //if (flgAOSAODColor == 1) {
                    //    $(this).find("td").eq(1).addClass("cls-score-green");
                    //}
                    //else if (flgAOSAODColor == 2) {
                    //    $(this).find("td").eq(1).addClass("cls-score-yellow");
                    //}
                    //else if (flgAOSAODColor == 3) {
                    //    $(this).find("td").eq(1).addClass("cls-score-red");
                    //}



                    //if (SeqNo > 0 &&  flgSubmit!=2 && parseInt(competencyid) != 3 && parseInt(competencyid) != 8) {
                    //    $(this).find("td").eq(1).html("<span>" + $(this).find("td").eq(1).html() + "</span><span style='font-size:10pt;margin-left:5px;cursor:pointer' onclick='fnShowColorPopUp(this)'>&#128678;</span>")
                    //} else {
                    $(this).find("td").eq(1).html("<span>" + $(this).find("td").eq(1).html() + "</span>");
                    //}
                }
                else {
                    $(this).find("td").eq(1).addClass("cls-bg-gray");
                    $(this).find("td").eq(1).html("");
                }
                if ($(this).find("td").eq(2).html() == "NA") {
                    $(this).find("td").eq(2).addClass("cls-bg-gray");
                    $(this).find("td").eq(2).html("");
                }
                //if (competencyid == 8 || competencyid == 3) {
                //    $("#tblEmp_Compiled").find("th[competencyid='" + competencyid + "']").css({
                //        "background": "#" + color,
                //        "color":"#ffffff"
                //    });
                //} else {
                //    $("#tblEmp_Compiled").find("th[competencyid='" + competencyid + "']").css("background", "#" + color);
                //}
                //$("#tblEmp").find("th[competencyid='" + competencyid + "']").css("background", "#" + color);
            });

            if (SeqNo != "0") {
                $("#tblScore").find("tbody").append("<tr competencyid='0' style='font-weight:700;'><td class='cls-1' style='border-color: transparent; text-align:right;'>Overall Average</td><td class='cls-2 " + cls + "' style='border: none;'>" + fnOverallAvg() + "</td><td class='cls-3' style='border-color: transparent;'></td></tr>");
            }
        }

        function fnAddScore(ctrl) {
            var CompetencyId = $(ctrl).closest("td").attr("CompetencyId");
            var EmpNodeId = $(ctrl).closest("td").attr("EmpNodeId");
            if (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) <= 5) {
                var incremental = $(ctrl).closest("td").find("span").eq(0).html() == "0.00" ? 1 : 0.5;
                var score = (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) + incremental).toFixed(2);
                $(ctrl).closest("td").find("span").eq(0).html(score);
                //$(ctrl).closest("td").removeClass("cls-score-red");
                //$(ctrl).closest("td").removeClass("cls-score-yellow");
                //$(ctrl).closest("td").removeClass("cls-score-green");
                //if (parseFloat(score).toFixed(2) < 1.5)
                //    $(ctrl).closest("td").addClass("cls-score-red");
                //else if (parseFloat(score).toFixed(2) >= 1.5 && parseFloat(score).toFixed(2) <= 2.49)
                //    $(ctrl).closest("td").addClass("cls-score-yellow");
                //else
                //    $(ctrl).closest("td").addClass("cls-score-green");

                fnSetColor(ctrl, CompetencyId, EmpNodeId);
            } else {
                alert("Scoring not allowed above 5 !");
            }
        }
        function fnMinusScore(ctrl) {
            var CompetencyId = $(ctrl).closest("td").attr("CompetencyId");
            var EmpNodeId = $(ctrl).closest("td").attr("EmpNodeId");
            if (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) > 0) {
                var incremental = $(ctrl).closest("td").find("span").eq(0).html() == "1.00" ? 1 : 0.5;
                var score = (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) - incremental).toFixed(2);
                $(ctrl).closest("td").find("span").eq(0).html(score);
                //$(ctrl).closest("td").removeClass("cls-score-red");
                //$(ctrl).closest("td").removeClass("cls-score-yellow");
                //$(ctrl).closest("td").removeClass("cls-score-green");
                //if (parseFloat(score).toFixed(2) < 1.5)
                //    $(ctrl).closest("td").addClass("cls-score-red");
                //else if (parseFloat(score).toFixed(2) >= 1.5 && parseFloat(score).toFixed(2) <= 2.49)
                //    $(ctrl).closest("td").addClass("cls-score-yellow");
                //else
                //    $(ctrl).closest("td").addClass("cls-score-green");
                fnSetColor(ctrl, CompetencyId, EmpNodeId)

            }
            else {
                alert("Scoring not allowed below 0 !");
            }
        }

        function fnSetColor(ctrl, CompetencyId, EmpNodeId) {
            var totalScore = 0.00, cntr = 0;

            $(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][flgEdit='1']").each(function () {
                if ($(this).html() != "" && $(this).attr("excersiceid") != "99") {
                    cntr++;
                    totalScore += $(this).find("span").length > 0 ? parseFloat($(this).find("span").eq(0).html()) : parseFloat($(this).html());
                }
            });

            var AvgScore1 = (parseFloat(totalScore / cntr)).toFixed(2);
            var AvgScore = parseFloat(AvgScore1).toFixed(2);
            //if (parseFloat(AvgScore1).toFixed(2) >= 4.5)
            //    AvgScore = 5;
            //else if (parseFloat(AvgScore1).toFixed(2) >= 3.5 && parseFloat(AvgScore).toFixed(2) < 4.5)
            //    AvgScore = 4;
            //else if (parseFloat(AvgScore1).toFixed(2) > 2.5 && parseFloat(AvgScore).toFixed(2) < 3.5)
            //    AvgScore = 3;
            //else if (parseFloat(AvgScore1).toFixed(2) >= 1.5 && parseFloat(AvgScore).toFixed(2) <= 2.5)
            //    AvgScore = 2;
            //else
            //    AvgScore = 1;

            $(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][excersiceid='-1']").html(AvgScore1);
            //$(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][excersiceid='-2']").html(AvgScore);
            //$(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][excersiceid='-2']").removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green");
            $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green");
            if (AvgScore <= 2) {
                $(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][excersiceid='-2']").addClass("cls-score-red");
                $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-red");
            }
            else if (AvgScore == 3) {
                $(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][excersiceid='-2']").addClass("cls-score-yellow");
                $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-yellow");
            }
            else {
                $(ctrl).closest("table").find("td[CompetencyId='" + CompetencyId + "'][EmpNodeId='" + EmpNodeId + "'][excersiceid='-2']").addClass("cls-score-green");
                $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-green");
            }

            $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).find("span").eq(0).html(AvgScore);

            var totalScore = 0.00, cntr = 0;
            $(ctrl).closest("table").find("td[EmpNodeId='" + EmpNodeId + "'][excersiceid='-1'][flgScoreEnable=1]").each(function () {
                if ($(this).html() != "") {
                    cntr++;
                    totalScore += $(this).find("span").length > 0 ? parseFloat($(this).find("span").eq(0).html()) : parseFloat($(this).html());
                }
            });
            var AvgScore1 = (parseFloat(totalScore / cntr)).toFixed(2);
            $(ctrl).closest("table").find("td[EmpNodeId='" + EmpNodeId + "'][excersiceid='99'][flgScoreEnable=1]").html(AvgScore1);
            $(".clsovscore").html(AvgScore1);
            $(ctrl).closest("table").find("td[EmpNodeId='" + EmpNodeId + "'][excersiceid='99'][flgScoreEnable=1]").removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green").removeClass("cls-score-darkgreen");
            $("#tblScore").find("tr[CompetencyId='0']").find("td").eq(1).removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green").removeClass("cls-score-darkgreen");
            if (parseFloat(AvgScore1).toFixed(2) <= 2.5) {
                $(ctrl).closest("table").find("td[EmpNodeId='" + EmpNodeId + "'][excersiceid='99'][flgScoreEnable=1]").addClass("cls-score-red");
                $("#tblScore").find("tr[CompetencyId='0']").find("td").eq(1).removeClass("cls-score-red").addClass("cls-score-red");
            }
            else if (parseFloat(AvgScore1).toFixed(2) >= 2.51 && parseFloat(AvgScore1).toFixed(2) <= 2.99) {
                $(ctrl).closest("table").find("td[EmpNodeId='" + EmpNodeId + "'][excersiceid='99'][flgScoreEnable=1]").addClass("cls-score-green");
                $("#tblScore").find("tr[CompetencyId='0']").find("td").eq(1).removeClass("cls-score-green").addClass("cls-score-green");
            }
            else {
                $(ctrl).closest("table").find("td[EmpNodeId='" + EmpNodeId + "'][excersiceid='99'][flgScoreEnable=1]").addClass("cls-score-darkgreen");
                $("#tblScore").find("tr[CompetencyId='0']").find("td").eq(1).removeClass("cls-score-red").addClass("cls-score-green");
            }



            //$("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).removeClass("cls-score-red");
            //$("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).removeClass("cls-score-yellow");
            //$("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).removeClass("cls-score-green");
            //if (parseFloat(AvgScore).toFixed(2) < 1.5)
            //    $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-red");
            //else if (parseFloat(AvgScore).toFixed(2) >= 1.5 && parseFloat(AvgScore).toFixed(2) <= 2.49)
            //    $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-yellow");
            //else
            //    $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).addClass("cls-score-green");

           // $("#tblScore").find("tr[CompetencyId='0']").find("td").eq(1).html(fnOverallAvg());//commented by mk 10apr2023


            fnSavecompetencyWise(CompetencyId);
        }


        function fnShowColorPopUp(sender) {
            var CompetencyId = $(sender).closest("td").attr("CompetencyId");
            var flgAOSAODColor = $(sender).closest("td").attr("flgAOSAODColor");
            var str = "<div style='margin:5px'>";
            str += "<table style='margin:5px' >";
            str += "<tr>";
            str += "<td style='border:3px solid #ffffff;'><input type='radio' name='rdoaos' value='1' " + (flgAOSAODColor == 1 ? "checked='checked'" : "") + " color='cls-score-green'/></td><td style='height:30px;border:3px solid #ffffff;' class='cls-score-green'>Area Of Strength</td>";
            str += "</tr>";
            str += "<tr>";
            str += "<td style='border:3px solid #ffffff;'><input type='radio' name='rdoaos' value='2' " + (flgAOSAODColor == 2 ? "checked='checked'" : "") + " color='cls-score-yellow'/></td><td style='height:30px;border:3px solid #ffffff;' class='cls-score-yellow'>Area Of Proficiency</td>";
            str += "</tr>";

            str += "<tr>";
            str += "<td style='border:3px solid #ffffff;'><input type='radio' name='rdoaos' value='3' " + (flgAOSAODColor == 3 ? "checked='checked'" : "") + " color='cls-score-red'/></td><td style='height:30px;border:3px solid #ffffff;' class='cls-score-red'>Area Of Development</td>";
            str += "</tr>";

            str += "</table>";
            str += "</div>";
            $("#dvDialog")[0].innerHTML = str;
            $("#dvDialog").dialog({
                title: "Colors:" + $(sender).closest("td").find("span").eq(0).html(),
                modal: true,
                close: function () {
                    $(this).dialog('destroy');
                    $("#dvDialog").html("");
                },
                buttons: {
                    "OK": function () {
                        if ($("input[name='rdoaos']:checked").length == 0) {
                            alert("Select Color First!");
                            return false;
                        }

                        var scolor = $("input[name='rdoaos']:checked").attr("color");

                        // $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green").addClass(scolor);
                        // $(sender).closest("td").attr("color", scolor);
                        // $("#tblScore").find("tr[CompetencyId='" + CompetencyId + "']").find("td").eq(1).attr("flgAOSAODColor", $("input[name='rdoaos']:checked").val());
                        $("#tblEmp").find("td.clsComp_" + CompetencyId).eq(0).attr("flgAOSAODColor", $("input[name='rdoaos']:checked").val());
                        $("#tblEmp").find("td.clsComp_" + CompetencyId).eq(0).removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green").addClass(scolor);
                        fnSaveWashupCmptncyTrafficLight(CompetencyId, $("input[name='rdoaos']:checked").val());
                        $(this).dialog('close');
                    },
                    "Cancel": function () {
                        $(this).dialog('close');
                    }
                }
            })
        }

        function fnOverallAvg() {
            var totalScore = 0.00, cntr = 0;
            $("#tblScore").find("tbody").eq(0).find("tr").each(function () {
                if ($(this).attr("competencyid") != "0") {
                    if ($(this).find("td").eq(1).find("span").eq(0).html() != "") {
                        cntr++;
                        totalScore += parseFloat($(this).find("td").eq(1).find("span").eq(0).html());
                    }
                }
            });

            if (cntr == 0)
                return "0.00";
            else
                return parseFloat(parseFloat(totalScore) / cntr).toFixed(2).toString();
        }

        function fnfail() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        function fnCmntChange(sender) {
            IsAddText = 1;
        }
        var flgSubmit = 0;
        function fnSaveScheduling1(flg) {
            if (flg == 2) {
                var scon = confirm("Are you sure you want to submit?");
                if (scon == false) {
                    return false;
                }
            }
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var Emp = $("#ConatntMatter_hdnEmp").val();
            flgSubmit = flg;// $("#ConatntMatter_hdnflgSave").val();
            var tbl = [];
            var tbl1 = [];

            $("#tblCompetencyCriteriaMstr tbody").find("tr").each(function () {
                    tbl.push({
                        'col1': $(this).attr("rspid"),
                        'col2': $(this).attr("CriteriaId"),
                        'col3': $(this).find("select").eq(0).val()
                    });
            }); 
            $("#tblReadinessMstr tbody").find("input[type='radio']:checked").each(function () {
                if ($(this).closest("tr").find("input[type='text']").eq(0).val().trim() != "") {
                    tbl1.push({
                        'col1': $(this).closest("tr").attr("rspid"),
                        'col2': $(this).closest("tr").attr("ReadinessLevelId"),
                        'col3': $(this).closest("tr").find("input[type='text']").eq(0).val(),
                        'col4': $(this).closest("tr").find("input[type='text']").eq(1).val()
                    });
                }
            });
           
            
            if (tbl1.length == 0) {
                alert("Kindly give the input for Readiness")
                return false;
            }

            $("#dvloader").show();
            PageMethods.fnSave(batch, Emp, tbl,tbl1, login, flgSubmit, fnSave_pass, fnfail);
        }
        var IsAddText = 0;
        function fnSaveScheduling(flg) {
            if (flg == 2) {
                var scon = confirm("Are you sure to submit? as you can not change once submitted.");
                if (scon == false) {
                    return false;
                }
            }
            IsAddText = 0;
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var Emp = $("#ConatntMatter_hdnEmp").val();
            flgSubmit = flg;// $("#ConatntMatter_hdnflgSave").val();
            var tbl = [];
            var tbl1 = [];

            $("#tblCompComment tbody").find("textarea").each(function () {
                tbl.push({
                        'col1': $(this).closest("tr").attr("ExcerciseRatingDetId"),
                        'col2': $(this).val(),
                    });
            });

            if (tbl.length == 0) {
                tbl.push({
                    'col1': '0',
                    'col2': '',
                });
            }
            //if (tbl1.length == 0) {
            //    alert("kindly give the input for readiness")
            //    return false;
            //}

            $("#dvloader").show();
            PageMethods.fnSaveCommts(batch, Emp, tbl, login, flgSubmit, fnSave_pass, fnfail);
        }
        function fnSave_pass(res) {
            if (res.split("|")[0] == "0") {
                var txt = flgSubmit == 1 ? "Saved Successfully !" : "Submitted Successfully !";
                $("#dvloader").hide();
                if (flgSubmit == 2) {
                    alert(txt);
                    $("#btnSubmit,#btnSave").hide();
                    fnGetMapping();
                }
            }
            else {
                $("#dvloader").hide();
                if (flgSubmit == 2) {
                    alert("Due to some technical reasons, we are unable to process your request !");
                }
            }
        }

        function fnSavecompetencyWise(Competency) {

            var login = $("#ConatntMatter_hdnLogin").val();

            var batch = $("#ConatntMatter_ddlBatch").val();
            var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
            var Emp = $("#ConatntMatter_hdnEmp").val();
            flgSubmit = "1";
            var tbl = [];

            $("#tblEmp").find("td[flgedit='1'][competencyid='" + Competency + "']").each(function () {
                if ($(this).html() != "") {
                    tbl.push({
                        'col1': Competency,
                        'col2': $(this).attr("excersiceid"),
                        'col3': $(this).find("span").eq(0).html(),
                    });
                }
            });

            //$("#tblEmp").find("td[flgedit='0'][competencyid='" + Competency + "'][excersiceid='-2']").each(function () {
            //    if ($(this).html() != "") {
            //        tbl.push({
            //            'col1': Competency,
            //            'col2': $(this).attr("excersiceid"),
            //            'col3': $(this).find("span").eq(0).html(),
            //        });
            //    }
            //});
            //$("#tblEmp").find("td[flgedit='0'][competencyid='" + Competency + "'][excersiceid='99']").each(function () {
            //    if ($(this).html() != "") {
            //        tbl.push({
            //            'col1': Competency,
            //            'col2': "99",
            //            'col3': $(this).find("span").eq(0).html(),
            //        });
            //    }
            //});

            $("#dvloader").show();
            PageMethods.fnSaveScoreFromWashUp(batch, Emp, tbl, login, flgSubmit, fnSavecompetencyWise_pass, fnfail);
        }

        function fnSavecompetencyWise_pass(res) {
            if (res.split("|")[0] == "0") {
                $("#dvloader").hide();
                var sData = $.parseJSON("[" + res.split("|")[1] + "]");

                for (var i in sData[0]) {
                    var CmptncyId = sData[0][i]["CmptncyId"];
                    var FinalScore = sData[0][i]["FinalScore"];
                    $("#tblScore tr[competencyid='" + CmptncyId + "']").find("td").eq(2).html(FinalScore);
                }
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request !");
            }
        }

        function fnSaveWashupCmptncyTrafficLight(Competency, flgColor) {

            var login = $("#ConatntMatter_hdnLogin").val();

            var batch = $("#ConatntMatter_ddlBatch").val();
            var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
            var Emp = $("#ConatntMatter_hdnEmp").val();

            $("#dvloader").show();
            PageMethods.fnSaveWashupCmptncyTrafficLight(batch, Emp, flgColor, login, Competency, fnSaveWashupCmptncyTrafficLight_pass, fnfail);
        }

        function fnSaveWashupCmptncyTrafficLight_pass(res) {
            if (res == "0") {
                $("#dvloader").hide();
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request !");
            }
        }


        function fnSaveRSPCmptncyComments() {
            //if ($("#ConatntMatter_ddlCompetency").val() != "0") {

            var Emp = $("#ConatntMatter_hdnEmp").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var login = $("#ConatntMatter_hdnLogin").val();
            var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
            var Comments = $("#txtCmptncyComments").val().trim();
            if (Comments == "") {
                alert("Enter some comments first!");
                $("#txtCmptncyComments").focus();
                return false;
            }
            $("#dvloader").show();
            setTimeout(function () {
                PageMethods.fnSaveRSPCmptncyComments(batch, $("#ConatntMatter_ddlCompetency").val(), login, SeqNo, Comments, function (result) {
                    $("#dvloader").hide();
                }, fnfail);

            }, 100)
            //}
            //else {
            //    $("#dvExcersice").html('');
            //}
        }

        function fnShowCompetencyComment() {
            if (IsAddText == 1 && flgSubmit == 1) {
                fnSaveScheduling(1);
            }
            $(".clscompcoments").hide();
            $("#txtCmptncyComments").val("");
            $("#txtCmptncyComments").prop("disabled", false);
            //if ($("#ConatntMatter_ddlCompetency").val() != "0") {

            $(".clscompcoments").show();
            var Emp = $("#ConatntMatter_hdnEmp").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            if (flgSubmit == 2) {
                $("#txtCmptncyComments").prop("disabled", true);
                $(".clscompcoments").eq(1).hide();
            }
            if ($("#ConatntMatter_ddlExercises").val()=="0") {
                $("#btnSubmit").closest("div").hide();
            }

            $("#dvloader").show();
            PageMethods.fnGetCompetencyComment(batch, $("#ConatntMatter_ddlExercises").val(), Emp, fnGetCompetencyComment_pass, fnfail);

        }
        function fnGetCompetencyComment_pass(res) {
            if (res.split("|")[0] == "0") {
                $("#dvExcersice").html(res.split("|")[1]);
                //$("#txtCmptncyComments").val(res.split("|")[2]);
                Tooltip(".clsCustomTooltip");
$('.textEditor').jqte({
                    ol: false
                });
                if (res.split("|")[1] == "Assessor rating is not available!!") {
                    $("#btnSubmit").closest("div").hide();
                } else {
                    if (flgSubmit == 1) {
                        $("#btnSubmit").closest("div").show();
                    }
                }
            }
            else {
                alert("Due to some technical reasons, we are unable to process your request !");
            }
            $("#dvloader").hide();
        }
        function fnShowImg(ctrl) {
            $("#dvImgDialog").dialog({
                title: "Photo :",
                resizable: false,
                height: "400",
                width: "auto",
                modal: true
            });
            var filename = $(ctrl).attr("src");
            $("#dvImgDialog").html("<div style='padding:20px; text-align: center;'><img src='" + filename + "' style='height: 300px; width: auto;'/></div>");
        }

        function fnStartGotoMeeting() {
            // f1();
            if (MeetingId == "" || MeetingId == "0") {
                alert("Meeting Not Available!");
                return false;
            }
var MeetingLink = $("#ConatntMatter_ddlBatch option:selected").attr("MeetingLink");

 window.open(MeetingLink);
return false;
            $("#dvloader").show();
            PageMethods.fnStartMeeting(MeetingId, BEIUsername, BEIPassword, function (result) {
                $("#dvloader").hide();
                if (result.split("|")[0] == "0") {
                    if (result.split("|")[1] != "") {
                        //f1();
                        window.open(result.split("|")[1]);
                    }
                }
                else {
                    alert("Error-" + result.split("|")[1]);
                }
            }, function (result) {
                $("#dvloader").hide();
                alert("Error-" + result._message);
            });
        }

        function fnRecalcualteOverAllScore() {
            $("#dvloader").show();
            PageMethods.fnRecalculateOverallScore($("#ConatntMatter_ddlBatch").val(), function (result) {
                $("#dvloader").hide();
                if (result.split("|")[0] == "0") {
                    fnGetMapping();
                }
                else {
                    alert("Error-" + result.split("|")[1]);
                }
            }, function (result) {
                $("#dvloader").hide();
                alert("Error-" + result._message);
            });
        }

        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        var TimerText = "Integration Time Left ";
        var isPrepTimeFinished = 0;

        //hdnCounterRunTime
        function f1() {
            $(document).ready(function () {
                //function FnUpdateTimer() {
                if (IsUpdateTimer == 1) {
                    if (parseInt(document.getElementById("ConatntMatter_hdnCounter").value) == 0) {
                        TimerText = "Integration Time Left : ";
                        flgOpenGotoMeeting = 1;
                        isPrepTimeFinished = 0;
                        IsUpdateTimer = 0;
                        document.getElementById("theTime").innerHTML = "Meeting Over";
                        // clearTimeout(sClearTime);
                        window.clearInterval(sClearTime);
                        clearTimeout(sClearTime);
                        $("#dvDialog")[0].innerHTML = "Your Integration time is over";
                        $("#dvDialog").dialog({
                            title: 'Alert',
                            modal: true,
                            width: '40%',
                            buttons: [{
                                text: "OK",
                                click: function () {
                                    $("#dvDialog").dialog("close");
                                }
                            }]
                        });
                        return false;
                    }
                }
                if (IsUpdateTimer == 0) { return; }
                SecondCounter = parseInt(document.getElementById("ConatntMatter_hdnCounter").value);
                if (SecondCounter <= 0) {
                    IsUpdateTimer = 0;
                    //alert("Your Time is over now")
                    counter = 0;
                    //(2, "", 2, 1);
                    return;
                }
                SecondCounter = SecondCounter - 1;
                hours = Math.floor(SecondCounter / 3600);
                Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
                Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);

                if (Seconds < 10 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds < 10 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds > 9 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + "0" + Minutes + ":" + Seconds;
                }
                else if (Seconds > 9 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = TimerText + ":0" + hours + ":" + Minutes + ":" + Seconds;
                }
                document.getElementById("ConatntMatter_hdnCounter").value = SecondCounter;

                //var TotalSecond = parseInt(document.getElementById("ConatntMatter_hdnExerciseTotalTime").value);
                //document.getElementById("ConatntMatter_hdnTimeElapsedSec").value = TotalSecond - SecondCounter;

                if (((hours * 60) + Minutes) == 5 && Seconds == 0) {
                    //  alert("hi")
                    $("#dvDialog")[0].innerHTML = "<center>Your Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " .</center>";
                    $("#dvDialog").dialog({
                        title: 'Alert',
                        modal: true,
                        width: '30%',
                        buttons: [{
                            text: "OK",
                            click: function () {
                                $("#dvDialog").dialog("close");
                            }
                        }]
                    });

                    //   document.getElementById("dvDialog").innerHTML = "<center>Your Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " After that your window will be closed automatically.</center>";
                }
                counter++;
                if (counter == 10) {//Auto Time Update
                    counter = 0;
                    //  fnStartMeetingTimer();
                    //counter = 1;
                }

                if (SecondCounter == 0) {
                    if (parseInt(document.getElementById("ConatntMatter_hdnCounter").value) == 0) {
                        IsUpdateTimer = 0;
                        flgOpenGotoMeeting = 1;
                        window.clearInterval(sClearTime);
                        clearTimeout(sClearTime);
                        document.getElementById("theTime").innerHTML = "Meeting Over";
                        $("#dvDialog")[0].innerHTML = "Your Integration time is over";
                        $("#dvDialog").dialog({
                            title: 'Alert',
                            modal: true,
                            width: '40%',
                            buttons: [{
                                text: "OK",
                                click: function () {
                                    $("#dvDialog").dialog("close");
                                }
                            }]
                        });
                        return false;
                    }
                    else {
                        IsUpdateTimer = 0;
                        counter = 0;
                        //fnUpdateElapsedTime();
                        return false;
                    }
                }
                // }
                sClearTime = setTimeout("f1()", 1000);

            });

        }
        var sClearTime;

        function fndsplyComment(ctrl) {

            var Competency = $(ctrl).closest("tr").find("td").eq(0).html();
            var ExerciseId = $(ctrl).attr("ExerciseID");
            $("#divComment")[0].innerHTML = "<br/><br/>Please wait.....";
            $("#divComment").dialog({
                modal: true,
                width: "90%",
                height: window.innerHeight - 20,
                title: $("#ConatntMatter_ddlCompetency option:selected").text() + " :",
                open: function () {
                    var Emp = $("#ConatntMatter_hdnEmp").val();
                    var batch = $("#ConatntMatter_ddlBatch").val();
                    var login = $("#ConatntMatter_hdnLogin").val();
                    var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
                    if (flgSubmit == 2) {
                        $("div[aria-describedby='divComment']").find("div.ui-dialog-buttonset").find("button").eq(0).hide();
                    }
                    $("#dvloader").show();

                    PageMethods.fnGetDetailRpt(Emp, batch, $("#ConatntMatter_ddlCompetency").val(), ExerciseId, function (response) {
                        $("#dvloader").hide();
                        if (response != "") {
                            $("#divComment").html(response);
                            if (flgSubmit == 2) {
                            $("#divComment").find("input[type='radio'],textarea").prop("disabled", true);
                             }
                        } else {
                            $("#divComment").html("No Details found !");
                        }
                    }, fnfail);
                },
                buttons: {
                    
                    "Save": function () {
                        var ArrDataSaving = []; var udt_RatingCommentsDetail = []; var totCheckNotDemonstrated = 0; var totalChecked = 0;
                        var totlen = $("#tbl_Ans").find("textarea");
                        var strPL = "";
                        for (var i = 0; i < totlen.length; i++) {
                            if (totlen.eq(i).val().trim().length == 0) {
                                alert("Behaviour text can not be blank!")
                                return false;
                            }
                            ArrDataSaving.push({ ID: totlen.eq(i).closest("tr").attr("EvidenceId"), Val: totlen.eq(i).val().trim() });
                        }


                        var $textArea = $("#divComment textarea#txtPositiveExample");
                        var strPL = "";
                        for (var i = 0; i < $textArea.length; i++) {
                            udt_RatingCommentsDetail.push({ ExcerciseRatingId: $textArea.eq(i).attr("ExcerciseRatingId"), Comments: $textArea.eq(i).val().trim() });
                        }

                        if (udt_RatingCommentsDetail.length == 0) {
                            udt_RatingCommentsDetail.push({ ExcerciseRatingId: '0', Comments: '' });
                        }


                        $("#loader").show();
                        var loginId = $("#ConatntMatter_hdnLogin").val();
                        var RSPExId = $("#ConatntMatter_hdnRSPExId").val();

                        PageMethods.fnSaveRating(ArrDataSaving, loginId, $("#ConatntMatter_ddlCompetency").val(), udt_RatingCommentsDetail, function (result) {
                            $("#loader").hide();
                            $("#divComment").dialog('close');
                            fnShowCompetencyComment();
                        }, function (result) {
                                $("#loader").hide();
                                alert("Error-" + result._message);
                        });
                    },
                    "Cancel": function () {
                        $("#divComment").dialog('close')
                    }
                },
                close: function () {
                    $("#divComment").dialog('destroy');
                    $("#divComment").html("");
                }
            });
        }

        function fnExpandDataCompetency(sender, ExerciseId) {
            if ($("#trCom_" + ExerciseId).css("display") == "none") {
                $("#trCom_" + ExerciseId).css("display", "table-row");
                $(sender).removeClass("fa-plus").addClass("fa-minus");
            } else {
                $("#trCom_" + ExerciseId).css("display", "none");
                $(sender).removeClass("fa-minus").addClass("fa-plus");
            }
        }

        function fnExcelReportBackUp() {
            var SeqNo = $("#ConatntMatter_hdnSeqNo").val();


            var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
            tab_text = tab_text + '<head>';
            tab_text = tab_text + '<xml>';
            tab_text = tab_text + '<x:ExcelWorkbook><x:ExcelWorksheets>';

            tab_text = tab_text + '<x:ExcelWorksheet>';
            if (SeqNo == 0) {
                tab_text = tab_text + '<x:Name>Integration Sheet1</x:Name>';
            } else {
                tab_text = tab_text + "<x:Name>P-" + SeqNo + "</x:Name>";
            }
            tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';

            tab_text = tab_text + '<x:ExcelWorksheet>';
            if (SeqNo == 0) {
                tab_text = tab_text + '<x:Name>Integration Sheet2</x:Name>';
            } else {
                tab_text = tab_text + "<x:Name>P-" + SeqNo + "</x:Name>";
            }
            tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';

            tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
            tab_text = tab_text + "<table border='1px'>";
            var dv1 = $('#dvEmp').clone();
            var dv2 = $('#dvScore').clone();
            dv1.find("table").attr("border", "1");
            dv1.find("table").attr("rules", "all");

            dv2.find("table").attr("border", "1");
            dv2.find("table").attr("rules", "all");


            if (SeqNo > 0) {
                var batch = $("#ConatntMatter_ddlBatch").val();
                var Emp = $("#ConatntMatter_hdnEmp").val();
                $("#dvloader").show();
                //.removeClass("cls-score-red").removeClass("cls-score-yellow").removeClass("cls-score-green").addClass(scolor);
                PageMethods.fnGetCompetencyComment(batch, 0, Emp, function (res) {
                    if (res.split("|")[0] == "0") {
                        dv1.find("thead").find("tr").append("<th>Remarks</th>")
                        dv1.find("thead").find("tr").attr("bgcolor", "#e9ecef");
                        dv1.find("tbody").find("tr").eq(0).append("<td></td>");
                        dv1.find("tbody").find("tr").eq(1).append("<td rowspan='" + (dv1.find("tbody").find("tr").length - 3) + "'>" + res.split("|")[2].replace(/\n/g, '<br style="mso-data-placement:same-cell;"/>') + "</td>");
                        dv1.find("table").find(".clstoremove").remove();
                        dv1.find("table").find("td").css("vertical-align", "middle");
                        dv1.find("table").find(".cls-score-red").css("background-color", "#ffd9d7");
                        dv1.find("table").find(".cls-score-yellow").css("background-color", "#fffacc");
                        dv1.find("table").find(".cls-score-green").css("background-color", "#D2F4DC");
                        dv1.find("table").find(".cls-score-darkgreen").css("background-color", "#84e19f");

                        dv2.find("table").find(".cls-score-red").css("background-color", "#ffd9d7");
                        dv2.find("table").find(".cls-score-yellow").css("background-color", "#fffacc");
                        dv2.find("table").find(".cls-score-green").css("background-color", "#D2F4DC");
                        dv2.find("table").find(".cls-score-darkgreen").css("background-color", "#84e19f");
                        tab_text = tab_text + dv1.html();
                        tab_text = tab_text + dv2.html();
                        tab_text = tab_text + '</table></body></html>';
                        var data_type = 'data:application/vnd.ms-excel';
                        var ua = window.navigator.userAgent;
                        var msie = ua.indexOf("MSIE ");

                        if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
                            if (window.navigator.msSaveBlob) {
                                var blob = new Blob([tab_text], {
                                    type: "application/vnd.ms-excel;charset=utf-8;"
                                });
                                if (SeqNo == 0) {
                                    navigator.msSaveBlob(blob, "IntegrationSheet_" + $("#ConatntMatter_ddlBatch option:selected").text() + ".xls");
                                } else {
                                    navigator.msSaveBlob(blob, "IntegrationSheet_P-" + SeqNo + ".xls");
                                }
                            }
                        } else {
                            var element = document.createElement('a');
                            element.setAttribute('href', 'data:application/vnd.ms-excel;charset=utf-8,' + encodeURIComponent(tab_text));
                            if (SeqNo == 0) {
                                element.setAttribute('download', "IntegrationSheet_" + $("#ConatntMatter_ddlBatch option:selected").text() + ".xls");
                            } else {
                                element.setAttribute('download', "IntegrationSheet_P-" + SeqNo + ".xls");
                            }
                            element.style.display = 'none';
                            document.body.appendChild(element);
                            element.click();
                            document.body.removeChild(element);
                            //window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text),'IntegrationSheet');
                        }
                    }
                    else {
                        alert("Due to some technical reasons, we are unable to process your request !");
                    }
                    $("#dvloader").hide();
                }, fnfail);
            }
            else {
                tab_text = tab_text + dv1.html();
                tab_text = tab_text + dv2.html();
                tab_text = tab_text + '</table>';


                tab_text = tab_text + '</body></html>';
                var data_type = 'data:application/vnd.ms-excel';
                var ua = window.navigator.userAgent;
                var msie = ua.indexOf("MSIE ");

                if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
                    if (window.navigator.msSaveBlob) {
                        var blob = new Blob([tab_text], {
                            type: "application/vnd.ms-excel;charset=utf-8;"
                        });
                        if (SeqNo == 0) {
                            navigator.msSaveBlob(blob, "IntegrationSheet_" + $("#ConatntMatter_ddlBatch option:selected").text() + ".xls");
                        } else {
                            navigator.msSaveBlob(blob, "IntegrationSheet_P-" + SeqNo + ".xls");
                        }
                    }
                } else {
                    var element = document.createElement('a');
                    element.setAttribute('href', 'data:application/vnd.ms-excel;charset=utf-8,' + encodeURIComponent(tab_text));
                    if (SeqNo == 0) {
                        element.setAttribute('download', "IntegrationSheet_" + $("#ConatntMatter_ddlBatch option:selected").text() + ".xls");
                    } else {
                        element.setAttribute('download', "IntegrationSheet_P-" + SeqNo + ".xls");
                    }
                    element.style.display = 'none';
                    document.body.appendChild(element);
                    element.click();
                    document.body.removeChild(element);
                    //window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text),'IntegrationSheet');
                }
            }
        }

        function fnExcelReport() {
            var batch = $("#ConatntMatter_ddlBatch").val();
            var batchstr = $("#ConatntMatter_ddlBatch option:selected").text();
            var NumberOfParticipants = $("#ConatntMatter_ddlBatch option:selected").attr("NumberOfParticipants");
            if (parseInt(NumberOfParticipants) > 0) {
                NumberOfParticipants = parseInt(NumberOfParticipants) + 1;
            }
            var str = encodeURI("CycleId=" + batch + "&NoOfParticipants=" + NumberOfParticipants + "&batchstr=" + batchstr);
            window.open("../../frmDownloadExcel.aspx?" + str, "_blank");
        }

       
        var tablesToExcel = (function () {
            var uri = 'data:application/vnd.ms-excel;base64,'
                , tmplWorkbookXML = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">'
                    + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>Axel Richter</Author><Created>{created}</Created></DocumentProperties>'
                    + '<Styles>'
                    + '<Style ss:ID="Currency"><NumberFormat ss:Format="Currency"></NumberFormat></Style>'
                    + '<Style ss:ID="Date"><NumberFormat ss:Format="Medium Date"></NumberFormat></Style>'
                    + '</Styles>'
                    + '{worksheets}</Workbook>'
                , tmplWorksheetXML = '<Worksheet ss:Name="{nameWS}"><Table>{rows}</Table></Worksheet>'
                , tmplCellXML = '<Cell{attributeStyleID}{attributeFormula}><Data ss:Type="{nameType}">{data}</Data></Cell>'
                , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
                , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
            return function (tables, wsnames, wbname, appname) {
                var ctx = "";
                var workbookXML = "";
                var worksheetsXML = "";
                var rowsXML = "";

                for (var i = 0; i < tables.length; i++) {
                    if (!tables[i].nodeType) tables[i] = document.getElementById(tables[i]);
                    for (var j = 0; j < tables[i].rows.length; j++) {
                        rowsXML += '<Row>'
                        for (var k = 0; k < tables[i].rows[j].cells.length; k++) {
                            var dataType = tables[i].rows[j].cells[k].getAttribute("data-type");
                            var dataStyle = tables[i].rows[j].cells[k].getAttribute("data-style");
                            var dataValue = tables[i].rows[j].cells[k].getAttribute("data-value");
                            dataValue = (dataValue) ? dataValue : tables[i].rows[j].cells[k].innerHTML;
                            var dataFormula = tables[i].rows[j].cells[k].getAttribute("data-formula");
                            dataFormula = (dataFormula) ? dataFormula : (appname == 'Calc' && dataType == 'DateTime') ? dataValue : null;
                            ctx = {
                                attributeStyleID: (dataStyle == 'Currency' || dataStyle == 'Date') ? ' ss:StyleID="' + dataStyle + '"' : ''
                                , nameType: (dataType == 'Number' || dataType == 'DateTime' || dataType == 'Boolean' || dataType == 'Error') ? dataType : 'String'
                                , data: (dataFormula) ? '' : dataValue
                                , attributeFormula: (dataFormula) ? ' ss:Formula="' + dataFormula + '"' : ''
                            };
                            rowsXML += format(tmplCellXML, ctx);
                        }
                        rowsXML += '</Row>'
                    }
                    ctx = { rows: rowsXML, nameWS: wsnames[i] || 'Sheet' + i };
                    worksheetsXML += format(tmplWorksheetXML, ctx);
                    rowsXML = "";
                }

                ctx = { created: (new Date()).getTime(), worksheets: worksheetsXML };
                workbookXML = format(tmplWorkbookXML, ctx);



                var link = document.createElement("A");
                link.href = uri + base64(workbookXML);
                link.download = wbname || 'Workbook.xls';
                link.target = '_blank';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        })();
    </script>
    <style type="text/css">
        .validatetooltip {
            display: none;
            position: absolute;
            border: 1px solid #ff0000;
            background-color: #ff0000;
            border-radius: 5px;
            padding: 2px 10px;
            color: #fff;
            max-width: 800px;
        }

        .clsClosetooltip {
            display: table-cell;
            text-align: right;
            padding-right: 3px;
            cursor: pointer;
        }

        .pointer {
            cursor: pointer !important;
        }

        .cls-score-red {
            background: #FFD9D7;
        }

        .cls-score-yellow {
            background: #FFFACC;
        }

        .cls-score-green {
            background: #D2F4DC;
        }

        .cls-score-darkgreen {
            background: #84e19f;
        }


        table th {
            padding: .2rem .1rem !important;
            font-size: 0.68rem !important;
            font-family: Arial, Helvetica, sans-serif !important;
            vertical-align: middle !important;
        }

        table td {
            padding: .16rem !important;
            font-size: 0.68rem !important;
            font-family: Arial, Helvetica, sans-serif !important;
            vertical-align: middle !important;
        }

        #tbl_Ans th.clsRating_4,
        #tbl_Ans th.clsRating_5,
        #tbl_Ans th.clsRating_6 {
            text-align: center;
        }


        #tblEmp_Compiled td.cls-3 {
            width: 140px;
            min-width: 120px;
            text-align: left;
            padding-left: 10px;
        }

        #tblExerciseWiseAvgScore td {
            text-align: center;
        }

            #tblExerciseWiseAvgScore td.cls-1 {
                text-align: left;
            }

        #tblAssessorMstr td.cls-0 {
            text-align: center;
        }

        #tblScore td.cls-2,
        #tblScore td.cls-3 {
            width: 20%;
            text-align: center;
        }

        #tblEmp td.cls-3, #tblEmp td.cls-4 {
            text-align: left !important;
        }

        #tblEmp td.cls-11 {
            border-bottom: 2px solid !important;
        }

        #tblScore td.clsComp_8,
        #tblEmp td.clsComp_8 {
            border-top: 2px solid !important;
        }

        #tblScore > thead.thead-light th,
        #tblExerciseWiseAvgScore > thead.thead-light th,
        #tblAssessorMstr > thead.thead-light th {
            background-color: #ffc000;
        }

        #tblEmp_Compiled > thead.thead-light th {
            color: #495057;
            background-color: #a5a5a5;
            border-color: #dee2e6;
        }

        #tblEmp_Compiled,
        #tblEmp {
            margin-bottom: 0;
        }

            #tblEmp td.cls-0,
            #tblEmp td.cls-1 {
                width: 120px;
                min-width: 120px;
                text-align: left;
                padding-left: 10px;
            }

            #tblEmp_Compiled td,
            #tblEmp td {
                width: 60px;
                min-width: 60px;
                text-align: center;
                vertical-align: middle;
            }

                #tblEmp_Compiled td.cls-1,
                #tblEmp_Compiled td.cls-2,
                #tblEmp_Compiled td.cls-3,
                #tblEmp_Compiled td.cls-4,
                #tblEmp_Compiled td.cls-5,
                #tblEmp_Compiled td.cls-6,
                #tblEmp_Compiled td.cls-7,
                #tblEmp_Compiled td.cls-8,
                #tblEmp_Compiled td.cls-10,
                #tblEmp_Compiled td.cls-11,
                #tblEmp_Compiled td.cls-12 {
                    text-align: left;
                    padding-left: 10px;
                }



                #tblEmp_Compiled td.cls-9 {
                    text-align: left;
                    padding-left: 10px;
                    min-width: 120px;
                }

                #tblEmp_Compiled td.cls-3,
                #tblEmp_Compiled td.cls-13 {
                    text-align: left;
                    padding-left: 10px;
                    
                }

                #tblEmp_Compiled td.cls-11 {
                    text-align: left;
                    padding-left: 10px;
                    min-width: 80px;
                }

        .cls-bg-gray {
            background: #ccc;
        }

        .cls-time {
            width: 100%;
            text-align: center;
            border-color: transparent;
        }

            .cls-time:hover,
            .cls-time-active {
                border: 1px solid #75DFEE;
            }

        #tblEmp_Compiled span.clsScore,
        #tblEmp span.clsScore {
            padding: 0 5px;
            white-space: nowrap;
        }

        #tblCompComment th:nth-child(1) {
            width: 30%;
        }
    </style>
    <style type="text/css">
        .clsCustomTooltip {
            cursor: pointer;
        }

        .customtooltip {
            display: none;
            position: absolute;
            border: 1px solid #333;
            background-color: #161616;
            border-radius: 5px;
            padding: 10px;
            color: #fff;
            max-width: 800px;
        }

        .ui-dialog {
            z-index: 10100 !important;
        }

        #loader {
            z-index: 10110 !important;
        }
.jqte {
    margin: 5px !important;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix" style="margin-bottom: 0px;">
        <h3 class="text-center" style="padding-left: 105px">Integration Session</h3>

        <time id="theTime" class="fst-color" style="display: none; float: right; margin-top: -34px">Meeting to start</time>
        
        <div class="title-line-center" style="width: 100%"></div>
    </div>
    <div style="margin-top: -38px; position: absolute;">
        Batch : 
        <asp:DropDownList ID="ddlBatch" runat="server" onchange="fnChangeBatch()"></asp:DropDownList>
        <input type="button" value="Start Teams Meeting" id="btnWashup" style="display: none" class="btn btn-primary btn-sm" onclick="fnStartGotoMeeting()" />

        <input type="button" value="Copy Meeting Link" id="btnWashup1" style="display: none; margin-left: 8px" class="btn btn-primary btn-sm" onclick="fnCopyMeetingLink()" />
    </div>
    <div id="dvShowHideCol" style="margin: .1rem 0rem; display: none">
       <%-- <label style="margin: 0px">
            <input value="1" onchange="fnShowHideCol(this)" type="checkbox" />
            Participant Details</label>
        <label style="margin: 0px 10px">
            <input value="2" onchange="fnShowHideCol(this)" type="checkbox" />
            Organizational Details</label>
        <label style="margin: 0px">
            <input value="3" onchange="fnShowHideCol(this)" type="checkbox" />
            DC Details</label>--%>

        <a href="###" onclick="fnExcelReport()" style="margin-left: 250px;display:none" class="btn btn-primary btn-sm"><i class="fa fa-download btn-sm" style="font-size:14px;padding:0px 5px"></i>Download</a>
<a href="###" onclick="fnRecalcualteOverAllScore()" id="btnRecalculateScore"  style="margin-left: 56px;" class="btn btn-primary btn-sm">Recalculate Overall Score</a>

    </div>
    <div id="dvEmp" style="overflow-x: auto; margin-bottom: .0rem;"></div>
    <div class="row">
        <div id="dvScore" class="col-6 d-none"></div>
        <div id="dvExcersiceBlock" class="col-12" style="display: none;">
            <div style="padding: 5px 10px;"><span style="color: #666; font-size: 0.9rem; font-weight: 700; float: left;">Exercise  :</span><select id="ddlExercises" class="form-check" runat="server" style="margin-left: 140px;" onchange="fnShowCompetencyComment();"></select></div>

           <%-- <div style="padding: 5px 10px;"><span style="color: #666; font-size: 0.9rem; font-weight: 700; float: left;">Competency  :</span><select id="ddlCompetency" class="form-check" runat="server" style="margin-left: 140px;" onchange="fnShowCompetencyComment();"></select></div>--%>
            <div id="dvExcersice"></div>
            <div class="clscompcoments1" style="display: none">
                <div>Remarks :</div>
               
                <textarea class="form-control w-100 border" rows="3" id="txtCmptncyComments"></textarea>
            </div>
            <div class="text-center" style="display: none; margin-top: 5px">
                <input type="button" value="Save Competency Comments" class="btn btn-primary btn-sm" onclick="fnSaveRSPCmptncyComments()">
            </div>
        </div>
    </div>
    <div id="dvCompetencyCriteria" style="overflow-x: auto; margin-bottom: .0rem;"></div>
    <div class="text-center " style="margin-top: 5px; margin-bottom: 5px;">
        <input type="button" id="btnSave" value="Save as draft" onclick="fnSaveScheduling(1)" class="btns btn-cancel" style="padding: 5px 20px" />
        <input type="button" id="btnSubmit" value="Submit" onclick="fnSaveScheduling(2)" class="btns btn-cancel" style="padding: 5px 20px" />
    </div>
    <div id="dvBtns" runat="server"></div>
    <div id="dvImgDialog" style="display: none"></div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>

    <div id="dvDialog" style="display: none;"></div>

    <div id="divComment" style="display: none;">
    </div>
    <asp:HiddenField ID="hdnUserlst" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnSeqNo" runat="server" />
    <asp:HiddenField ID="hdnBatch" runat="server" />
    <asp:HiddenField ID="hdnEmp" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
    <asp:HiddenField ID="hdnflgSave" runat="server" />
    <asp:HiddenField ID="hdnCounter" Value="0" runat="server" />

</asp:Content>
