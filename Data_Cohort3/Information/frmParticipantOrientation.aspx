<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmParticipantOrientation.aspx.vb" Inherits="Data_Information_Welcome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        function preventBack() { window.history.forward(); }

        setTimeout("preventBack()", 0);

        window.onunload = function () { null };
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#rolehead").css("display", "none");
            $("#liBackground").css("display", "none");

        })

    </script>
    <script type="text/javascript">
        function fnOpenParticipantOrientation() {
            var MeetingURL = document.getElementById("ConatntMatter_hdnLink").value;
            window.open(MeetingURL)
        }
        $(document).ready(function () {
            fnEnableAutomatically();
            setInterval("fnEnableAutomatically()", 10000);
        });
        function fnEnableAutomatically() {
            try {
                var hdnOTime = $("#ConatntMatter_hdnOTime").val();
                PageMethods.fnEnableAutomatically(hdnOTime, function (result) {
                            if (result == 0) {
                                $("#ConatntMatter_btnSubmit").prop("disabled", false);
                                $("#ConatntMatter_btnSubmit").removeClass("btn-cancel").addClass("btn-submit");
                            }
                        }, function (result) {
                            //alert(result._message)
                        });
            } catch (err) { }
        }

    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Participant Orientation</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="row">
        <div class="col-md-5">
            <div class="text-center">
                <img src="../../Images/Orientation.jpg" class="img-thumbnail " />
            </div>
        </div>
        <div class="col-md-7">
            <div class="mt-4">
                <h4 class="middle-title">What to expect from this process</h4>
                <ul>
                    <li>This Virtual Development Centre (VDC) is meant to measure behavioural competencies critical for your overall performance and development at TVSM.</li>
                    <li>You will be going through 6 exercises:
                        <ol>
 <li>Case Analysis</li>
<li>Internal Role Play</li>
<li>Fact Finding</li>
                            <li>Competency Based Interview</li>
                            
                           
                            <li>External Role Play</li>
                            <li>Group Discussion</li>
                        </ol>
                    </li>
                    <%--<li>Please adhere to your schedule as provided in the login credentials email</li>--%>
                    <li>Please click on the "Participant Orientation" button given below. Upon clicking the button, you will be directed to the 'Teams Meeting' for a video chat with the EY program manager.</li>
                </ul>
                <div class="text-center mt-2">
                    <input type="button" id="btnOrientation" runat="server" class="btns btn-submit" value="Participant Orientation" onclick="fnOpenParticipantOrientation()" />
                    <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-cancel" Enabled="false" Text="Next" />
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdnLink" runat="server" />
    <asp:HiddenField ID="hdnOTime" runat="server" />
</asp:Content>

