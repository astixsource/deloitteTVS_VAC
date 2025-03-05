<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmGetExperiencePageResponse.aspx.cs" Inherits="frmGetExperiencePageResponse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">   
     <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script> 
    <style type="text/css">
        /*.no-close .ui-dialog-titlebar-close {  display: none;}*/
        .bg-blue{
            background:#194597;
font-size:9pt !important;
        }
        .ui-dialog{
            z-index:10000 !important;
        }
    </style>
    <script type="text/javascript">
      
        function fnDownload() {
            var CycleID = $("#ConatntMatter_ddlCycleName").val();
            if (CycleID == 0) {
                alert("Kindly select batch first!");
                $("#ConatntMatter_ddlCycleName").focus();
                return false;
            }
            var url = "frmDownloadExcel.aspx?flg=2&CycleId=" + CycleID;
            window.open(url, "_blank");
        }
       
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Download Participant Experience Responses</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch :</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycleName" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            </asp:DropDownList>
            <input type="button" value="Download" onclick="fnDownload()" style="margin:10px 100px"  class="btn btn-primary" />
        </div>
    </div>
    <div id="dvMain" runat="server"></div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <div id="loader" class="loader-outerbg" style="display: none">
        <div class="loader"></div>
    </div>
      <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField runat="server" ID="hdnRoleId" value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" value="0" />
    
</asp:Content>


