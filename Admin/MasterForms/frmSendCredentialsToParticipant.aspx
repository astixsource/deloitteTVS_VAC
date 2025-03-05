<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="false" CodeFile="frmSendCredentialsToParticipant.aspx.vb" Inherits="Admin_MasterForms_frmSendCredentialsToParticipant" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
     <script type="text/javascript">
        $(document).ready(function () {

            $("#ConatntMatter_ddlCycleName").on("change", function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                $('#btnSave').hide();
                var CycleID = $("#ConatntMatter_ddlCycleName").val();
                $("#loader").show();
             
                PageMethods.fnGetParticpantAgCycle(CycleID, fnGetDisplaySuccessData, fnGetFailed);

            });           
        });
     
     function fnGetDisplaySuccessData(result) {

            $("#loader").hide();
            if (result.split("~")[0] == "1") {

                  $("#ConatntMatter_dvMain")[0].innerHTML = result.split("~")[1];
                 var  strReturnTableData = result.split("~")[1];


                //---- this code add by satish --- //
                if ($("#tblEmp").length > 0)
                {

                    $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");

                    var wid = $("#tblEmp").width(), thead = $("#tblEmp").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tblEmp").css({"width": wid, "min-width": wid});

                    for (i = 0; i < $("#tblEmp").find("th").length; i++) {
                        var th_wid = $("#tblEmp").find("th")[i].clientWidth;
                        $("#tblEmp_header, #tblEmp").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tblEmp").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                    var secheight = $('.section-title').outerHeight(), nvheight = $(".navbar").outerHeight(), fgheight = $('.form-group').outerHeight();
                    $('#dvtblbody').css({
                        'height': $(window).height() - (nvheight + secheight + fgheight + 250),
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                    }
                //---- end code --- //

                $("#btnSendMail").show();

                

            }
            else
            {
                $("#btnSendMail").hide();
            }
         
        }
        function fnGetFailed(result) {
            alert(result.split("@")[1])
        }

    </script>

     <script type="text/javascript">
        function checkBoxValidate() {
            valid = true;

            if ($('input[type=checkbox]:checked').length == 0) {
                alert("Please select at least one checkbox");
                valid = false;
            }

            return valid;
        }

            

        $(document).ready(function () {

            $('#btnSendMail').click(function () {

                $("#loader").show()

                var flgValidate = checkBoxValidate();

                if (flgValidate == false) {
                    return false;
                }

                var objDetail = new Array();
                var CycleID = $("#ConatntMatter_ddlCycleName").val();
                var chkflag = 0;


                var strCycleParticipantArr = new Array();
                $("input[type=checkbox]").each(function ()
                {
                    if ($(this).is(":checked"))
                    {
                        var ParticipantID = $(this).attr("ParticipantID");
                        var ParticipantEmailID = $(this).attr("ParticipantEmailID");
                        var UserName = $(this).attr("UserName");
                        var Password = $(this).attr("Password");
                        var SecondaryEmailID = $(this).attr("SecondaryEmailID");
                        strCycleParticipantArr = [{
                            ParticipantID: ParticipantID, ParticipantEmailID: ParticipantEmailID, UserName: UserName, Password: Password, SecondaryEmailID: SecondaryEmailID
                        }];
                        objDetail.push(strCycleParticipantArr[0]);
                    }                  
                    
                });

                PageMethods.fnSendMailToParticipantAgCycle(CycleID, objDetail, fnSendMailToParticipantSuccess, fnFailed)

            });

            function fnSendMailToParticipantSuccess(result) {
                if (result.split("~")[0] == "1")
                {
                    alert("Mail Sent Successfully")                   
                    $("#loader").hide();
                    
                }
            }
            function fnFailed(result) {
                if (result.split("~")[0] == "2") {
                    alert("Error while sending the mails");
                    $("#loader").hide();
                }

            }

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" Runat="Server">
     <div class="section-title clearfix"> 
        <h3 class="text-center">Invitation Mail To Participant</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Select Batch</label>
        <div class="col-4">
            <asp:DropDownList ID="ddlCycleName" runat="server" CssClass="form-control" AppendDataBoundItems="true">
               
            </asp:DropDownList>
        </div>
    </div>
    <div class="body-content">
            <div id="dvMain" runat="server"></div>
        </div>
     <div class="text-center">
        <input type="button" id="btnSendMail" value="Send Mail" class="btns btn-submit" style="display: none" />
    </div>
    <input type="hidden" id="hdnMenuFlag" value="0">
      <input type="hidden" id="hdnChkFlag" value="0">

    <div id="loader" class="loader_bg">
        <div class="loader"></div>
    </div>
</asp:Content>

