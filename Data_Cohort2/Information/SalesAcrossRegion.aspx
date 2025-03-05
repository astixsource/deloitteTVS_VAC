<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Panel.master" AutoEventWireup="false" CodeFile="SalesAcrossRegion.aspx.vb" Inherits="Data_Information_SalesAcrossRegion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>

    <script type="text/javascript">
        //(function ($) {
        $.fn.blink = function (options) {
            var defaults = {
                delay: 500
            };
            var options = $.extend(defaults, options);
            var obj = $(this);
            setInterval(function () {
                $(obj).fadeOut().fadeIn();
            }, options.delay);
        }

        //}(jQuery));

        function fnRole() {
            $('#role').hide();
            $('#structure').fadeIn(200);
        }
        function fnStructure() {
            $('#structure').hide();
            $('#role').fadeIn(200);
        }
    </script>
    <script type="text/javascript">
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        ///  f1();
        function f1() {
            $(document).ready(function () {
                //function FnUpdateTimer() {
                if (IsUpdateTimer == 0) { return; }
                SecondCounter = parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value);
                if (SecondCounter <= 0) {
                    IsUpdateTimer = 0;
                }
                SecondCounter = SecondCounter - 1;
                hours = Math.floor(SecondCounter / 3600);
                Minutes = Math.floor((SecondCounter - (hours * 3600)) / 60);
                Seconds = SecondCounter - (hours * 3600) - (Minutes * 60);


                if (Seconds < 10 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = "Reading Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds < 10 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = "Reading Time Left : 0" + hours + ":" + Minutes + ":" + "0" + Seconds;
                }
                else if (Seconds > 9 && Minutes < 10) {
                    document.getElementById("theTime").innerHTML = "Reading Time Left : 0" + hours + ":" + "0" + Minutes + ":" + Seconds;
                }
                else if (Seconds > 9 && Minutes > 9) {
                    document.getElementById("theTime").innerHTML = "Reading Time Left : 0" + hours + ":" + Minutes + ":" + Seconds;
                }
                document.getElementById("ConatntMatterRight_hdnCounter").value = SecondCounter;

                if (((hours * 60) + Minutes) == 5 && Seconds == 0) {

                    $("#dvDialog")[0].innerHTML = "<center>Your time left to read background information : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " </center>";
                    $("#dvDialog").dialog({
                        title: 'Alert',
                        modal: true,
                        width: '30%',
                        buttons: [{
                            text: "OK",
                            click: function () {
                                $("#dvDialog").dialog("close");
                            }
                        }]
                    });
                }

                counter++;
                counterAutoSaveTxt++;
                if (counter == 10) {//Auto Time Update
                    counter = 0;

                }
                if (counterAutoSaveTxt == 30) {//Auto Text Save
                    counterAutoSaveTxt = 0;

                }

                if (SecondCounter == 0) {
                    // alert("Level Complete");
                    IsUpdateTimer = 0;
                    counter = 0;

                }
                // }
                setTimeout("f1()", 1000);

            });

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime" class="fst-color" style='display: none'>Reading Time Left 00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatterRight" runat="Server">
    <div class="coll-body" id="role">
        <div class="section-title">
            <h3 class="text-center" id="HdngBrief">FUTURE OF BASE</h3>
            <div class="title-line-center"></div>
        </div>

        <ul class="nav nav-tabs pt-2" role="tablist">
            <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">CHANGING LANDSCAPE OF THE AUTOMOBILE INDUSTY IN INDIA</a></li>
            <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">FUTURE OF BASE</a></li>

        </ul>

        <div id="tab-content" class="tab-content">
            <!-- Tab panes 1-->
            
            <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
                <p>The automotive industry is drastically changing due to the following triggers:</p>
                <p><strong>Digitization: </strong>Digital commerce technologies are disrupting the automobile industry by unlocking greater efficiencies, personalization, and cost savings. &nbsp;Automobiles, today, are safer, user-friendly and comes with several features that improve their value and usefulness for automobile owners.&nbsp;Modern automobiles can offer much more than driving/riding one from one point to another, just like modern cell phones can perform more than just a call.&nbsp;</p>
                <p><strong>Sustainability:</strong> With the human impact on climate causing harmful effects on the environment, every industry is turning towards more environmentally friendly technology. &nbsp;Electric vehicles are gaining immense popularity nowadays all over the world&nbsp;to contribute to the cause. Governments are working towards creating the infrastructure/electric charging platforms to facilitate the change, along with offering subsidies, wherever necessary.</p>
                <p><strong>Customer Preferences:</strong> OEMs are responding to the new dimensions of mobility (connected, autonomous, shared and electric), new forms of ownership and an increased environmental focus.</p>
                <p><strong>Supply Chain Architecture:</strong> The Indian automotive supplier base is currently not too diversified for majority of components. This was to drive volume-based price efficiencies. However, this strategy is highly exposed to risks arising from disruptions in geographies that supply key auto components. Hence, organisations are currently evaluating the supply chain architecture and its vulnerabilities against external factors.</p>
            </div>
            <!-- Tab panes 3-->
            <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
                <p>With the landscape of the automobile industry changing drastically, BASE must transform itself to be a player in this dynamic and competitive market. Here are some initiatives the organisation is working on.</p>
                <p><strong>Premiumization:</strong> The focus is shifting towards creating premium bikes to improve margins across both domestic and global markets. With the new launches the organisation has earned high dividends. It has been able to capture 23 percent of the market share with this category. Today, two-wheelers are becoming an aspirational object and there are two-wheelers more expensive than some luxury vehicles in the market today. The company wants to capitalize on the trend.</p>
                <p><strong>Electric Vehicles:</strong> The India E-Bike market was valued at USD 1.02 million in 2020, and it is expected to reach&nbsp;USD 2.08 million by 2026, projecting CAGR of 12.69 % during the forecast period. (2021-2026). The company has launched a product last year to foray into this segment and continues to invest a lot in Research and Development to improvise its products in this domain.</p>
                <p><strong>Connected 2 wheelers:</strong> As the automotive industry veers towards digitization, coupled with smart phone connectivity, it&nbsp; has contributed to several use cases for connected two wheelers that include road and vehicle monitoring, driver behaviour analysis, SOS calls, smart helmets, theft protection, vehicles prognostics and health management.&nbsp; Since all these features are aligned to the safety and convenience of the two-wheeler owners, the company cannot ignore them.</p>
                <p><strong>Market Expansion:</strong> The organisation is one of the top two automotive manufactures in India and is aggressively&nbsp; working towards achieving significant share from international business, especially in Asian markets, capitalizing on the expertise developed in the areas of manufacturing, technology and marketing for better margins.</p>
                <div class="text-center mb-4">
                    <a href="#" onclick="fnMenu(5, this)" class="btns btn-submit" id="AnchorNext2">Next</a>
                </div>
            </div>
        </div>
    </div>
    <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
</asp:Content>

