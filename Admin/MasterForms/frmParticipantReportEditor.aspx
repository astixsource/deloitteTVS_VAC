<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmParticipantReportEditor.aspx.cs" Inherits="frmParticipantReportEditor" ValidateRequest="false" %>

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
            $("#btnSubmit,#btnSubmit1").hide();
            $("#dvloader").hide();


            // fnGetMapping();
        });

        function fnParticipant(ctrl) {
            $("#dvEmp").html('');
            $("#dvScore").html('');
            $("#dvExcersiceBlock").hide();
            $("#txtCmptncyComments").val("");
            $("#btnSubmit").hide();
            $("#ConatntMatter_dvBtns").find('a.active').removeClass('active');
            $(ctrl).addClass('active');
            $("#ConatntMatter_hdnSeqNo").val($(ctrl).attr("ind"));
            $("#ConatntMatter_ddlCompetency").val('0');
            $("#dvExcersice").html('');
            $("#lblmsg").html('');
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
            var batch = $("#ConatntMatter_ddlBatch").val();
            $("#dvEmp").html("");
            $("#btnSubmit,#btnSubmit1").hide();
            $("#lblmsg").html('');
            if (batch == 0) {
                //$("#ConatntMatter_ddlParticipantList").focus();
            }
            //MeetingId = $("#ConatntMatter_ddlBatch option:selected").attr("MeetingId");
            //var NumberOfParticipants = $("#ConatntMatter_ddlBatch option:selected").attr("NumberOfParticipants");
            //BEIUsername = $("#ConatntMatter_ddlBatch option:selected").attr("BEIUsername");
            //BEIPassword = $("#ConatntMatter_ddlBatch option:selected").attr("BEIPassword");
            //MeetingLink = $("#ConatntMatter_ddlBatch option:selected").attr("MeetingLink");
            //$("#btnWashup").hide();
            //$("#btnWashup1").hide();

            //if (batch != 0) {
            //    document.getElementById("theTime").innerHTML = "Meeting to start";
            //    $("#btnWashup").show();
            //    $("#btnWashup1").show();
            //    $("#ConatntMatter_hdnCounter").val($("#ConatntMatter_ddlBatch option:selected").attr("remainingsec"));

            //}
            //$("#ConatntMatter_hdnSeqNo").val("0");
            //var sbbtns = "";
            //sbbtns += ("<a href='#' class='btn btn-primary btn-sm active' style='padding:.10rem 1.0rem !important;' ind='0' onclick='fnParticipant(this);'>Compiled</a>");
            //  for (var i = 0; i < NumberOfParticipants; i++)
            //  {
            //      sbbtns += ("<a href='#' class='btn btn-primary btn-sm' ind='" + (i + 1) + "' style='margin-left:15px;padding:.10rem 1.0rem !important;' onclick='fnParticipant(this);'>P" + (i + 1) + "</a>");
            //    }
            $("#dvloader").show();
            PageMethods.fnGetParticipants(batch, $("#ConatntMatter_hdnLogin").val(), function (result) {
                $("#ConatntMatter_ddlParticipantList").html(result);


                $("#dvloader").hide();
            }, fnfail);
            // fnGetMapping();
        }

        function fnChangeParticipant() {
            var batch = $("#ConatntMatter_ddlParticipantList").val();
            if (batch == 0) {
                $("#dvEmp").html("");
                $("#btnSubmit,#btnSubmit1").hide();
                //$("#ConatntMatter_ddlParticipantList").focus();
                return false;
            }

            fnGetMapping();
        }


        function fnGetMapping() {
            var batch = $("#ConatntMatter_ddlBatch").val();
            var EmpNodeId = $("#ConatntMatter_ddlParticipantList").val();
            $("#dvShowHideCol").hide();
            $("#dvloader").show();
            $("#lblmsg").html('');
            PageMethods.fnGetEntries(batch, EmpNodeId, $("#ConatntMatter_hdnLogin").val(), fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#dvEmp").html('');
            $("#btnSubmit,#btnSubmit1").hide();
            $("#lblmsg").html('');
            $("#dvloader").hide();
            if (res.split("|")[0] == "0") {
                //$("#btnSubmit").show();
                $("#dvEmp").html(res.split("|")[1]);
                var flgSave =res.split("|")[2];
               
                $(".clsheader-1").eq(0).closest("tr").css("display", "table-row");
                $(".clsheader-1-1,.clsheader-2-1,.clsheader-3-1,.clsheader-4-1,.clsheader-5-1").eq(1).css({
                    "font-size": "15pt !important",
                    "text-align": "left",
                    "padding-top": "5px !important"
                });

                $(".clsHeader-12_0").eq(0).css({
                    "text-align": "left",
                    "padding-top": "5px !important"
                });
               // $("#TblReport_12,#TblReport_14").hide();
                $(".clsheader-2-1").closest("tr").hide();
                $(".clsheader-2-1").eq(0).closest("tr").css("display", "table-row");

                $(".clsheader-5-1").closest("tr").hide();
                $(".clsheader-5-1").eq(0).closest("tr").css("display", "table-row");

                $(".clsheader-3-1").html("<i class='fa fa-minus' style='margin-right:5px;cursor:pointer' onclick=\"fnShowHideTbl(this,'18')\"></i>" + $(".clsheader-3-1").html())
                $(".clsheader-4-1").html("<i class='fa fa-minus' style='margin-right:5px;cursor:pointer' onclick=\"fnShowHideTbl(this,'20')\"></i>" + $(".clsheader-4-1").html())
                //$("#TblReport_18").hide();
                //$("#TblReport_20").hide();
                $('.textEditor').jqte({
                    ol: false,
remove: true
                });
                var tbl = [];
                $("input.clsrdoAOSAOd:checkbox").bind("change", function () {
                    $(this).closest("tr").find("input:checkbox").not(this).prop("checked", false);
                    //tbl1.push({
                    //    'CompetencyId': $(this).attr("CompetencyId"),
                    //    'flgAOS_AOD': ($(this).is(":checked") ? $(this).val() : "0"),
                    //});
                });

                if (flgSave == "2") {
                    $("#btnSubmit,#btnSubmit1").hide();
                    $('div.jqte_editor').attr("contenteditable", false);
                    $("#lblmsg").html("Report Generated For This Participant");
                } else {
                    $("#btnSubmit,#btnSubmit1").show();
                }
            }
            else {
                alert("Due to some technical reasons, we are unable to process your request !");
            }
            
        }




        function fnfail() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        var flgSubmit = 0;
        function fnSaveSections(flgSubmit) {
            if (flgSubmit == 2) {
                var scon = confirm("Are you sure you want to submit?");
                if (scon == false) {
                    return false;
                }
            }
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var EmpNodeId = $("#ConatntMatter_ddlParticipantList").val();
            var tbl = []; var tbl1 = [];
            var TotalArea = $("textarea.textEditor").length;
            var FilledTextArea = 0;
            $("textarea.textEditor").each(function () {
                if ($(this).val().trim() != "") {
                    FilledTextArea++;
                   
                }
 tbl.push({
                        'SectionId': $(this).attr("SectionId"),
                        'RecordId': $(this).attr("recordid"),
                        'Descr': $(this).val(),
                    });
            });

            //$("input.clsrdoAOSAOd:checked").each(function () {
            //        tbl1.push({
            //            'CompetencyId': $(this).attr("CompetencyId"),
            //            'flgAOS_AOD': ($(this).is(":checked")? $(this).val():"0"),
            //        });
            //});

            //if (tbl1.length == 0) {
            //    alert("Select AOS/AOP/AOD for atleast one competency");
            //    return false;
            //}
            //if (tbl1.length >3) {
            //    alert("Selection for AOS/AOP/AOD can not be more than three competencies");
            //    return false;
            //}
            if (flgSubmit == 2) {
                if (TotalArea > FilledTextArea) {
                    var sConfirm = confirm("Some report fields are blanks, \nDo you still want to continue? ");
                    if (sConfirm == false) {
                        return false;
                    }
                }
            }

            $("#dvloader").show();
            PageMethods.fnSave(batch, EmpNodeId, tbl, login, flgSubmit, fnSave_pass, fnfail, flgSubmit);
        }
        function fnSave_pass(res, flgSubmit) {
            if (res.split("|")[0] == "0") {
                if (flgSubmit == 2) {
                    alert("Submitted successfully !");
                    $("#btnSubmit,#btnSubmit1").hide();
                    $('div.jqte_editor').attr("contenteditable", false);
                }
                $("#dvloader").hide();
                // fnGetMapping();
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request,kindly try again !</br>Error:" + res.split("|")[1]);
            }
        }

        function fnShowScore() {
            $("#dvloader").show();
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var EmpNodeId = $("#ConatntMatter_ddlParticipantList").val();
            PageMethods.fnGetScore(batch, EmpNodeId, function (results) {
                $("#dvloader").hide();
                fnSHowDialog(results);
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
            }, function (result) {
                $("#dvloader").hide();
                fnSHowDialog(results);
            });
        }

        function fnSHowDialog(results) {
            $("#dvScore").html(results);
            $("#dvScore").dialog({
                title:"Score",
                modal: true,
                width: "auto",
                height: "auto",
                "Close": function () {
                    $("#dvScore").dialog('destroy');
                },
                buttons: {
                    "Close": function () {
                        $("#dvScore").dialog('close');
                    }
                }
            })
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



        function fnExcelReport() {
            var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
            tab_text = tab_text + '<head><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>';
            tab_text = tab_text + '<x:Name>Integration Sheet</x:Name>';
            tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
            tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
            tab_text = tab_text + "<table border='1px'>";
            var dv1 = $('#dvEmp').clone();
            dv1.find("table").attr("border", "1");
            dv1.find("table").attr("rules", "all");
            tab_text = tab_text + dv1.html();
            tab_text = tab_text + $('#dvScore').html();
            tab_text = tab_text + '</table></body></html>';
            var data_type = 'data:application/vnd.ms-excel';
            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");

            if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
                if (window.navigator.msSaveBlob) {
                    var blob = new Blob([tab_text], {
                        type: "application/vnd.ms-excel;charset=utf-8;"
                    });
                    navigator.msSaveBlob(blob, "IntegrationSheet+" + $("#ConatntMatter_ddlBatch option:selected").text() + ".xls");
                }
            } else {
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));
                element.setAttribute('download', "IntegrationSheet+" + $("#ConatntMatter_ddlBatch option:selected").text() + ".xls");
                element.style.display = 'none';
                document.body.appendChild(element);
                element.click();
                document.body.removeChild(element);
                //window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text),'IntegrationSheet');
            }
        }

        function fnShowHideTbl(sender, tblIndex) {
            if ($("#TblReport_" + tblIndex).css("display") == "none") {
                $("#TblReport_" + tblIndex).show();
                $("#TblHeader_" + tblIndex + " td.clsheader-3").closest("tr").css("display", "table-row");
                $(sender).removeClass("fa-plus").addClass("fa-minus");
            } else {
                $("#TblReport_" + tblIndex).hide();
                $("#TblHeader_" + tblIndex + " td.clsheader-3").closest("tr").css("display", "none");
                $(sender).removeClass("fa-minus").addClass("fa-plus");
            }
        }
    </script>
    <style type="text/css">
        cls-bg-gray {
            background: #ccc;
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
         #tblEmp > thead.thead-light th{
            background-color: #ffc000;
        }
        .jqte_editor, .jqte_source {
            padding: 10px;
            background: #FFF;
            min-height: 120px;
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

        #tblEmp td.cls-3 {
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
                    min-width: 140px;
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

        .clsheader-2-1,.clsheader-1-1,.clsheader-5-1,.clsheader-3-1,.clsheader-4-1 {
            font-size: 15.5pt !important;
            font-weight: bold;
            padding-left: 8px !important;
        }

        .clsheader-2-2,.clsheader-5-2 {
            font-size: 12pt !important;
            font-weight: bold;
        }

        .clsheader-3 {
            font-size: 10.5pt !important;
            font-weight: bold;
            padding-left: 30px !important;
        }



        li {
            margin-top: 8px;
        }

            li:first-child {
                margin-top: 0;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix" style="margin-bottom: 0px;position:fixed;width:87%;background-color:#f4f4f4;z-index:100">
        <table style="width:100%">
            <tr>
                <td style="width:50%;padding-left:8px !important">
 <table style="width:100%">
     <tr>
         <td style="font-size:11pt !important;width:10.5%">
        Batch : </td>
         <td style="width:50%">
        <asp:DropDownList ID="ddlBatch" runat="server" CssClass="form-control" style="height:28px;padding: 0.325rem .75rem;" onchange="fnChangeBatch()"></asp:DropDownList>
             </td><td>
        <asp:DropDownList ID="ddlParticipantList" runat="server" CssClass="form-control"  style="height:28px;padding: 0.325rem .75rem;" onchange="fnChangeParticipant()">
            <asp:ListItem Value="0">-- Select Participant --</asp:ListItem>
        </asp:DropDownList>
                 </td>
         </tr>
    </table>
                </td>
                <td>
                    <h3 class="text-center" style="font-weight: bold;text-align:left;display:inline-block">Profile Summary</h3>
                </td>
                <td style="text-align:right"><input type="button" onclick="fnShowScore()" id="btnShowScore" value="Show Score" class="btn btn-primary btn-sm" /></td>
            </tr>

        </table>
        
        <div class="title-line-center" style="width: 100%"></div>
    </div>
   

    <div id="dvEmp" style="overflow-x: auto; margin-bottom: .0rem; padding: 50px 0px 10px 0px"></div>

    <div class="text-center" style="margin-top: 5px; margin-bottom: 10px;">
        <label id="lblmsg"></label>
        <input type="button" id="btnSubmit1" value="Save & Continue" onclick="fnSaveSections(1)" class="btns btn-cancel" style="padding: 10px 20px" />
        <input type="button" id="btnSubmit" value="Final Submit" onclick="fnSaveSections(2)" class="btns btn-cancel" style="padding: 10px 20px" />
    </div>
    <div id="dvBtns" runat="server" style="height: 10px"></div>
    <div id="dvImgDialog" style="display: none"></div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <div id="dvScore" style="display: none"></div>

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
