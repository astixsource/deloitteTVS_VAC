<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteManager.master" AutoEventWireup="true" CodeFile="frmParticipantListForRating.aspx.cs" Inherits="frmParticipantListForRating" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">    
    <style type="text/css">
        .bg-blue{
            background:#194597;
        }
         table.table, .table > tbody > tr > td {
    border-top: 1px solid #ddd !important;
}
    </style>
    <script type="text/javascript">
       

        function fnCaseStudy(EmpNodeID, CycleID) {
            window.location.href = "frmManagerAssessmentInstruction.aspx?str=" + EmpNodeID + "^" + CycleID;// "frmManagerAssessmentRating.aspx?str=" + EmpNodeID + "^" + CycleID + "&flgCallFrom=2";
        }

        function fnFinalSubmit(RSPExcersiceID) {

            var loginId = $("#ConatntMatter_hdnLoginID").val();
                $("#loader").show();
                PageMethods.fnCheckComplition(RSPExcersiceID, 0, function (result) {
                    $("#loader").hide();
                    if (result.split("|")[0] == "1") {
                        alert("Error-" + result.split("|")[1]);
                    }
                    else {
                        var arrData=$.parseJSON("["+result+"]");
                        if (arrData[0].length > 0) {
                            $("#divDialog").dialog({
                                title:"Alert!!",
                                width: '400',
                                height: '320',
                                    modal: true,
                                    open:function(){
                                        var strHTML = "<div style='font-size:12pt;padding:5px 0px;text-align:left'>Below Task are not still submitted,kindly submit first!</div>";
                                         strHTML += "<table style='margin:5px 5px 0px 5px;font-size:8.8pt' class='table table-bordered table-condensed' cellpadding='2' cellspacing='0'>";
                                        strHTML+="<thead><tr>";
                                        strHTML+="<th>SrNo</th>";
                                        $.each(arrData[0][0], function (key, value) {
                                            strHTML+="<th>"+key+"</th>";
                                        });
                                        strHTML+="</tr><thead>";

                                        strHTML+="<tbody>";
                                        for(var i in arrData[0]){
                                            strHTML+="<tr>";
                                            strHTML+="<td style='padding:3px;text-align:center'>"+(parseInt(i)+1)+"</td>";
                                            $.each(arrData[0][i], function (key, value) {
                                                strHTML += "<td style='padding:3px;'>" + value + "</td>";
                                            });
                                            strHTML+="</tr>";
                                        }
                                        strHTML+="</tbody></table>";
                                        $("#divDialog")[0].innerHTML=strHTML;
                                    },
                                    close: function () {
                                        $(this).dialog("destroy");
                                    },
                                    buttons:{
                                        "OK":function(){
                                            $(this).dialog("close");
                                        }
                                    }
                                });
                        }else{
                            window.location.href = "AssessorRatingConfirmation.aspx?flg=2&RSPExerciseId=" + RSPExcersiceID;
                        }
                    }
                }, function(result){});
           
        }
       

        //function fnOpenInstructionDialog() {
        //    $("#dvInstructions").dialog({
        //        title: "Instructions",
        //        width: '50%',
        //        maxHeight: $(window).height() - 150,
        //        modal: true,
        //        position: { my: 'center', at: 'center', of: window },
        //        close: function () {
        //            $(this).dialog("close");
        //            $(this).dialog("destroy");
        //        }
        //    });
        //}
        function fnGoBack() {
            window.location.href = "frmAssessorDashboard.aspx"
        }
        $(document).ready(function () {
            $("#loader").hide();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            //$("#ConatntMatter_ddlCycle").on("change", function () {
            //    $("#divBtnscontainer").hide();
            //    var LoginId = $("#ConatntMatter_hdnLoginId").val();
            //    var CycleId = $("#ConatntMatter_ddlCycle").val();
            //    fnGetStatus(CycleId);
            //});
            ////   $("#ConatntMatter_ddlCycle").find('option[value="1"]').attr('selected', 'true')
            //var SelectedCycleId = 0;
            //if ($("#ConatntMatter_ddlCycle").val() === "") {
            //    SelectedCycleId = 0
            //}
            //else
            //    SelectedCycleId = $("#ConatntMatter_ddlCycle").val();

            fnGetStatus(0);
        });

        function fnGetStatus(CycleId) {
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            //var RoleId = $("#ConatntMatter_hdnRoleId").val();
            //var CycleDate = $("#txtDate").val();

            PageMethods.frmGetStatus(LoginId,1, function (result) {
                $("#loader").hide();
                $("#ConatntMatter_divStatus")[0].innerHTML = result;
               // $("#ConatntMatter_divStatus").scrollLeft(0);

                if ($("#tbl_Status").length > 0) {

                    $("#ConatntMatter_divStatus").prepend("<div id='tblheader'></div>");

                    var wid = $("#tbl_Status").width(), thead = $("#tbl_Status").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tblEmp").css({ "width": wid, "min-width": wid });
                    for (i = 0; i < $("#tbl_Status").find("th").length; i++) {
                        var th_wid = $("#tbl_Status").find("th")[i].clientWidth;
                        // $("#tblEmp_header, #tbl_Status").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                        var th_wid = $("#tbl_Status").find("th")[i].clientWidth;
                        $("#tblEmp_header").find("th").eq(i).css("min-width", th_wid);
                        $("#tblEmp_header").find("th").eq(i).css("width", th_wid);
                        $("#tbl_Status").find("th").eq(i).css("min-width", th_wid);
                        $("#tbl_Status").find("th").eq(i).css("width", th_wid);

                    }
                    $("#tbl_Status").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");
                    var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                    $('#dvtblbody').css({
                        'height': $(window).height() - (nvheight + secheight + fgheight + 120),
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                }


            }, fnFail);
        }
        function fnFail(err) {
            $("#loader").hide();
            alert("Due to some technical error, we are unable to complete your request !");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">Participant List For Manager Assessment Form</h3>
        <div class="title-line-center"></div>
    </div>
    <%--<div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch :-</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycle" runat="server" CssClass="form-control" AppendDataBoundItems="true">
              
            </asp:DropDownList>
        </div>
    </div>--%>
    <div id="divStatus" runat="server"></div>

    <div onclick="fnGoBack()" style="display: none">Go Back</div>
    <div class="text-right d-none">
        <input type="button" id="btnInstructions" class="btns btn-submit" onclick="fnOpenInstructionDialog()" value="Instructions" />
    </div>
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <div id="divDialog" style="display:none"></div>
    <div id="dvInstructions" style="display: none;" title="Instructions">
        <p>Welcome, you are about to start assessment for the candidates.</p>
        <p>Please click on “Click to rate” according to the exercise and user that you want to assess.</p>
        <p>Please choose the item from the left and mark the appropriate responses for each item.</p>
        <p>Please ensure that you mark all appropriate evidences after thoroughly reading all the responses and evidences.</p>
        <p>Please click on Final Submit button after completion of assessment of an exercise.</p>
    </div>
</asp:Content>
