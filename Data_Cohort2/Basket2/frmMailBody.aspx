<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmMailBody.aspx.cs" Inherits="frmMailBody" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,Chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title></title>
    <!-- Latest compiled and minified CSS -->
    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        body {
            font-weight: 300;
            font-size: .85rem !important;
            font-weight: normal;
        }

        .panel {
            position: relative;
        }

        .nav-tabs {
            position: fixed;
            top: 39px;
            left: 10px;
            width: 100%;
            background: #fff;
        }

            .nav-tabs > li {
                margin-bottom: -1px;
            }

                .nav-tabs > li > a.nav-link {
                    background: #d9edf7;
                    color: #31708f;
                    margin-right: 5px;
                    border: 1px solid #bce8f1;
                    position: relative;
                }

                    .nav-tabs > li > a.nav-link::after {
                        content: "";
                        background: #4285F4;
                        height: 3px;
                        position: absolute;
                        width: 100%;
                        left: 0px;
                        top: -1px;
                        transition: all 250ms ease 0s;
                        transform: scale(0);
                    }

                    .nav-tabs > li > a.nav-link.active {
                        color: #044d91;
                    }

                        .nav-tabs > li > a.nav-link.active::after,
                        .nav-tabs > li > a.nav-link:hover::after {
                            transform: scale(1);
                        }

        .tab-nav > li > a.nav-link::after {
            background: #21527d none repeat scroll 0% 0%;
            color: #fff;
        }

        .tab-content {
            padding: 15px;
        }

            .tab-content > .tab-panel {
                margin-top: 30px;
            }

        .fade {
            display: none;
        }

        .show {
            display: block !important;
        }

        table.mailtable {
            border-collapse: collapse;
            border-spacing: 0;
            margin-bottom: 20px;
        }

            table.mailtable > tbody > tr > td,
            .tab-panel > .mailbodydv {
                padding: 2px 6px;
            }

                table.mailtable > tbody > tr > td:nth-child(1) {
                    width: 90px;
                    font-weight: 700;
                }

        .mail-signature-block {
            display: inline-block !important;
            min-width: 328px;
        }

            .mail-signature-block > img {
                float: right;
                width: 50px;
            }

        .valign-b {
            vertical-align: middle !important;
            background: #F2DBDB;
        }

        .table > thead > tr > th {
            vertical-align: bottom;
            background: #cfcfcf;
            color: #0371c0;
            text-align: center;
            font-size: 9.5pt;
        }

        table#Financials-tbl > tbody > tr > td:first-child {
            text-align: left !important;
        }
    </style>
    <!-- Latest compiled and minified JavaScript -->
   <%-- <script src="../../Scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="../../Scripts/popper.min.js" type="text/javascript"></script>
    <script src="../../Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function IframeHide(par) {
            parent.hideShowIframe(par);
        }
        $(document).ready(function () {
            ``
            var snjittblW = $("table#Sanjittbl-1").width(), snjittblCol = $("table#Sanjittbl-1 tr").find("th").length
            var snjittblW2 = $("table#Sanjittbl-2").width(), snjittblCol2 = $("table#Sanjittbl-2 tr").find("th").length
            var Financials = $("table#Financials-tbl").width(), FinancialsCol = $("table#Financials-tbl tr").find("td").length
            $("table#Sanjittbl-1 tr th").css({
                width: snjittblW / snjittblCol + "%"
            });
            $("table#Sanjittbl-2 tr th").css({
                width: snjittblW2 / snjittblCol2 + "%"
            });
            $("table#Financials-tbl tr td").css({
                width: Financials / FinancialsCol + "%"
            });
        });
    </script>--%>
</head>
<body>
    <form id="form1" runat="server">
        <div id="dvBodyContainer">
            <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="1">
                <%--View 0--%>
                <asp:View ID="View0" runat="server">
                    <div class="text-center">Please click on the Mail Name to view.</div>
                </asp:View>

                <asp:View ID="View1" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">
                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Urgent: Consolidated Expense Report and Cost Efficiency Insights Not Received</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Satish Verma, Head- Accounts, Head Office</td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We were expecting the consolidated expense report for the last quarter from your area, but it has not yet been received at the Head Office. In addition to the report, we would appreciate any insights on cost efficiency measures or improvements that can be implemented in your area. These insights are critical for our ongoing cost optimization and strategic planning.&nbsp;</p>
                            <p>Best regards,</p>
                            <p>Satish Verma, Head-Accounts</p>
                            <p>Head Office</p>

                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View2" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Request for Support on Unresolved Customer Complaints </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Suresh Patel, Territory Manager – Cuttack, Orissa</td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>Over the past week, I have encountered several customer complaints from dealerships in the Cuttack region, primarily regarding vehicle performance issues and delayed part deliveries. Despite my efforts, these concerns have not yet been resolved. Could you kindly provide your advice or support on how best to address these matters?&nbsp;</p>
                            <p>
                                Best regards,<br />
                                Suresh Patel<br />
                                Territory Manager, Cuttack, Orissa
                            </p>
                            <p>TVS Motor Company</p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View3" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Invite for Participation in Yearly Performance Review </td>
                            </tr>

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Ravi Kumar, Regional Service Manager</td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>I hope this message finds you well. As part of our ongoing talent development initiatives, I would like to invite you to participate in the annual performance review for TMs in your area. The review is scheduled for next month, and your input would be valuable in assessing their contributions and future growth.&nbsp;</p>
                            <p>Please help me with the feedback on your TM&rsquo;s performance and training/development requirements.&nbsp;</p>
                            <p>Best regards,</p>
                            <p>Ravi Kumar</p>
                            <p>Regional Service Manager</p>
                            <p>TVS Motor Company</p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View4" runat="server">
                    <div class="tab-panel">

                        <table class="mailtable">

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Proposal for a New Digital Tool for Scheduled Service Bookings </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Hiren Saxena, Dealer Manager, Naren TVSM</td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>I would like to propose an opportunity to expand our business by leveraging new digital tool for facilitating scheduled service bookings. These tools will enable customers to easily book their service appointments online, enhancing the customer experience and streamlining our service operations.&nbsp;</p>
                            <p>To successfully implement this, we would need to explore digital platforms that support online service booking and reminders. I believe this initiative will improve service efficiency and drive customer satisfaction.&nbsp;</p>
                            <p>Looking forward to your feedback and approval to proceed.</p>
                            
                            <p>Best regards,</p>
                            <p>Hiren Saxena,</p>
                            <p>Dealer Manager, Naren TVS</p>
                        </div>
                    </div>
                </asp:View>

            </asp:MultiView>
        </div>
    </form>
</body>
</html>
