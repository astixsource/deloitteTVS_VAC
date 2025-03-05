<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteAssessor.master" AutoEventWireup="true" CodeFile="frmParticipantListAgainstCycleForAssessor.aspx.cs" Inherits="Admin_MasterForms_frmParticipantListAgainstCycleForAssessor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style>
        tr.clstrgdmapped > td {
            background-color: #f5f5f5;
        }
    </style>
    <script type="text/javascript">

        $(document).ready(function () {
            fnUserList();
        });

        function fnView_Details(ctrl) {
           
            //var vanNodeType = $(ctrl).closest("tr").attr("ActivityID");
            var CycleId = $("#ConatntMatter_hdnCycleId").val();
            var cyclename = $("#ConatntMatter_hdnCycleName").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            var participantid = $(ctrl).closest("tr").attr("participantid");

            // alert(CycleId);
            window.location.href = "frmViewDetail.aspx?cycleid=" + CycleId + "&cyclename=" + cyclename + "&LoginId=" + LoginId + "&participantid=" + participantid; // For Server Update
           //     window.location.href = "/Admin/MasterForms/frmViewDetail.aspx?cycleid=" + CycleId + "&cyclename=" + cyclename + "&LoginId=" + LoginId; // For Local Machine
  

        }
        function fnUserList() {
            // var CycleId = 4; //$("#ConatntMatter_ddlCycle").val().split("^")[0];
            //var LoginId = 795; //$("#ConatntMatter_hdnLoginId").val();
            var CycleId = $("#ConatntMatter_hdnCycleId").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();

            //  alert(CycleId);
            //  alert(LoginId);

            $("#dvFadeForProcessing").show();
            PageMethods.fngetdata(CycleId, LoginId, function (result) {
                $("#dvFadeForProcessing").hide();
                $("#ConatntMatter_divdrmmain").show();
                $("#ConatntMatter_divdrmmain").html(result);
                $("#ConatntMatter_divdrmmain").prepend("<div id='tblheader'></div>");
                if ($("#tbldbrlist").length > 0) {
                    var wid = $("#tbldbrlist").width(), thead = $("#tbldbrlist").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tbldbrlist").css({ "width": wid, "min-width": wid });

                    for (i = 0; i < $("#tbldbrlist").find("th").length; i++) {
                        var th_wid = $("#tbldbrlist").find("th")[i].clientWidth;
                        $("#tblEmp_header, #tbldbrlist").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tbldbrlist").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                    $('#dvtblbody').css({
                        'height': $(window).height() - 380,
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                    $(".mergerow").closest('tr').find('td').css('border-top', '2px solid black');
                }
                // }
            },
                function (result) {
                    $("#dvFadeForProcessing").hide();
                    alert("Error-" + result._message);
                }
            )
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Welcome to L&T DC-4</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="section-content">
        <h4 class="middle-title">Developer Home Page</h4>
    </div>
<%--    <div class="section-title clearfix">
        <h3 class="text-center">Participant List</h3>
        <div class="title-line-center"></div>
    </div>--%>
    <div class="section-content">
        <div id="divdrmmain" runat="server" style="min-height: 300px"></div>
    </div>

    <div id="dvDialog" style="display: none"></div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvFadeForProcessing" class="loader_bg">
        <div class="loader"></div>
    </div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMenuId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMailFlag" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleName" Value="" />
    <asp:HiddenField runat="server" ID="hdnOrientationMeetingLink" Value="" />
    <asp:HiddenField runat="server" ID="hdnFeedbacksessionMeetingLink" Value="" />
</asp:Content>

