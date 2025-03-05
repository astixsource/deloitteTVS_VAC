<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteManager.master" AutoEventWireup="true" CodeFile="frmManagerAssessmentRating.aspx.cs" Inherits="frmManagerAssessmentRating" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-te-1.4.0.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-te-1.4.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#loader").hide();

            $("#ConatntMatter_divleft").css("height", '100%');
            $("#dvleftList").css("max-height", $(window).height() - 160);
            //$("#divRight").css("min-height", $(window).height() - 150);

            //$("#divBody").css("max-height", $(window).height() - 180);
            $("#divBody").css("height", $(window).height() - 170);
            var flgCallFrom = $("#ConatntMatter_hdnflgCallFrom").val();
            //if (flgCallFrom == 1) {
            //    frmGetExerciseDetail();
            //    //GetExerciseParticipantComments();
            //}
            //else {
            //frmGetExerciseDetail();
            //}
        });

        function fnBack() {
            window.location.href = "frmManagerAssessmentInstruction.aspx";
        }

        function fnChangeParticipant(sender) {
            var RspExerciseId = $(sender).val();
            $("#ConatntMatter_hdnRSPExId").val(RspExerciseId);
            frmGetExerciseDetail();
        }
        var IsFinalSubmit = 0;
        function frmGetExerciseDetail() {
            $("#loader").show();
            var loginId = $("#ConatntMatter_hdnLogin").val();
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            var flgCallFrom = $("#ConatntMatter_hdnflgCallFrom").val();
            PageMethods.frmGetExerciseDetail(RSPExId, loginId, flgCallFrom, function (result) {
                $("#loader").hide();

                if (result.split("|")[0] == "0") {

                    $("#dvleftList").html(result.split("|")[1]);
                    IsFinalSubmit = result.split("|")[2];
                    if (result.split("|")[2] == "2") {

                        //$("#divUserComment").hide();
                        $("#btnFinalSubmit").closest("div").hide();
                    }
                } else {
                    alert("Error-" + result.split("|")[1]);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });

        }

        function GetExerciseParticipantComments() {

            if (flgNotSave == 1) {
                alert("Kindly save data first as changes in data will be lost!");
                return false;
            }
            $("#ConatntMatter_hdnflgCallFrom").val("1");

            $("#loader").show();
            var loginId = $("#ConatntMatter_hdnLogin").val();
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            PageMethods.frmGetExerciseParticipantComments(RSPExId, loginId, function (result) {
                $("#loader").hide();
                //alert(result)
                if (result.split("|")[0] == "0") {
                    $("#divBody").css("display", "block");
                    $(".clsPP").css("display", "none");

                    // $("#divBack").css("display", "none");
                    $("#btnSaveContinue").show();
                    $("#divBody").html(result.split("|")[1]);

                    $("textarea,select,input").bind('change', function () {
                        flgNotSave = 1;
                    })
                    if (IsFinalSubmit == 2) {
                        $("#btnSaveContinue").hide();
                        $("textarea,select,input").prop("disabled", true);
                    }
                } else {
                    alert("Error-" + result.split("|")[1]);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }

        function fnMailDetails(ctrl) {

            // flgCallFrom = 2;
            if (flgNotSave == 1) {
                alert("Kindly save data first as changes in data will be lost!");
                return false;
            }
            $("#ConatntMatter_hdnflgCallFrom").val("2");
            $(".clsPP").css("display", "table-cell");
            var LoginId = $("#ConatntMatter_hdnLogin").val();
            var RSPExerciseId = $("#ConatntMatter_hdnRSPExId").val();
            var ExerciseId = $("#ConatntMatter_hdnExerciseId").val();
            var ExcerciseRatingDetId = $(ctrl).attr("ExcerciseRatingDetId");
            $("#ulmain li.clsLIHightlight").removeClass("clsLIHightlight");
            $(ctrl).addClass("clsLIHightlight");
            $("#loader").show();
            $("#btnSaveContinue").hide();
            flgNotSave = 0;
            $.ajax({
                url: "frmManagerAssessmentRating.aspx/fnGetDetailRpt",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ExcerciseRatingDetId:'" + ExcerciseRatingDetId + "',RSPExerciseId:'" + RSPExerciseId + "',LoginId:'" + LoginId + "',Competency:'" + JSON.stringify($(ctrl).html()) + "'}",
                success: function (response) {
                    $("#loader").hide();
                    if (response.d != "") {
                        $("#divBody").css("display", "block");
                        // $("#divBack").css("display", "none");

                        $("#ConatntMatter_hdnMailID").val(ExcerciseRatingDetId);
                        $("#btnSaveContinue").show();
                        var str = "<div style='float:right;margin-bottom:5px;padding-right:5px;display:none'><table style='font-size:11pt'><tr><td style='font-weight:bold;font-size:11pt'><b>Competency :</b></td><td>" + $(ctrl).html() + "</td></tr></table></div>";
                        $("#divBody").html(response.d);

                        $("textarea,select,input").bind('change', function () {
                            flgNotSave = 1;
                        })
                        if (IsFinalSubmit == 2) {
                            $("#btnSaveContinue").hide();
                            $("textarea,select,input").prop("disabled", true);
                        } else {
                            // fnCheckedScore($("#tbl_ScoreStatement input[name='rdoscore']:checked"), 2);
                        }
                        //$('.textEditor').jqte({
                        //                    ol: false,
                        //remove: true
                        //                });
                    }
                    else {
                        alert("No Details found !");
                    }
                },
                error: function (msg) {
                    $("#loader").hide();
                    alert('Error-' + msg.statusText);
                }
            });
        }

        function fnRatingAssessorSavePLListForSubCompetency(sender) {
            $("#divAlert").hide();
            var ExcerciseRatingDetId = $("#ConatntMatter_hdnMailID").val();
            var ExerciseCompetencyPLMapID = $(sender).closest("tr").attr("ExerciseCompetencyPLMapID");
            var RatingId = $(sender).val();
            $("#loader").show();
            PageMethods.fnRatingAssessorSavePLListForSubCompetency(ExcerciseRatingDetId, ExerciseCompetencyPLMapID, RatingId, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "0") {
                    fnSetBGColor(sender);
                    $(sender).closest("tr").find("i").show();
                } else {
                    alert("Error-" + result.split("|")[1]);
                    $(sender).prop("checked", false);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }

        function fnRatingAssessorSaveSubCompetencyScore(sender) {
            $("#divAlert").hide();
            var ExcerciseRatingDetId = $("#ConatntMatter_hdnMailID").val();
            var AnsVal = $(sender).val();
            $("#loader").show();
            PageMethods.fnRatingAssessorSaveSubCompetencyScore(ExcerciseRatingDetId, AnsVal, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "1") {
                    alert("Error-" + result.split("|")[1]);

                } else {
                    var MailId = $("#ConatntMatter_hdnMailID").val();
                    var li = $("#ConatntMatter_divleft").find("li[ExcerciseRatingDetId='" + MailId + "']").eq(0);
                    li.removeClass("clsNotOpen");
                    li.removeClass("clsOpen");
                    li.addClass("clsOpen");
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }
        function fnDeleteResponse(sender) {
            var ExcerciseRatingDetId = $("#ConatntMatter_hdnMailID").val();
            var ExerciseCompetencyPLMapID = $(sender).closest("tr").attr("ExerciseCompetencyPLMapID");
            var RatingId = 0
            $("#loader").show();
            PageMethods.fnRatingAssessorSavePLListForSubCompetency(ExcerciseRatingDetId, ExerciseCompetencyPLMapID, RatingId, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "0") {
                    $(sender).closest("tr").find("input[type=radio]:checked").prop("checked", false);
                    $(sender).closest("tr").find("input[type=radio]:checked").removeAttr("checked");
                    $(sender).closest("tr").find("td").removeClass("clsBGOrange").removeClass("clsBGRed").removeClass("clsBGGreen");
                    $(sender).hide();
                } else {
                    alert("Error-" + result.split("|")[1]);
                    $(sender).prop("checked", false);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });

        }
        var flgNotSave = 0;
        function fnSave(StatusId) {
            var ArrDataSaving = [];
            if (StatusId == 2) {
                if ($("#tbl_Ans_Positive").find("tbody").find("input[type='radio']:checked").length != $("#tbl_Ans_Positive").find("tbody").find("tr").length) {
                    alert("Kindly Select Rating Scale for all questions First!");
                    // $("#tbl_Ans_Positive").find("tbody").find("input[type='radio']").
                    return false;
                }
                //$("#dvDialog").html("</br>Are you sure you want to submit?");
                //$("#dvDialog").dialog({
                //    title: "Confirmation:",
                //    modal: true,
                //    position: {
                //        my: "center",
                //        at: "center",
                //        of: window
                //    },
                //    close: function () {
                //        $(this).dialog('destroy');
                //    },
                //    buttons: {
                //        "Yes": function () {
                //            $("#dvDialog").dialog('close');


                           
                //        },
                //        "No": function () {
                //            $("#dvDialog").dialog('close');
                //        }
                //    }
                //})
                if (!confirm("Are you sure you want to submit?")) {
                    return false;
                }
                $("#tbl_Ans_Positive").find("tbody").find("input[type='radio']:checked").each(function () {
                    IsBehaviouAvailable = 1;
                    ArrDataSaving.push({ RspDetID: $(this).attr("bid"), QstId: 0, RspExerciseId: 0, ActualAnswer: $(this).val() });
                });

                //alert(OverallScore)
                $("#loader").show();
                var loginId = $("#ConatntMatter_hdnLogin").val();
                var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
                $("#btnSaveContinue,#btnSaveContinue1").prop("disabled", true);
                PageMethods.fnSave(ArrDataSaving, loginId, RSPExId, StatusId, fnSaveSuccess, fnFail, StatusId);

            }
            else {

                $("#tbl_Ans_Positive").find("tbody").find("input[type='radio']:checked").each(function () {
                    IsBehaviouAvailable = 1;
                    ArrDataSaving.push({ RspDetID: $(this).attr("bid"), QstId: 0, RspExerciseId: 0, ActualAnswer: $(this).val() });
                });

                //alert(OverallScore)
                $("#loader").show();
                var loginId = $("#ConatntMatter_hdnLogin").val();
                var RSPExId = $("#ConatntMatter_hdnRSPExId").val();

                PageMethods.fnSave(ArrDataSaving, loginId, RSPExId, StatusId, fnSaveSuccess, fnFail, StatusId);
            }
        }

        function fnclickBehaviour(sender) {
            var btypeid = $(sender).attr("btypeid");
            var flg = $(sender).attr("flg");
            if (btypeid == 2) {
                $(sender).closest("td").prev().find("input").prop("checked", false);
            } else {
                if (flg == 2) {
                    $(sender).closest("td").next().find("input").prop("checked", false);
                }
            }
        }

        function fnConfirmYesOnSave() {

            fnCloseModalSecond();

            PageMethods.fnSave(ArrDataSaving, loginId, fnSaveSuccess, fnFail);
        }
        function fnCloseModalSecond() {
            $("#divAlertSecond").hide();
        }


        function fnCheckedScore(sender, flg) {
            $("input[name='rdoscorestatement']").prop("disabled", true);
            $(sender).closest("td").next().find("input").prop("disabled", false);
            if (flg == 1) {
                $("#TxtFinalScoreStatment").val("");
            }
            if ($(sender).closest("td").next().find("input").length == 1) {
                $(sender).closest("td").next().find("input").prop("checked", true);
                var scorestatement = $(sender).closest("td").next().find("input:checked").closest("label").text();
                fnShowScoreStatement(scorestatement, flg);
            }
        }

        function fnSelectScoreStatement(sender) {

            var scorestatement = $(sender).closest("label").text();
            fnShowScoreStatement(scorestatement, 1);
        }

        function fnShowScoreStatement(ScoreStatment, flg) {
            if (flg == 1) {
                $("#TxtFinalScoreStatment").val(ScoreStatment.trim());
            }
        }

        function fnSaveSuccess(result, flg) {
            $("#loader").hide();
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            if (result.split("|")[0] == "0") {
                if (flg == 2) {

                    $("#dvmsg").html("All responses submitted successfully");
                    // alert("Meeting ended successfully for Participant");
                    setTimeout(function () {
                        fnBack();
                    }, 3000);


                } else {
                    $("#dvmsg").html("Selected responses saved successfully");
                    setTimeout(function () {
                        $("#dvmsg").html("");
                    }, 3000);

                }
            }
            else {
                $("#btnSaveContinue,#btnSaveContinue1").prop("disabled", false);
                alert("Error:" + result.split("|")[1]);
            }
            flgNotSave = 0;
        }

        function fnSubmit() {
            if (flgNotSave == 1) {
                alert("Kindly save data first as changes in data will be lost!");
                return false;
            }

            if ($("#ConatntMatter_divleft").find("li.clsNotOpen").length > 0) {
                alert("Please respond to all the items before clicking on Submit button !");
            }
            else {
                //var loginId = $("#ConatntMatter_hdnLogin").val();
                //var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
                // PageMethods.fnFinalReview(RSPExId, loginId, fnReviewSuccess, fnFail);
                $("#dvDialog").html("</br>Are you sure to submit?");
                $("#dvDialog").dialog({
                    title: "Confirmation:",
                    modal: true,
                    close: function () {
                        $(this).dialog('destroy');
                    },
                    buttons: {
                        "Yes": function () {
                            $("#dvDialog").dialog('close');
                            fnSaveSubmit();
                        },
                        "No": function () {
                            $("#dvDialog").dialog('close');
                        }
                    }
                })

            }
        }

        function fnReviewSuccess(res) {
            $("#loader").hide();
            if (res.split("|")[0] == "0") {
                $("#divAlertbody").html(res.split("|")[1]);
                $("#divAlert").show();
            }
            else {
                alert("Due to some technical error, we are unable to process your request !");
            }
        }

        function fnCloseModal() {
            $("#divAlert").hide();
        }

        function fnSaveSubmit() {
            $("#divAlert").hide();
            var loginId = $("#ConatntMatter_hdnLogin").val();
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();

            $("#loader").show();
            PageMethods.fnFinalSubmit(RSPExId, loginId, fnSubmitSuccess, fnFail);
        }

        function fnSubmitSuccess(result) {
            $("#loader").hide();
            if (result == "0") {
                var loginId = $("#ConatntMatter_hdnLogin").val();
                var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
                window.location.href = "RatingStatus.aspx";
            }
            else {
                alert("Due to some technical error, we are unable to process your request !");
            }
        }

        function fnFail(err) {
            flgNotSave = 0;
            $("#loader").hide();
            $("#btnSaveContinue,#btnSaveContinue1").prop("disabled", false);
            alert("Error:" + err._message);
        }

        function fnShowHideReviewBlock(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).next("div.clsReviewBody").slideDown("slow");
                $(ctrl).attr("flg", "0");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/Icons/iconDel.gif");
            }
            else {
                $(ctrl).next("div.clsReviewBody").slideUp("slow");
                $(ctrl).attr("flg", "1");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/Icons/iconAdd.gif");
            }
        }

        function fnShowHideMail(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $("#divMail").slideDown("slow");
                $(ctrl).attr("flg", "0");
                $(ctrl).attr("src", "../../Images/Icons/iconDel.gif");
            }
            else {
                $("#divMail").slideUp("slow");
                $(ctrl).attr("flg", "1");
                $(ctrl).attr("src", "../../Images/Icons/iconAdd.gif");
            }
        }
    </script>
    <script type="text/javascript" language="javascript">
        function whichButton(event) {
            if (event.button == 2)//RIGHT CLICK
            {
                alert("Not Allow Right Click!");
            }
        }
        function noCTRL(e) {
            //alert(e);
            //e.preventDefault();

            var code = (document.all) ? event.keyCode : e.which;
            var msg = "Sorry, this functionality is disabled.";
            if (parseInt(code) == 17) //CTRL
            {
                alert(msg);
                window.event.returnValue = false;
            }
        }

        function isNumberKeyNotDecimal(evt) {
            //debugger;
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;


            return true;
        }

        function isNumericWithOneDecimal(evt) {
            var val1;
            if (!(evt.keyCode == 46 || (evt.keyCode >= 48 && evt.keyCode <= 57)))
                return false;
            var parts = evt.srcElement.value.split('.');
            if (parts.length > 2)
                return false;
            if (evt.keyCode == 46)
                return (parts.length == 1);
            if (evt.keyCode != 46) {
                var currVal = String.fromCharCode(evt.keyCode);
                val1 = parseFloat(String(parts[0]) + String(currVal));
                if (parts.length == 2)
                    val1 = parseFloat(String(parts[0]) + "." + String(currVal));
            }



            if ($(evt.srcElement).is("[crlt]")) {
                if (parts.length == 2 && parts[1].length >= 2) {
                    return false;
                }
            }

            return true;
        }
        function validateEmail(sEmail) {
            var filter = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
            if (filter.test(sEmail)) {
                return true;
            }
            else {
                return false;
            }
        }
        function fnSetBGColor(sender) {
            $(sender).closest("tr").find("td").removeClass("clsBGOrange").removeClass("clsBGRed").removeClass("clsBGGreen")
            if ($(sender).val() == 1) {
                $(sender).closest("td").removeClass("clsBGOrange").removeClass("clsBGRed").addClass("clsBGGreen");
            } else if ($(sender).val() == 2) {
                $(sender).closest("td").removeClass("clsBGGreen").removeClass("clsBGRed").addClass("clsBGOrange");
            } else {
                $(sender).closest("td").removeClass("clsBGOrange").removeClass("clsBGGreen").addClass("clsBGRed");
            }
        }


        function fnStartMeeting(sender) {
            var MeetingId = $(sender).attr("MeetingId");
            if ($(sender).html() == "Start Meeting" || $(sender).html() == "Resume Meeting") {
                if (MeetingId == "") {
                    alert("Meeting Not Available");
                    return false;
                }
                var MeetingLink = $(sender).attr("MeetingLink");
                $("#btnMeeting1").html("End Meeting For Participant");
                $("#btnMeeting1").attr("title", "Click on Close Meeting For Participant when you have finished interaction with the participant but still wish to continue and complete the scoring. Note you must close the Meeting separately. When participant has left, then continue with the scoring and click on Close & Exit to finally close this page.If you wish to close this page along with closing meeting with participant you can directly click on Close & Exit");
                $("#btnMeeting2").show();
                fnSetMeetingStatus(sender, 1, MeetingId, MeetingLink);
            } else {
                fnEndParticipantMeeting(sender);
            }
        }
        var flgMarkEndMeetingForParticipant = 0;
        function fnEndParticipantMeeting(sender) {
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            $("#loader").show();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            PageMethods.fnUpdateActualStartEndTime(RSPExId, (RoleId == 3 ? 2 : 3), 4, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "0") {
                    alert("Meeting ended successfully for Participant");
                    $(sender).hide();
                    $("#btnMeeting2").hide();
                    flgMarkEndMeetingForParticipant = 1;
                } else {
                    alert("Error-" + result.split("|")[1]);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            })
        }
        function fnCloseExit(flg) {
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            flgNotSave = 2;
            if (flgMarkEndMeetingForParticipant == 0 && flg == 1) {
                $("#loader").show();

                fnSave();

            } else {
                fnBack();
            }
        }
        function fnSetMeetingStatus(sender, flgMeeting, MeetingId, MeetingLink) {
            var RSPExId = $("#ConatntMatter_hdnRSPExId").val();
            var BEIUsername = $("#ConatntMatter_hdnBEIUsername").val();
            var BEIPassword = $("#ConatntMatter_hdnBEIPassword").val();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            $("#loader").show();
            PageMethods.fnStartMeeting(RSPExId, flgMeeting, MeetingId, RoleId, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "0") {
                    if (flgMeeting == 2) {
                        alert("Meeting Finished Successfully");
                        $("#btnMeeting2").hide();
                        $(sender).html("Meeting Finished");
                        $(sender).removeAttr("onclick");
                        $(sender).removeAttr("href");
                    }
                    else {
                        window.open(MeetingLink);
                    }
                }
                else {
                    alert("Error-" + result.split("^")[1]);
                }
            }, fnFail);
        }



    </script>
    <style type="text/css">
        .content-wrapper {
            min-height: 100%;
            margin-left: 0px;
            padding: 2px 5px;
            z-index: 89;
        }

        table.table, .table > tbody > tr > td {
            border-top: 1px solid #ddd !important;
            text-align: left;
        }

        ul.ulmain {
            padding: 0;
            margin: 0;
            border-bottom: none;
        }

        .ulmain > li {
            position: relative;
            cursor: pointer;
            color: #BCC1CD;
            font-weight: 500;
            font-size: 0.75rem;
            text-align: left;
            padding: 8px 15px;
            list-style: none;
            border-bottom: 1px dotted #ddd;
        }

            .ulmain > li.clsLIHightlight,
            .ulmain > li.clsLIHightlight:focus,
            .ulmain > li.clsLIHightlight:hover {
                color: #FFF;
                Background: #164396;
                outline: none;
            }

            .ulmain > li:hover {
                background: #164396;
                color: #BCC1CD;
            }

            .ulmain > li::after {
                content: "";
                background: #C60D4A;
                position: absolute;
                left: 0px;
                top: -1px;
                width: 3px;
                height: 100%;
                transition: all 250ms ease 0s;
                transform: scale(0);
            }

            .ulmain > li.clsLIHightlight::after,
            .ulmain > li:hover::after {
                transform: scale(1);
            }

        .divHeader {
            color: #194597;
        }

        .bg-blue {
            background: #194597;
        }

        .clsAnsYes {
            background-color: #defde0;
        }

        .clsAnsPartialYes {
            background-color: #fcf7de;
        }

        .clsAnsNo {
            background-color: #fddfdf;
        }

        td.clsBGGreen {
            background-color: #b3d335;
        }

        td.clsBGOrange {
            background-color: #f7941e;
        }

        td.clsBGRed {
            background-color: #ff0000;
        }

        td.clsCues {
            background-color: #ffffa6;
        }

        #ConatntMatter_divleft li.clsOpen {
            background-color: #9fddec;
            color: #666666;
        }

        #ConatntMatter_divleft li:hover {
            color: #ffffff;
            background-color: #666666;
        }

        li.clsLIHightlight {
            background-color: #ffff82 !important;
            color: #000000 !important;
        }

        td.clstdHighlighted {
            background-color: #ffff82;
        }

        td.clsSaveRating {
            background-color: #9fddec;
        }

        #ConatntMatter_divleft li.clsOpenComptency {
            background-color: #008080;
            color: #ffffff;
        }
    </style>
    <style type="text/css">
        .modal-dialog-center {
            margin-top: 15%;
        }

        td.clsBGGreen {
            background-color: #b3d335;
        }

        td.clsBGOrange {
            background-color: #f7941e;
        }

        td.clsBGRed {
            background-color: #ff0000;
        }

        .main-box {
            padding-bottom: 5px;
            max-width: 93%;
        }

        .container {
            padding-left: 0;
            padding-right: 0;
        }

        #ConatntMatter_divleft {
            border-right: 2px solid #808080;
        }

        .jqte {
            margin: 0px !important;
        }

        #ConatntMatter_divleft ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            width: 100%;
            background-color: #f1f1f1;
        }

        #ConatntMatter_divleft li {
            color: #000;
            padding: 7px 14px;
            border-bottom: 1px solid #a9a9a9;
        }



            #ConatntMatter_divleft li:hover {
                color: #ffffff;
                background-color: #666666;
            }

        #divHeader {
            padding: 6px;
            font-weight: bold;
            background-color: #eeeeee;
        }

        div.clsMaillbl {
            color: #005d9b;
            font-size: 14px;
            font-weight: bold;
            padding-top: 5px;
            padding-bottom: 10px;
        }

        #divMail,
        #divAnswer {
            padding: 10px;
            min-height: 80px;
            max-height: 200px;
            overflow-y: auto;
            border: 2px solid #eeeeee;
        }

        table.clsAns {
            width: 100%;
            border-collapse: collapse;
        }

            table.clsAns th {
                color: #000000;
                padding: 2px;
                font-size: 13px;
                font-weight: bold;
                text-align: center;
                background-color: #dddddd;
                border: 1px solid #eeeeee;
            }

            table.clsAns td {
                color: #000000;
                padding: 1px 0 1px 2px;
                font-size: 9.5pt;
            }

                table.clsAns td.clsInput {
                    text-align: center;
                }

        li.clsLIHightlight {
            background-color: #ffff82 !important;
        }

        div.clsReviewBlock {
            text-align: left;
            margin-bottom: 2px;
            border-radius: 3px;
            border: 1px solid #bce8f1;
        }

        div.clsReviewHead {
            cursor: pointer;
            padding-left: 10px;
            background-color: #d9edf7;
        }

        div.clsReviewBody {
            padding: 10px;
            font-size: 12px;
        }

        table.clstblResponse {
            width: 100%;
            border-collapse: collapse;
        }

            table.clstblResponse th {
                color: #000000;
                padding: 2px;
                font-size: 12px;
                font-weight: bold;
                text-align: center;
                background-color: #dddddd;
                border: 1px solid #eeeeee;
            }

            table.clstblResponse td {
                color: #000000;
                padding: 1px 0 1px 10px;
                font-size: 12px;
                border: 1px solid #eeeeee;
                border-bottom-color: #dddddd;
            }

                table.clstblResponse td:nth-child(2) {
                    width: 18%;
                }

        b, strong {
            font-weight: bold !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div id="loader" class="loader_bg">
        <div class="loader"></div>
    </div>
    <div class="d-block">
        <div id="divRight" class="content-wrapper">
            <table class="table table-sm mb-0 divHeader">
                <thead>
                    <tr>
                        <th style="width: 75px;" class="clsPP">Participant</th>
                        <th style="width: 10px;" class="clsPP">:</th>
                        <th id="tdUserCode" runat="server" style="text-align: left; font-weight: normal" class="clsPP"></th>
                        <th id="tdCaseStudy" runat="server" class="text-right"></th>
                    </tr>
                </thead>
            </table>
            <div id="divBody" runat="server" style="padding: 5px 10px 50px 10px; overflow-y: auto; background-color: #ffffff;">
            </div>
            <div style="border-top: 2px solid #b0b0b0; width: 100%; text-align: center; padding: 15px 0px 15px 0px; bottom: 0px; position: fixed; background-color: #ffffff;" id="divBack">
                <table style="width: 100%">
                    <tr>

                        <td style="width:55%;text-align:right">
                            <a href="#" onclick="fnSave(1)" class="btns btn-submit" id="btnSaveContinue">Save</a>
                            <a href="#" onclick="fnSave(2)" class="btns btn-submit" id="btnSaveContinue1">Submit</a>
                            <a href="#" onclick="fnBack()" class="btns btn-submit">Back</a>
                        </td>
                        <td id="dvmsg" style="padding:0px 5px;text-align:left">
                        </td>

                    </tr>
                </table>


            </div>
        </div>
    </div>


    <%--<div id="divContainer">
        <div id="" style="width: 22%; display: inline-block;" runat="server"></div>
        <div id="" style="width: 77%; display: inline-block; vertical-align: top;">
            <div id="divHeader">
                <table style="width: 100%; font-size: 12pt">
                    <tr>
                        <td style="width: 120px; padding-left: 10px;">User-Code</td>
                        <td style="width: 20px;">:</td>
                        <td id="tdUserCode" runat="server" style="font-weight: 100;"></td>
                        <td id="tdCaseStudy" runat="server" style="text-align: right; padding-right: 10px;"></td>
                    </tr>
                </table>
            </div>
            <div id="divBody" style="padding: 0; overflow-y: auto; background-color: #ffffff;">
            </div>
            <div style="text-align: center; margin-top: 10px;" id="divBack">
                <a href="#" onclick="fnSave()" style="display: none" id="btnSaveContinue" class="btns btn-submit">Save</a>
                <a href="#" onclick="fnBack()" class="btns btn-submit">Back</a>
            </div>
        </div>
    </div>--%>

    <div id="dvDialog" style="display: none"></div>
    <div id="divAlert" style="display: none;" class="modal" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content" style="padding: 2px;">
                <div class="modal-header" style="padding: 2px">
                    <h3 class="modal-title" id="divAlertHead">Responses</h3>
                    <button type="button" class="close" aria-hidden="true" onclick="fnCloseModal()">
                        <img src="../../Images/button_cancel.png" />
                    </button>

                </div>
                <div class="modal-body" style="padding: 2px; padding-top: 0px; height: 500px; overflow-y: auto" id="divAlertbody">
                </div>
                <div class="modal-footer" id="divAlertFooter">
                    <button type="button" data-backdrop="static" data-keyboard="false" class="btn btn-primary orange" onclick="fnSaveSubmit()">Confirm</button>
                    <button type="button" data-backdrop="static" data-keyboard="false" class="btn btn-primary orange" onclick="fnCloseModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divAlertSecond" style="display: none;" class="modal" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-center" role="document">
            <div class="modal-content" style="padding: 2px;">
                <div class="modal-header" style="padding: 2px">
                    <h3 class="modal-title" id="divAlertHeadSeconf">Alert!!!</h3>
                    <button type="button" class="close" aria-hidden="true" onclick="fnCloseModal()">
                        <img src="../../Images/button_cancel.png" />
                    </button>
                </div>
                <div class="modal-body" style="padding: 2px; padding-top: 0px; overflow-y: auto" id="divAlertbodySecond">
                </div>
                <div class="modal-footer" id="divAlertFooterSecond">
                    <button type="button" data-backdrop="static" data-keyboard="false" class="btn btn-primary orange" onclick="fnConfirmYesOnSave()">Yes</button>
                    <button type="button" data-backdrop="static" data-keyboard="false" class="btn btn-primary orange" onclick="fnCloseModalSecond()">No</button>
                </div>
            </div>
        </div>
    </div>


    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnRSPExId" runat="server" />
    <asp:HiddenField ID="hdnMailID" runat="server" />
    <asp:HiddenField ID="hdnflgCallFrom" Value="1" runat="server" />
    <asp:HiddenField ID="hdnBEIUsername" Value="" runat="server" />
    <asp:HiddenField ID="hdnBEIPassword" Value="" runat="server" />
    <asp:HiddenField ID="hdnExerciseId" Value="0" runat="server" />
    <asp:HiddenField ID="hdnRoleId" Value="0" runat="server" />

</asp:Content>
