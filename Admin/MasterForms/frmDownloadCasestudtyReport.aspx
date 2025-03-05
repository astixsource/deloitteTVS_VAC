<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmDownloadCasestudtyReport.aspx.cs" Inherits="Mapping" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script> 
    <script>
        function fnDownloadReport(cntr, ctrl) {
            //var IMEI = $("#hdnIMEI").val();
            //var login = $("#hdnLogin").val();
            //var RptDate = $("#hdnRptDate").val();
            //var PersonNodeID = $(ctrl).closest("tr").attr("PersonNodeID");
            //var PersonNodeTYpe = $(ctrl).closest("tr").attr("PersonNodeTYpe");
            //var PersonAttendanceID = $(ctrl).closest("tr").attr("PersonAttendanceID");

            //fnStartLoading();

            PageMethods.ChangeApprovalStatus(IMEI, login, RptDate, PersonNodeID, PersonNodeTYpe, PersonAttendanceID, cntr, ChangeApprovalStatus_pass, fnfailed, cntr);
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
                if ($(window).width() - (e.pageX + 20) < 330) {
                    mousex = e.pageX - 320;
                }
                var mousey = e.pageY + 10; //Get Y coordinates
                $('.customtooltip')
                    .css({ top: mousey, left: mousex })
            });
        }


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
        function isNumericWithOneDecimal(evt, ctrl) {
            if (!(evt.keyCode == 46 || (evt.keyCode >= 48 && evt.keyCode <= 57))) {
                return false;
            }
            var parts = evt.srcElement.value.split('.');
            if (parts.length > 2) {
                return false;
            }
            if (evt.keyCode == 46)
                return (parts.length == 1);
            if (evt.keyCode != 46) {
                var currVal = String.fromCharCode(evt.keyCode);
                val1 = parseFloat(String(parts[0]) + String(currVal));
                if (parts.length == 2)
                    val1 = parseFloat(String(parts[0]) + "." + String(currVal));
            }
            return true;
        }
    </script>
    <script>
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            $("#ConatntMatter_dvMain").css("min-height", $(window).height() - 280);
            $("#ConatntMatter_ddlBatch").on("change", function () {
                fnGetMapping();
            });
            fnGetMapping();
        });
        function fnGetMapping() {
            var batch = $("#ConatntMatter_ddlBatch").val();

            $("#dvloader").show();
            PageMethods.fnGetEntries(batch, fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#ConatntMatter_dvMain").html(res.split("~")[0]);
            $("#tblMapping").find("select").each(function () {
                $(this).html($("#ConatntMatter_hdnUserlst").val());
                $(this).val($(this).attr("defval"));
            });

            //$("#ConatntMatter_dvMain").prepend("<div id='tblheader' style='position:fixed'></div>");
            //if ($("#tblScheduling").length > 0) {
            //    var wid = $("#tblScheduling").width(), thead = $("#tblScheduling").find("thead").eq(0).html();
            //    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered bg-white table-sm clsTarget' style='width:" + (wid - 1) + "px;margin:0'><thead class='thead-light text-center'>" + thead + "</thead></table>");
            //    $("#tblScheduling").css({ "width": wid, "min-width": wid });
            //    $("#tblheader").css({ "width": wid, "min-width": wid });
            //    for (i = 0; i < $("#tblScheduling").find("th").length; i++) {
            //        var th_wid = $("#tblScheduling").find("th")[i].clientWidth;
            //        $("#tblEmp_header, #tblScheduling").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
            //    }
            //    $("#tblEmp_header thead").eq(0).css("height", ($("#tblScheduling thead").height()) + "px");
            //    //$("#tblScheduling").css("margin-top", "-" + ($("#tblEmp_header").height()-10) + "px");
            //}

            Tooltip(".clsCustomTooltip");
            $("#dvloader").hide();
        }
        function fnfail() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }

    </script>
    <script>
        function fnWashup(flg) {
            window.location.href = "frmWashUp.aspx?flg=" + flg;
        }
        function fnA3Sheet() {
            var cntr = 0, ind = 0;
            $("#tblScheduling").find("tbody").eq(0).find("tr").each(function () {
                cntr++;
                if ($(this).find("input[type='radio']").is(":checked")) {
                    ind = cntr;
                }
            });
            window.location.href = "frmA3Sheet.aspx?seq=" + ind;
        }
    </script>
    <script>


        function fnAssessorRating(ctrl) {
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_hdnBatch").val();
            var RspExcersice = $(ctrl).closest("td").attr("RspExcersiceId");
            $("#ConatntMatter_hdnRSPExcersice").val(RspExcersice);
            $("#ConatntMatter_hdnFileName").val($(ctrl).closest("td").attr("fileName"));

            $("#ConatntMatter_btnDownload").click();
        }
        function fnInBasket(ctrl) {
            var login = $("#ConatntMatter_hdnLogin").val();
            var RspExcersice = $(ctrl).closest("td").attr("RspExcersiceId");
            $("#ConatntMatter_hdnRSPExcersice").val(RspExcersice);

            $("#dvloader").show();
            PageMethods.fnInBasket(RspExcersice, login, fnInBasket_pass, fnfail);
        }

        function fnInBasket_pass(res) {
            if (res.split("^")[0] == "0") {
                $("#divInBasket").html(res.split("^")[1]);
                $("#divInBasket").dialog({
                    modal: true,
                    width: '90%',
                    height: $(window).height() - 100,
                    title: "In-Basket Evaluation :",
                    buttons: {
                        "Submit": function () {
                            fnSaveInBasket();
                        },
                        Cancel: function () {
                            $(this).dialog("close");
                        }
                    }
                });
            }
            else {
                alert("Due to some technical reasons, we are unable to process your request !");
            }
            $("#dvloader").hide();
        }

        function fnProsCons(ctrl, cntr) {
            $("#divComment").find("textarea").eq(0).val('');
            $("#divComment").find("textarea").eq(0).val($(ctrl).val());
            var title = "";
            if (cntr == 1)
                title = "Pros : ";
            else
                title = "Cons : ";

            $("#divComment").dialog({
                modal: true,
                width: 540,
                title: title,
                buttons: {
                    "Submit": function () {
                        $(ctrl).val($("#divComment").find("textarea").eq(0).val());
                        $(this).dialog("close");
                    },
                    Cancel: function () {
                        $(this).dialog("close");
                    }
                }
            });
        }
        function fnSaveInBasket() {
            var valComp = "";
            var tbl = [];
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_hdnBatch").val();

            $("#tblInBasket").find("tbody").eq(0).find("tr").each(function () {
                tbl.push({
                    'col1': $("#ConatntMatter_hdnRSPExcersice").val(),
                    'col2': $(this).attr("competencyId"),
                    'col3': $(this).find("td").eq(2).find("input[iden='Pros']").val(),
                    'col4': $(this).find("td").eq(2).find("input[iden='Cons']").val(),
                    //'col5': $(this).find("td").eq(1).find("input").val() == "" ? 0.00 : $(this).find("td").eq(1).find("input").val()
                    //'col5': $(this).find("td").eq(1).html() == "" ? 0.00 : $(this).find("td").eq(1).html()
                    'col5': $(this).find("td").eq(1).find("span").eq(0).html()
                });

                if (valComp == "") {
                    if ($(this).find("td").eq(2).find("input[iden='Pros']").val() == "" || $(this).find("td").eq(2).find("input[iden='Cons']").val() == "") {
                        valComp = $(this).find("td").eq(0).html();
                    }
                }
            });

            if (valComp == "") {
                $("#dvloader").show();
                PageMethods.fnSaveInBasketEval(tbl, login, batch, fnSaveInBasketEval_pass, fnfail);
            }
            else {
                var validate = confirm("Comments (Pros/Cons) for Competency - " + valComp + ", is blank. Please press Ok to continue.");
                if (validate) {
                    $("#dvloader").show();
                    PageMethods.fnSaveInBasketEval(tbl, login, batch, fnSaveInBasketEval_pass, fnfail);
                }
            }
        }

        function fnSaveInBasketEval_pass(res) {
            if (res.split("^")[0] == "0") {
                alert("In-Basket details saved successfully !");
                $("#divInBasket").dialog("close");
            }
            else {
                alert("Due to some technical reasons, we are unable to process your request !");
            }
            $("#dvloader").hide();
        }
        function fnAddScore(ctrl) {
            var CompetencyId = $(ctrl).closest("td").attr("CompetencyId");
            var score = (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) + 0.25).toFixed(2);
            $(ctrl).closest("td").find("span").eq(0).html(score);
            $(ctrl).closest("td").removeClass("cls-score-red");
            $(ctrl).closest("td").removeClass("cls-score-yellow");
            $(ctrl).closest("td").removeClass("cls-score-green");
            if (parseFloat(score).toFixed(2) < 2.5)
                $(ctrl).closest("td").addClass("cls-score-red");
            else if (parseFloat(score).toFixed(2) < 2.75)
                $(ctrl).closest("td").addClass("cls-score-yellow");
            else
                $(ctrl).closest("td").addClass("cls-score-green");
        }
        function fnMinusScore(ctrl) {
            if (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) > 1.50) {
                var score = (parseFloat($(ctrl).closest("td").find("span").eq(0).html()) - 0.25).toFixed(2);
                $(ctrl).closest("td").find("span").eq(0).html(score);
                $(ctrl).closest("td").removeClass("cls-score-red");
                $(ctrl).closest("td").removeClass("cls-score-yellow");
                $(ctrl).closest("td").removeClass("cls-score-green");
                if (parseFloat(score).toFixed(2) < 2.5)
                    $(ctrl).closest("td").addClass("cls-score-red");
                else if (parseFloat(score).toFixed(2) < 2.75)
                    $(ctrl).closest("td").addClass("cls-score-yellow");
                else
                    $(ctrl).closest("td").addClass("cls-score-green");
            }
            else {
                alert("Scoring not allowed below 1.50 !");
            }
        }


        function fnGotoMeeting(ctrl) {
            var batch = $("#ConatntMatter_hdnBatch").val();
            var RspExcersice = $(ctrl).closest("td").attr("RspExcersiceId");
            $("#ConatntMatter_hdnRSPExcersice").val(RspExcersice);

            $("#dvloader").show();
            PageMethods.fnGotoMeeting(RspExcersice, batch, fnGotoMeeting_pass, fnfail);
        }
        function fnGotoMeeting_pass(res) {
            if (res.split("^")[0] == "0") {
                window.open(res.split("^")[1]);
            }
            else {
                alert("Due to some technical reasons, we are unable to process your request !");
            }
            $("#dvloader").hide();
        }

        function fnSelectPart() {
            $("#btnA3Sheet").removeClass("btn-secondary");
            $("#btnA3Sheet").addClass("btn-info");
            $("#btnA3Sheet").attr("onclick", "fnA3Sheet();");
        }
    </script>

    <style>
        .clsBatchName{
            color: #0080C0;
            font-weight: bold;
            padding-bottom:4px;
        }

        #ConatntMatter_dvMain {
            overflow: auto;
        }

        .table th {
            vertical-align: middle !important;
            padding:2px !important;
        }

        .table td {
            padding:2px !important;
        }

       /* #tblScheduling th {
            color: transparent !important;
        }*/

        #tblScheduling td {
            vertical-align: middle;
        }

           

            #tblScheduling td.cls-5,
            #tblScheduling td.cls-6,
            #tblScheduling td.cls-7,
            #tblScheduling td.cls-8,
            #tblScheduling td.cls-9,
            #tblScheduling td.cls-10,
            #tblScheduling td.cls-11,
            #tblScheduling td.cls-12,
            #tblScheduling td.cls-13,
            #tblScheduling td.cls-14 {
                width: 100px;
                text-align: center;
            }

            #tblScheduling td.cls-99 {
                width:  40px;
                text-align: center;
            }

        .cls-bg-gray {
            background: #ccc;
        }

        .table th,
        .table td {
            border-color: #ccc !important;
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

            .customtooltip li {
                text-decoration: none;
            }
    </style>
    <style>
        #tblInBasket td {
            vertical-align: middle;
        }
        #tblInBasket td.cls-1 {
            width: 280px;
        }

        #tblInBasket td.cls-4 {
            width: 120px;
            text-align: center;
        }

        #tblInBasket td.cls-99 span {
            color: #666;
            font-weight: 700;
        }

        input[type='text'] {
            width: 90%;
            border-color: transparent !important;
        }
    </style>
    <style>
        .btn{
            font-size: 14px;
        }
        .clstdbtn {
            margin-left: 6px !important;
            font-size: 9px !important;
            padding: 2px 4px !important;
        }
        span.clsScore {
            padding: 0 5px;
            white-space: nowrap;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Download Case study Report</h3>
        <div class="title-line-center"></div>
   
    </div>
   <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch :</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlBatch" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            </asp:DropDownList>
        </div>
    </div>
    <div id="dvMain" runat="server"></div>
   
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
  
    <asp:Button ID="btnDownload" runat="server" Text="" OnClick="btnDownload_Click" Style="visibility: hidden" />
    <asp:HiddenField ID="hdnRSPExcersice" runat="server" />
    <asp:HiddenField ID="hdnFileName" runat="server" />
    <asp:HiddenField ID="hdnBatch" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
</asp:Content>
