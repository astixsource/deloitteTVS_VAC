<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort3/MasterPage/Panel.master" AutoEventWireup="false" CodeFile="DealerDistribution.aspx.vb" Inherits="Data_Information_DealerDistribution" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript">
        function fnGoBack() {
            window.location.href = "Groupoverview.aspx";
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

                //   document.getElementById("dvDialog").innerHTML = "<center>Your Time Left : 0" + hours + ":" + "0" + Minutes + ":" + "0" + Seconds + " After that your window will be closed automatically.</center>";
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
    <time id="theTime" class="fst-color" style='display: none'>Reading Time Left  00: 00: 00</time>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatterRight" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Dealer Distribution</h3>
        <div class="title-line-center"></div>
    </div>
    <ol>
        <li>MotorTek dealer network is  made up of a series of franchised dealerships, which vary from  single&nbsp;sites to multisite dealerships with 5-6 outlets.&nbsp; Although the  franchises are independent operators,&nbsp;they are required to abide by  certain policy and procedural guidelines laid down by MIL.</li>
        <li>Currently, MotorTek has  around 500 dealers spread out across the country.</li>
        <li>Dealer outlets vary in size  and activity.&nbsp; Main dealers offer sales, servicing, and parts  operations,&nbsp;whilst other dealerships are smaller and tend to focus mainly  on retail sales.&nbsp;</li>
    </ol>
    <h4 class="small-heading">Sales  Across Regions</h4>
    <ol>
        <li>As the dealer outlets vary  across the country in terms of size, the number of units they sell  also&nbsp;varies. In addition, there are different trends across the  country.</li>
        <li>Given below is the  graph showing the sales across 4 regions for MotorTek in the last 12 months 
	               <div class="text-center">
                       <img src="../../Images/mt-background-4.jpg" class="img-thumbnail w-75" />
                   </div>
        </li>
    </ol>
    <p>MotorTek  has been concerned about sales specifically in the EAST region as it is low  compared to other regions. Whilst they understand that there can be differences  across geographies, there is a need to understand the possible reasons and take  measures to improve sales in that region. </p>

    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

