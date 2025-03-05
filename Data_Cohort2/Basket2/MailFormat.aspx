<%@ Page Title="" Language="C#" MasterPageFile="~/Data_Cohort2/MasterPage/SiteInbasket.master" AutoEventWireup="true" CodeFile="MailFormat.aspx.cs" Inherits="MailFormat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .divContent{
    margin-top:48px;
}
        table.Financials-tbl {
            width: 60% !important;
        }

            table.Financials-tbl > tbody > tr > td:first-child {
                text-align: left;
            }

            table.Financials-tbl > tbody > tr > td:last-child {
                width: 100px;
                text-align: center;
            }

        .td-bg {
            background: #bfbfbf;
        }

        .main-box {
            padding-bottom: 0px !important;
        }

        .valign-b {
            vertical-align: middle !important;
            background: #F2DBDB;
        }

        .hilight_date {
            border: 2px solid transparent;
            border-radius: 20px;
            display: inline-block;
            padding: 1px 4px;
            -moz-border-radius: 20px;
            -webkit-border-radius: 20px;
            -khtml-border-radius: 30px;
        }

            .hilight_date.red {
                border-color: #ff0000 !important;
            }

            .hilight_date.green {
                border-color: #009219 !important;
            }

        .legend {
            color: #3D3A3C;
            border:1px solid #ddd;
            position: relative;
            padding-left:30px;
            padding-right:15px;
            display: inline-block;
        }

            .legend::before {
                content: "";
                position: absolute;
                width: 22px;
                height: 22px;
                left:0;
                top:0;                
                background: #D3D3D5;
            }
    </style>
    <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        $(document).ready(function () {
            $("#panelback").hide();
            //$("#imgLogo2").css("margin-right", "95px");

            $("#frmLeft, #frmRight").css({
                "height": $(window).height()-70,
                'width': '100%',
                'overflow': 'hidden',
                'margin-top': '0px'
            });
            var snjittblW = $("table#Sanjittbl-1").width(), snjittblCol = $("table#Sanjittbl-1 tr").find("th").length
            var snjittblW2 = $("table#Sanjittbl-2").width(), snjittblCol2 = $("table#Sanjittbl-2 tr").find("th").length
            $("table#Sanjittbl-1 tr th").css({
                width: snjittblW / snjittblCol + "%"
            });
            $("table#Sanjittbl-2 tr th").css({
                width: snjittblW2 / snjittblCol2 + "%"
            });
        });

        var binding = "";
        $(document).ready(function () {
            var sURL = "frmInbox.aspx?ExerciseID=" + document.getElementById("ConatntMatter_hdnExerciseID").value + "&ElapsedTimeMin=" + document.getElementById("ConatntMatter_hdnTimeElapsedMin").value +
                "&ElapsedTimeSec=" + document.getElementById("ConatntMatter_hdnTimeElapsedSec").value + "&TotalTime=" + document.getElementById("ConatntMatter_hdnTotalTime").value + "&RspID=" + document.getElementById("ConatntMatter_hdnRspID").value + "&BandID=" + document.getElementById("ConatntMatter_hdnBandID").value + "&ExerciseType=" + document.getElementById("ConatntMatter_hdnExerciseType").value + "&intLoginID=" + document.getElementById("ConatntMatter_hdnLoginID").value
            $("#frmRight").attr("src", sURL);
            binding = document.getElementById("ConatntMatter_hdnBandID").value;
        });

        function fnLeftPopup(cntr) {
            var filename = "";
            var divname = "";
            var foldername = "";

            if (cntr == 4) {
                filename = "Brief";
                divname = "Brief";
                $("#Brief").dialog({
                    title: "Brief",
                    width: "65%",
                    height: "480",
                    position: { my: 'center', at: 'center', of: window },
                    modal: true,
                    draggable: false,
                    resizable: false
                });

            }
            else if (cntr == 5) {
                filename = "SepCalendar";
                divname = "SepCalendar";
                $("#SepCalendar").dialog({
                    title: "March Calendar",
                    width: "65%",
                    height: "480",
                    position: { my: 'center', at: 'center', of: window },
                    modal: true,
                    draggable: false,
                    resizable: false
                });

            }
            else if (cntr == 6) {
                filename = "SajitCalendars";
                divname = "SajitCalendars";
                $("#SajitCalendars").dialog({
                    title: "Sanjit’s Calendar",
                    width: "65%",
                    height: "480",
                    position: { my: 'center', at: 'center', of: window },
                    modal: true,
                    draggable: false,
                    resizable: false
                });
            }
            else if (cntr == 7) {
                filename = "ProStructure";
                divname = "ProStructure";
                var src = "<img src='../../Images/set-1_inbx-img.jpg' />";
                $("#OrgStructure").html(src)
                $("#ProStructure").dialog({
                    title: "Project Structure",
                    width: "65%",
                    height: "480",
                    position: { my: 'center', at: 'center', of: window },
                    modal: true,
                    draggable: false,
                    resizable: false
                });
            }

            //binding
            //if (binding == "1") {
            //    foldername = "PgM";
            //}
            //else if (binding == "2") {
            //    foldername = "ADH";
            //}
            //else if (binding == "3") {
            //    foldername = "DM";
            //}

        }

        function fnStartLoading() {
            $("#dvLoadingFade").css("display", "table");
        }
        function fnEndLoading() {
            $("#dvLoadingFade").css("display", "none");
        }

        function fnlogout() {
            window.location.href = "../Exercise/ExerciseMain.aspx?intLoginID=" + document.getElementById("ConatntMatter_hdnLoginID").value;
        }
    </script>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime">Time Left
        00: 00: 00</time>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="row divContent">
        <div class="col-md-2 col-sm-3">
            <div class="row">
                <iframe name="frmLeft" id="frmLeft" src="frmLeft.aspx" frameborder="0"></iframe>
            </div>
        </div>
        <div class="col-md-10 col-sm-9">
            <div class="row">
                <iframe name="frmRight" id="frmRight" frameborder="0"></iframe>
            </div>
        </div>
    </div>

    <div id="Brief" style="display: none">
        <div class="section-title">
            <h3 class="text-center">Brief</h3>
            <div class="title-line-center"></div>
        </div>
        <h4 class="middle-title">THE ORGANIZATION</h4>
        <p>Reliable Steels Industries was formed in 2000 in India by 3 passionate partners from the Metals and Mining Industry. They started this with all their earnings, with a deep passion to serve the Steel industry.</p>
        <p>Reliable has 10 plants in India, with 20,000 employees. They have been a high profit and high growth organization and among the top 3 in India and Top 10 globally.</p>
        <p>In the last decade, their growth has increased by the manufacturing of a steel product, which finds major market in developed countries.</p>
        <div class="row">
            <div class="col-md-12">
                <h4 class="middle-title">The Role</h4>
                <p>You are <strong>Roshan Singh</strong> and the Vice President and Plant Head for the largest plant of Reliable Steels Industries. You have joined 2 years back to take this role and you earlier worked with another competitor based out of India.</p>
                <p>Today is 14th March 2024. You were on your annual one-week leave till yesterday. You have resumed at 1 pm today. On your way to work, you receive a call from your reporting manager Sunil Parihar that you are required to represent your organization, along with one of your partners, at the Indian Steel Organization Annual Conference. The conference begins tomorrow and you will need to take the last flight out tonight. You will be out of office for the next 4 days. Essentially this gives you 3-4 hours at work today to work on pending things from the last week and to also clear any actions for this week.</p>
                <p>Supriya, who also supports you as &amp; when required, has left the following mails at your desk for your appropriate action. The emails have been left in no particular order.</p>
            </div>
        </div>
    </div>

    <div id="SepCalendar" style="display: none;">
        <%--<table class="table table-bordered text-center table-sm mb-0">
            <thead>
                <tr>
                    <th colspan="7">September</th>
                </tr>
                <tr>
                    <th>SUN</th>
                    <th>MON</th>
                    <th>TUE</th>
                    <th>WED</th>
                    <th>THU</th>
                    <th>FRI</th>
                    <th>SAT</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>&nbsp;</td>
                    <td>1</td>
                    <td>2</td>
                    <td>3</td>
                    <td>4</td>
                    <td>5</td>
                    <td>6</td>
                </tr>
                <tr>
                    <td>7</td>
                    <td>8</td>
                    <td>9</td>
                    <td>10</td>
                    <td>11</td>
                    <td>12</td>
                    <td>13</td>
                </tr>
                <tr>
                    <td>14</td>
                    <td>15</td>
                    <td>16</td>
                    <td>
                        <div class="hilight_date red">17</div>
                    </td>
                    <td>18</td>
                    <td>19</td>
                    <td>
                        <div class="hilight_date red">20</div>
                    </td>
                </tr>
                <tr>
                    <td>21</td>
                    <td style="background-color: lightgray">22</td>
                    <td style="background-color: lightgray">23</td>
                    <td style="background-color: lightgray">24</td>
                    <td style="background-color: lightgray">25</td>
                    <td style="background-color: lightgray">26</td>
                    <td>27</td>
                </tr>
                <tr>
                    <td>28</td>
                    <td>
                        <div class="hilight_date green">29</div>
                    </td>
                    <td>30</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </tbody>
        </table>--%>
         <div class="col-md-6">
                 <div class="about-img-one">
                <img src="../../Images/Set2_Calender.png" class="img-thumbnail" />
            </div>
                <p>Official Holidays [7th March, 24th March, 25th March]</p>
            </div>
       
    </div>

    <div id="SajitCalendars" style="display: none">
        <div class="section-title">
            <h3 class="text-center">Sanjit’s Calendar</h3>
            <div class="title-line-center"></div>
        </div>
        <table class="table table-bordered text-center" id="Sanjittbl-1">
            <thead>
                <tr>
                    <th>September</th>
                    <th>21</th>
                    <th>22</th>
                    <th>23</th>
                    <th>24</th>
                    <th>25</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>09.00 – 10.00</td>
                    <td>&nbsp;</td>
                    <td rowspan="2" class="valign-b">Meeting with Construction team</td>
                    <td class="valign-b">MD &amp; CEO Update</td>
                    <td rowspan="5" class="valign-b">Site Visit</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>10.00 – 11.00</td>
                    <td rowspan="3" class="valign-b">Vendor Review Meeting – Siraj Khan</td>
                    <td>&nbsp;</td>
                    <td rowspan="3" class="valign-b">Candidate Interview – Parwati Unnikrishnan</td>
                </tr>
                <tr>
                    <td>11.00 – 12.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>12.00 – 13.00</td>
                    <td>&nbsp;</td>
                    <td class="valign-b">Meeting with Akshay Lal</td>
                </tr>
                <tr>
                    <td>13.00 – 14.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>14.00 – 15.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td rowspan="3" class="valign-b">Board Meeting – Arpit Mathur</td>
                    <td>&nbsp;</td>
                    <td rowspan="3" class="valign-b">Weekly Update – All hands</td>
                </tr>
                <tr>
                    <td>15.00 – 16.00</td>
                    <td class="valign-b">IRIS City Project Update</td>
                    <td rowspan="2" class="valign-b">Client Update – On Call</td>
                    <td>Discussion - QRM</td>
                </tr>
                <tr>
                    <td>16.00 – 17.00 </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>17.00 – 18.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="valign-b">Retirement Dinners – Lalit Anandani</td>
                    <td>&nbsp;</td>
                </tr>
            </tbody>
        </table>
        <table class="table table-bordered text-center" id="Sanjittbl-2">
            <thead>
                <tr>
                    <th>September/ October</th>
                    <th>28</th>
                    <th>29</th>
                    <th>30</th>
                    <th>1</th>
                    <th>2</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>09.00 – 10.00</td>
                    <td>&nbsp;</td>
                    <td rowspan="9" class="valign-b">Site Visit</td>
                    <td rowspan="2" class="valign-b">Procurement Update – Nishit Kumar Mehra</td>
                    <td class="valign-b">MD &amp; CEO Update</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>10.00 – 11.00</td>
                    <td class="valign-b">Training Needs –Manpreet Saini</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>11.00 – 12.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td rowspan="2" class="valign-b">Meeting with Client</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>12.00 – 13.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>13.00 – 14.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>14.00 – 15.00</td>
                    <td rowspan="4" class="valign-b">Vendor Review meeting – Anil Swamy</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td rowspan="3" class="valign-b">Weekly Update – All hands</td>
                </tr>
                <tr>
                    <td>15.00 – 16.00</td>
                    <td class="valign-b">HSE Review – Bhaumik Lalwani</td>
                    <td class="valign-b">Production Review</td>
                </tr>
                <tr>
                    <td>16.00 – 17.00 </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>17.00 – 18.00</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div id="ProStructure" style="display: none">
        <div class="section-title">
            <h3 class="text-center">ORGANIZATION CHART</h3>
            <div class="title-line-center"></div>
        </div>
        <div class="text-center">
            <img src="../../Images/Set2_OrgChart.png" class="img-thumbnail" />
        </div>
    </div>

    <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnBandID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseType" runat="server" Value="0" />
    <asp:HiddenField ID="hdnExerciseTotalTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedMin" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTimeElapsedSec" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTotalTime" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnLoginID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnRSPDetID" runat="server" Value="0" />
     <asp:HiddenField ID="hdnIsProctoringEnabled" runat="server" Value="0" />
</asp:Content>


