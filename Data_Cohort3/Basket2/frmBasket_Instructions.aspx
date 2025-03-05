<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmBasket_Instructions.aspx.vb" Inherits="Set1_Basket_frmBasket_Instructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
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
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#panellogout,#panelback").hide();

        });
    </script>
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
        $("#panelLogout").hide();
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="d-flex justify-content-between align-items-center">
        <div class="p-2">&nbsp;</div>
        <div class="section-title">
            <h3 class="text-center">Situation</h3>
            <div class="title-line-center"></div>
        </div>
        <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Go to inbox" />
    </div>
    <div class="section-content">
        <h4 class="middle-title">Your Profile</h4>
        <p>You are Mr. Rajeev Sharma. You are the President  – Special Projects for Evergreen group of companies. You and your team act as  the internal consulting unit for large complex projects. You have just  completed 20 years with the Evergreen group and have a total experience in the  infrastructure and construction sector of over 30 years. You report directly to  the MD &amp; CEO of the organization who has consistently placed his faith in  you on multiple occasions in the past, to provide solutions to challenging  problems. </p>
        <div class="row">
            <div class="col-md-8">
                <h4 class="middle-title">The Scenario</h4>
                <ul>
                    <li>On Tuesday,  16th September 2022, the President of the IRIS city development-Krakozhia  project, Mr. Sanjit Kumar was suddenly taken ill and rushed to the hospital. </li>
                    <li>Although  his condition has now improved, he remains in hospital for further treatment.</li>
                    <li>On the  night of 17th September, you received a call from Mr. Ramakrishna  Arun (MD of Evergreen) who informed that Mr. Sanjit was clearly unable to  return to work, whereupon, he expects you to act lead the mega project till his  return, starting Saturday 20th September, and tackle the critical outstanding  items in Mr. Sanjit&rsquo;s inbox. </li>
                    <li>You  only have 120 minutes before you must leave for the airport as you are about to  travel for a 1-week International conference in Barcelona, Spain which begins  on Monday, where you are a keynote speaker. </li>
                    <li>You  will be back in office on Monday, 29th September. </li>
                    <li>It  will not be possible to contact anyone from your conference as it will be very  intensive and you are unlikely to have access to a telephone.</li>
                </ul>
            </div>
            <div class="col-md-4">
                <table class="table table-bordered text-center table-sm mb-0">
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
                            <td>22</td>
                            <td>23</td>
                            <td>24</td>
                            <td>25</td>
                            <td>26</td>
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
                </table>
            </div>
        </div>
        <h4 class="middle-title">Your Task </h4>
        <ul>
            <li>The mails in your inbox are as left by Mr. Sanjit on 17th  September 2022, with some recent additions that have arrived since his absence. </li>
            <li>As you  will not be back in the office until Monday 29th September and are not  contactable in the interim, you need to ensure that your responses/  instructions for each of the items are clear. </li>
            <li>You must  write emails, plan appointments, meetings, make decisions and request  information. </li>
            <li>You  need to read each In-Basket item and carryout the following tasks. 
                <ul>
                    <li>Categorize  the documents into three sets i.e. High priority &lsquo;H&rsquo;, Medium priority &lsquo;M&rsquo; and  low priority &lsquo;L&rsquo;. The &lsquo;H&rsquo; documents will indicate that the documents need to be  acted upon immediately, &lsquo;M&rsquo; would mean acted upon after &lsquo;H&rsquo; documents and so on  for &lsquo;L&rsquo; documents. </li>
                    <li>In  case of delegation of activity to team members, please mention specific  actions/ activities they need to undertake as part of your email to them</li>
                    <li>Write  the most appropriate plan of action on each paper i.e. what you would actually  do if you received such a document. You can respond to the document in one of  the following ways:
                <ul>
                    <li>Write  emails</li>
                    <li>Plan  appointments</li>
                    <li>Plan  meetings</li>
                    <li>Make  decisions</li>
                    <li>Request  information</li>
                </ul>
                    </li>
                </ul>
        </ul>
        <p>You may then detail the plan of action as appropriate </p>
    </div>

</asp:Content>

