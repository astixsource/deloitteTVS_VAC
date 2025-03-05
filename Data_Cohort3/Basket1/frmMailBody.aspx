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
                                <td>Immediate Action Required on Customer Complaint </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Dealer Manager/Supervisor - Immediate Technical Resolution and Customer Complaint  </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We have received a complaint regarding a recurring issue with the engine cooling system on one of the models. The customer is dissatisfied, and this needs immediate resolution. Please ensure that the issue is investigated and addressed with the urgency it deserves. Also, we require your assistance in getting the DWM issue resolved at the earliest.</p>
                            <p>Looking forward to your prompt action.</p>
                            <p>
                                Best regards,<br />
                                Dealer Manager
                            </p>

                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View2" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Weekly Business Performance Review and Dealer Updates</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Area Manager/NSM - Business Update and Dealer Performance </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>
                                Please provide a comprehensive analysis of today&rsquo;s business, including the status of customer complaints and their resolutions. I have noticed that the dealer manager has not filled the required report, and it is crucial that we include the latest data on service point expansions, new areas, and any performance improvements or issues. Kindly review and propose solutions to improve dealer performance.<br />
                                Let me know your updates.
                            </p>
                            <p>
                                Best regards,<br />
                                Area Manager
                            </p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View3" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Addressing Service Issues and Business Growth Strategy</td>
                            </tr>

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Dealer Owner - Business Growth and Service Training </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>I hope you're doing well. We are looking at expanding our dealership and increasing the ramp-up numbers, but we need some support with the availability of spare parts, especially for the models with high service demand. Additionally, there is some conflict among our dealer team, and I'd appreciate it if you could help with training our service team. Also, the pending claims at the area office need resolution. Can we schedule a meeting to discuss these?</p>
                            <p>Please share your action plan on how to approach these issues, before the meeting.</p>
                            <p>
                                Best regards,<br />
                                Dealer Owner
                            </p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View4" runat="server">
                    <div class="tab-panel">

                        <table class="mailtable">

                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Escalated Customer Complaint Resolution Needed</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Head Office/Section Heads - Escalated Customer Complaint </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We've received an escalated customer complaint regarding a service delay, and we need your team to act on it immediately. Please ensure that a detailed report is provided and that corrective actions are taken to resolve this promptly. Additionally, I would like a presentation on how we can improve our service response time across all regions.</p>
                            <p>Please share a comprehensive plan on how will you address this?</p>
                            <p>Best regards,<br />
                                Head Office Section Head</p>
                        </div>
                    </div>
                </asp:View>

            </asp:MultiView>
        </div>
    </form>
</body>
</html>
