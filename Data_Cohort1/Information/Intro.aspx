<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Panel.master" AutoEventWireup="false" CodeFile="Intro.aspx.vb" Inherits="Data_Information_Intro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%--<link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>--%>

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
        <h3 class="text-center">Introduction</h3>
        <div class="title-line-center"></div>
    </div>

    <p>NextGen Motors is a leading manufacturer of 2 wheelers Electric Vehicles in India. With a legacy built on reliability, performance, and customer satisfaction, NextGen Motors has been a preferred choice for countless riders across the nation.</p>
    <p>The Indian 2-wheeler EV market is experiencing exponential growth, projected to reach an impressive 7 Billion USD by 2027. This surge is fuelled by factors such as rising disposable incomes, increasing urbanization, and a burgeoning demand for sustainable solutions. In addition, there has been strong support from the government and fossil fuel costs have risen.</p>
    <p>However, amidst this promising landscape, NextGen Motors faces stiff competition from both established industry giants and innovative new entrants. To stay ahead, it is imperative for NextGen Motors to continually enhance its service delivery and customer engagement strategies.</p>
    <div class="section-title">
        <h3 class="text-center">Strategy and Vision</h3>
        <div class="title-line-center"></div>
    </div>
    <p><strong>Vision:</strong></p>
    <p>NextGen Motors envisions a future where transportation is not only efficient and convenient but also environmentally friendly and technologically advanced. By leveraging IoT, AI, and other emerging technologies, the company aims to lead the transition towards electric vehicles, paving the way for safer and smarter mobility solutions globally.</p>

    <p><strong>Strategy:</strong></p>
    <p>NextGen Motors's future focused strategy focuses on innovation, sustainability, and customer-centricity. Key pillars of the strategy include:</p>

    <div class="text-center">
        <img src="../../Images/Intro.jpg" class="img-thumbnail" />
    </div>

    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

