<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmGroupDiscussion.aspx.vb" Inherits="frmGroupDiscussion" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        $(function () {
            $(".user_nav").hide();
        });
    </script>
</asp:Content>

<asp:Content ID="ContentTimer" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Group Discussion</h3>
        <div class="title-line-center"></div>
    </div>
     <ul class="nav nav-tabs" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">Your Task</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Response Rate</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Survey Analysis</a></li>
        <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Summary of Results</a></li>
        <li><a class="nav-link" href="#CSTab-5" role="tab" data-toggle="tab">Appendix</a></li>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <h4 class="small-heading">Your  Task</h4>
            <p>An external  consultancy has just conducted an employee opinion survey at the request of  Human Resources.  HR has reached out you  for your support to make this intervention a success. Now, you and your  colleagues are about to hold a Board meeting to discuss issues arising from the  survey and to reach agreement as to how to address some of the issues that have  been highlighted. Unfortunately, your Director who was supposed to lead this  discussion has called in to explain that his flight has been delayed and he will  not be able to join the meeting. However, he wishes you to proceed with the  meeting in his absence and to make recommendations ready for his return.</p>
            <p>Your  recommendations should be as specific as possible and state exactly what course  of action you feel is necessary. You may wish to make certain assumptions in  order to express your recommendations. In any event, you should anticipate all  probable consequences of your recommendations when they are implemented and  suggest responses to each.</p>
            <p>All  recommendations made by the Board need to be consistent with the core  objectives, which are:</p>
            <ul>
                <li>To  increase competitiveness in the marketplace</li>
                <li>To  improve the retention of staff</li>
                <li>To  develop technical expertise in new areas</li>
                <li>To  promote a culture of continuous learning</li>
            </ul>
            <p>Group  members should indicate their agreement with the group&rsquo;s decision by voting on  every recommendation.</p>
            <h4 class="small-heading">Timing</h4>
             <p>
                Individual Preparation time : 20 mins<br />
                Assessor Instructions : 5 mins  <br />
                Group Discussion: 25 mins<br />
                Recommendation and Q&A – 10 minutes     
         </p>
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <h4 class="small-heading">Response  Rate</h4>
            <p>The employee  opinion survey was designed to address the following key areas of concern: pay  and benefits, training &amp; career development, quality and  communication.  The questionnaires were  sent to 5,600 people (white collar employees) from H Automotive and 4,105 were  returned in time for analysis. This represents a 73% response rate across all  functions.</p>
            <p>Table 1.1  shows the response rates in terms of both function and managerial level.</p>
            <p class="font-weight-bold">Table 1.1 Response Rate</p>
            <table class="table table-bordered table-sm">
                <thead>
                    <tr>
                        <th>Function</th>
                        <th>Non-Management</th>
                        <th>Middle Management</th>
                        <th>Senior Management</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Special Projects</td>
                        <td>374</td>
                        <td>20</td>
                        <td>6</td>
                        <td>400</td>
                    </tr>
                    <tr>
                        <td>Quality and Compliance</td>
                        <td>1010</td>
                        <td>40</td>
                        <td>10</td>
                        <td>1060</td>
                    </tr>
                    <tr>
                        <td>R&amp;D</td>
                        <td>295</td>
                        <td>20</td>
                        <td>5</td>
                        <td>320</td>
                    </tr>
                    <tr>
                        <td>Marketing</td>
                        <td>246</td>
                        <td>30</td>
                        <td>4</td>
                        <td>280</td>
                    </tr>
                    <tr>
                        <td>Production</td>
                        <td>1345</td>
                        <td>60</td>
                        <td>15</td>
                        <td>1420</td>
                    </tr>
                    <tr>
                        <td>Sales</td>
                        <td>180</td>
                        <td>15</td>
                        <td>5</td>
                        <td>200</td>
                    </tr>
                    <tr>
                        <td>Purchasing</td>
                        <td>148</td>
                        <td>10</td>
                        <td>2</td>
                        <td>160</td>
                    </tr>
                    <tr>
                        <td>HR</td>
                        <td>19</td>
                        <td>5</td>
                        <td>1</td>
                        <td>25</td>
                    </tr>
                    <tr>
                        <td>Finance</td>
                        <td>200</td>
                        <td>36</td>
                        <td>4</td>
                        <td>240</td>
                    </tr>
                    <tr>
                        <td class="font-weight-bold"><strong>Totals</strong></td>
                        <td class="font-weight-bold"><strong>3817</strong></td>
                        <td class="font-weight-bold"><strong>236</strong></td>
                        <td class="font-weight-bold"><strong>52</strong></td>
                        <td class="font-weight-bold"><strong>4105</strong></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <h4 class="small-heading">Survey Analysis</h4>
            <p class="font-weight-bold">Pay &amp; Benefits</p>
            <p>Overall, 41%  of responding employees believe that their pay is much lower in comparison to H  Automotive&rsquo;s competitors. Looking specifically at each function, the majority  of responses in Quality and Compliance, Special Projects, Sales and Production  fall into this category. An analysis of responses regarding employees&rsquo; benefits  package (sickness, holidays, contracted hours, pension, etc) reveals that there  is a marked difference in the ratings across different levels in the  organisation.  The majority of Middle and  Senior Management feel that the package they are offered is good; however, the  majority of respondents in Non-Management rate the package as average or poor.</p>
            <p>The results  of a further question regarding the physical working environment (ventilation,  lighting, workspace, noise level, overall conditions) reveal that respondents  in all functions, except for Production, regard them as satisfactory. Specifically,  respondents in Production are dissatisfied with workspace and noise levels.</p>
            <p class="font-weight-bold">Training &amp; Career Development</p>
            <p>Satisfaction  with job training varies considerably across functions. Most respondents in  Quality and Compliance, Special Projects and Production are not satisfied with  the training provided.  In contrast to  this, responses from Human Resources, Purchasing and Finance indicate that they  are satisfied with the trainings provided, whilst the responses from Sales,  Marketing and R&amp;D indicate that the majority neither agree nor disagree.</p>
            <p>In terms of  career development, employees were asked to indicate whether they had any  intention of leaving the Company within the next 2 years. The results varied  dramatically across the functions. Responses from Quality and Compliance and Special  Projects indicate that 5% and 8% respectively will definitely leave, 41% and  35% will probably leave while another 46% and 50% say that there is a 50-50  chance.  Within Sales, 65% of respondees  stated that there was a 50-50 chance of leaving.  Responses from Marketing, HR, Finance and Production  were more positive with a higher proportion indicating they would probably not  leave.</p>
            <p>Employees  were also asked to rate how satisfied they are with opportunities to get a  better job within H Automotive. Only 20% of Middle Management respondees were  satisfied with opportunities within the Company, a marked difference from last  year&rsquo;s figure of 41%. Analysis by function reveals that both Non-Management and  Middle Management within Production, Quality and Compliance and Sales are  dissatisfied with the opportunities available to them.</p>
            <p class="font-weight-bold">Quality</p>
            <p>In terms of  quality, employees were asked to rate whether or not they felt the quality of  services and products provided by the Company had improved compared with last year.  The results of the analysis show that only  16% of all respondents believe that the quality of products and services has  improved.  Analysis by function indicates  44% of respondees within Production and 40% within Quality and Compliance disagree  with the statement: &ldquo;There has been an improvement in quality.&rdquo;</p>
            <p>Employees  were also asked to indicate whether or not they agreed that concerns about  quality were easily reported to Management and were dealt with quickly.  Analysis of the results found that only 5% of respondees agree that it is easy  to report such concerns. A similar pattern of results was found when employees  were asked to rate H Automotive&rsquo;s commitment to quality, with only 19% agreeing  that the organisation was committed to quality.</p>
            <p class="font-weight-bold">Communication</p>
            <p>The results  show that a significant number of respondees (45%) are dissatisfied with the  information they receive from Management about what is going on in the Company;  this view is not function specific.   Employees were also asked to indicate how confident they were that their  views and suggestions were communicated upwards by their Management. The  findings are similar to last year&rsquo;s survey and show that across all functions  the majority are not confident about this issue, in fact only 1% are sure that  their views are communicated.</p>
            <p>A further  question looked at whether communication in each function had improved compared  with 1 year ago.  The results showed that  the only respondees who feel that communication is slightly better are in HR  and Finance. Functions that have shown a deterioration in their perception of  communication are R&amp;D, Quality and Compliance and Purchasing.</p>
        </div>
        <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <h4 class="small-heading">Summary of Results </h4>
            <p>The  following points have been identified as areas of concern when viewed in  conjunction with H Automotive core objectives.</p>
            <p class="font-weight-bold">H Automotive&rsquo;s core issues:</p>
            <ul>
                <li>There  is a high intention to leave</li>
                <li>Management  has not conveyed its commitment to quality</li>
                <li>Quality  issues are not easy to communicate nor are they dealt with quickly</li>
            </ul>
            <p class="font-weight-bold">Increasing Competitiveness:</p>
            <ul>
                <li>Employees  have doubts about the quality of H Automotive&rsquo;s products and services</li>
                <li>Concerns  regarding quality are not dealt with quickly</li>
                <li>The  Company needs to be competitive in terms of price and quality</li>
            </ul>
            <p class="font-weight-bold">Increasing Retention of Staff:</p>
            <ul>
                <li>Pay  is not in line with competitors</li>
                <li>The  benefits package is viewed as poor amongst some groups</li>
                <li>Some  groups of employees feel that there are few opportunities for better jobs  within the Company</li>
                <li>Some  groups of employees are not satisfied with the training they receive</li>
            </ul>
            <p class="font-weight-bold">Development of Technical Expertise in  New Areas:</p>
            <ul>
                <li>There  is a high intention to leave amongst some groups</li>
                <li>There  is poor communication regarding the direction of the Company</li>
                <li>Training  is not regarded as satisfactory by some groups of employees</li>
                <li>There  has been a deterioration in communication within R&amp;D</li>
            </ul>
            <p class="font-weight-bold">Culture of Continuous Learning:</p>
            <ul>
                <li>There  is poor communication regarding new initiatives or changes in the direction of  the Company</li>
            </ul>
        </div>
        <!-- Tab panes 5-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-5">
            <h4 class="small-heading">Appendix</h4>
            <p>The data  represents the average score for all staff, unless a breakdown is provided -</p>
            <p class="font-weight-bold">1) Pay &amp; Benefits</p>
            <div class="text-center">
                <img src="../../Images/lvl-12GD_1.PNG" class="img-thumbnail w-75" />
            </div>
            <p class="font-weight-bold">2) Training &amp; Career Development</p>
            <div class="text-center">
                <img src="../../Images/lvl-12GD_2.PNG" class="img-thumbnail w-75" />
            </div>
            <p class="font-weight-bold">3) Quality</p>
            <div class="text-center">
                <img src="../../Images/lvl-12GD_3.PNG" class="img-thumbnail w-75" />
            </div>
            <p class="font-weight-bold">4) Communication </p>.
            <div class="text-center">
                <img src="../../Images/lvl-12GD_4.PNG" class="img-thumbnail w-75" />
            </div>
        </div>
    </div>
</asp:Content>

