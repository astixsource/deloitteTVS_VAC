<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmAssessorParticipantMapping.aspx.cs" Inherits="frmAssessorParticipantMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%--<script src="../../JDatatable/jquery.dataTables.js" type="text/javascript"></script>
    <link href="../../JDatatable/jquery.dataTables.css" rel="stylesheet" />--%>

    <style type="text/css">
        table.table {
            border-collapse: collapse;
            font-size: .8rem;
        }
        tr.clsHighlightrows td {
            background-color: #f1ff94;
        }
        tr.clsHighlightrowsAssessor td {
            background-color: #f3a570;
        }
        tr.clsHighlightrowsMeeting td {
            background-color: #f7c29f;
        }
        
        /*tr.clsHighlightrowsChangeRoute td {
            background-color: #ffff79;
        }

        tr.clsHighlightrows td {
            background-color: #ffd5d5;
        }

        .mainpanel {
            padding: 0px !important;
            font-family: Arial Narrow;
        }

        div.dataTables_scrollBody {
            overflow-y: scroll !important;
        }

        .iframe-placeholder {
            background: url('data:image/svg+xml;charset=utf-8,<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 100% 100%"><text fill="%23FF0000" x="50%" y="50%" font-family="\'Lucida Grande\', sans-serif" font-size="24" text-anchor="middle">Page is being loaded , please wait..</text></svg>') 0px 0px no-repeat;
        }

        .inner-addon {
            position: relative;
        }

        .leftMenu-headding {
            width: 235px !important;
        }

        .inner-addon .glyphicon {
            position: absolute;
            padding: 10px;
            pointer-events: none;
        }

        .left-addon .glyphicon {
            left: 0px;
        }

        .right-addon .glyphicon {
            right: 0px;
        }

        .left-addon input {
            padding-left: 30px;
        }

        .right-addon input {
            padding-right: 30px;
        }

        input[type=text]::-ms-clear {
            display: none;
        }

        .ui-autocomplete-loading {
            background: url('../images/preloader_18.gif') no-repeat right center;
        }

        .mcacAnchor span {
            font: normal 11px 'HelveticaLTStdRoman',Arial, Helvetica, sans-serif;
            color: Black;
        }

        a.icon-bnt {
            padding: 2pt 0;
            font-size: 10pt;
            text-align: center;
            cursor: pointer;
            margin: 0 1pt 0 0;
            display: inline-block;
            *display: inline;
            text-decoration: none;
            width: auto;
            color: #fff;
            background: #26A6E7 none;
            border: 0 none;
            border-radius: 1px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }

            a.icon-bnt span {
                height: 25px;
                width: 25px;
                float: left;
                padding: 0 1pt 0 0;
            }

                a.icon-bnt span.PostOrder {
                    background: url(../btnImg/PostOrder_Icon.png) center no-repeat;
                }

        .custom-combobox {
            position: relative;
            display: inline-block;
            height: 35px;
        }

        .custom-combobox-toggle {
            position: absolute;
            top: 0;
            bottom: 0;
            margin-left: -1px;
            padding: 0;
            *height: 1.7em;
            *top: 0.1em;
        }

        .custom-combobox-input {
            margin: 0;
            padding: 0.3em;
            background: #fff;
            outline: none;
            width: 330px;
            height: 35px;
        }*/
    </style>

    <script>
        (function ($) {
            $.widget("custom.combobox", {
                _create: function () {
                    this.wrapper = $("<span>")
                        .addClass("custom-combobox")
                        .insertAfter(this.element);

                    this.element.hide();
                    this._createAutocomplete();
                    this._createShowAllButton();
                },

                _createAutocomplete: function () {
                    var selected = this.element.children(":selected"),
                        value = selected.val() ? selected.text() : "";

                    this.input = $("<input>")
                        .appendTo(this.wrapper)
                        .val(value)
                        .attr("title", "")
                        .addClass("custom-combobox-input ui-widget ui-widget-content ui-state-default ui-corner-left")
                        .autocomplete({
                            delay: 0,
                            minLength: 0,
                            source: $.proxy(this, "_source")
                        })
                        .tooltip({
                            tooltipClass: "ui-state-highlight"
                        });

                    this._on(this.input, {
                        autocompleteselect: function (event, ui) {
                            ui.item.option.selected = true;
                            this._trigger("select", event, {
                                item: ui.item.option
                            });
                            var DBNodeID = ui.item.option.value;
                            fnDBRChange(DBNodeID);
                        },

                        autocompletechange: "_removeIfInvalid"
                    });
                },

                _createShowAllButton: function () {
                    var input = this.input,
                        wasOpen = false;

                    $("<a>")
                        .attr("tabIndex", -1)
                        .attr("title", "Show All Items")
                        .tooltip()
                        .appendTo(this.wrapper)
                        .button({
                            icons: {
                                primary: "ui-icon-triangle-1-s"
                            },
                            text: false
                        })
                        .removeClass("ui-corner-all")
                        .addClass("custom-combobox-toggle ui-corner-right")
                        .mousedown(function () {
                            wasOpen = input.autocomplete("widget").is(":visible");
                        })
                        .click(function () {
                            input.focus();

                            // Close if already visible
                            if (wasOpen) {
                                return;
                            }

                            // Pass empty string as value to search for, displaying all results
                            input.autocomplete("search", "");
                        });
                },

                _source: function (request, response) {
                    var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
                    response(this.element.children("option").map(function () {
                        var text = $(this).text();
                        if (this.value && (!request.term || matcher.test(text)))
                            return {
                                label: text,
                                value: text,
                                option: this
                            };
                    }));
                },

                _removeIfInvalid: function (event, ui) {

                    // Selected an item, nothing to do
                    if (ui.item) {
                        return;
                    }

                    // Search for a match (case-insensitive)
                    var value = this.input.val(),
                        valueLowerCase = value.toLowerCase(),
                        valid = false;
                    this.element.children("option").each(function () {
                        if ($(this).text().toLowerCase() === valueLowerCase) {
                            this.selected = valid = true;
                            return false;
                        }
                    });

                    // Found a match, nothing to do
                    if (valid) {
                        return;
                    }

                    // Remove invalid value
                    this.input
                        .val("")
                        .attr("title", value + " didn't match any item")
                        .tooltip("open");
                    this.element.val("");
                    this._delay(function () {
                        this.input.tooltip("close").attr("title", "");
                    }, 2500);
                    this.input.data("ui-autocomplete").term = "";
                    $("#ConatntMatter_ddlRoute").html("<option value='0' routenodetype='0'>-------</option>");
                    $("#divdrmmain")[0].innerHTML = "";
                },

                _destroy: function () {
                    this.wrapper.remove();
                    this.element.show();
                }
            });
        })(jQuery);
    </script>
    <script>
        $.widget('custom.mcautocomplete', $.ui.autocomplete, {
            _create: function () {
                this._super();
                this.widget().menu("option", "items", "> :not(.ui-widget-header)");
            },
            _renderMenu: function (ul, items) {
                var self = this,
                    thead;
                if (this.options.showHeader) {
                    var strHTML = "";
                    var swd = 0;
                    $.each(this.options.columns, function (index, item) {
                        swd += parseInt(item.width);
                        strHTML += ('<span style="padding:0 4px;float:left;width:' + item.width + ';">' + item.name + '</span>');
                    });
                    swd += parseInt(50);
                    $(ul).css("width", swd + "px");
                    table = $('<div class="ui-widget-header" style="width:' + swd + 'px;position:fixed;margin-top:-2px"></div>');
                    table.append(strHTML);
                    table.append('<div style="clear: both;"></div>');
                    ul.append(table);
                }
                var cnt = 0;
                $.each(items, function (index, item) {
                    self._renderItem(ul, item, cnt);
                    cnt++;
                });
                $("#txtCustomer").removeClass("ui-autocomplete-loading");
            },
            _renderItem: function (ul, item, cnt) {
                var stylee = "";
                if (cnt == 0) {
                    stylee = "style='margin-top:10px'";
                }
                var t = '',
                    result = '';
                if (item.label != "No Record Found!!") {
                    $.each(this.options.columns, function (index, column) {
                        var strd = item[column.valueField ? column.valueField : index];
                        t += '<span style="padding:0 4px;float:left;width:' + column.width + ';">' + ((strd == "" || strd == null || strd == "null") ? "&nbsp;" : strd) + '</span>'
                    });
                    result = $('<li ' + stylee + '></li>')
                        .data('ui-autocomplete-item', item)
                        .append('<a class="mcacAnchor">' + t + '<div style="clear: both;"></div></a>')
                        .appendTo(ul);
                } else {
                    result = $('<li style="margin-top:15px"></li>')
                        .data('ui-autocomplete-item', item)
                        .append('<a class="mcacAnchor">' + item.label + '<div style="clear: both;"></div></a>')
                        .appendTo(ul);
                }

                return result;
            }
        });
    </script>
    <script>
        var StoreList = [];
        $(document).ready(function () {
            //$('#fraLeft').load(function () {
            //    $("#fraLeft").contents().find("#DvMenu").find("li").removeClass("activemenu");
            //    $("#fraLeft").contents().find("#DvMenu").find("li[nid='9']").addClass("activemenu");
            //    $("#fraLeft")[0].height = $(window).height() - ($("#dvBanner").height() + $(".footer").height());
            //});

            //$(document).data("BranchData", $("#ConatntMatter_ddlBranch").clone());
            //$("#ConatntMatter_ddlBranch option").remove();
            //$("#ConatntMatter_ddlBranch").html("<option value='0-0'>------<option>");
            //$("#ConatntMatter_ddlBranch option").eq(1).remove();
            //if ($("#ConatntMatter_ddlBranch option").length = 1) {

            //   // fnDSEList();
            //}
            fnDSEList();
            $('#txtFindDbr').keyup(function () {
                var val = $(this).val().toUpperCase();
                $("#tbldbrlist").find("tbody").eq(0).find("tr").css("display", "none");

                var tbl = $("#tbldbrlist>tbody>tr");
                var tr;
                for (var i = 0; i < tbl.length; i++) {
                    tr = $(tbl[i]);
                    for (var j = 0; j < $(tr).find("td").length; j++) {
                        if ($(tr).find("td").eq(j).attr("Searchable") == "1") {
                            var tdText = $(tr).find("td").eq(j).html().toUpperCase();
                            if (tdText.indexOf(val) > -1) {
                                $(tr).css("display", "table-row");
                            }
                        }
                    }
                }
            });
        });

        function fnMarkAtt(sender) {
            if ($(sender).is(":checked")) {
                $(sender).closest("td").next().find("a").show();
            } else {
                $(sender).closest("td").next().find("a").hide();
            }
        }
        function AddParameter(form, name, value) {
            var $input = $("<input />").attr("type", "hidden")
                .attr("name", name)
                .attr("value", value);
            form.append($input);
        }

        function fnEditOrder(sender) {
            var StoreId = $(sender).closest("tr").attr("storeid");
            var TeleCallingId = $(sender).closest("tr").attr("TeleCallingId");
            var StoreName = $(sender).closest("tr").find("a").eq(1).html();
            var gstno = "";
            gstno = gstno == "" ? 2 : gstno;
            var LastCallDate = "";
            var LastOrderDate = "";
            var RouteId = $("#ConatntMatter_ddlRoute").val();
            var flgDefault = $("#ConatntMatter_ddlRoute option:selected").attr("flgDefault");
            var flgOnRoute = flgDefault;// $("#ConatntMatter_ddlRoute option:selected").attr("flgOnRoute");
            var SalesNodeId = $(sender).closest("tr").attr("BranchNodeId");
            var SalesNodeType = $(sender).closest("tr").attr("BranchNodeType");
            var Branch = $(sender).closest("tr").find("td").eq(1).html();
            var strStoreName = StoreId + "^" + StoreName.replace("&", "") + "^1^" + gstno + "^" + LastCallDate + "^" + LastOrderDate + "^" + RouteId + "^" + flgDefault + "^" + flgOnRoute + "^" + SalesNodeId + "^" + SalesNodeType + "^" + TeleCallingId + "^" + Branch;
            fnShowOrderBookingForm(strStoreName);
        }
        function fnClosedvOrderPop() {
            try {
                $("#InvReportDialog").dialog('close');
            } catch (err) { }
        }
        function fnRemoveClass() {
            $("#IframeInvRpt").removeClass("iframe-placeholder");
        }
        var flgValidUpdate = 0;

        function fnRefreshStatus() {

            fnDSEList();
        }
        function fnChangeBranch(sender) {
            fnDSEList();
        }
        function fnChangeSite(sender) {
            var val = $(sender).val();
            var options = $(document).data("BranchData").clone();
            $("#ConatntMatter_ddlBranch option").remove();
            $("#ConatntMatter_ddlBranch").html("<option value='0-0'>------<option>");
            $(options).find("option[sitenodeid='" + val + "']").appendTo($("#ConatntMatter_ddlBranch"));
            $("#ConatntMatter_ddlBranch option").eq(1).remove();
        }
        var arrRouteData = []; var arrSectorData = [];
        function fnDSEList() {
            var CycleId = $("#ConatntMatter_ddlCycle").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            $("#dvFadeForProcessing").show();
            PageMethods.fnGetAssessorParticipantForMappingList(CycleId, function (result) {
                $("#dvFadeForProcessing").hide();
                $("#divBTNS").hide();
                if (result.split("|")[0] == "2") {
                    alert("Error-" + result.split("|")[1]);
                } else if (result == "") {
                    $("#divdrmmain")[0].innerHTML = "No Participant Found!!!";
                }
                else {

                    $("#divdrmmain")[0].innerHTML = result.split("|")[0];
                    //---- this code add by satish --- //
                    $("#divdrmmain").prepend("<div id='tblheader'></div>");
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
                            'height': $(window).height() - (nvheight + secheight + fgheight + 190),
                            'overflow-y': 'auto',
                            'overflow-x': 'hidden'
                        });
                        $("#divBTNS").show();
                    }
                    //---- end code --- //


                    $("#divAssessorContainer")[0].innerHTML = result.split("|")[1];
                    
                    //$("#tbldbrlist").DataTable({
                    //    scrollY: "58vh",
                    //    scrollX: false,
                    //    scrollCollapse: true,
                    //    paging: false,
                    //    "ordering": false,
                    //    "info": false,
                    //    "bFilter": false,
                    //    "bSorting": false,
                    //    "searching": false,
                    //})
                }
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    alert("Error-" + result._message);
                }
            )
        }

        function fnSaveFinalData() {
            var tbl = $("#tbldbrlist").find('select');
            if (tbl.length == 0) {
                alert("Kindly Select Assessor first!!!");
                return false;
            }
            $("#dvDialog")[0].innerHTML = "Are you sure you have selected the correct developer for each participant?"
            $("#dvDialog").dialog({
                width:"385",
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
                                    var AttendDetId = tbl.eq(i).closest("tr").attr("ParticipantCycleMappingId");
                                    var UserId = tbl.eq(i).closest("tr").find("select option:selected").val();
                                    arrDSENodeID.push({ AttendDetId: AttendDetId, UserId: UserId });
                                }
                            }
                        }
                        if (arrDSENodeID.length == 0) {
                            alert("Action is not completed as you have not mapped any new Developer!");
                            return false;
                        }
                        var LoginId = $("#ConatntMatter_hdnLoginId").val();
                        $("#dvFadeForProcessing").show();
                        PageMethods.fnPopulateAssessorParticipantMapping(LoginId, arrDSENodeID, function (result) {
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
       
        function fnShowDetail(sender, pid) {
            $("#dvFadeForProcessing").show();
            PageMethods.fnAssessorParticipantMappingDetails(pid, function (result) {
                $("#dvFadeForProcessing").hide();
                $("#dvDialog")[0].innerHTML = result.split("|")[1];
                $("#dvDialog").dialog({
                    width: "450",
                    modal: true,
                    title: (result.split("|")[0] == "2" ? "Error" : "Information:"),
                    buttons: {
                        "OK": function () {
                            $(this).dialog('close');
                        }
                    }
                });
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    alert(result._message)
                }
            );
        }

        function fnDeleteParticipantMapping(sender, pid) {
            var MeetingId = $(sender).closest("tr").attr("meetingid");
            var strMsg = "";
            if (MeetingId > 0) {
                strMsg = "Are you sure you want to remove mapping with this Developer as BEI Meeting has been already scheduled with this participant?";
            } else {
                strMsg = "Are you sure you want to remove mapping with this Developer?";
            }
            $("#dvDialog")[0].innerHTML = strMsg;
            $("#dvDialog").dialog({
                width: "560",
                modal: true,
                title: "Confirmation:",
                buttons: {
                    "Yes": function () {
                        $(this).dialog('close');
                        fnConfirmMapping(sender, pid);
                    },
                    "No": function () {
                        $(this).dialog('close');
                    }
                }
            });
        }
        function fnConfirmMapping(sender, pid) {
            $("#dvFadeForProcessing").show();
            PageMethods.fnDeleteAssessorParticipantMapping(pid, function (result) {
                $("#dvFadeForProcessing").hide();
                if (result.split("|")[0] == "2") {
                    $("#dvDialog")[0].innerHTML = "Error-" + result.split("|")[1];
                } else {
                    $(sender).closest("tr").removeClass("clsHighlightrows");
                    $(sender).closest("tr").removeClass("clsHighlightrowsMeeting");
                    $(sender).closest("tr").find("select").eq(0).removeAttr("onchange");
                    $(sender).closest("tr").find("select").prop("disabled", false);
                    $(sender).closest("tr").find("select option[value=0]").prop("selected", true);
                    $(sender).closest("tr").attr("meetingid", "0");
                    $(sender).closest("tr").attr("flgMapped", "0");
                    $("#dvDialog")[0].innerHTML = "Mapping Removed Successfully";
                    $(sender).remove();
                }
                $("#dvDialog").dialog({
                    width: "auto",
                    modal: true,
                    title: (result.split("|")[0] == "2" ? "Error" : "Information:"),
                    buttons: {
                        "OK": function () {
                            $(this).dialog('close');
                        }
                    }
                });
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    alert("Error-" + result._message)
                }
            );
        }

        $(document).ready(function () {
        //    $('.clsassessor')
        //.on('focus', function () {
        //    $(this).data("prev", $(this).val());
        //})
        //.change(function () {
        //    var Preval = $(this).data("prev");
        //    if (parseInt(Preval) > 0) {
        //        var totCount = $("#tbldbrlist1 tr[AssessorCycleMappingId='" + $(this).val() + "']").attr("totcount");
        //        if (parseInt(totCount) > 3) {
        //            alert("Ensure that the participants mapped to a developer does not exceed 3");
        //            $(this).val($(this).data("prev"));
        //        } else {
        //            $(this).data("prev", $(this).val());
        //        }
        //    }
        //});
            $("#dvDialog")[0].innerHTML = "Ensure that the participants mapped to a developer does not exceed 3";
            $("#dvDialog").dialog({
                title:"Information:",
                modal: true,
                width: "auto",
                height:"auto"
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Participant and Developer Mapping</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-group row">
        <label for="ac" class="col-sm-2 col-form-label">Select Batch :</label>
        <div class="col-sm-4">
            <asp:DropDownList runat="server" ID="ddlCycle" onchange="fnDSEList()" CssClass="form-control">
            </asp:DropDownList>
        </div>
        <div class="col-3 offset-1">
            <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
            <input type="text" class="form-control" placeholder="Search" name="search" id="txtFindDbr">
        </div>
    </div>
    <div class="row">
        <div class="col-8">
            <div id="divdrmmain"></div>
        </div>
        <div class="col-4">
            <div id="divAssessorContainer"></div>
        </div>
    </div>


    <div class="text-center" id="divBTNS" style="display: none;">
        <a href="###" class="btns btn-submit" onclick="fnSaveFinalData()" id="anchorbtn2">Save Mapping</a>
    </div>

    <div id="dvDialog" style="display: none"></div>
    <div id="dvFadeForProcessing" class="loader_bg">
        <div class="loader"></div>
    </div>

    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMenuId" Value="0" />

</asp:Content>
