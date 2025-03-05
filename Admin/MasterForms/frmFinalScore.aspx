<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmFinalScore.aspx.cs" Inherits="Admin_MasterForms_frmFinalScore" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script>
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        $(document).ready(function () {
            $("#ConatntMatter_dvMain").css("height", $(window).height() - 280);
            //$("#dvloader").hide();
            fnGetMapping();
        });

        function fnGetMapping() {
            var batch = $("#ConatntMatter_ddlBatch").val();

            $("#dvloader").show();
            PageMethods.fnGetEntries(batch, fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#ConatntMatter_dvMain").html(res);
            //$("#tblMapping").find("select").each(function () {
            //    $(this).html($("#ConatntMatter_hdnUserlst").val());
            //    $(this).val($(this).attr("defval"));
            //});

            //var MappingStatus = result.split("|")[1];
            //if (MappingStatus != "") {
            //    if (parseInt(MappingStatus) > 2) {
            //        $("#btnSubmit").hide();
            //        $("#spnmeeting")[0].innerHTML = MappingStatus == "0" ? "Mapping Not Done" : (MappingStatus == "2" ? "Mapping Done" : "Meeting Created");
            //    }
            //    else if (parseInt(MappingStatus) == 1) {
            //        $("#btnSubmit").show();
            //        $("#spnmeeting")[0].innerHTML = "Mapping Partially Done";
            //    }
            //    else {
            //        $("#spnmeeting")[0].innerHTML = MappingStatus == "0" ? "Mapping Not Done" : (MappingStatus == "2" ? "Mapping Done" : "Meeting Created");
            //    }
            //}

            $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");
            if ($("#tblScheduling").length > 0) {
                var wid = $("#tblScheduling").width(), thead = $("#tblScheduling").find("thead").eq(0).html();
                $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered bg-white table-sm clsTarget' style='width:" + (wid - 1) + "px;margin:0'><thead class='thead-light text-center'>" + thead + "</thead></table>");
                $("#tblScheduling").css({ "width": wid, "min-width": wid });

                for (i = 0; i < $("#tblScheduling").find("th").length; i++) {
                    var th_wid = $("#tblScheduling").find("th")[i].clientWidth;
                    $("#tblEmp_header, #tblScheduling").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                }
                $("#tblScheduling").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                $('#dvtblbody').css({
                    'height': $(window).height() - 355,
                    'overflow-y': 'auto',
                    'overflow-x': 'hidden'
                });
            }

            $("#dvloader").hide();
        }
        function fnfail(results) {
            alert("Due to some technical reasons, we are unable to process your request !");
            //alert(results.get_message());
            //$('#diverror').html(results.get_message());
            $("#dvloader").hide();
        }
        

        function fndownload(ctrl)
        {
            //var empnodeid = $(ctrl).closest('tr').attr('employeenodeid');
            //var cycleid = $("#ConatntMatter_ddlBatch").val();
            $("#ConatntMatter_hdnfilename").val($(ctrl).closest('td').prev('td').text() + "_" + $("#ConatntMatter_ddlBatch option:selected").text());
            $("#ConatntMatter_hdnScore").val($(ctrl).closest('tr').attr('employeenodeid') + '^' + $("#ConatntMatter_ddlBatch").val());
            $("#ConatntMatter_btndownload").click();
        }


       
        
    </script>
    <style>
        #ConatntMatter_dvMain {
            overflow:auto;
        }

        #tblScheduling th {
            vertical-align: middle;
        }

        #tblScheduling tbody tr:nth-child(1) td:nth-child(1)
         {
            width: 30%;
        }      

        #tblScheduling td:nth-child(2)
        {
            width:10%;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
        }

        /*#tblScheduling td.cls-3,
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
        }*/

        .cls-bg-gray{
            background: #ccc;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" Runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Final Score</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-inline mb-3 d-flex">
        <label for="ac" class="col-form-label mr-3">Select Batch</label>
        <div class="input-group">
            <asp:DropDownList ID="ddlBatch" runat="server" CssClass="form-control" onchange="fnGetMapping();">
            </asp:DropDownList>
        </div>
        <div class="input-group ml-auto">
        </div>
    </div>

    <div id="dvMain" runat="server"></div>
   
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <asp:HiddenField ID="hdnUserlst" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
    <asp:HiddenField id="hdnScore" runat="server"/>
    <asp:HiddenField id="hdnfilename" runat="server"/>
    <asp:Button id="btndownload" runat="server" style="display:none;" OnClick="btndownload_click"/>
    <div id="diverror"></div>
</asp:Content>

