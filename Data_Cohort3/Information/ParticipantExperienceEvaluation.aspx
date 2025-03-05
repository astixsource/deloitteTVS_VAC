<%@ Page Title="" Language="C#" MasterPageFile="~/Data_Cohort3/MasterPage/Site.master" AutoEventWireup="true" CodeFile="ParticipantExperienceEvaluation.aspx.cs" Inherits="Admin_MasterForms_ParticipantExperienceEvaluation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
     <%--<link href="../../CSS/jquery-ui.css" rel="stylesheet" type="text/css">

    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>--%>
    <script type="text/javascript">
         function fnOpenFlashFeedbackMeeting()
          {
             var MeetingURL = document.getElementById("ConatntMatter_hdnGoToMeetingURL").value;
             
             window.open(MeetingURL)
         }
         function fnSubmit() {           

             window.location.href = "../Survey/frmThankYou.aspx";
         }
     </script>


   <style>
   .clsRequired {
             border: solid 1px #dc3545;  
        }
</style>
    <script>
        $(document).ready(function () {

            fnGetDetails();

        });


        function fnGetDetails() {
            var hdnRspID = $("#ConatntMatter_hdnRspID").val();
            $("#dvFadeForProcessing").show();
            PageMethods.GetDetails(hdnRspID,GetDetailsSuccess, fnFailed);
        }

  </script>

     <script type="text/javascript">
         
         function GetDetailsSuccess(result) {

             if (result != "0") {
                 $('#divData').html(result.split('|')[0]);

                 $('.max-slider').each(function (e) {

                     var sliderInput = $(this).siblings('input[type=text]');
                     $(this).slider({
                         range: "max",
                         min: 1,
                         max: 5,
                         value: $(this).siblings('input[type=text]').val() == '' ? '1' : $(this).siblings('input[type=text]').val(),
                         slide: function (event, ui) {

                             sliderInput.val(ui.value);
                         }
                     });

                     sliderInput.val($(this).slider("value"));
                 });
                // $("#ConatntMatter_hdnGoToMeetingURL").val(result.split('|')[1]);
                 $("#divBTNS").show();
             }
             else {
                 $('#divData').html("<span style='color:red;font-weight: bold'>No record(s) found</span>");

             }

             $("#dvFadeForProcessing").hide();
         }


         function fnFailed(result) {
             $("#dvFadeForProcessing").hide();
         }



         function fnSave()
         {

             $('input[type=text]').each(function () {
                 if ($(this).val() == '') {
                     $(this).addClass('clsRequired');
                 }
                 else {

                     $(this).removeClass('clsRequired');
                 }
             });

             if ($('.clsRequired').length > 0) {
                 alert("Box marked with red must required to fill.");
                 return false;
             }
             var conf = confirm("Are you sure to submit?");
             if (conf == false) {
                 return false;
             }
             var objDetail = new Array();
             var RspID = $("#ConatntMatter_hdnRspID").val();
             var LoginId = $("#ConatntMatter_hdnLoginId").val();
             $('input[type=text]').each(function () {
                 // myArray[i] = $(this).val();
                 var RspExerciseSubQtsnId = $(this).attr("RspExerciseSubQtsnId");
                 var Responses = $(this).val();
                 

                 var dataArray = new Array();
                 dataArray = [{
                     RspExerciseSubQtsnId: RspExerciseSubQtsnId, Responses: Responses
                 }];
                 objDetail.push(dataArray[0]);
             });

             $("#dvFadeForProcessing").show();
             PageMethods.fnSave(objDetail,LoginId,RspID, fnSaveSuccess, fnSaveFailed);


         }


         function fnSaveSuccess(result) {
             $("#dvFadeForProcessing").hide();

             if (result.split("|")[0] == "0") {
                 window.location.href = "../Exercise/ExerciseMain.aspx";
             }
             else
             {
                 alert(result.split("|")[1])
             }

         }

         function fnSaveFailed(result) {
             $("#dvFadeForProcessing").hide();
             alert(result.split("|")[1])
         }



     </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" Runat="Server">
       <div class="section-title clearfix">
        <h3 class="text-center">Participant Experience Evaluation</h3>
        <div class="title-line-center"></div>
    </div>
    <div id="divData"></div>

    <div class="text-center" id="divBTNS" style="display: none;padding:20px;">
          <%-- <Input type ="button" ID="btnSave" runat="server" value= "Go To Feedback Meeting" onClick = "fnOpenFlashFeedbackMeeting()"  class="btns btn-cancel"/>--%>
        <a href="###" class="btns btn-submit" onclick="return fnSave()" id="anchorbtn_other">Submit</a>             
    </div>
     <div id="dvFadeForProcessing" class="loader_bg">
        <div class="loader"></div>
    </div>
     <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
     <asp:HiddenField ID="hdnRspID" runat="server" Value="0" />
    <asp:HiddenField ID="hdnGoToMeetingURL" runat="server" Value="" />
</asp:Content>

