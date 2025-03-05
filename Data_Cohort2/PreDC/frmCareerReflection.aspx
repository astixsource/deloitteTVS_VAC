<%@ Page Title="" Language="C#" MasterPageFile="~/Data_Cohort2/MasterPage/Site.master" AutoEventWireup="true" CodeFile="frmCareerReflection.aspx.cs" Inherits="Generalist_PreDC_frmCareerReflection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
     <link href="../../CSS/jquery-ui.css" rel="stylesheet" />
    <style>
        .table-bordered td, .table-bordered th {
            border: 1px solid #000000 !important;
        }
        .table td input{
            border: 1px solid #e0e0e0;
        }
        
        .table td textarea{
            border: none !important;
        }
        .clsdivImg{
            float: left;
    position: absolute;
    width: 160px;
    height: 158px;
    border: 1px solid #000;
    opacity: .25;
    background: #b0b0b0;
    z-index: 2;
    display:none
        }
        .box{
            border: 1px solid #000;
         width: 160px;
    height: 158px;           
    }
    .stack-top{
        position: absolute;
        z-index: 9;
        display:none;
         width: 160px;
    height: 158px;
    border: 1px solid #000;
    opacity:.5;
    background-color:#000;
    padding:50px;
    }
    </style>
    <script>
        var sDialog;
        $(document).ready(function () {
            //$("#s_photo").click(function () {
            //    $("#s_file").trigger("click");
            //});
            //$("#imgPic").mouseover(function () {
            //    $(".stack-top").css({
            //        left: $(this).position().left,
            //        top: $(this).position().top,
            //        "display":"inline-block"
            //    })
            //}).mouseout(function () {
            //    $(".stack-top").hide();
            //})
            $("#txtName").val($("#ConatntMatter_hdnEmpName").val());
            fnGetCareerReflectionProfileData();
        });

        function fnGetCareerReflectionProfileData() {
            $("#loader").show();
            var EmpNodeId = $("#ConatntMatter_hdnEmpNodeId").val();
            PageMethods.fnGetCareerReflectionProfileData(EmpNodeId, function (result) {
                    $("#loader").hide();
                    if (result.split("|~|")[0] == "0" && result.split("|~|")[1]!="") {
                        var sData = $.parseJSON(result.split("|~|")[1]);
                        var tbl = sData.Table;
                        if (sData.Table.length > 0) {
                            $("#txtName").val(tbl[0]["FullName"]);
                            $("#txtTotalExperience").val(tbl[0]["TotExperience"]);
                            $("#txtExperienceAtBosch").val(tbl[0]["BoschExperience"]);
                            $("#txtReportingMembers").val(tbl[0]["NoOfReportingMembers"]);
                            $("#txtLevel").val(tbl[0]["Level"]);
                            $("#txtFunction").val(tbl[0]["Function"]);
                            $("#txtCareer").val(tbl[0]["CareerPath"]);
                            $("#txtarea1").val(tbl[0]["FactorsToMotivate"]);
                            $("#txtarea2").val(tbl[0]["Achievements"]);
                            $("#txtarea3").val(tbl[0]["KeyEventsAndExperiences"]);
                            $("#txtarea4").val(tbl[0]["KeyLearnings"]);
                            var PhotoFileName = tbl[0]["PhotoFileName"];
                            if (PhotoFileName != null) {
                                if (PhotoFileName.trim() != "") {
                                    $("#imgPic")[0].src = "../../ProfilePics/" + PhotoFileName;
                                    $("#imgPic").attr("picname", PhotoFileName);
                                }
                            }
                        }
                        }
                    }, function (result) {
                        $("#loader").hide();
                        $("#dvDialog")[0].innerHTML = "Error-" + result._message;
                        $("#dvDialog").dialog({
                            title: "Alert!",
                            modal: true,
                            width: "auto",
                            height: "auto",
                            close: function () {
                                $(this).dialog('destroy');
                            },
                            buttons: {
                                "OK": function () {
                                    $(this).dialog('close');
                                }
                            }
                        });

                    });

        }
        function fnSaveCareerReflectionProfileData() {
            $("#dvDialog")[0].innerHTML = "<br/>Are you sure to Save the Infomation?"
            $("#dvDialog").dialog({
                title: "Confirmation:",
                modal: true,
                height: "auto",
                close: function () {
                    $(this).dialog('destroy');
                },
                buttons: {
                    "Yes": function () {
                        var LoginId = $("#ConatntMatter_hdnLogin").val();
                        var FullName = $("#txtName").val().trim();
                        if (FullName == "") {
                            alert("Enter Name First");
                            $("#txtName").focus();
                            return false;
                        }
                        var TotExperience = $("#txtTotalExperience").val().trim();
                        if (TotExperience == "") {
                            alert("Enter Total Experience First");
                            $("#txtTotalExperience").focus();
                            return false;
                        }
                        var BoschExperience = $("#txtExperienceAtBosch").val().trim();
                        if (BoschExperience == "") {
                            alert("Enter Bosch Experience First");
                            $("#txtExperienceAtBosch").focus();
                            return false;
                        }

                        var NoOfReportingMembers = $("#txtReportingMembers").val().trim();
                        NoOfReportingMembers = NoOfReportingMembers == "" ? 0 : NoOfReportingMembers;
                        var sLevel = $("#txtLevel").val().trim();
                        var sFunction = $("#txtFunction").val().trim();
                        var CareerPath = $("#txtCareer").val().trim();
                        var FactorsToMotivate =  $("#txtarea1").val().trim();
                        var Achievements = $("#txtarea2").val().trim();
                        var KeyEventsAndExperiences = $("#txtarea3").val().trim();
                        var KeyLearnings = $("#txtarea4").val().trim();

                        if (FactorsToMotivate == "" || Achievements == "" || KeyEventsAndExperiences == "" || KeyLearnings == "") {
                            alert("Kindly anwser the each question first");
                            return false;
                        }
                        var PhotoFileName =$("#imgPic").is("[picname]")? $("#imgPic").attr("picname"):"";
                        
                        $("#loader").show();
                        $("#dvDialog").dialog('close');
                        PageMethods.fnSaveCareerReflectionProfileData(LoginId, FullName, TotExperience,BoschExperience, NoOfReportingMembers
        ,sLevel,sFunction,CareerPath,FactorsToMotivate,Achievements,KeyEventsAndExperiences,
         KeyLearnings,PhotoFileName, function (result) {
                            $("#loader").hide();
                            $("#dvDialog")[0].innerHTML = result.split("|")[1];
                            $("#dvDialog").dialog({
                                title: "Alert!",
                                modal: true,
                                width: "auto",
                                height: "auto",
                                close: function () {
                                    $(this).dialog('destroy');
                                },
                                buttons: {
                                    "OK": function () {
                                        $(this).dialog('close');
                                        if (result.split("|")[0] == 0) {
                                            window.location.href = "frmThanksForCareerReflection.aspx";
                                        }
                                    }
                                }
                            });
                        }, function (result) {
                            $("#loader").hide();
                            $("#dvDialog")[0].innerHTML = "Error-" + result._message;
                            $("#dvDialog").dialog({
                                title: "Alert!",
                                modal: true,
                                width: "auto",
                                height: "auto",
                                close: function () {
                                    $(this).dialog('destroy');
                                },
                                buttons: {
                                    "OK": function () {
                                        $(this).dialog('close');
                                    }
                                }
                            });
                        });
                    },
                    "No": function () {
                        $(this).dialog('close');
                    }
                }
            })

        }

        function fnBackpage() {
            window.location.href = "frmSlotBooking.aspx";
        }
        function fnSetDiv(sender,flg) {
            if (flg == 1) {
                var x = $("#imgPic").position().left + $("#imgPic").outerWidth();
    var y = $("#imgPic").position().top - jQuery(document).scrollTop();

    $("#s_photo").dialog("open");
    $('#s_photo').dialog('option', 'position', [$(sender).position().top, $(sender).position().left]);
            } else {
               $("#s_photo").dialog('hide');
            }
        }

        function fnUploadImgage() {
            var fileUpload = $("#s_file").get(0);
            var files = fileUpload.files;
            if (files.length == 0) {
                return false;
            }
            var data = new FormData();
            for (var i = 0; i < files.length; i++) {
                data.append(files[i].name, files[i]);
            }

            data.append("FolderName", "ProfilePics");
            data.append("EmpNodeId", $("#ConatntMatter_hdnEmpNodeId").val());
            var filePath = "";
            $("#loader").show();
            $.ajax({
                url: "../../FileUploadHandler.ashx?flgfilefolderid=10",
                type: "POST",
                data: data,
                async: true,
                contentType: false,
                processData: false,
                success: function (result) {
                    $("#loader").hide();
                    if (result.split("|")[0] == "1") {
                        $("#imgPic")[0].src = "../../ProfilePics/" + result.split("|")[2]
                        $("#imgPic").attr("picname", result.split("|")[2]);
                    }
                    else {
                        alert("Error : " + result.split("|")[1]);
                        return false;
                    }
                },
                error: function (err) {
                    alert(err.statusText)
                    $("#loader").hide();
                }
            });
        }
        function fnShowFileDialog() {
            $("#s_file").trigger("click");
        }
    </script>
   <script>
       function whichButton(event) {
           if (event.button == 2)//RIGHT CLICK
           {
               alert("Not Allow Right Click!");
           }
       }
       function noCTRL(e) {
           //alert(e);
           //e.preventDefault();

           var code = (document.all) ? event.keyCode : e.which;
           var msg = "Sorry, this functionality is disabled.";
           if (parseInt(code) == 17) //CTRL
           {
               alert(msg);
               window.event.returnValue = false;
           }
       }

       function isNumberKeyNotDecimal(evt) {
           //debugger;
           var charCode = (evt.which) ? evt.which : event.keyCode
           if (charCode > 31 && (charCode < 48 || charCode > 57))
               return false;


           return true;
       }

       function isNumericWithOneDecimal(evt) {
           var val1;
           if (!(evt.keyCode == 46 || (evt.keyCode >= 48 && evt.keyCode <= 57)))
               return false;
           var parts = evt.srcElement.value.split('.');
           if (parts.length > 2)
               return false;
           if (evt.keyCode == 46)
               return (parts.length == 1);
           if (evt.keyCode != 46) {
               var currVal = String.fromCharCode(evt.keyCode);
               val1 = parseFloat(String(parts[0]) + String(currVal));
               if (parts.length == 2)
                   val1 = parseFloat(String(parts[0]) + "." + String(currVal));
           }



           if ($(evt.srcElement).is("[crlt]")) {
               
               if (parts.length == 2 && parts[1].length >= 2) {
                   return false;
               }
           }

           return true;
       }
       function validateEmail(sEmail) {
           var filter = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
           if (filter.test(sEmail)) {
               return true;
           }
           else {
               return false;
           }
       }
   </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">CAREER REFLECTION PROFILE</h3>
        <div class="title-line-center"></div>
    </div>
    <div>
        <table class="table table-bordered m-0">
            <tbody>
                <tr>
                    <td style="background-color: #c00000; color: #fff; font-size: 15pt; font-weight: bold; text-align: center" class="p-1">A. My Profile
                    </td>
                </tr>
                <tr>
                    <td style="padding: 0px">
                        <table class="table table-bordered m-0">
                            <tr>
                                <td style="background-color: #e0e0e0; font-size: 13pt; font-weight: bold; text-align: center; padding: 0px">Personal Data
                                </td>
                                <td style="background-color: #e0e0e0; font-size: 13pt; font-weight: bold; text-align: center; padding: 0px">Professional Data
                                </td>
                            </tr>
                            <tr>
                                <td class="p-0">
                                    <table class="table table-bordered m-0">
                                        <tr>
                                            <td style="width:33%" class="p-0">
                                                <div class="box">
                                                <img src="../../ProfilePics/NoImage.png" style="width:100%;height:158px"  id="imgPic" picname=""  />
                                                    </div>
                                                <div id="s_photo" class="box stack-top" ><i class="fa fa-pencil" style="color:blue;font-size:30px;"></i></div>

