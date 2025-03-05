<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmDashboard.aspx.cs" Inherits="Admin_frmDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            var nvheight = $(".navbar").outerHeight(), secheight = $('.section-content').outerHeight();
            $("#ConatntMatter_dvLinks").css({ 'min-height': $(window).height() - (nvheight + secheight + 130) });
            $(".table td, .table th").css({ 'vertical-align': 'middle' });


            $("#btnGInstructions").click(function () {
                $("#dvGInstructions").dialog({
                    title: "General Instructions",
                    width: '50%',
                    maxHeight: $(window).height() - 300,
                    modal: true,
                    position: { my: 'center', at: 'center', of: window },
                    close: function () {
                        $(this).dialog("close");
                        $(this).dialog("destroy");
                    }
                });
            });

            //$("#btncasesutdy_one").click(function () {
            //    $("#casesutdy_one").dialog({
            //        title: "Case Study One",
            //        width: '80%',
            //        maxHeight: $(window).height() - 150,
            //        modal: true,
            //        position: { my: 'center', at: 'center', of: window },
            //        close: function () {
            //            $(this).dialog("close");
            //            $(this).dialog("destroy");
            //        }
            //    });
            //});
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Welcome to TVSM Assessment Centre</h3>
        <div class="title-line-center"></div>
    </div>
    <h4 class="small-heading" runat="server" id="pgsubtitle">Admin Home Page</h4>
    <div id="dvLinks" runat="server" class="clearfix"></div>

    <div class="text-right" id="btnGI" runat="server" style="display: none">
        <input type="button" id="btnGInstructions" class="btns btn-submit" value="General Instructions" />
    </div>

    <div id="dvGInstructions" style="display: none;" title="Instructions">
        <p>As a Developer for DC-1, you are required to follow the below steps:</p>
        <ol>
            <li>Go to participant exercise status and view the progress of participants mapped to you</li>
            <li>Based on case study completion status, initiate scheduling of the participant BEI by clicking on &quot;Manage Scheduling&quot;</li>
            <li>Immediately post scheduling, navigate to paticipant rating to commence rating of case study responses</li>
            <li>Ensure completion of case study evaluation prior to beginning BEI</li>
            <li>Navigate to Participant Rating to initiate BEI and complete rating</li>
        </ol>
    </div>

</asp:Content>

