<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Panel.master" AutoEventWireup="false" CodeFile="Base.aspx.vb" Inherits="Data_Information_Base" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>

    <script type="text/javascript">
        function fnGoBack() {
            window.location.href = "MyTask.aspx";
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
       // }(jQuery))
    </script>
    <script type="text/javascript">
        var SecondCounter = 0; var MinuteCounter = 0; var hours = 0; var IsUpdateTimer = 1; var flgChances = 1; var counter = 0; var counterAutoSaveTxt = 0;

        function f1() {
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
        <h3 class="text-center">Base</h3>
        <div class="title-line-center"></div>
    </div>
    <ul class="nav nav-tabs pt-2" role="tablist">
        <li><a class="nav-link active" href="#CSTab-1" role="tab" data-toggle="tab">Introduction</a></li>
        <li><a class="nav-link" href="#CSTab-2" role="tab" data-toggle="tab">Core Values</a></li>
        <li><a class="nav-link" href="#CSTab-3" role="tab" data-toggle="tab">ORGANISATIONAL STRUCTURE</a></li>

    </ul>

    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <p>Base is an Indian automobile manufacturer, based out of Chennai. The Company was founded in the year 1981 with a vision of creating cost-effective and affordable two-wheelers to all Indians irrespective of their socio-economic class. Through a combination of innovative product development and effective customer service, the company has grown to become one of the trusted brands in India. It is currently, the second largest motor company in the country with a revenue of 18,000 crores.</p>
            <p>The vision of the organization is to be/stay one among the top two automotive manufactures in India and one among the top five in Asia. It is working towards achieving significant share from international business, especially in Asian markets, capitalizing on the expertise developed in the areas of manufacturing, technology, and marketing.&nbsp;</p>
            <p><strong>Products:</strong> The organisation manufactures the largest range of 2 wheelers to cater to its wide range of customers. Currently, the organisation has a total of 10 bikes, of which 2 are in the premium category, and 1 in the electric scooter category.</p>

        </div>
        <!-- Tab panes 2-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-2">
            <p>The motor industry has become increasingly competitive with several players struggling to compete for market share. Indeed, some of the larger manufacturers in the country have faded away over the last 25 years.&nbsp; There is a concern amongst those that remain that their future is by no&nbsp;means assured and that there is no room for complacency if they need to thrive in this market.</p>
            <p>Base is driven by its values of <strong>&ldquo;Quality</strong>&rdquo; and <strong>&ldquo;Innovation&rdquo; </strong>to retain its brand promise and market position.</p>
            <h4 class="small-heading">Values of the organisation:</h4>

            <ul>
                <li><strong>Customer Centricity: </strong>The company is committed to producing innovative, easy to handle, environment-friendly products, backed by reliable customer service. It invests in extensive research and development to anticipate customer needs and deliver innovative and quality products.</li>
                <li><strong>Innovation: </strong>The company has always believed in technology and thus engages in honing and sustaining its cutting-edge technology by constant benchmarking against international leaders.</li>
                <li><strong>Quality Orientation</strong>: The focus on quality has resulted in the organisation adopting TQM- Total Quality Management. This has enabled the team to not only focus on results but also on the process.</li>
                <li><strong>People: </strong>The organization is investing heavily on building capabilities to realize its vision and at the same time improving job satisfaction of employees.</li>
            </ul>
        </div>

        <!-- Tab panes 3-->
        <div role="tabpanel" class="tab-pane fade" id="CSTab-3">
            <ul>
                <li>The Company is headed by Vaibhav, the Managing Director.</li>
                <li>Madhusudan, the President is responsible for 6 core departments. Each department is led by the respective Department Head.</li>
            </ul>
            <div class="text-center mb-4">
                <img class="img-thumbnail" src="../../Images/OrgStr.jpg" />
            </div>
            <div class="text-center mb-4"><a href="#" onclick="fnMenu(2, this)" id="btnNext" class="btns btn-submit">Next</a></div>
        </div>


    </div>


    <%--    <div class="text-center mb-4"><a href="#" onclick="fnMenu(2, this)" id="btnNext" class="btns btn-submit">Next</a></div>--%>

    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

