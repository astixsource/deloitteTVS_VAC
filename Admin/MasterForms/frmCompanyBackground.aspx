<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmCompanyBackground.aspx.cs" Inherits="Admin_MasterForms_frmCompanyBackground" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        function fnRole() {
            $('#role').hide();
            $('#structure').fadeIn(200);
        }
        function fnStructure() {
            $('#structure').hide();
            $('#role').fadeIn(200);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Background Information</h3>
        <div class="title-line-center"></div>
    </div>
    <ul class="nav nav-tabs" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">Company Background</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Industry Scenario</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">Current Situation</a></li>
        <li><a class="nav-link" href="#CSTab-4" role="tab" data-toggle="tab">Your Role</a></li>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <div class="section-title">
                <h3 class="text-center">Company Background</h3>
                <div class="title-line-center"></div>
            </div>
            <p>You represent an automotive components manufacturing organization called H Automotive.</p>
            <h4 class="small-heading">About H Automotive</h4>
            <p>H Automotive is a US-based multi-national with a £20 billion turnover worldwide. It has a wide variety of interests, having started in the 1930s as a manufacturer of tires. Since that time it has reshaped itself many times and has expanded its base, initially into Europe and more recently Africa and the Pacific Rim countries.</p>
            <h4 class="small-heading">H Automotive in the UK</h4>
            <p>The UK is the largest single market for the Corporation’s products in Europe. Of the £6 billion revenue generated in Europe, the UK accounts for approximately £2 billion. Within the UK there are four different manufacturing locations and there is a certain amount of inter-company trading both within the UK and throughout Europe. The four product/technology lines that are represented are:</p>
            <ul>
                <li>Automotive products comprising Batteries, Brakes, Belts, Filter, Spark Plugs, Automotive Bulbs, Lubricants. The factory is located in Southampton where the plant employs about 4,800 people and generates revenue of £1.2 billion.</li>
                <li>Non-automotive products, which is located in Hatfield, comprising of packaging, energy and building solutions, power tools and consumer retail. About 2,900 people are employed at the Hatfield site and generating revenue of £340 million.</li>
                <li>Safety technologies, working on new systems that improve vehicle safety in all vehicle classes, focusing on active &amp; passive vehicle safety and automated driving. The plant is located in Swindon and employees about 2500 people and generates £257 million.</li>
                <li>Intelligent Mobility Solutions, with the amalgamation of vehicle technology, cloud and other technology-driven services, mobility solutions focus on revolutionising the automotive industry, located in Daventry in the Midlands. The plant employs 2,800 people and generates £293 million.</li>
            </ul>
        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <div class="section-title">
                <h3 class="text-center">Industry Scenario</h3>
                <div class="title-line-center"></div>
            </div>
            <p>The automobile sector is at an inflexion point. This sector has witnessed its worst slowdown in 2019 for the first time since 2009 (previous recession) in global economies. In Q1 FY20, automobile sales witnessed the sharpest decline of 10.5% y-o-y in the last 5 years.</p>
            <p>There are several reasons that can be attributed to this prolonged decline:</p>
            <ul>
                <li>Overall week consumer sentiment that is pervasive in the economy</li>
                <li>The crisis in the NBFC space which has led to a liquidity squeeze, resulting in a drastic decline in the number of fresh loans to the auto sector.</li>
                <li>Adjustment of production lines to new safety norms</li>
                <li>High insurance costs, high ownership costs, increased load carrying capacity for Medium &amp; Heavy Commercial Vehicles leading to high inventories which is causing slow movement in the wholesale movement of vehicles.</li>
            </ul>
            <p>Now, with the current Covid-19 situation, the The auto industry has seen the impact from a supply shock to a global demand shock. Automotive sales most likely will decrease 14-22% among the US and European markets in 2020.</p>
        </div>
        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <div class="section-title">
                <h3 class="text-center">Current Situation at H Automotive - UK</h3>
                <div class="title-line-center"></div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <h4 class="small-heading">Decline in Top line</h4>
                    <div class="text-center">
                        <img src="../../Images/lvl-11-CSituation-1.png" class="img-thumb w-75" />
                    </div>
                </div>
                <div class="col-md-6">
                    <h4 class="small-heading">Decline in overall sales</h4>
                    <div class="text-center">
                        <img src="../../Images/lvl-11-CSituation-2.png" class="img-thumb w-75" />
                    </div>
                </div>
            </div>
            <p>Plummeting sales have put cost-cutting pressures on H Automotive. The organization will have to rethink about its overall strategy and <strong>use cost saving</strong> and <strong>growth</strong> as levers to achieve its strategic objectives.</p>
            <p><strong>Now what?</strong> Amidst such uncertainty, it is critical that H Automotive takes a comprehensive approach and develop a range of scenarios and robust contingency plans to navigate through these turbulent times</p>
        </div>
        <!-- Tab panes 4-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-4">
            <div class="coll-body" id="role">
                <div class="section-title">
                    <h3 class="text-center">Your Role</h3>
                    <div class="title-line-center"></div>
                </div>
                <p>You will assume the role of Sam Burton, the newly appointed General Manager for H Automotive’s UK Operation. As GM – UK Operations, you are responsible to oversee Production of the Company’s products within the UK and also for exports from the UK plant.</p>
                <p>You have just been transferred to this position in an expected promotion from your previous role as AGM for the smaller H Automotive operation in Belgium where you had been based for the last 3 years. You joined H Automotive UK 2 weeks back.</p>
                <div class="text-center pt-3">
                    <a href="#" onclick="fnRole()" class="btns btn-submit" id="AnchorNext1">See Org Structure</a>
                </div>
            </div>
            <div class="coll-body" id="structure" style="display: none">
                <div class="section-title">
                    <h3 class="text-center">Organisation Structure</h3>
                    <div class="title-line-center"></div>
                </div>
                <div class="text-center mb-3" id="EngSalesOrg">
                    <img src="../../Images/lvl-12-org.png" class="img-thumbnail" usemap="#Map" style="width: 790px !important" />
                </div>

                <div class="text-center pt-3 mb-3">
                    <a href="#" onclick="fnStructure()" class="btns btn-submit" id="AnchorBack">Back</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

