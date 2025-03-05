<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmManageParticipantAgCycle.aspx.vb" Inherits="Admin_MasterForms_frmManageParticipantAgCycle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ConatntMatter_ddlCycleName").on("change", function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                $('#btnSave').hide();
                var CycleID = $("#ConatntMatter_ddlCycleName").val();
                var SetName = $("#ConatntMatter_ddlCycleName option:selected").text().split("-->")[1]
                $("#loader").show();
                $("#lblSetName").html("Mapped Set Name --> " + SetName);
                fnDisplayParticpantAgCycle();

            });

            $("#ConatntMatter_btnSearch").click(function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";

                var FullID = $("#ConatntMatter_ddlCycleName").val();               

                var UserFilter = $("#ConatntMatter_txtSearch").val();
                var CycleID = FullID.split("^")[0];
                var BandId =  FullID.split("^")[1];

                if (CycleID == "0") {
                    alert("Please select the Batch first")
                    return false;
                }
                $("#loader").show()
                //  debugger;
                PageMethods.fnDisplayParticpantAgCycle(CycleID, 2, UserFilter, fnGetDisplaySuccessData, fnGetFailed);
            });

        });

        function fnDisplayParticpantAgCycle() {
            var FullID = $("#ConatntMatter_ddlCycleName").val();
            var CycleID = FullID.split("^")[0];
            PageMethods.fnDisplayParticpantAgCycle(CycleID, 1, '', fnGetDisplaySuccessData, fnGetFailed);
        }

        function fnGetDisplaySuccessData(result) {

            $("#loader").hide();
            if (result.split("@")[0] == "1") {

                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("@")[1];
                var strReturnTableData = result.split("@")[1];


                //---- this code add by satish --- //
                if ($("#tblEmp").length > 0) {

                    $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");

                    var wid = $("#tblEmp").width(), thead = $("#tblEmp").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tblEmp").css({ "width": wid, "min-width": wid });

                    for (i = 0; i < $("#tblEmp").find("th").length; i++) {
                        var th_wid = $("#tblEmp").find("th")[i].clientWidth;
                        $("#tblEmp_header, #tblEmp").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tblEmp").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                    var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                    $('#dvtblbody').css({
                        'height': $(window).height() - (nvheight + secheight + fgheight + 250),
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                }
                //---- end code --- //

                $("#btnSave").show();

                $("input[type=checkbox]").change(function () {


                    if ($(this).is(":checked")) {
                        if ($(this).attr("flgexist") == "1") {
                            $(this).attr("flg", 0);
                        } else {
                            $(this).attr("flg", 1);
                        }
                    } else {
                        if ($(this).attr("flgexist") == "1") {
                            $(this).attr("flg", 1);
                        } else {
                            $(this).attr("flg", 0);
                        }
                    }

                    if ($("input[type=checkbox][flg=1]").length > 0) {
                        $("#hdnChkFlag").val(1);
                    } else {
                        $("#hdnChkFlag").val(0);
                    }
                });

            }
            var activeIndex = parseInt($("#tablist").find("a.active").closest("li").index()) + 1;
            fnShowDataAssigned(activeIndex);
        }
        function fnGetFailed(result) {
            alert(result.split("@")[1])
        }

    </script>
    <script type="text/javascript">
        function checkBoxValidate() {
            valid = true;

            if ($('input[type=checkbox]:checked').length == 0) {

                $("#dvDialog")[0].innerHTML = "Please select at least one checkbox"
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


                valid = false;
            }

            return valid;
        }



        $(document).ready(function () {

            $('#btnSave').click(function () {

                $("#loader").show()

                var flgValidate = checkBoxValidate();

                if (flgValidate == false) {
                    return false;
                }

                var objDetail = new Array();
                var FullID = $("#ConatntMatter_ddlCycleName").val();
                var CycleID = FullID.split("^")[0];
                var BandId = FullID.split("^")[1];


                var chkflag = 0;

                //var strCycleParticipantArr = new Array();
                //$("input[type=checkbox]:checked").each(function () {
                //    var ParticipantID = $(this).attr("ParticipantID");
                //    //  var CmpCycleMapId = $(this).attr("CmpCycleMapId");
                //    chkflag = $(this).attr("chkflag");
                //    strCycleParticipantArr = [{
                //        CycleID: CycleID, ParticipantID: ParticipantID, chkflag: chkflag
                //    }];
                //    objDetail.push(strCycleParticipantArr[0]);
                //});


                var strCycleParticipantArr = new Array();
                $("input[type=checkbox][flg=1]").each(function () {
                    var ParticipantID = $(this).attr("ParticipantID");

                    chkflag = this.checked ? "1" : "0";

                    strCycleParticipantArr = [{
                        CycleID: CycleID, ParticipantID: ParticipantID, chkflag: chkflag, BandId: BandId
                    }];
                    objDetail.push(strCycleParticipantArr[0]);
                });

                PageMethods.fnManageAssessmentParticipantAgCycle(CycleID,BandId, objDetail, fnUpdateParticipantCycleSuccess, fnUpdateParticipantCycleFailed)

            });

            function fnUpdateParticipantCycleSuccess(result) {
                if (result.split("@")[0] == "1") {
                    $("#dvDialog")[0].innerHTML = "Save Successfully"
                    $("#dvDialog").dialog({
                        width: "200",
                        modal: true,
                        title: "Alert",
                        buttons:
                            {
                                "Ok": function () {
                                    $(this).dialog('close');
                                }
                            }
                    });

                    $("#tblEmp  input[type=checkbox]:checked").closest("tr").attr("flgactive", "1");
                    var i = parseInt($("#tablist").find("a.active").closest("li").index()) + 1
                    $("#hdnChkFlag").val(0);
                    fnShowDataAssigned(i);
                    $("#loader").hide();

                    fnDisplayParticpantAgCycle();
                }
            }
            function fnUpdateParticipantCycleFailed(result) {
                if (result.split("@")[0] == "2") {
                    alert("Error");
                }

            }

        });

    </script>
    <script type="text/javascript">
        var OldActive = 3;
        function fnShowDataAssigned(X) {
            var CycleID = $("#ConatntMatter_ddlCycleName").val();

            if (CycleID == 0) {
                alert("Please select the Cycle Name");
                $("#ConatntMatter_ddlCycleName").eq(0).focus();
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
            if (X == 1)   ////// Assigned
            {
                $("#tblEmp tbody tr").hide();
                $("#tblEmp  tbody tr[flgactive=1]").css("display", "table-row")
            }
            else if (X == 2)  ///// No Assigned
            {
                $("#tblEmp tbody tr").hide();
                $("#tblEmp  tbody tr[flgactive=0]").css("display", "table-row")
            }
            else {
                $("#tblEmp  tbody tr").css("display", "table-row")
            }
            $("#tablist").find("a.active").removeClass("active");
            $("#tablist").find("a").eq(OldActive - 1).addClass("active");
            //PageMethods.fnDisplayParticpantAgCycle(CycleID, X, fnGetDisplaySuccessData, fnGetFailed, X);

        }
    </script>
    <script type="text/javascript">
        function fnDeleteParticipantMapping(Sender) {
            var EmpNodeID = $(Sender).attr("PNodeID")


            $("#dvDialog")[0].innerHTML = "Are you sure you want to delete this user"
            $("#dvDialog").dialog({
                width: "400",
                modal: true,
                title: "Alert",
                buttons:
                    {
                        "Yes": function () {
                            PageMethods.fnCheckMappedUsersAgCycle(EmpNodeID, fnChkSuccessMapped, fnFailed, Sender);
                        },
                        "No": function () {
                            $(this).dialog('close');
                        }
                    }
            });


        }
        function fnChkSuccessMapped(result, Sender) {


            //  var Sender = Str.split("^")[0]
            var EmpNodeID = $(Sender).attr("PNodeID")
            if (result.split("@")[0] == "1") {
                var chkFlag = result.split("@")[1]
                if (chkFlag == "1") {

                    $("#dvDialog")[0].innerHTML = "You can not delete this user because this user is already started his/her Assessment."
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

                    return false;
                }
                else {
                    PageMethods.fnDeleteUser(EmpNodeID, fnDeleteSuccess, fnFailed, Sender);
                }
            }
            else {
                alert("Error....")
            }
        }
        function fnDeleteSuccess(result, sender) {
            if (result.split("@")[0] == "1") {


                $(sender).closest('tr').find('input[type="checkbox"]').prop('disabled', false);
                $(sender).closest('tr').find('input[type="checkbox"]').prop('checked', false);
                $(sender).closest("tr").find('input[type="checkbox"]').attr('flgexist', 0);
                $(sender).closest("tr").find('input[type="checkbox"]').attr('flg', 0);


                $("#dvDialog")[0].innerHTML = "Maping Removed Successfully"
                $("#dvDialog").dialog({
                    width: "325",
                    modal: true,
                    title: "Alert",
                    buttons:
                        {
                            "Ok": function () {
                                $(this).dialog('close');
                            }
                        }
                });

                $(sender).remove();
                //    fnDisplayParticpantAgCycle();

            }
        }
        function fnFailed(result) {
            alert("Error - " + result.split("^")[1])
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">

    <div class="section-title clearfix">
        <h3 class="text-center">Batch Mapping With Participant</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycleName" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            </asp:DropDownList>
        </div>
    </div>
    <div class="form-inline mb-3 d-flex">        
        <label class="col-form-label font-weight-bold" for="Cycle" id="lblSetName"></label>
        <div class="input-group ml-auto">
            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search" CssClass="form-control"></asp:TextBox>
            <div class="input-group-append">
                <input type="button" id="btnSearch" runat="server" value="Show" class="btn btn-primary" />
            </div>
        </div>
    </div>

    <div class="body-content">
        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist" id="tablist">
            <li><a class="nav-link" onclick="fnShowDataAssigned(1)" style="cursor:pointer">Assigned</a></li>
            <li><a class="nav-link"  onclick="fnShowDataAssigned(2)" style="cursor:pointer">Un - Assigned</a></li>
            <li><a class="nav-link active" onclick="fnShowDataAssigned(3)" style="cursor:pointer">Show All</a></li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            
            <div id="dvMain" runat="server"></div>
        </div>
    </div>

    <div class="text-center">
        <input type="button" id="btnSave" value="Save" class="btns btn-submit" style="display: none" />
    </div>
    <input type="hidden" id="hdnMenuFlag" value="0">
      <input type="hidden" id="hdnChkFlag" value="0">

    <div id="loader" class="loader_bg">
        <div class="loader"></div>
    </div>
       <div id="dvDialog" style="display: none"></div>
</asp:Content>

