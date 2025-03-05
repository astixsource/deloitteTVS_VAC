<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmCaseStudyInstructions.aspx.vb" Inherits="frmCaseStudyInstructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%--<script src="../../Scripts/webcamV5Main.js"></script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Case Study</h3>
        <div class="title-line-center"></div>
    </div>
   
<h5>Welcome to the Behavioral Insight Tool!</h5>
    <p>The tool is designed to gain insights into your behavior and the ability to handle various workplace scenarios. </p>
<br><br>
<h5>Please read the following instructions carefully before you begin:
</h5>
   <div>
<ol>
<li>The tool consists of multiple-choice questions (MCQs) based on real-life situations you may encounter in the workplace.</li>
<li>Each question presents a situation with four possible responses.</li>
<li>Your task is to choose the response that you feel would be the most appropriate and effective for handling the situation.</li>
<li>You are encouraged to answer honestly and choose the option that best reflects how you would naturally respond in the given situation.</li>

</ol>
</div>
    <div class="text-center">
        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Next" />
    </div>
</asp:Content>

