<%@ Page Language="C#" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="true" CodeFile="frmSlotBooking.aspx.cs" Inherits="frmSlotBooking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <%--<style type="text/css">
        .bg-blue {
            background: #194597;
        }

        table.table, .table > tbody > tr > td {
            border-top: 1px solid #ddd !important;
            vertical-align: middle;
            text-align: center;
            padding:2px !important;.navbar, .section-title, 
        }
    </style>--%>
    <script>
        $(function () {
            $("#loader").hide();
            fnAssessmentgetAvailableSlots();
            setInterval("fnUpdateSlotAutomatically()", 10000);
        });

        function fnUpdateSlotAutomatically() {
            try {
                var LoginId = $("#ConatntMatter_hdnLoginId").val();
                if ($("#tbl_Status").length > 0) {
                    PageMethods.fnAssessmentgetAvailableSlots(LoginId, 2, function (result) {
                        if (result != "") {
                            var sData = $.parseJSON(result);
                            var tbl = sData.Table;
                            var CycleId = tbl[0]["CycleId"];
                            var SlotId = tbl[0]["SlotId"];
                            var SlotsAvailable = tbl[0]["SlotsAvailable"];
                            $("#tbl_Status tr[CycleId='" + CycleId + "'][SlotId=" + SlotId + "]").find("td[iden='slot']").html(SlotsAvailable);
                            if (SlotsAvailable == 0) {
                                $("#tbl_Status tr[CycleId='" + CycleId + "'][SlotId=" + SlotId + "]").find("td[iden='btn']").html("");
                            }
                        }
                    }, function (result) { });
                } 

            } catch (err) { }
        }
        var IsCRFilled = 0;
        function fnAssessmentgetAvailableSlots() {
            $("#loader").show();
            var loginId = $("#ConatntMatter_hdnLogin").val();
            PageMethods.fnAssessmentgetAvailableSlots(loginId, 1, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "0") {
                    $("#divMainContainer").html(result.split("|")[1]);
                    if ($("#tbl_Status").length == 0) {
                        $("#para1").hide();
                        $("#ConatntMatter_hdnScheduleExist").val("1");
                    }
                } else {
                    $("#divMainContainer").html("Error-" + result.split("|")[1]);
                }
            }, function (result) {
                $("#loader").hide();
                $("#divMainContainer").html("Error-" + result._message);
            });
        }

        function fnNextpage() {
            window.location.href = "frmCareerReflection.aspx";
        }

        function fnBookSlot(sender) {
            var slotdate = $(sender).attr("slotdate");
            var SlotDescr = $(sender).attr("SlotDescr");
           // alert(SlotDescr)
//SlotDescr = SlotDescr.trim().split(" to ")[1];
           // alert(SlotDescr)
            $("#dvDialog")[0].innerHTML = "Please confirm you are booking slot " + SlotDescr + " on " + slotdate + ".";
            $("#dvDialog").dialog({
                title: "Confirmation:",
                modal: true,
                height: "auto",
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "Confirm": function () {
                        var CycleId = $(sender).closest("tr").attr("cycleid");
                        var SlotId = $(sender).closest("tr").attr("slotid");
                        var loginId = $("#ConatntMatter_hdnLogin").val();
                        var EmpNodeId = $("#ConatntMatter_hdnEmpNodeId").val();
                        $("#loader").show();
                        $("#dvDialog").dialog('close');
                        PageMethods.fnBookSlot(CycleId, SlotId, loginId,$("#ConatntMatter_hdnScheduleExist").val(), function (result) {
                            $("#loader").hide();
                            var flgSuccess = 0; var str = "";
                            if (result.split("|")[0] == "1") {
                                flgSuccess = result.split("|")[1];
                                if (flgSuccess == 1) {
                                    str = "Slot Not Available"
                                } else {
                                    str = $("#ConatntMatter_hdnScheduleExist").val()== "0" ? "Your assessment has been successfully scheduled for " + slotdate + ". " : "Your assessment has been successfully re-scheduled for " + slotdate + ". ";
                                }
                                
                            } else {
                                flgSuccess = 2;
                                str = "Error-" + result.split("|")[1];
                            }
                            $("#dvDialog")[0].innerHTML = str;
                            $("#dvDialog").dialog({
                                title: "Alert!",
                                modal: true,
                                width: "400",
                                height: "auto",
                                close: function () {
                                    $(this).dialog('destroy');
                                },
                                buttons: {
                                    "OK": function () {
                                        $(this).dialog('close');
                                        if (flgSuccess != 2) {
                                            fnAssessmentgetAvailableSlots();
                                        }
                                    }
                                }
                            });
                        }, function (result) {
                            $("#loader").hide();
                            $("#dvDialog")[0].innerHTML = "Error-" + result._message;
                            $("#dvDialog").dialog({
                                title: "Alert!",
                                modal: true,
                                width: "auto",
                                height: "auto",
                                close: function () {
                                    $(this).dialog('destroy');
                                },
                                buttons: {
                                    "OK": function () {
                                        $(this).dialog('close');
                                        if (flgSuccess != 2) {
                                            fnAssessmentgetAvailableSlots();
                                        }
                                    }
                                }
                            });
                        });
                    },
                    "Back": function () {
                        $(this).dialog('close');
                    }
                }
            })

        }

        function fnCancelSlot(sender, ParticipantCycleMappingId, P_CalendarEventId) {
            
            $("#dvDialog")[0].innerHTML = "Are you sure to cancel this slot?"
            $("#dvDialog").dialog({
                title: "Confirmation:",
                modal: true,
                height: "auto",
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "Yes": function () {
                        $("#loader").show();
                        var loginId = $("#ConatntMatter_hdnLogin").val();
                        PageMethods.fnAssessmentMakeSlotVacant(ParticipantCycleMappingId, P_CalendarEventId, function (result) {
                            $("#loader").hide();
                            var str = ""; var flgSuccess = 0;
                            if (result.split("|")[0] == "0") {
                                str = "Slot Cancelled successfully";
                                flgSuccess = 0;
                                $("#ConatntMatter_hdnScheduleExist").val("1");
                            } else {
                                flgSuccess = 1;
                                str = "Error-" + result.split("|")[1];
                            }
                            $("#dvDialog")[0].innerHTML = str;
                            $("#dvDialog").dialog({
                                title: "Alert!",
                                modal: true,
                                width: "auto",
                                height: "auto",
                                close: function () {
                                    $(this).dialog('destroy');
                                },
                                buttons: {
                                    "OK": function () {
                                        $(this).dialog('close');
                                        if (flgSuccess == 0) {
                                            fnAssessmentgetAvailableSlots();
                                        }
                                    }
                                }
                            });
                        }, function (result) {
                            $("#loader").hide();
                            $("#dvDialog")[0].innerHTML = "Error-" + result._message
                            $("#dvDialog").dialog({
                                title: "Alert!",
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
                            });
                        });
                    },
                    "No": function () {
                        $(this).dialog('close');
                    }
                }
            });
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



    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div id="loader" class="loader_bg">
        <div class="loader"></div>
    </div>

    <div class="section-title clearfix">
        <h3 class="text-center">ASSESSMENT SLOT BOOKING</h3>
        <div class="title-line-center"></div>        
    </div>
    <p id="para1">Please make sure you choose your slot at least 2 days before the scheduled date of the VDC. Please note that the slot options that you see on the screen are the only available slot options.</p>
    <div id="divMainContainer"></div>
    <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnEmpNodeId" Value="0" runat="server" />
    <asp:HiddenField ID="hdnScheduleExist" Value="0" runat="server" />
</asp:Content>