<input type="file" name="s_file" id="s_file" style="opacity: 0;display:none" onchange="fnUploadImgage()">
                                            </td>
                                            <td class="p-1">
                                                <table class="table m-0 border-0">
                                                    <tr>
                                                        <td style="border:none  !important" class="p-0">
                                                            <div style="font-weight:bold">
                                                    Name:
                                                </div>
                                                <div>
                                                    <input placeholder="Type here" type="text" id="txtName" style="border:none  !important;width: 100%;height:38px;background-color:transparent;" disabled="disabled" />
                                                </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="border:none !important;vertical-align:bottom;padding:50px 0px 0px 0px">
 <input type="button"  value="Upload Image" class="btn btn-primary" onclick="fnShowFileDialog()" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                
                                              
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="p-0">
                                    <table class="table table-bordered m-0">
                                        <tr>
                                            <td class="p-1">
                                                <div style="font-weight:bold">
                                                    Level:
                                                </div>
                                                <div>
                                                    <input placeholder="Type here" type="text" id="txtLevel" style="width: 100%" />
                                                </div>
                                            </td>
                                            <td class="p-1">
                                                <div style="font-weight:bold">
                                                    Total Experience (in years):
                                                </div>
                                                <div>
                                                    <input placeholder="Type here" type="text" id="txtTotalExperience" style="width: 100%" onkeypress='return isNumericWithOneDecimal(event)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' autocomplete="off" />
                                                </div>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="p-1">
                                                <div style="font-weight:bold">
                                                    Function/ Industry:
                                                </div>
                                                <div>
                                                    <input placeholder="Type here" type="text" id="txtFunction" style="width: 100%" />
                                                </div>
                                            </td>
                                            <td class="p-1">
                                                <div style="font-weight:bold">
                                                    Experience at Bosch (in years):
                                                </div>
                                                <div>
                                                    <input placeholder="Type here" type="text" id="txtExperienceAtBosch" style="width: 100%" onkeypress='return isNumericWithOneDecimal(event)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' autocomplete="off" />
                                                </div>

                                            </td>
                                            <tr>
                                                <td class="p-1">
                                                    <div style="font-weight:bold">
                                                        Career Path:
                                                    </div>
                                                    <div>
                                                        <input placeholder="Type here" type="text" id="txtCareer" style="width: 100%" />
                                                    </div>
                                                </td>
                                                <td class="p-1">
                                                    <div style="font-weight:bold">
                                                        No. of Reporting Members, if any:
                                                    </div>
                                                    <div>
                                                        <input placeholder="Type here" type="text" id="txtReportingMembers" style="width: 100%" onkeypress='return isNumberKeyNotDecimal(event)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' autocomplete="off" />
                                                    </div>

                                                </td>
                                            </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td style="background-color: #c00000; color: #fff; font-size: 15pt; font-weight: bold; text-align: center" class="p-1">B. My Motivations and Aspirations
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 11pt;font-weight:bold" class="p-1">What are the key factors that motivate and energize you in your professional journey?
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 12pt; padding: 0px">
                        <textarea id="txtarea1" rows="2" style="width: 100%" placeholder="Type here"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 11pt;font-weight:bold" class="p-1">What are your top 3 key successes/ achievements in the last 5 years?
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 12pt; padding: 0px">
                        <textarea id="txtarea2" rows="2" style="width: 100%" placeholder="Type here"></textarea>
                    </td>
                </tr>

                <tr>
                    <td style="background-color: #c00000; color: #fff; font-size: 15pt; font-weight: bold; text-align: center" class="p-1">C. My Experiences
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 11pt;font-weight:bold" class="p-1">What are some of the key events and experiences in your career that have contributed to you, to become the professional that you are today?
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 12pt; padding: 0px">
                        <textarea id="txtarea3" rows="2" style="width: 100%" placeholder="Type here"></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 11pt;font-weight:bold" class="p-1">What have been your key learnings from such experiences? Please share behavioural and leadership learnings and not technical learnings?
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 12pt; padding: 0px">
                        <textarea id="txtarea4" rows="2" style="width: 100%" placeholder="Type here"></textarea>
                    </td>
                </tr>
            </tbody>

        </table>
    </div>
    <div class="text-center m-3" id="divbtns"><input type="button" value="Save" class="btns btn-submit" onclick="fnSaveCareerReflectionProfileData()" style="margin-bottom:5px" /><input type="button" value="Back" class="btns btn-submit" onclick="fnBackpage()" style="margin-bottom:5px" /></div>
    <div id="loader" class="loader_bg">
        <div class="loader"></div>
    </div>
    <div id="dvDialog" style="display: none"></div>
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnEmpNodeId" Value="0" runat="server" />
    <asp:HiddenField ID="hdnEmpName" Value="" runat="server" />
</asp:Content>

