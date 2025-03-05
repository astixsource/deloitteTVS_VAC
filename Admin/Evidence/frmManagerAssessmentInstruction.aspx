<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/SiteManager.master" AutoEventWireup="false" CodeFile="frmManagerAssessmentInstruction.aspx.vb" Inherits="Admin_Evidence_frmManagerAssessmentInstruction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%--<script src="../../Scripts/webcamV5Main.js"></script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Manager Assessment Instruction and Background</h3>
        <div class="title-line-center"></div>
    </div>
      <p><strong>Key Instructions:</strong></p>
    <ul>
         <li>Be honest and objective in your responses</li>
        <li>Use a stable internet connection to prevent disruptions while submitting the form</li>
        <li>Each question is mapped to a competency. Please ensure you answer all the questions</li>
        <li>Please provide your feedback based on below rating scale:</li>
    </ul>

    <table class="table table-bordered table-sm">
    <thead>
        <tr>
            <th><strong>Rating Scale</strong></th>
            <th> </th>
            <th><strong>Rating Level Description</strong></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>Ineffectively</strong></td>
            <td>1</td>
            <td>Does not demonstrate adequate abilities in this area. Needs significant development to increase its effectiveness.</td>
        </tr>
        <tr>
            <td><strong>Somewhat Effectively</strong></td>
            <td>2</td>
            <td>Sometimes demonstrates adequate abilities in this area but needs some development to increase effectiveness and consistency.</td>
        </tr>
        <tr>
            <td><strong>Effectively</strong></td>
            <td>3</td>
            <td>Demonstrates adequate and effective abilities in this area. Displays competence consistently.</td>
        </tr>
        <tr>
            <td><strong>Very Effectively</strong></td>
            <td>4</td>
            <td>Demonstrates effectiveness in this area across situations of varying complexity. Well above average.</td>
        </tr>
        <tr>
            <td><strong>Extremely Effectively</strong></td>
            <td>5</td>
            <td>Demonstrates exceptional abilities in this area. Significantly outperforms expectations consistently and is a role model.</td>
        </tr>
    </tbody>
</table>



    <div class="text-center">
          <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click" />
        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Next" OnClick="btnSubmit_Click" />
    </div>
</asp:Content>

