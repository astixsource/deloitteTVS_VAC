<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="false" CodeFile="frmManageCycle.aspx.vb" Inherits="Admin_MasterForms_frmManageCycle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    
    <script type="text/javascript">
        var today = "";
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            $("#ConatntMatter_lstCycle").css({
                "height": $(window).height() - ($(".navbar").outerHeight() + 160)
            });

            var allsecheight = $(".navbar").outerHeight() + $('.section-title').outerHeight() + $('.d-flex').outerHeight();
            $("#ConatntMatter_dvMain").tblheaderfix({
                height: $(window).height() - (allsecheight + 170)
            });

            $("#ConatntMatter_btnSearch").click(function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";

                var UserFilter = $("#ConatntMatter_txtSearch").val();
                $("#loader").show()
                //  debugger;
                PageMethods.fnGetCycleDetails(0, UserFilter, 2, fnGetAllSuccessData, fnFailedCycle, 0);
            });
            $("#ConatntMatter_btnShowAll").click(function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                $("#ConatntMatter_txtSearch").val('');
                PageMethods.fnGetCycleDetails(0, '', 1, fnGetAllSuccessData, fnFailedCycle, 0);
            });

            fnSetDateTimePicker();
        });
        function fnSetDateTimePicker() {
            var today = new Date();

            $("#ConatntMatter_txtDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true,
                minDate: new Date(),
                showOn: "button",
                buttonImage: "../../Images/Icons/calendar-icon.jpg",
                buttonImageOnly: true,
                buttonText: "Select date",
                onSelect: function (d, el) {
                    fnBatchName();
                    //var Oritxt = $("#ConatntMatter_txtOriDate").val(); 
                    //var selday = new Date((MonthArr.indexOf(d.split("-")[1]) + 1) + "/" + d.split("-")[0] + "/" + d.split("-")[2]);
                    //var timeDiff = Math.abs((selday.getTime()) - (today.getTime()));
                    //var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    //var minday = 0;
                    //if (diffDays > 4)
                    //    minday = diffDays - 4;
                    //$("#ConatntMatter_txtOriDate").datepicker('option', 'minDate', minday);
                    //$("#ConatntMatter_txtOriDate").datepicker('option', 'maxDate', selday);
                    //$('img.ui-datepicker-trigger').css({ 'cursor': 'pointer', 'height': '25px', 'width': '25px', 'position': 'absolute', 'bottom': '7px', 'right': '10px' });

                    //if (Oritxt != "") {
                    //    var Oriday = new Date((MonthArr.indexOf(Oritxt.split("-")[1]) + 1) + "/" + Oritxt.split("-")[0] + "/" + Oritxt.split("-")[2]);
                    //    var timeDiff = Math.abs((selday.getTime()) - (Oriday.getTime()));
                    //    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    //    if (diffDays > 4)
                    //        $("#ConatntMatter_txtOriDate").val('');
                    //}
                }
            });

            //$("#ConatntMatter_txtOriDate").datepicker({
            //    dateFormat: "dd-M-yy",
            //    changeMonth: true,
            //    changeYear: true,
            //    minDate: new Date(),
            //    showOn: "button",
            //    buttonImage: "../../Images/Icons/calendar-icon.jpg",
            //    buttonImageOnly: true,
            //    buttonText: "Select date",
            //    onSelect: function (d, el) {
            //        //
            //    }
            //});

            $('img.ui-datepicker-trigger').css({ 'cursor': 'pointer', 'height': '25px', 'width': '25px', 'position': 'absolute', 'bottom': '7px', 'right': '10px' });
        }

        function getDate(element) {
            var date;
            try {
                date = $.datepicker.parseDate(dateFormat, element.value);
            } catch (error) {
                date = null;
            }

            return date;
        }
    </script>

    <script type="text/javascript">
        $.fn.tblheaderfix = function (options) {
            var strid = $(this)[0].id, clss = $(this).find("table").attr('class');
            var defaults = {
                width: '100%',
                height: 350,
                padding: 1
            };
            var options = $.extend(defaults, options);
            $(this).css({ "width": options.width, "height": options.height, "padding": options.padding });

            $(this).find("table").attr('id', strid + '_tbl');
            var contant = $(this).html(), wid = $("#" + strid + "_tbl").width(), thead = $("#" + strid + "_tbl").find("thead").eq(0).html();
            $(this).html("<div id='" + strid + "_head'></div><div id='" + strid + "_body'></div>");
            $("#" + strid + "_head").html("<table id='" + strid + "_hfix' class='" + clss + " mb-0' style='width:" + wid + "px'><thead>" + thead + "</thead><tbody></tbody></table>");
            $("#" + strid + "_body").html(contant);
            $("#" + strid + "_tbl").css({ "width": wid, "min-width": wid });
            for (i = 0; i < $("#" + strid + "_tbl").find("th").length; i++) {
                var th_wid = $("#" + strid + "_tbl").find("th")[i].clientWidth; //offsetWidth;
                $("#" + strid + "_hfix, #" + strid + "_tbl").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
            }
            $("#" + strid + "_tbl").css("margin-top", "-" + ($("#" + strid + "_hfix")[0].offsetHeight) + "px");
            $("#" + strid + "_body").css({
                'height': $(this).height() - $("#" + strid + "_head").outerHeight(),
                'overflow-y': 'auto',
                'overflow-x': 'hidden'
            });
        }
    </script>

    <script type="text/javascript">
        function fnSaveCycle() {
            var CycleName = document.getElementById("ConatntMatter_txtCycleName").value.trim();
            var CycleDate = document.getElementById("ConatntMatter_txtDate").value.trim();
            var DCId = $('#ConatntMatter_ddlDC').val();
            var DCttYPE = $('#ConatntMatter_ddlDC option:selected').text();
            var SetID = "0"; //$('#ConatntMatter_ddlSetName').val();
            var NOP = $('#ddlNOP').val();
            var OriDate = ""; //$("#ConatntMatter_txtOriDate").val();
            var OriTime = ""; //$("#ConatntMatter_txtOriTime").val();
            if ($('#ConatntMatter_ddlDC').val() == "0") {
                alert("Please select the DC Type");
                return false;
            }
            if (CycleDate == "") {
                alert("Please enter batch date")
                return false;
            }
            //if (SetID == 0) {
            //    alert("Please select the Set Name")
            //    return false;
            //}
            if (CycleName == "") {
                alert("Please enter batch name")
                return false;
            }
            if (NOP == "0") {
                alert("Please select No. Of Participants")
                return false;
            }
            //if (OriDate == "") {
            //    alert("Please select the Orientation date")
            //    return false;
            //}
            //if (OriTime == "") {
            //    alert("Please enter Orientation Time")
            //    return false;
            //}
            CycleName = CycleName.replace("_", " ");
            var hdnCycleID = document.getElementById("ConatntMatter_hdnCycleID").value;
            PageMethods.fnManageCycleName(hdnCycleID, CycleName, CycleDate, SetID, NOP, DCId, OriDate, OriTime, fnSuccessCycle, fnFailedCycle);

        }
        function fnSuccessCycle(result) {
            if (result.split("@")[0] == "1") {

                var CycleID = result.split("^")[1]
                document.getElementById("ConatntMatter_hdnCycleID").value = CycleID;

                var CycleName = document.getElementById("ConatntMatter_txtCycleName").value.trim();
                var CycleDate = document.getElementById("ConatntMatter_txtDate").value.trim();


                var Returnresult = result.split("@")[0]
                if (Returnresult == 1) {
                    PageMethods.fnGetCycleDetails(0, '', 1, fnGetAllSuccessData, fnFailedCycle, 1);
                }


            }
            else {
                alert("Error....")
            }
        }

        function fnGetAllSuccessData(result, returnVal) {
            if (result.split("@")[0] == "1") {
                if (returnVal == 1) {
                    $("#dvDialog").dialog('close');
                    if (document.getElementById("ConatntMatter_hdnFlag").value == "1") {
                        alert("Updated Successfully")
                    }
                    else {
                        alert("Saved Successfully")
                    }
                }

                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("@")[1];

                var allsecheight = $(".navbar").outerHeight() + $('.section-title').outerHeight() + $('.d-flex').outerHeight();
                $("#ConatntMatter_dvMain").tblheaderfix({
                    height: $(window).height() - (allsecheight + 170)
                });


            }
        }

        function fnFailedCycle(result) {
            alert("Error - " + result.split("^")[1])
        }
    </script>
    <script type="text/javascript">
        function fnAddNewCycle() {
            $("#dvbtnSave").show();
            $("#ConatntMatter_ddlDC").removeAttr("disabled");
            $("#ConatntMatter_txtDate").removeAttr("disabled");
            $("#ConatntMatter_txtDate").next("img").show();
            $("#ConatntMatter_txtCycleName").removeAttr("disabled");
            $("#ddlNOP").removeAttr("disabled");

            $("#dvDialog").dialog({
                title: "Add New Batch Details",
                resizable: false,
                height: "auto",
                width: "50%",
                modal: true
            });
            document.getElementById("ConatntMatter_txtCycleName").value = "";
            document.getElementById("ConatntMatter_txtDate").value = "";
            document.getElementById("ConatntMatter_hdnCycleID").value = 0;
            document.getElementById("ConatntMatter_hdnFlag").value = 0;
            $("#ddlNOP").val("0");
            $("#ConatntMatter_ddlDC").val("0");
            fnGetSetName();
        }

        function fndelete_row(CycleID) {
            if (confirm('Are you sure you want to delete this batch')) {
                PageMethods.fnCheckMappedUsersAgCycle(CycleID, fnChkSuccessMapped, fnFailedCycle, CycleID);
            }
        }

        function fnChkSuccessMapped(result, CycleID) {

            if (result.split("@")[0] == "1") {
                var chkFlag = result.split("@")[1];
                if (chkFlag == "1") {
                    alert("You can not delete this Batch because Users are already Mapped with the batch. In any case if you want to remove this , kindly remove the mapping first from ''Batch mapping with user.");
                    return false;
                }
                else {
                    PageMethods.fnDeleteCycle(CycleID, fnDeleteSuccess, fnFailedCycle);
                }
            }
            else {
                alert("Error....");
            }
        }
        function fnDeleteSuccess(result) {
            if (result.split("@")[0] == "1") {
                alert("Delete Successfully")
                PageMethods.fnGetCycleDetails(0, '', 1, fnGetAllSuccessData, fnFailedCycle, 0);
            }
        }
    </script>

    <script type="text/javascript">


        function fnEditCycleDetails(CycleID, CycleName, CycleStartdate, DCTypeId, NOP, OriDate, OriTime, flgLock) {
            CycleName = replaceAll(CycleName, "_", " ")
            document.getElementById("ConatntMatter_hdnCycleID").value = CycleID;
            document.getElementById("ConatntMatter_txtCycleName").value = CycleName;
            document.getElementById("ConatntMatter_txtDate").value = CycleStartdate;
            document.getElementById("ConatntMatter_hdnFlag").value = 1;
            $("#ddlNOP").val(NOP);
            $("#ConatntMatter_ddlDC").val(DCTypeId);
            
            $("#dvDialog").dialog({
                title: "Modify Batch Details",
                resizable: false,
                height: "auto",
                width: "50%",
                modal: true
            });

            if (flgLock == "1") {
                $("#dvbtnSave").hide();
                $("#dvDialog").dialog('option', 'title', "Batch Details : Locked for Editing !");
                $("#ConatntMatter_ddlDC").prop("disabled", true);
                $("#ConatntMatter_txtDate").prop("disabled", true);
                $("#ConatntMatter_txtDate").next("img").hide();
                $("#ConatntMatter_txtCycleName").prop("disabled", true);
                $("#ddlNOP").prop("disabled", true);
            }
            else {
                $("#dvbtnSave").show();
                $("#dvDialog").dialog('option', 'title', "Modify Batch Details :");
                $("#ConatntMatter_ddlDC").removeAttr("disabled");
                $("#ConatntMatter_txtDate").removeAttr("disabled");
                $("#ConatntMatter_txtDate").next("img").show();
                $("#ConatntMatter_txtCycleName").removeAttr("disabled");
                $("#ddlNOP").removeAttr("disabled");
            }
        }

        function replaceAll(str, find, replace) {
            while (str.indexOf(find) > -1) {
                str = str.replace(find, replace);
            }
            return str;
        }

        function fnGetSetName() {
            if ($("#ConatntMatter_ddlDC").val() == "0") {
                $("#ConatntMatter_ddlSetName").html("<option value='0'>-- Select --</option>");
            }
            else {
                var str = "";
                str += "<option value='0'>-- Select --</option>";

                var SetName = $.parseJSON('[' + $("#ConatntMatter_hdnSet").val() + ']')[0];
                for (var i = 0; i < SetName.length; i++) {
                    if (SetName[i]["DCTypeId"] == $("#ConatntMatter_ddlDC").val()) {
                        str += "<option value='" + SetName[i]["CycleSetId"] + "'>" + SetName[i]["CycleSet"] + "</option>";
                    }
                }

                $("#ConatntMatter_ddlSetName").html(str);
            }
        }

        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        function fnBatchName() {
            var dc = $("#ConatntMatter_ddlDC").val();
            var DCttYPE = $('#ConatntMatter_ddlDC option:selected').text();
            DCttYPE = dc == "0" ? "" : DCttYPE;
            var txtDate = $("#ConatntMatter_txtDate").val();
            if (txtDate != "") {
                if (dc != 0) {
                    $("#ConatntMatter_txtCycleName").val(DCttYPE + " (" + txtDate + ")");
                } else {
                    $("#ConatntMatter_txtCycleName").val(txtDate);
                }
            }
            $("#ddlNOP").html("<option value='0' selected>--Select--</option>")
             if (dc == "1") {
$("#ddlNOP").append("<option value='9' >9</option>")
                 $("#ddlNOP").append("<option value='12' >12</option>")
            } else {
                 $("#ddlNOP").append("<option value='9' >9</option>")
            }
            
            //if (dc != "0" && txtDate != "") {
            //    var str = "";
            //    str += $("#ConatntMatter_ddlDC").find("option[value='" + dc + "']").eq(0).html();
            //    str += " " + txtDate.split("-")[0] + "-" + txtDate.split("-")[1];
            //    $("#ConatntMatter_txtCycleName").val(str).to;
            //}
        }

        function fnChkTimeFormat() {
            var OriTime = $("#ConatntMatter_txtOriTime").val();
            if (OriTime.toString().length != 5) {
                alert("Time Format is not valid !");
                $("#ConatntMatter_txtOriTime").val('');
            }
            else if (OriTime.indexOf(":") != 2) {
                alert("Time Format is not valid !");
                $("#ConatntMatter_txtOriTime").val('');
            }
            else if (parseInt(OriTime.split(":")[0]) > 23) {
                alert("Time Format is not valid !");
                $("#ConatntMatter_txtOriTime").val('');
            }
            else if (parseInt(OriTime.split(":")[1]) > 59) {
                alert("Time Format is not valid !");
                $("#ConatntMatter_txtOriTime").val('');
            }
        }
    </script>
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
                if (!(evt.keyCode == 58 || (evt.keyCode >= 48 && evt.keyCode <= 57))) {
                    return false;
                }
                var parts = evt.srcElement.value.split(':');
                if (parts.length > 2) {
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Batch Information</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="form-inline mb-3 d-flex">
        <div>
            <input type="button" id="btnShowAll" runat="server" value="Show All" class="btn btn-primary" />
        </div>
        <div class="input-group ml-auto">
            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search" CssClass="form-control"></asp:TextBox>
            <div class="input-group-append">
                <input type="button" id="btnSearch" runat="server" value="Show" class="btn btn-primary" />
            </div>
        </div>
    </div>
    <div id="dvMain" runat="server"></div>
    <div class="text-center">
        <input type="button" id="AddNewCycle" value="Add New Batch" onclick="fnAddNewCycle()" class="btns btn-cancel" />
    </div>


    <div id="dvDialog" style="display:none">
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="EmpCode">Which type of DC</label>
                <asp:DropDownList ID="ddlDC" runat="server" CssClass="form-control" onChange='fnBatchName();'>
                </asp:DropDownList>
            </div>
            <div class="form-group col-md-6">
                <label for="CycleDate">Batch Date</label>
                <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" MaxLength="50" ReadOnly="true"></asp:TextBox>
            </div>
            <div class="form-group col-md-6">
                <label for="CycleDate">No Of Participants</label>
                <select id="ddlNOP" class="form-control">
                    <option value="0">--Select--</option>
                   
                </select>
            </div>
             <div class="form-group col-md-6">
                <label for="CycleName">Batch Name</label>
                <asp:TextBox ID="txtCycleName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>
        <div class="form-row">
           
        </div>
        <div class="text-center" id="dvbtnSave">
            <input type="button" value="Save" onclick="fnSaveCycle()" class="btns btn-cancel" />
        </div>
    </div>


    <asp:HiddenField ID="hdnCycleID" runat="server" Value=" 0" />
    <asp:HiddenField ID="hdnFlag" runat="server" Value=" 0" />
    <asp:HiddenField ID="hdnSet" runat="server" Value=" 0" />
</asp:Content>

