<%@ Page Title="" Language="VB" MasterPageFile="~/Data_Cohort1/MasterPage/Site.master" AutoEventWireup="false" CodeFile="frmSrvy.aspx.vb" Inherits="frmSrvy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        body {
            font-size: 14px;
        }
        table#tblsvry > tbody > tr > td > table > tbody > tr > td{
            border: none;
            padding:0;
        }

    </style>
    <script type="text/javascript">
        //$(document).ready(function () {
        //    //$("#mainsection").css("height", $(window).height() - ($("#head").height() + $("#foot").height()) + "px");
        //});

        function fnLogout() {
            window.location.href = "../../Login.aspx";
        }

        var arResult = new Array();
        var arChk = new Array();
        var strRet = "";

        function fnShowStar(Id) {
            document.getElementById("td" + Id).innerHTML = "*";

        }

        function fnHideStar(Id) {
            document.getElementById("td" + Id).innerHTML = "&nbsp;";
            //document.getElementById("td" + Id).bgcolor= "mistyrose";
        }

        function fnUpDateArray(indx, strText) {

            if (arResult[indx] == 0) {

                document.getElementById("ConatntMatter_hdnColorCounter").value = parseInt(document.getElementById("ConatntMatter_hdnColorCounter").value, 10) + 1;

                fnFillColor(document.getElementById("ConatntMatter_hdnColorCounter").value);
            }
            arResult[indx] = strText;
            fnHideStar(indx);
        }

        function fnFillColor(id) {

            //   document.getElementById("tdColor" + id).style.backgroundColor = "#008000";
        }

        function fnValidate() {
            //		alert("validate");
            strRet = "";

            var FlagValidate = 0;                   // 0 : No Error ( Validation OK)   ||    1 : Error ( Validation Failed)

            for (var indx = 0; indx < parseInt(document.getElementById("ConatntMatter_hdnNoOfQuestions").value, 10); ++indx) {
                if (arResult[indx] == 0) {
                    FlagValidate = 1;
                    fnShowStar(indx);
                }
                else {
                    strRet += "|" + arResult[indx];

                }
            }

            if (strRet != "") {
                strRet = strRet.substring(1);
            }
            //alert(strRet)
            return FlagValidate;
        }

        function fnValidate1() {
            //		alert("validate");
            strRet = "";

            var FlagValidate = 0;                   // 0 : No Error ( Validation OK)   ||    1 : Error ( Validation Failed)

            for (var indx = 0; indx < parseInt(document.getElementById("ConatntMatter_hdnNoOfQuestions").value, 10); ++indx) {
                if (arResult[indx] == 0) {
                    FlagValidate = 1;
                    //fnShowStar(indx);
                    fnHideStar(indx);
                }
                else {
                    strRet += "|" + arResult[indx];

                }
            }

            if (strRet != "") {
                strRet = strRet.substring(1);
            }
            return FlagValidate;
        }


        function fnNext() {
            //alert(document.getElementById("hdnPageNmbr").value);

            if (parseInt(fnValidate(), 10) == 1) {
                alert("You have left atleast one question unanswered ( marked with * ). Please note that it is compulsory to respond to every question!");
                return false;
            }

            // alert(strRet)
            document.getElementById("ConatntMatter_hdnDirection").value = 2;
            document.getElementById("ConatntMatter_hdnResult").value = strRet;
            document.getElementById("ConatntMatter_hdnSaveType").value = 10;
            document.getElementById("ConatntMatter_btnSaveASP").click();


        }

        function fnPrevious() {

            /*	if(parseInt(fnValidate(),10) == 1)
            {
            alert("You have left atleast one question unanswered. Please note that it is compulsory to respond to every question!" );			
            return false;
            } */


            fnValidate1();
            /*var rt=fnCheck();
            if (parseInt(rt,10)==1)
            {
            alert("You must choose a different rank for each statement");
            return false;
            }	*/

            document.getElementById("ConatntMatter_hdnDirection").value = 1;
            document.getElementById("ConatntMatter_hdnResult").value = strRet;
            document.getElementById("ConatntMatter_hdnSaveType").value = 1;

            document.getElementById("ConatntMatter_btnSaveASP").click();

        }

        function fnSaveExit() {
            if (window.confirm("Do you really want to Exit ")) {
                strRet = "";
                for (var indx = 0; indx < parseInt(document.getElementById("ConatntMatter_hdnNoOfQuestions").value, 10); ++indx) {
                    if (arResult[indx] != 0) {
                        strRet += "|" + arResult[indx];
                    }
                }
                if (strRet != "") {
                    strRet = strRet.substring(1);
                }
                document.getElementById("ConatntMatter_hdnResult").value = strRet;
                document.getElementById("ConatntMatter_hdnSaveType").value = 0;
                document.getElementById("ConatntMatter_hdnDirection").value = 0;
                document.getElementById("ConatntMatter_btnSaveASP").click();
            }
            else {
                return false;
            }
        }



        function fnPageLoad() {

            var intArLength = document.getElementById("ConatntMatter_hdnNoOfQuestions").value;
            for (var indx = 0; indx < intArLength; ++indx) {
                arResult[indx] = 0;
            }
            if (document.getElementById("ConatntMatter_hdnPreviousSelected").value != "") {
                var arSel = new Array();
                arSel = document.getElementById("ConatntMatter_hdnPreviousSelected").value.split("@");
                for (var indx = 0; indx < arSel.length; ++indx) {
                    arResult[arSel[indx].split("|")[0]] = arSel[indx].split("|")[1];
                }
            }

            if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 11) {
                document.getElementById("ConatntMatter_btnNext").value = "Submit";
            }


            if (document.getElementById("ConatntMatter_hdnPageNmbr").value == 1) {
                document.getElementById("btnPrevious").style.display = "none";
            }
            /* if(document.getElementById("hdnPageNmbr").value == 5)
            {
            //document.getElementById("tblHeadForPage12").style.display="block";
            } */

        }

        function scrollValue() {
            document.getElementById("tblTopHeader").style.top = document.body.sscrollTop;
            document.getElementById("tblTopHeader").style.left = 14;
        }

        function fnShowRetCodeHelp() {
            document.getElementById("tdRetCodeHelp").style.top = parseInt(event.clientY, 10) + parseInt(document.body.scrollTop, 10);
            document.getElementById("tdRetCodeHelp").style.left = event.clientX
            document.getElementById("tdRetCodeHelp").style.display = "block";
        }

        function fnHideRetCodeHelp() {
            document.getElementById("tdRetCodeHelp").style.display = "none";
        }

        function fnOpen() {
            var valInstruction = 1
            window.open("frmInstructions.aspx?valInstruction=" + valInstruction, "Instructions", 'width=550,height=600')
        }

        function fnOpenGlossaryWindow() {
            var value = 1
            window.open("frmDefinitions.aspx?value=" + value, "Glossary", 'width=1000,height=500')
        }



    </script>
    <script type="text/javascript">
        history.forward(+1);

        $(document).ready(function () {
            $("#tblsvry tr").eq(0).hide();
            fnPageLoad();
        });

    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Assessment Survey</h3>
        <div class="title-line-center"></div>
    </div>
    <table id="tblTopHeader" style="background: #2488C4; color: #FFF; margin-bottom: 0; width:100%">
        <tr>
            <td style="width:5%">&nbsp;</td>
            <td style="width:55%">Page No - 1/1</td>
            <td align="right" id="tdHead1" runat="server" style="width:40%">
                <table style="width:100%" class="text-center">
                    <tr>
                        <td style="width:20%">Strongly Agree</td>
                        <td style="width:20%">Agree</td>
                        <td style="width:20%">Neutral</td>
                        <td style="width:20%">Disagree</td>
                        <td style="width:20%">Strongly Disagree</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <h4 class="small-heading">Please Rate the following</h4>
    <div id="dvSurvey" runat="server"></div>
    <div class="text-center">Do you have suggestions to help us make this process better?</div>
    <div class="text-center">
        <textarea id="txtCmnt" class="form-control" rows="5" cols="40" runat="server" style="width: 50%; margin: 0 auto"></textarea>
    </div>

    <div class="text-center mt-3 mb-3">
        <input type="button" class="btns btn-submit" id="btnPrevious" style="display: none" onclick="fnPrevious()" value="Previous" />
        <input type="button" class="btns btn-submit" id="btnSaveExit" style="display: none" onclick="fnSaveExit()" value="Save & Exit" />
        <input type="button" class="btns btn-submit" id="btnNext" onclick="fnNext()" value="Submit" runat="server" />
    </div>

    <div style="display: none;">
        <input id="hdnNoOfQuestions" type="text" size="2" name="hdnNoOfQuestions" runat="server" />
        <input id="hdnPageNmbr" type="text" size="2" name="hdnPageNmbr" runat="server" />
        <input id="hdnDirection" type="text" size="2" name="hdnDirection" runat="server" />
        <input id="hdnResult" type="text" name="hdnResult" runat="server" />
        <input id="hdnSaveType" type="text" size="2" name="hdnSaveType" runat="server" />

        <input id="hdnPreviousSelected" type="text" size="5" name="hdnPreviousSelected" runat="server" />
        <asp:Button ID="btnSaveASP" Style="visibility: hidden" runat="server" Text="Save"></asp:Button>
        <input id="hdnColorCounter" type="text" size="4" name="hdnColorCounter" runat="server" />
    </div>
</asp:Content>

