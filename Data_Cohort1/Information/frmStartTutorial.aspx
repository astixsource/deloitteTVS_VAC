<%@ Page Title="" Language="C#" MasterPageFile="~/Data_Cohort1/MasterPage/Site.master" AutoEventWireup="true" CodeFile="frmStartTutorial.aspx.cs" Inherits="PGM_Information_frmStartTutorial" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".middle").wrap("<div class='outer-middle'></div>");
        });
        function closePopup() {
            var myVideo = $("#myvideo")[0];
            myVideo.pause();
            myVideo.currentTime = '0';

            $('.modal').fadeOut(300);
        }


        function fnAssessment() {
            window.location.href = "Intro.aspx?RspID=" + $("#ConatntMatter_hdnRSP").val().toString();            
        }

    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">My Tasks</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="section-content">
        <div class="row absolute-center">
            <div class="col-sm-6 col-md-3">
                <div class="panel-box panel-box-default">
                    <%--<div class="panel-box-title" style="background-image: url('../../Images/task-2.png')">--%>
                    <div class="panel-box-title">
                        <img src="../../Images/task-2.png" />
                        <div class="panel-box-title-text">Assessment</div>
                    </div>
                    <div class="panel-body">
                        <table class="table">
                            <tbody>
                                <tr>
                                    <td style="width: 25%">Task </td>
                                    <td>Virtual Assessment</td>
                                </tr>
                                <tr>
                                    <td>Time</td>
                                    <td>8 hours</td>
                                </tr>
                            </tbody>
                        </table>
                        <a href="#" class="btn w-100" onclick="fnAssessment();" id="assessment">Start Assessment</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hdnStatus" runat="server" />
    <asp:HiddenField ID="hdnRSP" runat="server" />
    <asp:HiddenField ID="BasketTimeAlloted" runat="server" Value="0" />
    <asp:HiddenField ID="BasketElapsedTimeInMint" runat="server" Value="0" />
    <asp:HiddenField ID="BasketElapsedTimeInSec" runat="server" Value="0" />
    <asp:HiddenField ID="BasketExcersiseID" runat="server" Value="0" />
    <asp:HiddenField ID="BasketExcersiseType" runat="server" Value="0" />
</asp:Content>



