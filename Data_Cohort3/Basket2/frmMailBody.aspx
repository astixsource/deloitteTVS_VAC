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
                                <td>Immediate Attention: Customer Complaint Escalated on Social Media</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Social Media Complaint via ASM/RSM </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>A customer has posted a complaint on social media about a recent service experience. The customer is extremely dissatisfied and has been vocal about their concerns. Please investigate this matter immediately and respond to the customer with a satisfactory resolution. This is a sensitive issue that requires your prompt attention to maintain the brand image.</p>
                            <p>Before you proceed, send me a detailed action plan in next one hour on how will you proceed to address this issue.</p>
                            <p>
                                Best regards,<br />
                                ASM
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
                                <td>Ongoing Issues with Fleet Maintenance</td>
                            </tr>
                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>From a Key Fleet Customer </td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are still facing issues with engine overheating on multiple fleet vehicles serviced last week. This has disrupted our deliveries and is leading to client complaints. Please address this immediately and provide a resolution plan.</p>
                            <p>
                                Regards,<br />
                                Fleet Customer
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
                                <td>Integration Plan for New Dealership</td>
                            </tr>

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>New Dealership Integration</td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are in the process of integrating a new dealership in a rural area, and your assistance is required in ensuring that the service operations are set up efficiently. Please share your insights or suggestions on how to proceed. We would also need help in equipping the new dealership&rsquo;s service team. Can you share a detailed plan for this?</p>
                            <p>
                                Best regards,<br />
                                Head Office
                            </p>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="View4" runat="server">
                    <div class="tab-panel">

                        <table class="mailtable">

                            <tr>
                                <td>From</td>
                                <td>:</td>
                                <td>Private Mechanics/Retail Part Sellers </td>
                            </tr>
                            <tr>
                                <td>Subject</td>
                                <td>:</td>
                                <td>Collaboration Opportunity: Service and Parts Support</td>
                            </tr>
                        </table>
                        <div class="mailbodydv">
                            <p>We are considering collaborating with local private mechanics and retail parts sellers to extend our service reach in under-served areas. Please review the viability of this collaboration and share any potential benefits or risks. Additionally, please ensure that our standards are maintained for parts quality and service delivery.</p>
                            <p>Best regards,<br />
                                Private Mechanic/Part Seller</p>
                        </div>
                    </div>
                </asp:View>

            </asp:MultiView>
        </div>
    </form>
</body>
</html>
