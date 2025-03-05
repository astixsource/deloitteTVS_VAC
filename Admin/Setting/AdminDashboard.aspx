<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="Admin_Setting_AdminMenu" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style>
        /*#ConatntMatter_dvLinks table tr:nth-child(1) td:nth-child(2){
            width:260px;
        }*/

        .table td {
            vertical-align: middle !important;
        }
        .col-fst{
            width: 170px;
            color: rgb(4, 77, 145);
            text-align: center;
            font-weight: 500;
            text-transform: uppercase;
            vertical-align: middle;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-content">
        <div class="section-title clearfix m-0">
            <h3 class="text-center">Welcome to TVSM Assessment Centre</h3>
            <div class="title-line-center"></div>
        </div>
        <h4 class="small-heading" runat="server" id="pgsubtitle">Admin Home Page</h4>
        <p>Please click on the below options to access respective tabs. You can click on the Back button to come back to this page & Home button for Main Menu, provided at the top right corner.</p>
    </div>
    <div id="dvLinks" runat="server" class="clearfix"></div>
</asp:Content>
