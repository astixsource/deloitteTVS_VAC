<%@ Page Language="VB" AutoEventWireup="false" CodeFile="frmBasketQues.aspx.vb" Inherits="Basket_frmBasketQues" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/Site.css" rel="stylesheet" />

    <script src="../../Scripts/jquery-1.12.4.js"></script>
     <script src="../../Scripts/validation.js"></script>

    <script type="text/javascript">
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
        $(document).ready(function () {
            $("#dvFadeForProcessing").hide();
            var excerciseId = $("#hdnExerciseID").val();
            var excerciseMultimailId = $("#hdnExerciseMultiMailID").val();
            $("body").css("background", "#FFFFFF");
           
            parent.fnBackSHow();
        });

        function fnCloseQuestion() {
            var strAllAnswers = "";
            var multiMailQuesId = $("#tblMain").attr("MultiMailQuesId");
            var exerciseId = $("#tblMain").attr("ExerciseId");
            var bandID = $("#tblMain").attr("BandID");
            var rspExcerciseID = $("#hdnRSPExerciseID").val();
            var intProirty = parent.$("input[name='ddlPrority']:checked").val();

            for (var ques = 0; ques < $("#tblMain").find("div[IsQues=1]").length; ques++) {
                var quesId = $($("#tblMain").find("div[IsQues=1]")[ques]).attr("QuesId");
                var selectedValues = "";
                for (var i = 0; i < $($("#tblMain").find("div[IsQues=1]")[ques]).find("input:checked").length; i++) {
                    var val = $($($("#tblMain").find("div[IsQues=1]")[ques]).find("input:checked")[i]).val();
                    if (selectedValues == "") {
                        selectedValues = val;
                    }
                    else {
                        selectedValues += "^" + val;
                    }
                }

                if (selectedValues == "") {
                    alert("Please answer all the questions.");
                    return false;
                }

                if (strAllAnswers == "") {
                    strAllAnswers = quesId + "@" + selectedValues;
                }
                else {
                    strAllAnswers += "|" + quesId + "@" + selectedValues;
                }
            }

            if (strAllAnswers == "") {
                alert("Please select the answer first.");
                return false;
            }
            else {
                strAllAnswers = strAllAnswers + "|";
            }
            $("#dvFadeForProcessing").show();
            PageMethods.spUpdateAnswer(multiMailQuesId, rspExcerciseID, strAllAnswers, $("#hdnRspMailInstanceID").val(), intProirty, fnSuccess, fnFailed);
            //parent.fnCloseQuestion();
        }

        function fngoback() {
            parent.fnCloseQuestion();
        }

        function fnSuccess(result) {
            $("#dvFadeForProcessing").hide();
            if (result.split("^")[0] == "1") {
                parent.fnSaveQuestion();
                parent.fnUpdateStatus();
            }
            else {
                $("#dvFadeForProcessing").hide();
                //alert(result.split("^")[1]);
                alert(result);
                return false;
            }
        }

        function fnFailed(result) {
            $("#dvFadeForProcessing").hide();
            //alert(result._message);
            alert("Oops! Something went wrong. Please try again.");
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <div id="dvFadeForProcessing" style="display:block" class="loader_bg" >
        <div class="loader"></div>
    </div>
        <div class="clearfix" id="dvMain" runat="server">
        </div>

        <asp:HiddenField ID="hdnMultiMailQstnID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnExerciseID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnRSPExerciseID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnRspMailInstanceID" runat="server" Value="0" />
    </form>
</body>
</html>
