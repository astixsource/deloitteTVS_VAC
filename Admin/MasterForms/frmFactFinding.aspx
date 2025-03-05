<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmFactFinding.aspx.vb" Inherits="frmFactFinding" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
     <script type="text/javascript">
         $(function () {
             $(".user_nav").hide();
         });
    </script>
</asp:Content>
<asp:Content ID="ContentTimer" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Instructions for Participant</h3>
        <div class="title-line-center"></div>
    </div>
    
  <h4 class="small-heading">Introduction</h4>
    <p>This fact finding exercise helps to determine your ability to research information, to make decisions and present those decisions. As GM Operations, you are responsible for production, warehousing and distribution. A short description of a situation has been provided to you demanding your immediate decision. </p>
    <p>To enable you to reach your decision, An Information Supplier (Assessor) will answer any questions you wish to ask about the situation. The Information Supplier has a considerable amount of information, which you can obtain by asking specific questions. If you ask general questions, you will be advised to make them more specific.</p>
    <p><b>Fact finding exercise timings:</b></p>
    <table class="mailtable">
        <tr>
            <td>5 minutes</td>
            <td> Read the brief and prepare your questions.</td>
        </tr>
        <tr>
            <td valign='top'>10 minutes</td>
            <td valign='top'>Interview the Information Supplier to obtain the information you require which will help you to make a decision. You may terminate the interview before the end of the 10 minutes if you so wish. Before the end of the time period, you should review the data you have collected and arrive at a decision.<br />Present your decision and the reasons behind it. </td>
        </tr>
        <tr>
            <td>5 minutes</td>
            <td>Question/Feedback by Assessor</td>
        </tr>
    </table>
    <h4 class="small-heading">The Situation</h4>
    <p>Trevor Bishop is the Marketing Manager of H Automotive. He telephoned you (few minutes ago) demanding that Peter Stevens, the Warehouse Foreman, is immediately and severely disciplined.  Your secretary took the call while you were in a meeting and told him that you would get back to him with your response to his request. </p>     
   
</asp:Content>

