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
                                <td>DWM Issue Resolution and Enhancing Customer Satisfaction </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Dealer Manager/Supervisor - DWM and Customer Satisfaction (Priority: 1) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are facing some difficulties with the DWM (Dealer Work Management) system, and it's affecting the overall service quality. Please assist us in resolving this as soon as possible. Additionally, we need to address the recent customer complaints effectively to improve satisfaction scores. I would appreciate any solutions or strategies you can suggest.</p>
                            <p>Best regards,</p>
                            <p>Dealer Manager</p>

                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View2" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Dealer Performance Metrics and Market Intelligence</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Area Manager/NSM - Market Intelligence and Reporting (Priority: 2) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>Please analyze the latest dealer performance data and include an assessment of market trends that may affect our service operations. We need more detailed reports on customer complaints, specifically any recurring issues that might need broader solutions. Please ensure the reports are submitted by the end of the week. Kindly share your approach to create the report by end of the day.</p>
                            <p>Best regards,</p>
                            <p>Area Manager</p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View3" runat="server">
                    <div class="tab-panel">
                        <table class="mailtable">


                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Conflict Among Dealer Team and Upcoming Service Training </td>
                            </tr>

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Dealer Owner - Conflict Resolution and Team Training (Priority: 3) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are facing internal conflicts among our dealer team, which is affecting service performance. Could you help in navigating this conflict? Suggest what can be done to improve both team morale and customer satisfaction.</p>
                            <p>Best regards,</p>
                            <p>Dealer Owner</p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View4" runat="server">
                    <div class="tab-panel">

                        <table class="mailtable">

                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Review and Improvement of Service Training Programs </td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Head Office/Section Heads - Service Training Program Review (Priority: 4) </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We need your feedback on the current service training program. Please assess the effectiveness of the training delivered to the service teams and suggest any improvements. I would also appreciate any data on how well our teams are implementing the learnings to enhance customer experience and resolve complaints.</p>
                            <p>Please share a plan by end of the day on how to will you collect the feedback and what questions will you ask?</p>
                            <p>Best regards,</p>
                            <p>Head Office Section Head</p>
                        </div>
                    </div>
                </asp:View>

            </asp:MultiView>
        </div>
    </form>
</body>
</html>
