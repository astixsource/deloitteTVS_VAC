<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmScheduling.aspx.cs" Inherits="Mapping" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script>
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
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
        function isNumericWithColon(evt, ctrl) {
            var msg = "Time format must be like hh:mm e.g. 04:08 ! ";
            if (!(evt.keyCode == 58 || (evt.keyCode >= 48 && evt.keyCode <= 57))) {
                ValidationTooltip(ctrl, msg);
                return false;
            }
            var parts = evt.srcElement.value.split(':');
            if (parts.length > 2) {
                ValidationTooltip(ctrl, msg);
                return false;
            }
            if (evt.keyCode == 58)
                return (parts.length == 1);
            if (evt.keyCode != 58) {
                var currVal = String.fromCharCode(evt.keyCode);
                val1 = parseFloat(String(parts[0]) + String(currVal));
                if (parts.length == 2)
                    val1 = parseFloat(String(parts[0]) + "." + String(currVal));
            }
            return true;
        }
    </script>
    <script>
        function ValidationTooltip(ctrl, msg) {
            fnValidationTooltip();
            $('<p class="validatetooltip"><span style="display:table-cell">' + msg + '</span><i class="fa fa-times clsClosetooltip" onclick="fnValidationTooltip();"></i></p>')
                //.html(msg)
                .appendTo('body')
                .fadeIn('slow');
            $('.validatetooltip')
                .css({ top: $(ctrl).offset().top + 20, left: $(ctrl).offset().left + 5 });
        }
        function fnValidationTooltip() {
            $(".validatetooltip").remove();
        }

        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            $("#ConatntMatter_dvMain").css("height", $(window).height() - 280);
            //$("#dvloader").hide();
            fnGetMapping();
        });

        function fnGetParticipant() {
            var batch = $("#ConatntMatter_ddlBatch").val();
            if (batch == "0") {
                $("#ddlParticipant").html("<option value='0'>All</option>");
                fnGetMapping();
            }
            else {
                $("#dvloader").show();
                PageMethods.fnGetParticipants(batch, fnGetParticipants_pass, fnfail);
            }
        }
        function fnGetParticipants_pass(res) {
            $("#ddlParticipant").html(res);
            $("#ddlParticipant").val("0");
            fnGetMapping();
        }

        function fnGetMapping() {
            var batch = $("#ConatntMatter_ddlBatch").val();
            var Participant = $("#ddlParticipant").val();

            $("#dvloader").show();
            PageMethods.fnGetEntries(batch, Participant, fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#ConatntMatter_dvMain").html(res.split("^")[0]);
            if (res.split("^")[1] == "0") {
                fnInitialize();
                $("#ConatntMatter_dvMain").css("height", $(window).height() - 280);
               // $("#btnSubmit").show();
            }
            else {
                $("#ConatntMatter_dvMain").css("height", $(window).height() - 250);
                $("#btnSubmit").hide();
            }
            $("#dvloader").hide();
        }
        function fnAddZero(str, cntr) {
            if (str.toString().length == 1)
                return "0" + str;
            else
                return str;
        }
        function fnInitialize() {
            $("#tblScheduling").find("td.cls-12").each(function () {
                var time = $(this).html();
                var typeid = $(this).closest("tr").attr("typeid");
                if (time != "" && typeid == "10") {
                    $(this).html("<input type='text' maxlength='5' onkeypress='return isNumericWithColon(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' class='cls-time' defval='" + time + "' value='" + time + "' onfocus='fntxtfocus(1, this);' onblur='fntxtblur(1, this);'/>");
                }
            });
            $("#tblScheduling").find("td.cls-13").each(function () {
                var time = $(this).html();
                var typeid = $(this).closest("tr").attr("typeid");
                if (time != "" && typeid == "10") {
                    $(this).html("<input type='text' maxlength='5' onkeypress='return isNumericWithColon(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' class='cls-time' defval='" + time + "' value='" + time + "' onfocus='fntxtfocus(2, this);' onblur='fntxtblur(2, this);'/>");
                }
            });
            $("#tblScheduling").find("td.cls-14").each(function () {
                var time = $(this).html();
                if (time != "") {
                    $(this).html("<input type='text' maxlength='5' onkeypress='return isNumericWithColon(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' class='cls-time' defval='" + time + "' value='" + time + "' onfocus='fntxtfocus(3, this);' onblur='fntxtblur(3, this);'/>");
                }
            });
            $("#tblScheduling").find("td.cls-15").each(function () {
                var time = $(this).html();
                if (time != "") {
                    $(this).html("<input type='text' maxlength='5' onkeypress='return isNumericWithColon(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' class='cls-time' defval='" + time + "' value='" + time + "' onfocus='fntxtfocus(4, this);' onblur='fntxtblur(4, this);'/>");
                }
            });
            $("#tblScheduling").find("td.cls-16").each(function () {
                var time = $(this).html();
                if (time != "") {
                    $(this).html("<input type='text' maxlength='5' onkeypress='return isNumericWithColon(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' class='cls-time' defval='" + time + "' value='" + time + "' onfocus='fntxtfocus(5, this);' onblur='fntxtblur(5, this);'/>");
                }
            });
            $("#tblScheduling").find("td.cls-17").each(function () {
                var time = $(this).html();
                if (time != "") {
                    $(this).html("<input type='text' maxlength='5' onkeypress='return isNumericWithColon(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' class='cls-time' defval='" + time + "' value='" + time + "' onfocus='fntxtfocus(6, this);' onblur='fntxtblur(6, this);'/>");
                }
            });
        }
        function fntxtfocus(cntr, ctrl) {
            $(ctrl).addClass("cls-time-active");
        }
        function fntxtblur(cntr, ctrl) {
            var flgValidate = 0;
            $(ctrl).removeClass("cls-time-active");

            if ($(ctrl).val() == "") {
                $(ctrl).val($(ctrl).attr("defval"));
                flgValidate = 1;
                msg = "Field cann't be blank";
            }
            else if ($(ctrl).val().length != 5) {
                $(ctrl).val($(ctrl).attr("defval"));
                flgValidate = 1;
                msg = "Invalid Time Format. Time must be in hh:mm e.g. 20:10 !";
            }
            else if ($(ctrl).val().indexOf(":") != 2) {
                $(ctrl).val($(ctrl).attr("defval"));
                flgValidate = 1;
                msg = "Invalid Time Format. Time must be in hh:mm e.g. 20:10 !";
            }
            else if (parseInt($(ctrl).val().split(":")[0]) > 23) {
                $(ctrl).val($(ctrl).attr("defval"));
                flgValidate = 1;
                msg = "Invalid Time Format. Time must be in hh:mm e.g. 20:10 !";
            }
            else if (parseInt($(ctrl).val().split(":")[1]) > 59) {
                $(ctrl).val($(ctrl).attr("defval"));
                flgValidate = 1;
                msg = "Invalid Time Format. Time must be in hh:mm e.g. 20:10 !";
            }

            if (flgValidate == 0) {
                var e_s_time = 0, e_e_time = 0, p_s_time = 0, p_e_time = 0, m_s_time = 0, m_e_time = 0;
                e_s_time = $(ctrl).closest("tr").find("td.cls-12").find("input").length == 0 ? parseInt($(ctrl).closest("tr").find("td.cls-12").html().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-12").html().split(":")[1].toString()) : parseInt($(ctrl).closest("tr").find("td.cls-12").find("input").eq(0).val().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-12").find("input").eq(0).val().split(":")[1].toString());
                e_e_time = $(ctrl).closest("tr").find("td.cls-13").find("input").length == 0 ? parseInt($(ctrl).closest("tr").find("td.cls-13").html().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-13").html().split(":")[1].toString()) : parseInt($(ctrl).closest("tr").find("td.cls-13").find("input").eq(0).val().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-13").find("input").eq(0).val().split(":")[1].toString());
                p_s_time = $(ctrl).closest("tr").find("td.cls-14").html() == "" ? 0 : parseInt($(ctrl).closest("tr").find("td.cls-14").find("input").eq(0).val().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-14").find("input").eq(0).val().split(":")[1].toString());
                p_e_time = $(ctrl).closest("tr").find("td.cls-15").html() == "" ? 0 : parseInt($(ctrl).closest("tr").find("td.cls-15").find("input").eq(0).val().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-15").find("input").eq(0).val().split(":")[1].toString());
                m_s_time = $(ctrl).closest("tr").find("td.cls-16").html() == "" ? 0 : parseInt($(ctrl).closest("tr").find("td.cls-16").find("input").eq(0).val().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-16").find("input").eq(0).val().split(":")[1].toString());
                m_e_time = $(ctrl).closest("tr").find("td.cls-17").html() == "" ? 0 : parseInt($(ctrl).closest("tr").find("td.cls-17").find("input").eq(0).val().split(":")[0].toString() + $(ctrl).closest("tr").find("td.cls-17").find("input").eq(0).val().split(":")[1].toString());

                switch (cntr) {
                    case 2:
                        if (e_s_time > e_e_time) {
                            flgValidate = 1;
                            msg = "Exercise End Time cann't be greater than Exercise Start Time";
                        }
                        break;
                    case 4:
                        if (p_s_time > p_e_time) {
                            flgValidate = 1;
                            msg = "Preperation End Time cann't be greater than Preperation Start Time";
                        }
                        break;
                    case 6:
                        if (m_s_time > m_e_time) {
                            flgValidate = 1;
                            msg = "Meeting End Time cann't be greater than Meeting Start Time";
                        }
                        break;
                }

                if (cntr > 2) {
                    if (p_s_time == 0) {
                        $(ctrl).closest("tr").find("td.cls-12").html($(ctrl).closest("tr").find("td.cls-16").find("input").eq(0).val());
                    }
                    else if (m_s_time == 0) {
                        $(ctrl).closest("tr").find("td.cls-12").html($(ctrl).closest("tr").find("td.cls-14").find("input").eq(0).val());
                    }
                    else if (p_s_time > m_s_time) {
                        $(ctrl).closest("tr").find("td.cls-12").html($(ctrl).closest("tr").find("td.cls-16").find("input").eq(0).val());
                    }
                    else {
                        $(ctrl).closest("tr").find("td.cls-12").html($(ctrl).closest("tr").find("td.cls-14").find("input").eq(0).val());
                    }

                    if (p_e_time == 0) {
                        $(ctrl).closest("tr").find("td.cls-13").html($(ctrl).closest("tr").find("td.cls-17").find("input").eq(0).val());
                    }
                    else if (m_e_time == 0) {
                        $(ctrl).closest("tr").find("td.cls-13").html($(ctrl).closest("tr").find("td.cls-15").find("input").eq(0).val());
                    }
                    else if (p_e_time > m_e_time) {
                        $(ctrl).closest("tr").find("td.cls-13").html($(ctrl).closest("tr").find("td.cls-15").find("input").eq(0).val());
                    }
                    else {
                        $(ctrl).closest("tr").find("td.cls-13").html($(ctrl).closest("tr").find("td.cls-17").find("input").eq(0).val());
                    }
                }
            }

            if (flgValidate == 1) {
                ValidationTooltip(ctrl, msg);
                $(ctrl).focus();
            }
        }
        function fnfail() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        function fnSaveScheduling() {
            var login = $("#ConatntMatter_hdnLogin").val();
            var batch = $("#ConatntMatter_ddlBatch").val();
            var tbl = [];
            var flgValidate = 0, msg = "";

            var e_s_time = 0, e_e_time = 0, d_cur = 0, d_nxt = 0;
            var p_s_time = 0, p_e_time = 0, m_s_time = 0, m_e_time = 0;
            var trArr = $("#tblScheduling").find("tbody").eq(0).find("tr");
            var ParticipantId = trArr.eq(0).attr("ParticipantId");
            for (var i = 0; i < trArr.length - 1; i++) {
                p_s_time = 0, p_e_time = 0, m_s_time = 0, m_e_time = 0;
                p_s_time = trArr.eq(i).closest("tr").find("td.cls-14").html() == "" ? 0 : parseInt(trArr.eq(i).closest("tr").find("td.cls-14").find("input").eq(0).val().split(":")[0].toString() + trArr.eq(i).closest("tr").find("td.cls-14").find("input").eq(0).val().split(":")[1].toString());
                p_e_time = trArr.eq(i).closest("tr").find("td.cls-15").html() == "" ? 0 : parseInt(trArr.eq(i).closest("tr").find("td.cls-15").find("input").eq(0).val().split(":")[0].toString() + trArr.eq(i).closest("tr").find("td.cls-15").find("input").eq(0).val().split(":")[1].toString());
                m_s_time = trArr.eq(i).closest("tr").find("td.cls-16").html() == "" ? 0 : parseInt(trArr.eq(i).closest("tr").find("td.cls-16").find("input").eq(0).val().split(":")[0].toString() + trArr.eq(i).closest("tr").find("td.cls-16").find("input").eq(0).val().split(":")[1].toString());
                m_e_time = trArr.eq(i).closest("tr").find("td.cls-17").html() == "" ? 0 : parseInt(trArr.eq(i).closest("tr").find("td.cls-17").find("input").eq(0).val().split(":")[0].toString() + trArr.eq(i).closest("tr").find("td.cls-17").find("input").eq(0).val().split(":")[1].toString());

                e_s_time = 0, e_e_time = 0, d_cur = 0, d_nxt = 0;
                d_cur = trArr.eq(i).attr("strDate").split("-")[2] + fnAddZero(MonthArr.indexOf(trArr.eq(i).attr("strDate").split("-")[1])) + fnAddZero(trArr.eq(i).attr("strDate").split("-")[0]);
                d_nxt = trArr.eq(i + 1).attr("strDate").split("-")[2] + fnAddZero(MonthArr.indexOf(trArr.eq(i + 1).attr("strDate").split("-")[1])) + fnAddZero(trArr.eq(i + 1).attr("strDate").split("-")[0]);
                e_s_time = trArr.eq(i + 1).find("td.cls-12").find("input").length == 0 ? parseInt(d_nxt.toString() + trArr.eq(i + 1).find("td.cls-12").html().split(":")[0].toString() + trArr.eq(i + 1).find("td.cls-12").html().split(":")[1].toString()) : parseInt(d_nxt.toString() + trArr.eq(i + 1).find("td.cls-12").find("input").eq(0).val().split(":")[0].toString() + trArr.eq(i + 1).find("td.cls-12").find("input").eq(0).val().split(":")[1].toString());
                e_e_time = trArr.eq(i).find("td.cls-13").find("input").length == 0 ? parseInt(d_cur.toString() + trArr.eq(i).find("td.cls-13").html().split(":")[0].toString() + trArr.eq(i).find("td.cls-13").html().split(":")[1].toString()) : parseInt(d_cur.toString() + trArr.eq(i).find("td.cls-13").find("input").eq(0).val().split(":")[0].toString() + trArr.eq(i).find("td.cls-13").find("input").eq(0).val().split(":")[1].toString());

                if (flgValidate == 0) {
                    if (p_s_time > 0 && m_s_time > 0) {
                        if (p_s_time > p_e_time) {
                            flgValidate = 1;
                            msg = "Preperation start time shouldn't be greater than Preperation end time. Please check for the User - " + trArr.eq(i).attr("Participant") + ", Exercise - " + trArr.eq(i).attr("Exercise") + " !";
                        }
                        else if (p_s_time > m_s_time) {
                            flgValidate = 1;
                            msg = "Preperation start time shouldn't be greater than Meeting start time. Please check for the User - " + trArr.eq(i).attr("Participant") + ", Exercise - " + trArr.eq(i).attr("Exercise") + " !";
                        }
                        else if (p_e_time > m_s_time) {
                            flgValidate = 1;
                            msg = "Time Overlapped between Preperation Time & Meeting Time. Please check for the User - " + trArr.eq(i).attr("Participant") + ", Exercise - " + trArr.eq(i).attr("Exercise") + " !";
                        }
                        else if (m_s_time > m_e_time) {
                            flgValidate = 1;
                            msg = "Meeting start time shouldn't be greater than Meeting end time. Please check for the User - " + trArr.eq(i).attr("Participant") + ", Exercise - " + trArr.eq(i).attr("Exercise") + " !";
                        }
                    }
                    else if (p_s_time > 0) {
                        if (p_s_time > p_e_time) {
                            flgValidate = 1;
                            msg = "Preperation start time shouldn't be greater than Preperation end time. Please check for the User - " + trArr.eq(i).attr("Participant") + ", Exercise - " + trArr.eq(i).attr("Exercise") + " !";
                        }
                    }
                    else if (m_s_time > 0) {
                        if (m_s_time > m_e_time) {
                            flgValidate = 1;
                            msg = "Meeting start time shouldn't be greater than Meeting end time. Please check for the User - " + trArr.eq(i).attr("Participant") + ", Exercise - " + trArr.eq(i).attr("Exercise") + " !";
                        }
                    }
                }

                if (flgValidate == 0) {
                    if (e_e_time > e_s_time && ParticipantId == trArr.eq(i + 1).attr("ParticipantId")) {
                        flgValidate = 1;
                        msg = "Time Overlapped for User - " + trArr.eq(i + 1).attr("Participant") + ", Exercise - " + trArr.eq(i + 1).attr("Exercise") + " !";
                    }
                }

                if (ParticipantId != trArr.eq(i + 1).attr("ParticipantId")) {
                    ParticipantId = trArr.eq(i + 1).attr("ParticipantId");
                }               
            }

            if (flgValidate == 0) {
                for (var i = 0; i < trArr.length; i++) {
                    tbl.push({
                        'col1': trArr.eq(i).attr("mappingid"),
                        'col2': trArr.eq(i).attr("strDate"),
                        'col3': trArr.eq(i).find("td.cls-12").find("input").length == 0 ? trArr.eq(i).find("td.cls-12").html() : trArr.eq(i).find("td.cls-12").find("input").eq(0).val(),
                        'col4': trArr.eq(i).find("td.cls-13").find("input").length == 0 ? trArr.eq(i).find("td.cls-13").html() : trArr.eq(i).find("td.cls-13").find("input").eq(0).val(),
                        'col5': trArr.eq(i).find("td.cls-14").find("input").length == 0 ? "00:00" : trArr.eq(i).find("td.cls-14").find("input").eq(0).val(),
                        'col6': trArr.eq(i).find("td.cls-15").find("input").length == 0 ? "00:00" : trArr.eq(i).find("td.cls-15").find("input").eq(0).val(),
                        'col7': trArr.eq(i).find("td.cls-16").find("input").length == 0 ? "00:00" : trArr.eq(i).find("td.cls-16").find("input").eq(0).val(),
                        'col8': trArr.eq(i).find("td.cls-17").find("input").length == 0 ? "00:00" : trArr.eq(i).find("td.cls-17").find("input").eq(0).val()
                    });
                }

                $("#dvloader").show();
                PageMethods.fnSave(batch, tbl, login, fnSave_pass, fnfail);
            }
            else
                alert(msg);
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

        #ConatntMatter_dvMain {
            overflow: auto;
        }

        #tblScheduling th {
            vertical-align: middle;
        }

        #tblScheduling tbody tr:nth-child(1) td:nth-child(1),
        #tblScheduling td.cls-5,
        #tblScheduling td.cls-7,
        #tblScheduling td.cls-9 {
            width: 10%;
        }      

        #tblScheduling td.cls-3,
        #tblScheduling td.cls-12,
        #tblScheduling td.cls-13,
        #tblScheduling td.cls-14,
        #tblScheduling td.cls-15,
        #tblScheduling td.cls-16,
        #tblScheduling td.cls-17 {
            width:6%;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Participant & Developer Mapping</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-inline mb-3 d-flex">
        <label for="ac" class="col-form-label">Select Batch</label>
        <div class="input-group ml-3">
            <asp:DropDownList ID="ddlBatch" runat="server" CssClass="form-control" onchange="fnGetParticipant();">
            </asp:DropDownList>
        </div>
        <label for="ac" class="col-form-label" style="margin-left: 3rem;">Participant</label>
        <div class="input-group ml-3">
            <select id="ddlParticipant" class="form-control" onchange="fnGetMapping();" style="width:250px;">
                <option value="0">All</option>
            </select>
        </div>
    </div>

    <div id="dvMain" runat="server"></div>
    <div class="text-center" style="margin-top:10px;display:none">
        <input type="button" id="btnSubmit" value="Save Mapping" onclick="fnSaveScheduling()" class="btns btn-cancel d-none" />
    </div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <asp:HiddenField ID="hdnUserlst" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
</asp:Content>
