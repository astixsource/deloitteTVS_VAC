<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort2/MasterPage/Panel.master" AutoEventWireup="false" CodeFile="ChangingLandscape.aspx.vb" Inherits="Data_Information_ChangingLandscape" %>

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
    <div class="section-title">
        <h3 class="text-center">Changing Landscape</h3>
        <div class="title-line-center"></div>
    </div>
    <p>The  automotive industry is drastically changing due to the following triggers:</p>
    <p><strong>Digitization </strong>Digital commerce technologies are disrupting  the automobile industry by unlocking greater efficiencies, personalization, and  cost savings.  Automobiles,  today, are safer, user-friendly and comes with several features that improve  their value and usefulness for automobile owners.&nbsp;Modern automobiles can  offer much more than driving/riding one from one point to another, just like  modern cell phones can perform more than just a call.</p>
    <p><strong>Sustainability</strong> With the human impact on climate causing harmful effects on the environment,  every industry is turning towards more environmentally friendly technology.  &nbsp;Electric vehicles are gaining immense popularity nowadays all over the  world&nbsp;to contribute to the cause. Governments are working towards creating  the infrastructure/electric charging platforms to facilitate the change, along  with offering subsidies, wherever necessary.</p>
    <p><strong>Customer  Preferences</strong> OEMs are responding to the new  dimensions of mobility (connected, autonomous, shared and electric), new forms  of ownership and an increased environmental focus.</p>
    <p><strong>Supply  Chain Architecture</strong> The Indian automotive  supplier base is currently not too diversified for majority of components. This  was to drive volume-based price efficiencies. However, this strategy is highly  exposed to risks arising from disruptions in geographies that supply key auto  components. Hence, organisations are currently evaluating the supply chain  architecture and its vulnerabilities against external factors.</p>
   
    
    <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField ID="hdnCounter" runat="server" Value="0" />
</asp:Content>

