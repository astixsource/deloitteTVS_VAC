<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteAssessor.master" AutoEventWireup="true" CodeFile="frmAssessorPreDCPostDC.aspx.cs" Inherits="Admin_MasterForms_frmAssessorDC_Orien_FeedbackProcess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .card-header{
            cursor:pointer;
            text-align:center;
        }
        .card-header:hover,
        .card-header:active,
        .card-header.active{
            background:#007BFF;
            color:#FFF;
        }
		.card-body{
		min-height: 140px;
		}
    </style>
    <script type="text/javascript">
        function fnOpenAssessorForm(flg) {
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            PageMethods.fnGetAssessmentCycleListForAssessor(flg, LoginId, function (result) {
                $("#loader").hide();
                var sdata = $.parseJSON('[' + result + ']');
                if (sdata[0].Table.length > 0) {
                    var cycleid = sdata[0].Table[0]["CycleId"];
                    var cyclename = sdata[0].Table[0]["CycleName"];
                    if (flg == 1) {
                        var Orient_AssesseeMeetLink = sdata[0].Table[0]["Orient_AssesseeMeetLink"];
                        window.location.href = "frmAssessorPreDCDashboard.aspx?cycleid=" + cycleid + "&cyclename=" + cyclename + "&LoginId=" + LoginId;
                    } else if (flg == 2) {
                        var Orient_AssesseeMeetLink = sdata[0].Table[0]["Orient_AssesseeMeetLink"];
                        var MeetingId = sdata[0].Table[0]["Orient_MeetingID"];
                        var BEIUsername = sdata[0].Table[0]["BEIUsername"];
                        var BEIPassword = sdata[0].Table[0]["BEIPassword"];
                        window.location.href = "frmAssessorDC_Orien_FeedbackProcess.aspx?cycleid=" + cycleid + "&cyclename=" + cyclename + "&Orientlink=" + Orient_AssesseeMeetLink + "&MeetingId=" + MeetingId;
                    } else {
                        alert("No DC Found!");
                    }
                } else {
                    alert("No DC Found!");
                }
            }, function (results) {
                $("#loader").hide();
                alert("Error-" + results._message);
            })
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
        <p class="text-center">Please click on the below option to access respective tab. You can click the home button provided at the top right corner to come back to this page.</p>
    </div>
    <div class="row absolute-center">
        <div class="col-3">
            <div class="card">
                <h6 class="card-header" onclick="fnOpenAssessorForm(1)">PRE- DC</h6>
                <div class="card-body">
                    <p>View General Instructions, Tools, Competency Model and participant details for the upcoming batch</p>
                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card">
                <h6 class="card-header" onclick="fnOpenAssessorForm(2)">DURING- DC</h6>
                <div class="card-body">
                    <p>Join Orientation Session, navigate through the ongoing DC process and conduct feedback session</p>
                </div>
            </div>
        </div>
        <div class="col-3">
            <div class="card">
                <h6 class="card-header" onclick="fnOpenAssessorForm(3)">POST-DC</h6>
                <div class="card-body">
                    <p>View reports for all participants assessed by you. Document and submit Pen Pictures and join IDP discussions for the recent batch</p>
                </div>
            </div>
        </div>
    </div>
    <div id="loader" class="loader-outerbg" style="display: none">
        <div class="loader"></div>
    </div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleName" Value="" />

</asp:Content>

