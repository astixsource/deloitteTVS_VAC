<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmSBR_Quality.aspx.vb" Inherits="frmSBR_Quality" %>

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
        <h3 class="text-center">Instructions for Participant</h3>
        <div class="title-line-center"></div>
    </div>
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">The Situation</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Logistics</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Production</a></li>
        <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Sales & Marketing</a></li>
        <li><a class="nav-link" href="#CSTab-5" role="tab" data-toggle="tab">Quality</a></li>
        <%--<li><a class="nav-link" href="#CSTab-6" role="tab" data-toggle="tab">Your Response</a></li>--%>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <h4 class="small-heading">Timing</h4>
            <p>Preparation and response: 30 mins</p>
            <h4 class="small-heading">The  Situation</h4>
            <p>Owing to the current situation, the game in the market is changing, H Automotive is facing stiff  competition. The entire management has recently been re-thinking about  the various aspects that must be covered in the corporate strategy that will enable  them  to  gain  market  leadership  position  by  2020.  One of the critical success factors decided upon is Quality Leadership.</p>
            <p>H Automotive believes that their competitive advantage lies in the price at  which they provide a wide range of products. The strategy is now to improve quality  both  in  terms  of  product  and  customer service  and  use  economies  of  scale  to  achieve  lower  costs.  If  the  strategy  fails,  the  company  will  lose  its  competitive  advantage and a significant amount of market share.  </p>
            <p>The company is under tremendous pressure of saving costs, but not at the cost of quality. Unfortunately, in the recent past there have been numerous complaints from clients on quality issues. In response, the quality team has been doing more frequent quality checks to get into the depth of the issues.</p>
            <p>In a recent Quality Audit, one of the Auditors, decided to take a random sample of parts at various stages in the production system and assess their ‘quality’ in terms of specification and standard to drawing. The findings were not good; 70 percent of all parts measured were outside drawing tolerance. When asked why this was, the Production Manager, said ‘stoppages in the production process result in rushing operations to  pull  back  lost  time; why  can’t  Purchasing get their act together and get bits to us on time?’.  </p>
            <p>Inputs from various department heads also show some critical lags.  </p>
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <h4 class="small-heading">Input from Logistics Department</h4>
            <p>The biggest concern is the current lead-time from order receipt to dispatch which is in excess of twelve weeks while the industry average is six weeks. One of the main areas for concern is the amount of time spent chasing machine parts and the lack of up-to-date scheduling information.</p>
            <p>In addition, the quality control process is lengthy due in part to a large percentage of non-conforming machines arriving at final inspection prior to dispatch.</p>
        </div>
        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <h4 class="small-heading">Input from Production Department</h4>
            <p>The manufacturing of each item takes between 5 and 7 weeks. Final assembly of machines is a Jobbing operation(one-off production, involving producing custom work), though components are made in batches. The batch size is set at 15 days supply to try to achieve a stock turn of 6:1 (though the actual stock turn is about 3:1). There are a number of problems with the manufacturing process: primarily, lack of clearly written operating procedures and where procedures exist, they are out-of-date. Though the factory layout is consistent with the processes, we are significantly behind our competitors in terms of new technology.</p>
        </div>
        <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <h4 class="small-heading">Sales & Marketing Department</h4>
            <p>60% of our business is exports which was slated to grow to 65% in 2020 but does not look possible currently. We have good long term relationships and 25% of our business is through repeat. Our speed of response to market demand needs to be improved to reach higher sales. Also, market lead times are typically twelve weeks, but salesmen often quote as low as four to get a sale which then does not happen on time.</p>
        </div>
        <!-- Tab panes 5-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-5">
            <h4 class="small-heading">Input from Quality Department</h4>
            <p>One of the major challenges is the constant changes of specification, which has repercussions in production planning, stores  and ordering. This results in quality problems in internally produced parts. Checks and controls for external  suppliers also need to be strengthened.</p>
            <p>Additionally, there is considerable pressure to deliver the machines on time, so machines are  often put into the build programme in anticipation of customer demand in order to try  to reduce the actual lead-time.  </p>

        </div>
        <%--<div role="tabpanel" class="tab-pane fade" id="CSTab-6">
            <h4 class="small-heading">Your Response</h4>
            <div class="clearfix bg-light" id="dvMain" runat="server"></div>

            <div class="text-center mb-3">
                <input type="button" id="btnNext" class="btns btn-cancel" value="Submit" onclick="fnNext()">
            </div>
        </div>--%>
    </div>
</asp:Content>

