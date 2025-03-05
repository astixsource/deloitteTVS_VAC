<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="false" CodeFile="frmManageEmployeeDetails.aspx.vb" Inherits="Admin_MasterForms_frmManageEmployeeDetails" validateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .pointer {
            cursor: pointer;
        }
    </style>
    <script type="text/javascript">
        $.fn.tblheaderfix = function (options) {
            var strid = $(this)[0].id, clss = $(this).find("table").attr('class');
            var defaults = {
                width: '100%',
                height: 350,
                padding: 1
            };
            var options = $.extend(defaults, options);
            $(this).css({ "width": options.width, "height": options.height, "padding": options.padding });

            $(this).find("table").attr('id', strid + '_tbl');
            var contant = $(this).html(), wid = $("#" + strid + "_tbl").width(), thead = $("#" + strid + "_tbl").find("thead").eq(0).html();
            $(this).html("<div id='" + strid + "_head'></div><div id='" + strid + "_body'></div>");
            $("#" + strid + "_head").html("<table id='" + strid + "_hfix' class='" + clss + " mb-0' style='width:" + wid + "px'><thead>" + thead + "</thead><tbody></tbody></table>");
            $("#" + strid + "_body").html(contant);
            $("#" + strid + "_tbl").css({ "width": wid, "min-width": wid });
            for (i = 0; i < $("#" + strid + "_tbl").find("th").length; i++) {
                var th_wid = $("#" + strid + "_tbl").find("th")[i].clientWidth; //offsetWidth;
                $("#" + strid + "_hfix, #" + strid + "_tbl").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
            }
            $("#" + strid + "_tbl").css("margin-top", "-" + ($("#" + strid + "_hfix")[0].offsetHeight) + "px");
            $("#" + strid + "_body").css({
                'height': $(this).height() - $("#" + strid + "_head").outerHeight(),
                'overflow-y': 'auto',
                'overflow-x': 'hidden'
            });
        }

        var string = /^[a-zA-Z]*$/;
        var stringFirstName = /^[a-zA-Z ]*$/;

        function fnUploadFile(ctrlId, flg, UserType) {
            var allowedExtensions = "";
            if (flg == 1) {
                allowedExtensions = /(\.pdf)$/i;
            }
            else if (flg == 2) {
                allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
            }
            else if (flg == 3) {
                if (UserType == "1") {
                    allowedExtensions = /(\.pdf)$/i;
                }
                else {
                    allowedExtensions = /(\.avi|\.mp4|\.mpeg)$/i;
                }
            }

            if (!allowedExtensions.exec($("#" + ctrlId).val())) {
                alert('Invalid file type');
                $("#" + ctrlId).val('');
                return false;
            }
            else {
                var fileUpload = $("#" + ctrlId).get(0);
                var files = fileUpload.files;
                var data = new FormData();
                data.append("Fileobj", files[0]);
                data.append("FileName", files[0].name);
                data.append("EmpCode", $("#ConatntMatter_txtEmpCode").val());
                data.append("UserType", UserType);
                data.append("flg", flg);

                $.ajax({
                    url: "../Handler/FileUploaderHandler.ashx",
                    type: "POST",
                    data: data,
                    contentType: false,
                    processData: false,
                    success: function (result) {
                        if (flg == 1) {
                            $('#ConatntMatter_hdnUploader1').val(result);

                            if ($("#Uploader2").val() != "") {
                                fnUploadFile("Uploader2", 2, UserType);
                            }
                            else if ($("#Uploader3").val() != "") {
                                fnUploadFile("Uploader3", 3, UserType);
                            }
                            else {
                                fnSave();
                            }
                        }
                        else if (flg == 2) {
                            $('#ConatntMatter_hdnUploader2').val(result);

                            if ($("#Uploader3").val() != "") {
                                fnUploadFile("Uploader3", 3, UserType);
                            }
                            else {
                                fnSave();
                            }
                        }
                        else {
                            $('#ConatntMatter_hdnUploader3').val(result);
                            fnSave();
                        }
                    },
                    error: function (err) {
                        alert("Error : " + err.statusText);
                    }
                });
            }
        }
        function fnSaveEmployeeDetails() {
            var Fname = document.getElementById("ConatntMatter_txtFName").value.trim();
            var EmailID = document.getElementById("ConatntMatter_txtEmailID").value.trim();
            var Empcode = document.getElementById("ConatntMatter_txtEmpCode").value.trim();
            var UserType = $('#ConatntMatter_ddlUserType').val();
            var Grade = $('#ConatntMatter_ddlGrade').val();

            if (UserType == 0) {
                alert("Please select the User type !")
                return false;
            }
            if (Fname == "") {
                alert("Please enter the name")
                return false;
            }
            if (Empcode == "") {
                alert("Please enter the User code !")
                return false;
            }
            if (EmailID == "") {
                alert("Please enter the Email-Id !")
                return false;
            }
            if (IsEmail(EmailID) == false) {
                alert("Please enter the correct Email-Id !")
                return false;
            }
            if (UserType == "1" && $('#ConatntMatter_ddlGrade').val() == "0") {
                alert("Please select the Grade !")
                return false;
            }
            if ($("#Uploader1").val() != "") {
                fnUploadFile("Uploader1", 1, UserType);
            }
            else if ($("#Uploader2").val() != "") {
                fnUploadFile("Uploader2", 2, UserType);
            }
            else if ($("#Uploader3").val() != "") {
                fnUploadFile("Uploader3", 3, UserType);
            }
            else {
                fnSave();
            }
        }
        function fnSave() {
            var Fname = document.getElementById("ConatntMatter_txtFName").value.trim();
            var EmailID = document.getElementById("ConatntMatter_txtEmailID").value.trim();
            var SecondaryEmailID = "";
            var Empcode = document.getElementById("ConatntMatter_txtEmpCode").value.trim();
            var UserType = $('#ConatntMatter_ddlUserType').val();
            var SetID = 0;
            var Grade = $('#ConatntMatter_ddlGrade').val();
            var BandType = $('#ConatntMatter_ddlBandType').val();
            //var Uploader1 = $('#ConatntMatter_hdnUploader1').val();
            //var Uploader2 = $('#ConatntMatter_hdnUploader2').val();
            //var Uploader3 = $('#ConatntMatter_hdnUploader3').val();
            var Uploader1 = "";
            var Uploader2 = "";
            var Uploader3 = "";

            Fname = Fname.replace("_", " ");
            var hdnEmpID = document.getElementById("ConatntMatter_hdnEmpID").value;
            PageMethods.fnManageEmployeeDetails(hdnEmpID, Fname, Empcode, EmailID, SecondaryEmailID, UserType, Grade, BandType, SetID, Uploader1, Uploader2, Uploader3, fnSaveSuccessEmpDetails, fnFailed);
        }

        function fnSaveSuccessEmpDetails(result) {
            if (result.split("@")[0] == "1") {
                if (result.split("@")[1] == "1") {
                    alert("This EmailID/User Code is already exists into the system")
                    return false;
                }
                else {
                    var UserFilter = $("#ConatntMatter_ddlUsers").val();
                    PageMethods.fnGetEmployeeDetails(UserFilter, '', 1, fnGetAllSuccessData, fnFailed, 1);
                }

            }
            else {
                alert("Error....")
            }
        }

        function fnGetAllSuccessData(result, returnVal) {
            $("#loader").hide();
            if (result.split("~")[0] == "1") {
                if (returnVal == 1) {
                    $("#dvDialog").dialog('close');
                    if (document.getElementById("ConatntMatter_hdnFlag").value == "1") {
                        alert("Updated Successfully")
                    }
                    else {
                        alert("Saved Successfully")
                    }
                }
                $("#ConatntMatter_dvMain_head").show();
                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("~")[1];
                var allsecheight = $(".navbar").outerHeight() + $('.section-title').outerHeight() + $('.d-flex').outerHeight();
                $("#ConatntMatter_dvMain").tblheaderfix({
                    height: $(window).height() - (allsecheight + 170)
                });
            }
            else if (result.split("~")[0] == "2") {
                $("#ConatntMatter_dvMain_head").hide();
                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("~")[1];
            }
            else {
                $("#ConatntMatter_dvMain_head").hide();
                $("#ConatntMatter_dvMain")[0].innerHTML = result.split("~")[1];
            }
        }
        function fnFailed(result) {
            alert("Error - " + result.split("^")[1])
        }

        function fnAddNewEmployee() {
            $("#dvDialog").dialog({
                title: "Add New User Details",
                resizable: false,
                height: "auto",
                width: "50%",
                modal: true
            });
            document.getElementById("ConatntMatter_txtFName").value = "";
            document.getElementById("ConatntMatter_txtEmpCode").value = "";
            document.getElementById("ConatntMatter_txtEmailID").value = "";
            $("#ConatntMatter_ddlUserType").val(0);
            $("#ConatntMatter_ddlUserType").prop("disabled", false);
            document.getElementById("ConatntMatter_hdnEmpID").value = 0;
            document.getElementById("ConatntMatter_hdnFlag").value = 0;

            $("#Uploader1").val('');
            $("#Uploader2").val('');
            $("#Uploader3").val('');
            $("#ConatntMatter_hdnUploader1").val('');
            $("#ConatntMatter_hdnUploader2").val('');
            $("#ConatntMatter_hdnUploader3").val('');
            $("#Uploader1").show();
            $("#Uploader2").show();
            $("#Uploader3").show();
            $("#divUploadedCV").hide();
            $("#divUploadedOrg").hide();
            $("#divUploadedPhotoVideo").hide();

            $("#divUpload").hide();
            $("#divUploadOrg").hide();
        }
        function fndelete_row(EmpNodeID) {
            if (confirm('Are you sure, you want to delete this User ?')) {
                PageMethods.fnCheckMappedUsersAgCycle(EmpNodeID, fnChkSuccessMapped, fnFailed, EmpNodeID);
            }
        }
        function fnChkSuccessMapped(result, EmpNodeID) {
            if (result.split("@")[0] == "1") {
                var chkFlag = result.split("@")[1]
                if (chkFlag == "1") {
                    alert("You can not delete this user because this user is already started his/her Assessment.")
                    return false;
                }
                else if (chkFlag == "2") {
                    alert("You can not delete this user because this user is already mapped to a batch. In any case, if you want to remove this , kindly remove the mapping first from Batch mapping with user.")
                    return false;
                }
                else {
                    PageMethods.fnDeleteUser(EmpNodeID, fnDeleteSuccess, fnFailed);
                }
            }
            else {
                alert("Error....")
            }
        }
        function fnDeleteSuccess(result) {
            if (result.split("@")[0] == "1") {
                alert("Delete Successfully")
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                $("#ConatntMatter_txtSearch").val("");
                var UserFilter = $("#ConatntMatter_ddlUsers").val();
                $("#loader").show()
                PageMethods.fnGetEmployeeDetails(UserFilter, '', 1, fnGetAllSuccessData, fnFailed, 0);
            }
        }
    </script>
    <script type="text/javascript">
        function fnEditEmployeeDetails(EmpNodeId, FName, EmailID, EmpCode, UserType,Grade,Band, Uploader1, Uploader2, Uploader3) {
            document.getElementById("ConatntMatter_hdnFlag").value = 1;
            document.getElementById("ConatntMatter_hdnEmpID").value = EmpNodeId;
            document.getElementById("ConatntMatter_txtFName").value = replaceAll(FName, "-", " ");
            document.getElementById("ConatntMatter_txtEmailID").value = EmailID;
            document.getElementById("ConatntMatter_txtEmpCode").value = EmpCode;
            $("#ConatntMatter_ddlUserType").val(UserType);
            $("#ConatntMatter_ddlUserType").prop("disabled", true);
            fnType();
            if (UserType == "1") {
                
                $("#ConatntMatter_ddlGrade").val(Grade);
            }
    
            $("#ConatntMatter_ddlBandType").val(Band);
            $("#ConatntMatter_hdnUploader1").val(Uploader1);
            $("#ConatntMatter_hdnUploader2").val(Uploader2);
            $("#ConatntMatter_hdnUploader3").val(Uploader3);
            if (Uploader1 != "") {
                $("#Uploader1").hide();
                $("#divUploadedCV").show();
                $("#divUploadedCV").html("<span class='text-success ml-3 fa fa-file-text pointer' file='" + Uploader1 + "' onclick='fnShowPDF(this, 1);' style='padding-right: 6px; font-size: 20px;'></span><a href='#' onclick='fnRemoveUpload(1);' style='color:#ff0000;'> Change/Remove</a>");
            }

            if (Uploader2 != "") {
                $("#Uploader2").hide();
                $("#divUploadedPhotoVideo").show();
                $("#divUploadedPhotoVideo").html("<span class='text-success ml-3 fa fa-camera pointer' file='" + Uploader2 + "' onclick='fnShowImg(this);' style='padding-right: 6px; font-size: 20px;'></span><a href='#' onclick='fnRemoveUpload(2);' style='color:#ff0000;'> Change/Remove</a>");
            }

            if (Uploader3 != "") {
                $("#Uploader3").hide();
                $("#divUploadedOrg").show();
                if (UserType == "1") {
                    $("#divUploadedOrg").html("<span class='text-success ml-3 fa fa-file-text pointer' file='" + Uploader3 + "' onclick='fnShowPDF(this, 3);' style='padding-right: 6px; font-size: 20px;'></span><a href='#' onclick='fnRemoveUpload(3);' style='color:#ff0000;'> Change/Remove</a>");
                }
                else {
                    $("#divUploadedOrg").html("<span class='text-success ml-3 fa fa-video-camera pointer' file='" + Uploader3 + "' onclick='fnShowVideo(this);' style='padding-right: 6px; font-size: 20px;'></span><a href='#' onclick='fnRemoveUpload(2);' style='color:#ff0000;'> Change/Remove</a>");
                }
            }

            $("#dvDialog").dialog({
                title: "Modify User Details",
                resizable: false,
                height: "auto",
                width: "50%",
                modal: true
            });
        }
        function replaceAll(str, find, replace) {
            while (str.indexOf(find) > -1) {
                str = str.replace(find, replace);
            }
            return str;
        }
        function IsEmail(email) {
            var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (!regex.test(email)) {
                return false;
            } else {
                return true;
            }
        }
    </script>
    <script>
        function fnShowPDF(ctrl, cntr) {
            var filename = $(ctrl).attr("file");
            document.getElementById("iFramePdf").src = "../../Files/" + filename;
            $("#dvPdfDialog")[0].style.display = "block";
            $("#dvPdfDialog").dialog({
                title: "CV :",
                resizable: false,
                height: $(window).height() - 150,
                width: "90%",
                modal: true,
                open: function () {
                    $("body").css("overflow", "hidden");
                    $("#iFramePdf").height(($(window).height() - 250) + "px");
                },
                close: function () {
                    document.getElementById("iFramePdf").src = "";
                }
            });

            if (cntr == 1) {
                $("#dvPdfDialog").dialog("option", "title", "CV :");
            }
            else {
                $("#dvPdfDialog").dialog("option", "title", "Org Structure :");
            }
        }
        function fnShowImg(ctrl) {
            $("#dvImgDialog").dialog({
                title: "Photo :",
                resizable: false,
                height: "400",
                width: "400",
                modal: true
            });
            var filename = $(ctrl).attr("file");
            $("#dvImgDialog").html("<div style='padding:20px;'><img src='../../Files/" + filename + "' style='width:300px; height: 300px;'/></div>");
        }
        function fnShowVideo(filename) {
            var filename = $(ctrl).attr("file");
            document.getElementById("iFrameVideo").src = "../../Files/" + filename;
            $("#dvVideoDialog")[0].style.display = "block";
            $("#dvVideoDialog").dialog({
                title: "Video :",
                resizable: false,
                height: $(window).height() - 150,
                width: "90%",
                modal: true,
                open: function () {
                    $("body").css("overflow", "hidden");
                    $("#iFrameVideo").height(($(window).height() - 250) + "px");
                },
                close: function () {
                    document.getElementById("iFrameVideo").src = "";
                }
            });
        }
    </script>
    <script>      
        $(document).ready(function () {
            var allsecheight = $(".navbar").outerHeight() + $('.section-title').outerHeight() + $('.d-flex').outerHeight();
            $("#ConatntMatter_dvMain").tblheaderfix({
                height: $(window).height() - (allsecheight + 170)
            });

            $("#ConatntMatter_ddlUsers").on("change", function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                $("#ConatntMatter_txtSearch").val("");
                var UserFilter = $("#ConatntMatter_ddlUsers").val();
                $("#loader").show()
                PageMethods.fnGetEmployeeDetails(UserFilter, '', 1, fnGetAllSuccessData, fnFailed, 0);

            });
            $("#ConatntMatter_btnSearch").click(function () {
                $("#ConatntMatter_dvMain")[0].innerHTML = "";
                $("#ConatntMatter_ddlUsers").find('option[value="0"]').attr('selected', 'selected')

                var UserFilter = $("#ConatntMatter_txtSearch").val();
                $("#loader").show();
                PageMethods.fnGetEmployeeDetails(0, UserFilter, 2, fnGetAllSuccessData, fnFailed, 0);
            });

            $(".calender").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true,
				yearRange: "c-100:c+20",
                maxDate: new Date(),
                showOn: "button",
                buttonImage: "../../Images/Icons/calendar-icon.jpg",
                buttonImageOnly: true,
                buttonText: "Select date",
                onSelect: function (d, el) {
                    //
                }
            });

            $('img.ui-datepicker-trigger').css({ 'cursor': 'pointer', 'height': '25px', 'width': '25px', 'position': 'absolute', 'bottom': '7px', 'right': '10px' });

            var MasterArr = $("#ConatntMatter_hdnMaster").val().split("|");
            $("#ddlGender").html(MasterArr[0]);
            $("#ddlJobFunction").html(MasterArr[1]);
            $("#ddlOfficeSite").html(MasterArr[2]);
            $("#ddlICDescription").html(MasterArr[3]);
            $("#ddlOverallExperience").html(MasterArr[4]);
            $("#ddlEducation").html(MasterArr[5]);
            $("#ddlPerformance").html(MasterArr[6]);

            PageMethods.fnGetEmployeeDetails(1, '', 1, fnGetAllSuccessData, fnFailed, 0);
        });

        function fnType() {
            $("#ConatntMatter_ddlGrade").val('0');
            $("#Uploader1").val('');
            $("#Uploader2").val('');
            $("#Uploader3").val('');
            $("#ConatntMatter_hdnUploader1").val('');
            $("#ConatntMatter_hdnUploader2").val('');
            $("#ConatntMatter_hdnUploader3").val('');
            $("#Uploader1").show();
            $("#Uploader2").show();
            $("#Uploader3").show();
            $("#divUploadedCV").hide();
            $("#divUploadedOrg").hide();
            $("#divUploadedPhotoVideo").hide();

            $("#divUpload").css("display", "none");
            $("#divUploadOrg").css("display", "none");
            var ddlUserType = $("#ConatntMatter_ddlUserType").val();

            switch (ddlUserType) {
                case "0":               // No Select
                    break;
                case "1":               // Participant
                    //$("#lblUpload").html("Upload Org. Structure (only .pdf format allowed)");
                    //$("#divUpload").css("display", "flex");
                    //$("#divUploadOrg").css("display", "flex");
                    break;
                case "2":               // Developer
                    //$("#lblUpload").html("Upload Video");
                    //$("#divUpload").css("display", "flex");
                    //$("#divUploadOrg").css("display", "flex");
                    break;
                case "3":               // EY Admin
                    break;
                case "4":               // EY Super Admin
                    break;
            }
        }
        function fnRemoveUpload(cntr) {
            if (cntr == 1) {
                $("#Uploader1").show();
                $("#divUploadedCV").hide();
                $("#ConatntMatter_hdnUploader1").val('');
            }
            else if (cntr == 2) {
                $("#Uploader2").show();
                $("#divUploadedPhotoVideo").hide();
                $("#ConatntMatter_hdnUploader2").val('');
            }
            else {
                $("#Uploader3").show();
                $("#divUploadedOrg").hide();
                $("#ConatntMatter_hdnUploader3").val('');
            }
        }
    </script>
    <script>
        function fnEditDemographicDetails(EmpNodeID) {
            $("#ConatntMatter_hdnEmpID").val(EmpNodeID);
            PageMethods.fnEditDemographicDetails(EmpNodeID, fnEditDemographicDetails_Pass, fnFailed);
        }

        function fnEditDemographicDetails_Pass(result) {
            if (result.split("^")[0] == "1") {
                var res = result.split("^")[1].split("|");
                $("#txtdob").val(res[0]);
                $("#ddlGender").val(res[1]);
                $("#txtJobTitle").val(res[2]);
                $("#ddlJobFunction").val(res[3]);
                $("#ddlOfficeSite").val(res[4]);
                $("#ddlICDescription").val(res[5]);
                $("#txtBUDescription").val(res[6]);
                $("#txtDOJ").val(res[7]);
                $("#ddlOverallExperience").val(res[8]);
                $("#ddlEducation").val(res[9]);
                $("#ddlPerformance").val(res[10]);
                $("#txtExpInRole").val(res[11]);
                $("#txtLocation").val(res[12]);

                $("#dvDemographicDialog").dialog({
                    title: "Demographic Details :",
                    resizable: false,
                    height: "auto",
                    width: "50%",
                    modal: true
                });
            }
            else {
                alert("Error - " + result.split("^")[1])
            }
        }
        function fnSaveDemographicDetails() {
            var EmpId = $("#ConatntMatter_hdnEmpID").val();
            var dob = $("#txtdob").val();
            var gender = $("#ddlGender").val();
            var jobtitle = $("#txtJobTitle").val();
            var jobfunction = $("#ddlJobFunction").val();
            var officeSite = $("#ddlOfficeSite").val();
            var IC = $("#ddlICDescription").val();
            var BU = $("#txtBUDescription").val();
            var doj = $("#txtDOJ").val();
            var overallExp = $("#ddlOverallExperience").val();
            var edu = $("#ddlEducation").val();
            var Perform = $("#ddlPerformance").val();
            var ExpInRole = $("#txtExpInRole").val();
            var loc = $("#txtLocation").val();

            if (dob == "") {
                alert("Please select the Date of Birth !");
            }
            else if (gender == "0") {
                alert("Please select the Gender !");
            }
            else if (jobtitle == "") {
                alert("Please enter the Job Title !");
            }
            else if (jobfunction == "0") {
                alert("Please select the Job Function !");
            }
            else if (officeSite == "0") {
                alert("Please select between Office & Site !");
            }
            else if (IC == "0") {
                alert("Please select the IC Description !");
            }
            else if (BU == "") {
                alert("Please enter the BU Description !");
            }
            else if (doj == "") {
                alert("Please select the L&T Date of joining  !");
            }
            else if (overallExp == "0") {
                alert("Please select the Overall Experience (in Years) !");
            }
            else if (edu == "0") {
                alert("Please select the Overall Education details !");
            }
            else if (Perform == "0") {
                alert("Please select the Performance category !");
            }
            else if (ExpInRole == "") {
                alert("Please enter the Experience in Current Role (in months)  !");
            }
            else if (loc == "") {
                alert("Please enter the Location !");
            }
            else {
                PageMethods.fnSaveDemographicDetails(EmpId, dob, gender, jobtitle, jobfunction, officeSite, IC, BU, doj, overallExp, edu, Perform, ExpInRole, loc, fnSaveDemographicDetails_Pass, fnFailed);
            }
        }

        function fnSaveDemographicDetails_Pass(result) {
            if (result.split("^")[0] == "1") {
                alert("Saved successfully ! ")
                $("#dvDemographicDialog").dialog('close');
            }
            else {
                alert("Error - " + result.split("^")[1]);
            }
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
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
    </script>
    <style>
        .fixed-top {
            z-index: 99;
        }

        #ConatntMatter_dvMain_tbl tr td.cls-1,
        #ConatntMatter_dvMain_tbl tr td.cls-2,
        #ConatntMatter_dvMain_tbl tr td.cls-6 {
            text-align: left;
            padding-left: 5px;
        }

        #ConatntMatter_dvMain_tbl tr td.cls-1 {
            width: 220px;
        }

        #ConatntMatter_dvMain_tbl tr td.cls-3 {
            width: 100px;
        }
        #ConatntMatter_dvMain_tbl tr td.cls-5 {
            width: 140px;
        }
        #ConatntMatter_dvMain_tbl tr td.cls-6 {
            width: 280px;
        }
        #dvDemographicDialog div.form-group {
            margin-bottom: 0.7rem;
        }

        #dvDemographicDialog label {
            margin-bottom: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">User Information</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="form-inline mb-3 d-flex">
        <label for="ac" class="col-form-label mr-3">Select Filter</label>
        <div class="input-group">
            <asp:DropDownList ID="ddlUsers" runat="server" CssClass="form-control">
                <%--<asp:ListItem Value="0">.......</asp:ListItem>--%>
                <asp:ListItem Value="1" Selected="true">Participant Not Mapped with any batch</asp:ListItem>
                <asp:ListItem Value="2">Show Participant</asp:ListItem>
                <asp:ListItem Value="3">Show Developer</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="input-group ml-auto">
            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search" CssClass="form-control"></asp:TextBox>
            <div class="input-group-append">
                <input type="button" id="btnSearch" runat="server" value="Show" class="btn btn-primary" />
            </div>
        </div>
    </div>

    <div id="dvMain" runat="server"></div>
    <div class="text-center mt-2">
        <input type="button" id="AddNewEmployee" value="Add New User" onclick="fnAddNewEmployee()" class="btns btn-cancel" />
    </div>

    <div id="dvDialog" style="display: none">
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="EmpCode">User Type</label>
                <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-control" onChange="fnType();">
                    <asp:ListItem Value="0" Selected="True">- Select -</asp:ListItem>
                    <asp:ListItem Value="1">Participant</asp:ListItem>
                    <asp:ListItem Value="2">Developer</asp:ListItem>
                </asp:DropDownList>
            </div>
               <div class="form-group col-md-6" id="BandType">
                <label>Band Type</label>
                <asp:DropDownList ID="ddlBandType" runat="server" CssClass="form-control">
                </asp:DropDownList>
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="FName">Full Name</label>
                <asp:TextBox ID="txtFName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group col-md-6">
                <label for="EmpCode">User Code</label>
                <asp:TextBox ID="txtEmpCode" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group col-md-6">
                <label for="EmailID">EmailID</label>
                <asp:TextBox ID="txtEmailID" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
             <div class="form-group col-md-6" id="GradeBlock">
                <label>Grade Type</label>
                <asp:DropDownList ID="ddlGrade" runat="server" CssClass="form-control">
                </asp:DropDownList>
            </div>
          
        </div>
        <div class="form-row" id="divUpload" style="display: none;">
            <div class="form-group col-md-6">
                <label>Upload CV (only .pdf format allowed)</label>
                <div id="divUploadedCV"></div>
                <input type="file" id="Uploader1" class="form-control" />
            </div>
            <div class="form-group col-md-6">
                <label>Upload Photo</label>
                <div id="divUploadedPhotoVideo"></div>
                <input type="file" id="Uploader2" class="form-control" />
            </div>
        </div>
        <div class="form-row" id="divUploadOrg" style="display: none;">
            <div class="form-group col-md-6">
                <label id="lblUpload">Upload Org. Structure (only .pdf format allowed)</label>
                <div id="divUploadedOrg"></div>
                <input type="file" id="Uploader3" class="form-control" />
            </div>
            <div class="form-group col-md-6">
            </div>
        </div>
        <div class="text-center mb-2">
            <input type="button" value="Save" onclick="fnSaveEmployeeDetails()" class="btns btn-cancel" />
        </div>
    </div>
    <div id="dvDemographicDialog" style="display: none">
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>Date Of Birth</label>
                <input type="text" id="txtdob" class="form-control calender" readonly="true" />
            </div>
            <div class="form-group col-md-3"></div>
            <div class="form-group col-md-3">
                <label>Gender</label>
                <select id="ddlGender" class="form-control"></select>
            </div>
            <div class="form-group col-md-12">
                <label>Job Title</label>
                <input type="text" id="txtJobTitle" class="form-control" />
            </div>
            <div class="form-group col-md-9">
                <label>Job Function Description</label>
                <select id="ddlJobFunction" class="form-control"></select>
            </div>
            <div class="form-group col-md-3">
                <label>Office or Site</label>
                <select id="ddlOfficeSite" class="form-control"></select>
            </div>
            <div class="form-group col-md-6">
                <label>IC Description</label>
                <select id="ddlICDescription" class="form-control"></select>
            </div>
            <div class="form-group col-md-6">
                <label>BU Description</label>
                <input type="text" id="txtBUDescription" class="form-control" />
            </div>
            <div class="form-group col-md-6">
                <label>L&T Date of joining</label>
                <input type="text" id="txtDOJ" class="form-control calender" readonly="true" />
            </div>
            <div class="form-group col-md-6">
                <label>Overall Experience (in Years)</label>
                <select id="ddlOverallExperience" class="form-control"></select>
            </div>
            <div class="form-group col-md-6">
                <label>Education details</label>
                <select id="ddlEducation" class="form-control"></select>
            </div>
            <div class="form-group col-md-6">
                <label>Performance category</label>
                <select id="ddlPerformance" class="form-control"></select>
            </div>
            <div class="form-group col-md-6">
                <label>Experience in current role (in months)</label>
                <input type="text" id="txtExpInRole" class="form-control" maxlength="3" onkeypress='return isNumberKeyNotDecimal(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' />
            </div>
            <div class="form-group col-md-6">
                <label>Location</label>
                <input type="text" id="txtLocation" class="form-control" />
            </div>
        </div>
        <div class="text-center mb-2">
            <input type="button" value="Save" onclick="fnSaveDemographicDetails()" class="btns btn-cancel" />
        </div>
    </div>
    <div id="dvPdfDialog" style="display: none">
        <iframe src="" id="iFramePdf" style="vertical-align: middle; background-color: White; width: 100%; border: 0;"></iframe>
    </div>
    <div id="dvImgDialog" style="display: none"></div>
    <div id="dvVideoDialog" style="display: none">
        <iframe src="" id="iFrameVideo" style="vertical-align: middle; background-color: White; width: 100%; border: 0;"></iframe>
    </div>

    <asp:HiddenField ID="hdnEmpID" runat="server" Value=" 0" />
    <asp:HiddenField ID="hdnFlag" runat="server" Value=" 0" />
    <asp:HiddenField ID="hdnMaster" runat="server" Value="" />
    <asp:HiddenField ID="hdnUploader1" runat="server" Value="" />
    <asp:HiddenField ID="hdnUploader2" runat="server" Value="" />
    <asp:HiddenField ID="hdnUploader3" runat="server" Value="" />
</asp:Content>

