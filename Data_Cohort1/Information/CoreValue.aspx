<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Panel.master" AutoEventWireup="false" CodeFile="CoreValue.aspx.vb" Inherits="Data_Information_CoreValue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript">
        function fnGoBack() {
            window.location.href = "LeadershipPresence.aspx";
        }
    </script>
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
        //}(jQuery))
    </script>
    <script type="text/javascript">
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;
        function f1() {

            if (IsUpdateTimer == 0) { return; }
            SecondCounter = parseInt(document.getElementById("ConatntMatterRight_hdnCounter").value);
            if (SecondCounter <= 0) {
                IsUpdateTimer = 0;

                $("#theTime").addClass("blinkmsg");

                $('.blinkmsg').blink({
                    delay: "1500"
                });

                return;
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

                $("#dvDialog")[0].innerHTML = "<center>Reading Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " </center>";
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


                $("#theTime").addClass("blinkmsg");


            }
            // }
            setTimeout("f1()", 1000);
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
    <time id="theTime" class="fst-color" style='display: none'>Reading Time Left 00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatterRight" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Market Dynamics and Government Incentives</h3>
        <div class="title-line-center"></div>
    </div>

    <p><strong>Market Dynamics:</strong></p>
    <p>
        NextGen Motors operates in a dynamic market characterized by rapid technological advancements, changing consumer preferences, and increasing regulatory scrutiny on emissions and sustainability. The rise of electric vehicles presents both opportunities and challenges for the company, driving the need for continuous innovation and adaptation.

    </p>
    <p><strong>Government Incentives:</strong></p>
    <p>NextGen Motors benefits from government incentives and subsidies aimed at promoting the adoption of electric vehicles and sustainable practices. High ESG ratings and compliance with environmental regulations further reinforce the company's eligibility for such incentives, providing financial support and a competitive advantage in the market.</p>
    <div class="section-title">
        <h3 class="text-center">NextGen Motors Two-Wheeler Models</h3>
        <div class="title-line-center"></div>
    </div>

    <table class="table table-bordered table-sm">
        <thead>
            <tr>
                <th width="56">
                    <p><strong>Model</strong></p>
                </th>
                <th width="85">
                    <p><strong>Price (INR)</strong></p>
                </th>
                <th width="387">
                    <p><strong>Features</strong></p>
                </th>
                <th width="72">
                    <p><strong>Sold In</strong></p>
                </th>
            </tr>
        </thead>
        <tbody>

            <tr>
                <td width="56">
                    <p><strong>Electron</strong></p>
                </td>
                <td width="85">
                    <p>Rs 1,20,000 &ndash; Rs 1,55,000</p>
                </td>
                <td width="387">
                    <p>- Sleek, lightweight</p>
                    <p>- Ease of handling</p>
                    <p>- Fast charging (0-80% in one hour)</p>
                    <p>- Smart Dashboard, connects with a mobile app</p>
                    <p>- Affordable segment</p>
                </td>
                <td width="72">
                    <p>India, South-East Asia</p>
                </td>
            </tr>
            <tr>
                <td width="56">
                    <p><strong>ETorque</strong></p>
                </td>
                <td width="85">
                    <p>Rs 1,35,000 &ndash; Rs 1,77,000</p>
                </td>
                <td width="387">
                    <p>- Powerful electric motor, for rugged terrain</p>
                    <p>- Highest battery capacity (range of 150Km)</p>
                    <p>- Bulky</p>
                    <p>- Traction Control System</p>
                    <p>- Riders can switch between different modes (Eco, Standard, Sports)</p>
                    <p>- Mid-range price segment</p>
                </td>
                <td width="72">
                    <p>India, South-East Asia</p>
                </td>
            </tr>
            <tr>
                <td width="56">
                    <p><strong>Proton</strong></p>
                </td>
                <td width="85">
                    <p>Rs 1,50,000 &ndash; Rs 1,85,000</p>
                </td>
                <td width="387">
                    <p>- Modern design (sleek)</p>
                    <p>- Aerodynamic</p>
                    <p>- Sports model, capable of high speed</p>
                    <p>- Removable battery packs</p>
                    <p>- Luxury segment</p>
                </td>
                <td width="72">
                    <p>India, South-East Asia</p>
                </td>
            </tr>
            <tr>
                <td width="56">
                    <p><strong>eZypp</strong></p>
                </td>
                <td width="85">
                    <p>Exclusive for Delish Deliveries</p>
                    <p>Rs 1,25,000</p>
                </td>
                <td width="387">
                    <p>- Comes with an insulated storage compartment to store food</p>
                    <p>- Light, replaceable battery packs</p>
                    <p>- Simple design with easily replaceable parts</p>
                    <p>- Ease of handling</p>
                </td>
                <td width="72">
                    <p>India</p>
                </td>
            </tr>
            <tr>
                <td width="56">
                    <p><strong>Neon</strong></p>
                </td>
                <td width="85">
                    <p>Rs 1,66,000 &ndash; Rs 2,00,000</p>
                </td>
                <td width="387">
                    <p>- Luxury segment</p>
                    <p>- Newest model in the market</p>
                    <p>- Capable of High speeds</p>
                    <p>- Fast charging</p>
                    <p>- Highest range amongst all other models</p>
                </td>
                <td width="72">
                    <p>India</p>
                </td>
            </tr>
        </tbody>
    </table>


    <div class="section-title">
        <h3 class="text-center">Recent Developments</h3>
        <div class="title-line-center"></div>
    </div>
    <p>Over the last few years, NextGen Motors has invested in new areas for rapid growth in various markets. Here are few noteworthy initiatives.</p>
    <ul>
        <li><strong>Expansion in South-East Asia Market: </strong>NextGen Motors penetrated the southeast Asian market 2 years ago, and currently has a market share of 6.5% in the region. Over the last few months, the leadership has decided to focus on increasing sales, focusing on the rural market. The organization is also looking for opportunities to expand the after sales network within these countries.</li>
        <li><strong>Strategic Partnership with Delish: </strong>NextGen Motors and Delish Deliveries (a growing food ordering and delivery service) have entered an exclusive five-year contract where all Delish delivery partners will be provided customized NextGen Motors&rsquo;s electric scooters and after sales maintenance. This contract is exclusive to your region within the country.</li>
        <li><strong>Smartphone Application:</strong> The NextGen Motors smartphone application is exclusive for all NextGen Motors customers, through which they get access to the various products, accessories, and services of NextGen Motors. The app can also be used for monitoring vehicle performance, detect vehicle location, and allows the customer to opt for software and firmware updates on the vehicle. This is made possible via the IOT sensors present in various components of all NextGen Motors models, a strategic move made by the organization few years ago.</li>
        <li><strong>Launch of Neon Electric scooter:</strong> This new model of electric scooters will provide the highest battery efficiency and range. The battery pack in this model has been designed in collaboration with a German two-wheeler manufacturer.</li>
        <li><strong>Workshop on wheels: </strong>These are mobile unit vans that provides vehicle servicing and diagnostic capabilities right at the customer&rsquo;s doorstep, or in remote locations during emergencies. Right now, this program is being piloted in Bangalore which is a part of your region. In the future, this initiative will be expanded to include all major cities pan India.</li>
        <li><strong>Sustainability Initiatives: </strong>In line with their ESG commitments, NextGen Motors has implemented green manufacturing processes and launched recycling programs for old vehicle batteries. These initiatives help minimize the environmental footprint and promotes sustainable practices throughout the operations.</li>
        <li><strong>Enhanced Customer Support:</strong> NextGen Motors has upgraded its customer support system with AI-driven chatbots and a 24/7 helpline to provide timely assistance and resolve issues efficiently, ensuring a seamless service experience for our customers.</li>
        <li><strong>Dealer Network Expansion:</strong> To meet the increasing demand, NextGen Motors has expanded its dealer network, opening new showrooms and service centres in key locations. In recent months, the organization has also focused on enhancing its distributors&rsquo; network in countries such as Myanmar, Vietnam, Philippines, Malaysia, Singapore and Indonesia.</li>
    </ul>

    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

