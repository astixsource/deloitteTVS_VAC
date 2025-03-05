<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmBEISchedulingList.aspx.cs" Inherits="frmBEISchedulingList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
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
        #divCalander img {
            width: auto;
        }
    </style>
    <script>
        var StoreList = [];
        $(document).ready(function () {
            //$("#txtDate").val($("#ConatntMatter_hdnCycleDate").val());
            //$("#txtDate").datepicker({
            //    dateFormat: 'dd-M-yy',
            //    changeMonth: true,
            //    changeYear: true,
            //    showOn: "button",
            //    buttonImage: "../../images/calender.jpg",
            //    buttonImageOnly: true,
            //    buttonText: "Select date",
            //    onSelect: function (d, el) {
            //        fnBEIList();
            //    }
            //});



            $("#ConatntMatter_ddlCycle").on("change", function () {
                $("#divBtnscontainer").hide();
                var CycleId = $("#ConatntMatter_ddlCycle").val();
                fnBEIList(CycleId);
            });

            var SelectedCycleId = 0;
            if ($("#ConatntMatter_ddlCycle").val() === "")
            {
                SelectedCycleId = 0
            }
            else
            {
                SelectedCycleId = $("#ConatntMatter_ddlCycle").val();
            }
               

            fnBEIList(SelectedCycleId);
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
       
        var flgValidUpdate = 0;

        var arrRouteData = []; var arrSectorData = [];
        function fnBEIList(CycleId) {
            //var CycleID = $("#txtDate").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            $("#dvFadeForProcessing").show();
            PageMethods.fnGetBEIScheduleList(CycleId, function (result) {
                $("#dvFadeForProcessing").hide();
                if (result.split("|")[0] == "2") {
                    alert("Error-" + result.split("|")[1]);
                } else if (result == "") {
                    $("#divdrmmain")[0].innerHTML = "No Record Found!!!";
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
                    }
                }
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    alert("Error-" + result._message);
                }
            )
        }
       
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">BEI Scheduling List</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-group row">
       

        <label class="col-2 col-form-label" for="Cycle">Select Batch :-</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycle" runat="server" CssClass="form-control" AppendDataBoundItems="true">
              
            </asp:DropDownList>
        </div>

        <div class="col-3 offset-1">
            <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
            <input type="text" class="form-control" placeholder="Search" name="search" id="txtFindDbr">
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div id="divdrmmain"></div>
        </div>
    </div>


    

    <div id="dvDialog" style="display: none"></div>
    <div id="dvFadeForProcessing" class="loader_bg">
        <div class="loader"></div>
    </div>

    <asp:HiddenField runat="server" ID="hdnLogin" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMenuId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleDate" Value="" />
    <asp:HiddenField ID="hdnRoleId" runat="server" />
</asp:Content>
