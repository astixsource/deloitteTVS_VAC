<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmRolePlayInternal.aspx.vb" Inherits="frmRolePlayInternal" %>

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
        <h3 class="text-center">Internal Role Play</h3>
        <div class="title-line-center"></div>
    </div>
   <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">The Situation</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Information</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Team Member</a></li>
        <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Your Task </a></li>
        
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <h4 class="small-heading">The Situation</h4>
            <p>One of your key clients, Cars Plus has raised serious complaints regarding the recent delivery of a key order. This resulted in Cars Plus losing significant business with their customers. Your team member Charlie Payne was handling the account and the order in question.</p>
            <p>Cars Plus is a prestigious account which has been instrumental for H Automotive in securing multiple other clients in the same region over the last 1 year. Cars Plus has highlighted the issues to your CEO. In the email to the CEO, the issues highlighted by Cars Plus were:</p>
          
            <ul>
                <li>The inferior quality of the delivered products  </li>
                <li>The failure to stick to the timelines that were agreed at the outset </li>
                <li>Lack of proper communication around delays in the delivery schedule</li>
                <li>Lack of ability or willingness to resolve this issue by your team member, Charlie Payne</li>
            </ul>
            <p>In the past, Cars Plus had appreciated H Automotive’s product quality, timely delivery and after sales support services that were provided, especially compared to some of the leading competitors. They were impressed with the professionalism and technical excellence provided by H Automotive, and indeed by Charlie Payne. However, this recent issue has resulted in serious damage to the relationship between Cars Plus and H Automotive. Cars Plus is even thinking to remove H Automotive from its key suppliers list.</p>
            <p>The CEO is already under tremendous pressure due to the current business situation and is considering employee headcount reduction as the only viable option. He has reached out to all the Operation Heads to seek their inputs/suggestions to create an action plan around the same. </p>
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <h4 class="small-heading">Information from your predecessor, Mr. Alan Smith</h4>
            <p>Hi Sam,</p>
            <p>Congratulations on your appointment, I’m sorry that we didn’t have a chance to meet before I left.</p>
            <p>I am sure, you will be immediately aware of the problems that we have experienced at Cars Plus, culminating in the letter of complaint that was sent to the CEO. I thought I would give you a bit of background to help you understand the situation. I hope these details will give you a picture of what has been happening to help you sort things out.  It is important that we get back into the Cars Plus’s good books quickly as you know how such stories can get around in our fraternity.</p>
            <p>
                Good luck!!<br>
                Alan
            </p>

            <p class="font-weight-bold">Cars Plus</p>
            <p>Cars Plus is a prestigious account which has been instrumental for H Automotive in securing multiple other clients in the same region over the last 1 year. Cars Plus has highlighted the issues to your CEO. In the email to the CEO, the issues highlighted by Cars Plus were:
</p>

            <p class="font-weight-bold">The Project</p>
            <p>The current order was of a larger batch size than usual (almost triple) based on Cars Plus’ expansion project. However, the time to deliver (2 months) agreed upon was not adequate as per the order size. Our purchase team had raised this supply concern as our suppliers were not geared to raise their production capacity. Still, the order was accepted considering the business slowdown and the targets to be met. While all efforts were made to meet the delivery timelines, yet it was delayed by 20 working days.</p>
            <p>I received the intimation from Cars Plus last week. I had sent out a meeting request to Charlie, but he ignored the same. I didn’t follow up, I thought you would prefer to investigate things yourself as I was leaving.</p>

            <p class="font-weight-bold">The Issues</p>
            <p>There seem to have been several problems. I am not sure of all the details because I assumed that Charlie was in control of things and I wanted to give Charlie the ‘chance to lead’.  However, from what I understand there were supplier related problems which meant that the assembly started 10 days later than the scheduled date.  As a result, inward quality checks were hurried.  In addition, there were also complaints about lack of proper communication and clarity on exact schedule of delivery. </p>
        </div>
        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <h4 class="small-heading">Information about your Team Member, Charlie Payne</h4>
            <p>Charlie has been an employee of H Automotive for over 5 years and as a Key Account Manager, was instrumental in developing good relations with multiple customers within the region which resulted in us becoming market leaders. Charlie was promoted to Key Account Manager eighteen months ago and seemed to be making good progress in getting results from his team.  In particular, Charlie did a good job in these two accounts - Cars Plus and Brakes International.  Charlie is normally very enthusiastic and is able to get on well with colleagues, direct reports and especially clients.  Indeed, it was Charlie’s excellent working relationships with customers, developed over a number of years, that has helped H Automotive to be where it is today. This was the reason why Alan was happy to leave it to Charlie to oversee the order delivery. After all, Charlie knew all the people involved and Alan was sure that everything would be followed through successfully.</p>
            <p>Unfortunately, things have gone rather badly over last 2 months as the project started to run into difficulties. Charlie has started to lose enthusiasm and has appeared somewhat frustrated with both, the client and some colleagues. On top of that, some of Charlie’s team members have voiced concerns about being left to do things with little direction or support.</p>
        </div>
        <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <h4 class="small-heading">Your Task </h4>
          
            <p>You have arranged a meeting with your team member - Charlie Payne to discuss what happened and how to resolve the situation. You have learned from your sources that Charlie is quite upset about what has happened and you are keen move things forward in a timely but positive way. </p>
            <p>By the end of the meeting you should aim to make some progress on a number of issues including:</p>
           <ul>
               <li>Investigate Charlie’s view of what happened</li>
               <li>Understand and resolve the issues faced by Charlie with colleagues, team members and other stakeholders</li>
               <li>Try to re-motivate Charlie as a key contributor to your team</li>
           </ul>
        </div>
       
       
    </div>

</asp:Content>

