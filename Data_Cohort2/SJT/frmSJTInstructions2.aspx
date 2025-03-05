<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/SiteInstruction.master" AutoEventWireup="false" CodeFile="frmSJTInstructions2.aspx.vb" Inherits="SJT_frmSJTInstructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%--<script src="../../Scripts/webcamV5Main.js"></script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Situational Judgment Test (SJT)</h3>
        <div class="title-line-center"></div>
    </div>
      <p><strong>Instructions:</strong></p>
    <ul>
        <li>Read each scenario carefully and choose the most effective response.</li>
       <%-- <li>Consider the organizational context of fictitious Organisation - <em>Prism Technologies</em> while answering.</li>--%>
        <li>Total time allotted: 30 minutes.</li>
        <li>Select the responses from the options provided</li>
    </ul>
  <%--  <p><strong>Prism Technologies India Pvt. Ltd.</strong></p>
    <p>Prism Technologies aims to double its market share in the next five years through innovation, operational efficiency, and a focus on sustainability. However, it faces challenges such as fluctuating raw material costs, competition from global players, and tightening government regulations on emissions.</p>
    <p><strong>Industry:</strong> Precision manufacturing specializing in industrial equipment and automation solutions.</p>
    <p><strong>Operations:</strong></p>
    <ul>
        <li>Headquarters in Pune, with manufacturing units in Chennai and Ahmedabad.</li>
        <li>Key clients include automotive, renewable energy, and heavy machinery sectors.</li>
        <li>Annual revenue: ₹2,500 crores; net profit margin: 8%.</li>
        <li>Workforce: 4,500 employees across manufacturing, R&amp;D, and sales.</li>
    </ul>--%>
    <div class="text-center">
          <asp:Button ID="btnBack" runat="server" CssClass="btns btn-submit" Text="Back" OnClick="btnBack_Click" />
        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Next" />
    </div>
     <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />
</asp:Content>

