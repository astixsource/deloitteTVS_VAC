<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteAssessor.master" AutoEventWireup="true" CodeFile="frmUndertakingPage.aspx.cs" Inherits="Admin_MasterForms_frmUndertakingPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        function fnChkAgree(flg) {
            if ($("#chkAgree").is(":checked")) {
                var LoginId = $("#ConatntMatter_hdnLoginId").val();
             //   alert(LoginId);
                window.location.href = "frmAssessorPreDCPostDC.aspx?&LoginId=" + LoginId;
            }
            else {
                $("#dvDialog")[0].innerHTML = "<center>Please click on ''I agree'' to proceed further.</center>";
                $("#dvDialog").dialog({
                    title: 'Consent Message',
                    modal: true,
                    width: '30%',

                    buttons: [{
                        text: "OK",
                        click: function () {

                            $("#dvDialog").dialog("close");
                        }
                    }],
                    close: function () {
                        $(this).dialog("close");
                        $(this).dialog("destroy");

                        return false;
                    }
                });
                return false;
            }
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div>
        <div>
            <p>Dear Developer,</p>
            <p>In this letter “Information” shall mean any information comprising inter alia products, processes, methodologies, frameworks, models, ideas, interpretations, documentation, manuals, software, discs, reports, research, working notes, papers and techniques used by EY in connection with Assessment Centres for Larsen &amp; Toubro in whatever form.</p>
            <p>In consideration of EY granting you access to the Information, you undertake with <b>EY and as consultant for Larsen &amp; Toubro</b> that:</p>
            <ol type="1">
                <li>Subject to Clause 8 below, you will keep the Information strictly confidential and will not disclose it to any third party without our prior written consent. </li>
                <li>The Information will only be disclosed to those personnel of Larsen &amp; Toubro and EY who need access to the Information for the proper performance of their duties in relation to the project and only to the extent necessary for the purpose of the project.  You will take appropriate steps to ensure that all personnel to whom access to the Information is given are aware of its confidentiality, and that they are bound by restrictions at least as onerous as those placed on you by the terms of this letter.</li>
                <li>You acknowledge that some or all of the Information is or may be price-sensitive information [defined in Regulation 2(ha) of the Securities and Exchange Board of India (Prohibition of Insider Trading) Regulations, 1992, as amended and currently in force] and that the use of such information may be regulated or prohibited by applicable legislations relating to insider dealing and you undertake not to use any Information for any unlawful purpose. On acquiring any Information, you shall comply with all applicable laws in India in relation to insider trading and otherwise the acquisition of securities.</li>
                <li>You agree to indemnify and hold harmless EY, its partners and staff and any of our clients to whom the Information relates against all loss, damage and expense (including legal expenses relating to any actions, proceedings and claims brought or threatened) of whatsoever nature and howsoever arising out of or in connection with (a) any breach by you, your directors or personnel of the terms and conditions of the letter, or (b) any violation of the laws described in clause 3 above.</li>
                <li>The Information disclosed to you will be used solely for the purpose of conducting Assessment Centres for Larsen &amp; Toubro You will establish and maintain all reasonable security measures to provide for the safe custody of the Information and to prevent unauthorised access to it.</li>
                <li>On the termination of the above project/our engagement/dealings with each other, or immediately upon being requested to do so, you will return all the Information disclosed to you, and any copies thereof.</li>
                <li>The obligations contained above shall not apply to any Information which
                    <ul>
                        <li>is or subsequently comes into the public domain otherwise than through a breach of this agreement;</li>
                        <li>is already rightfully in your possession;</li>
                        <li>is obtained by you from a third party without any restriction on disclosure;</li>
                        <li>you are required to disclose by law or professional or regulatory obligation.</li>
                    </ul>
                </li>
                <li>If you become aware of any breach of confidence or threatened breach of confidence by any of your employees, agents or sub-contractors you will promptly notify us of the same and give us all reasonable assistance in connection with any proceedings which we may institute against such persons.</li>
                <li>You acknowledge that we retain the copyright and intellectual property rights in the Information and that you may not copy, adapt, modify or amend any part of the Information or otherwise deal with any part of the Information except with our prior express written authority.</li>
                <li>You will comply with the obligations set out herein indefinitely.</li>
            </ol>
        </div>
    </div>

    <div class="text-center">
        <input type="Checkbox" id="chkAgree" />
        <input type="button" id="btnAgree" value="I Agree" class="btns btn-submit" onclick="fnChkAgree(1)" />
        <%--   <div class="text-center mt-4"><a href="##" id="btnNext" class="btns btn-submit" onclick="fnNext(1)">Continue</a></div>--%>
        <%-- <asp:Button ID="btnSubmit" style="visibility:hidden" runat="server"  Text="I Agree" />--%>
    </div>

    <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleName" Value="" />

</asp:Content>

