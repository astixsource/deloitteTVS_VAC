<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmPhotoReports.aspx.cs" Inherits="frmDataAndReports" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <%-- <link href="../../CSS/jquery-te-1.4.0.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-te-1.4.0.min.js" type="text/javascript"></script>--%>
    <style type="text/css">
        div.clsloader {
            position: fixed;
            width: 100%;
            top: 0;
            left: 0;
            height: 100%;
            z-index: 200;
            background-color: white;
            opacity: 0.5;
        }

        body {
            overflow-x: hidden !important;
        }

        .jqte_editor, .jqte_source {
            padding: 10px;
            background: #FFF;
            min-height: 260px;
            max-height: 900px;
            overflow: auto;
            outline: none;
            word-wrap: break-word;
            -ms-word-wrap: break-word;
            resize: vertical;
        }

        .jqte {
            margin: 0px !important;
        }

        .ui-dialog {
            z-index: 1200 !important;
        }

        fieldset {
            background-color: #eeeeee;
        }

            fieldset > div {
                padding-top: 4px;
                padding-left: 0.75em;
                padding-right: 0.75em;
            }

        legend {
            background-color: gray;
            color: white;
            padding: 5px 10px;
            font-size: 11pt;
        }

        input[type=file] {
            margin: 5px;
        }

        table.table {
            border-collapse: collapse;
            font-size: .75rem;
        }

        td.clslegendlbl {
            padding-right: 10px;
            font-size: 10px;
            font-weight: bold;
        }

        #tblCalendar img {
            width: auto;
        }

        #tblNormalImg td, #tblNormalImg1 td {
            padding: 2px !important;
        }

        #tblNormalImg, #tblNormalImg1 {
            width: auto !important;
        }

        .ui-dialog .ui-dialog-content {
            position: relative;
            border: 0;
            padding: 0.0em 0.15em;
            background: none;
            overflow: auto;
        }
        #divfilterheader{
            margin-bottom: 5px;
    text-align: center;
    font-size: 10pt;
    background-color: #fff;
    position: fixed;
    width: 94%;
    padding: 5px;
        }
         #divfilterheader > label{
    font-size: 10pt;
        }
    </style>
   
    <style>
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height:24px;
  margin-bottom:0px !important;
  padding:0px !important
}

.switch input { 
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 19px;
    width: 19px;
    left: 4px;
    bottom: 3px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}
</style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#loader").hide();
            //$("#ddlAssessor").html($("#ConatntMatter_hdnAssessorMstr").val());

            var d = new Date();
            fnGetStatus();

        });

        function fnSaveValidate(sender) {
            var EmpIdd = $(sender).closest("tr").attr("empid");
            var AssessmentDate = $(sender).closest("tr").attr("AssessmentDate");
            var loginId = $("#ConatntMatter_hdnLogin").val();
            var flgValidate = $(sender).is(":checked") ? 1 : 0;
            $("#loader").show();
            PageMethods.fnSave($(sender).closest("tr").attr("empid"), AssessmentDate, loginId, flgValidate, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == 1) {
                    alert("Error:" + result.split("|")[1]);
                }
            }, function (result) {
                    $("#loader").hide();
                    alert("Error:" + result._message);
            });
        }
        var EmpId = 0;
        function fnSHowImg(sender) {
            EmpId = $(sender).closest("tr").attr("empid");
            var arrList = jQuery.grep(arrImgData[0], function (element, index) {
                return (element.EmpID == EmpId && element.flgselfie == 1);
            });

            var arrList_s = jQuery.grep(arrImgData[0], function (element, index) {
                return (element.EmpID == EmpId && element.flgselfie == 2);
            });
            var strHTML = "";
            var cnt = 0;
            for (var i in arrList) {
                if (cnt == 0) {
                    strHTML += "<tr>";
                }
                strHTML += "<td style='width:180px;height:180px'><div style='display:inline-block'><img style='width:180px;height:180px' src='../../snapshot/" + arrList[i]["Picname"] + "'></div>";
                strHTML += "<div style='width:180px;display:inline-block'><b>Time : </b>" + arrList[i]["PictureTime"] + "</div>";
                strHTML += "<div style='width:180px;display:inline-block'><span style='color:" + (arrList[i]["flgViolated"] == 1 ? "#ff0000" : (arrList[i]["flgViolated"] == 2 ? "#8080c0" : "#70ad47")) + "'>" + arrList[i]["ViolationRule"] + "</span></div>";
                strHTML += "</td>";
                cnt++;
                if (cnt == 7) {
                    cnt = 0;
                    strHTML += "</tr>";
                }

            }
            if (cnt < 7) {
                var str = "";
                if (cnt == 1) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                } else if (cnt == 2) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 3) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 4) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 5) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 6) {
                    strHTML += "<td style='width:180px;height:180px'></td></tr>";
                }
            }




            //--------------Instances
            var arrList_Intances = jQuery.grep(arrImgData[0], function (element, index) {
                return (element.EmpID == EmpId && element.flgselfie == 1 && element.instancenumber > 0);
            });
            var strHTML_Instances = "";
            var OldInstances = "";
            var cnt = 0;
            var cntIntances = 1;
            for (var i in arrList_Intances) {
                if (OldInstances != arrList_Intances[i]["instancenumber"]) {
                    
                    if (cnt < 7) {
                        var str = "";
                        if (cnt == 1) {
                            strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                        } else if (cnt == 2) {
                            strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                        }
                        else if (cnt == 3) {
                            strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                        }
                        else if (cnt == 4) {
                            strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                        }
                        else if (cnt == 5) {
                            strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                        }
                        else if (cnt == 6) {
                            strHTML_Instances += "<td style='width:180px;height:180px'></td></tr>";
                        }
                    }
                    strHTML_Instances += "<tr><td colspan='2'><h4>Instance" + arrList_Intances[i]["instancenumber"] + "</h4></td><td colspan='5'><h4>Time:" + arrList_Intances[i]["InstanceDescr"] + "</h4></td></tr>";
                    cnt = 0;
                }
                OldInstances = arrList_Intances[i]["instancenumber"];
                if (cnt == 0) {
                    strHTML_Instances += "<tr>";
                }
                strHTML_Instances += "<td style='width:180px;height:180px'><div style='display:inline-block'><img style='width:180px;height:180px' src='../../snapshot/" + arrList_Intances[i]["Picname"] + "'></div>";
                strHTML_Instances += "<div style='width:180px;display:inline-block'><b>Time : </b>" + arrList_Intances[i]["PictureTime"] + "</div>";
                strHTML_Instances += "<div style='width:180px;display:inline-block'><span style='color:" + (arrList_Intances[i]["flgViolated"] == 1 ? "#ff0000" : (arrList_Intances[i]["flgViolated"] == 2 ? "#8080c0" : "#70ad47")) + "'>" + arrList_Intances[i]["ViolationRule"] + "</span></div>";
                strHTML_Instances += "</td>";
                cnt++;
                if (cnt == 7) {
                    cnt = 0;
                    strHTML_Instances += "</tr>";
                }

            }
            if (cnt < 7) {
                var str = "";
                if (cnt == 1) {
                    strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                } else if (cnt == 2) {
                    strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 3) {
                    strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 4) {
                    strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 5) {
                    strHTML_Instances += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 6) {
                    strHTML_Instances += "<td style='width:180px;height:180px'></td></tr>";
                }
            }


            //------------------selfie
            var strHTML_s = "";
            var cnt = 0;
            for (var i in arrList_s) {
                if (cnt == 0) {
                    strHTML_s += "<tr>";
                }
                strHTML_s += "<td style='width:180px;height:180px'><div><img style='width:180px;height:180px' src='../../Snapshot/" + arrList_s[i]["Picname"] + "'></div>";
                strHTML_s += "<div style='width:180px;'><b>Time : </b>" + arrList_s[i]["PictureTime"] + "</div>";
                strHTML_s += "<div style='width:180px;'><span style='color:" + (arrList_s[i]["flgViolated"] == 1 ? "#ff0000" : (arrList_s[i]["flgViolated"] == 2 ? "#8080c0" : "#70ad47")) + "'>" + arrList_s[i]["ViolationRule"] + "</span></div>";
                strHTML_s += "</td>";
                cnt++;
                if (cnt == 3) {
                    cnt = 0;
                    strHTML_s += "</tr>";
                }

            }
            if (cnt < 3) {
                var str = "";
                if (cnt == 1) {
                    strHTML_s += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                } else if (cnt == 2) {
                    strHTML_s += "<td style='width:180px;height:180px'></td></tr>";
                }

                else if (cnt == 4) {
                    strHTML_s += "<td style='width:180px;height:180px'></td></tr>";
                }
            }


            var ss = "<h4>Selfie Photo</h4>"
            if (strHTML_s != "") {
                ss += "<table class='table table-bordered d-inline-block'>" + strHTML_s + "</table>";
            } else {
                ss += "No Record Found!";
            }

            ss += "<br/>"
            ss += "<h4>Assessment Photo</h4>";
            if (strHTML != "") {
                ss += "<table class='table table-bordered' id='tblNormalImg'>" + strHTML + "</table>";
            } else {
                ss += "No Record Found!";
            }

            ss += "<br/>"
            ss += "<h4>No Of Instance Focus Not On Screen</h4>";
            if (strHTML_Instances != "") {
                ss += "<table class='table table-bordered' id='tblNormalImg1'>" + strHTML_Instances + "</table>";
            } else {
                ss += "No Record Found!";
            }
            var strFileter ="<div id='divfilterheader'><label style='margin-right:10px'><input type='radio' onclick='fnFilterData(1)' name='rdoproc'/> All</label><label style='margin-right:10px'><input type='radio' onclick='fnFilterData(2)'  name='rdoproc' /> Validated</label><label><input type='radio' onclick='fnFilterData(3)'  name='rdoproc' /> Not Validated</label> </div>"
            $("#divDialog")[0].innerHTML = strFileter +"<div style='width:100%;padding-top:43px'>"+ ss+"</div>";
            $("#divDialog").dialog({
                title: 'Photo Details :',
                resizable: false,
                height: window.innerHeight - 10,
                width: "100%",
                modal: true,
            })
        }

        function fnFilterData(flg) {
            $("#loader").show();
            var arrList = [];
            if (flg == 2) {// Validated
                arrList = jQuery.grep(arrImgData[0], function (element, index) {
                    return (element.EmpID == EmpId && element.flgselfie == 1 && element.flgViolated==0);
                });
            } else if (flg == 3) {//Not Validated
                arrList = jQuery.grep(arrImgData[0], function (element, index) {
                    return (element.EmpID == EmpId && element.flgselfie == 1 && element.flgViolated>0);
                });
            } else {
                arrList = jQuery.grep(arrImgData[0], function (element, index) {
                    return (element.EmpID == EmpId && element.flgselfie == 1);
                });
            }
            var strHTML = "";
            var cnt = 0;
            for (var i in arrList) {
                if (cnt == 0) {
                    strHTML += "<tr>";
                }
                strHTML += "<td style='width:180px;height:180px'><div style='display:inline-block'><img style='width:180px;height:180px' src='../../snapshot/" + arrList[i]["Picname"] + "'></div>";
                strHTML += "<div style='width:180px;display:inline-block'><b>Time : </b>" + arrList[i]["PictureTime"] + "</div>";
                strHTML += "<div style='width:180px;display:inline-block'><span style='color:" + (arrList[i]["flgViolated"] == 1 ? "#ff0000" : (arrList[i]["flgViolated"] == 2 ? "#8080c0" : "#70ad47")) + "'>" + arrList[i]["ViolationRule"] + "</span></div>";
                strHTML += "</td>";
                cnt++;
                if (cnt == 7) {
                    cnt = 0;
                    strHTML += "</tr>";
                }

            }
            if (cnt < 7) {
                var str = "";
                if (cnt == 1) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                } else if (cnt == 2) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 3) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 4) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 5) {
                    strHTML += "<td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td><td style='width:180px;height:180px'></td></tr>";
                }
                else if (cnt == 6) {
                    strHTML += "<td style='width:180px;height:180px'></td></tr>";
                }
            }

            if (strHTML != "") {
                $("#tblNormalImg").html(strHTML);
            } else {
                $("#tblNormalImg").html("No Record Found!");
            }
            $("#loader").hide();
        }
        var arrImgData = [];
        function fnGetStatus() {
            $("#loader").show();
            var LoginId = $("#ConatntMatter_hdnLogin").val();
            var BandId = $("#ConatntMatter_ddlCycle").val();
            PageMethods.frmGetStatus(LoginId, BandId,0, function (result) {
                $("#loader").hide();
                $("#ConatntMatter_divStatus")[0].innerHTML = result.split("|")[0];
                if (result.split("|")[0] != "No Record Found !" && result.split("|")[0] != "") {
                    arrImgData = $.parseJSON('[' + result.split("|")[1] + ']');
                }
                $("#tblbody").scrollLeft(0);



                $("#ConatntMatter_divStatus").prepend("<div id='tblheader'></div>"), $("#tbl_Status").wrap("<div id='tblbody'></div>");
                if ($("#tbl_Status").length > 0) {
                    // $("#divBtnscontainer").show();
                    var wid = $("#tbl_Status").width(), thead = $("#tbl_Status").find("thead").eq(0).html();
                    $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                    $("#tbl_Status").css({ "width": wid, "min-width": wid });

                    for (i = 0; i < $("#tbl_Status").find("th").length; i++) {
                        var th_wid = $("#tbl_Status").find("th")[i].offsetWidth;
                        $("#tblEmp_header").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                    }
                    $("#tbl_Status").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");
                    $("#tblheader").css("width", $("#tblbody")[0].clientWidth);

                    $("#tblbody").scroll(function () {
                        $("#tblheader").scrollLeft(this.scrollLeft);
                    });
                    $('#tblbody').css({
                        'height': $(window).height() - ($(".navbar").outerHeight() + 220),
                        "margin-bottom": "20px",
                        'overflow-y': 'auto',
                        'overflow-x': 'hidden'
                    });
                }


            }, fnFail);
        }

        function fnChangeBand() {
            fnGetStatus();
        }

        function fnFail(err) {
            $("#loader").hide();
            alert("Due to some technical error, we are unable to complete your request !");
        }

        function fnAssignAssessorSuccess(res, td_id) {
            $("#loader").hide();
            if (res.split("^")[0] == "1") {
                alert("Due to some technical error, we are unable to process your request !");
            }
            else {
                var style = "";
                switch (res.split("^")[1]) {
                    case "1":
                        style = "color: #ffffff; background-color: #ff0000;";
                        break;
                    case "2":
                        style = "color: #000000; background-color: #ff9b9b;";
                        break;
                    case "3":
                        style = "color: #000000; background-color: #80ff80;";
                        break;
                    case "4":
                        style = "color: #000000; background-color: #8080ff;";
                        break;
                    case "5":
                        style = "color: #ffffff; background-color: #8000ff;";
                        break;
                    case "6":
                        style = "color: #ffffff; background-color: #0000a0;";
                        break;
                    default:
                        style = "color: #000000; background-color: transparent;";
                        break;
                }

                if (res.split("^")[3] == "1") {
                    var td = $("#tbl_Status").find("td[id='" + td_id + "']").eq(0);
                    td.attr("style", style);
                    td.find("a").eq(0).attr("style", style);
                    td.find("a").eq(0).html(res.split("^")[2]);
                }
                else {
                    var td = $("#tbl_Status").find("td[id='" + td_id + "']").eq(0);
                    td.attr("style", style);
                    td.html(res.split("^")[2]);
                }
            }
        }

        function fnCheckUncheck(ctrl, flg) {
            if ($(ctrl).is(":checked")) {
                $("#tbl_Status tbody").find("input[type='checkbox'][flg='" + flg + "']").prop("checked", true);
            }
            else {
                $("#tbl_Status tbody").find("input[type='checkbox'][flg='" + flg + "']").prop("checked", false);
            }
        }

        function fnDownloadData(flg) {
            var ArrDataSaving = [];
            $("#tbl_Status tbody").find("input[type='checkbox'][flg='" + flg + "']:checked").each(function () {
                //window.open("../../Report/" + $(this).attr("doc"), "_blank");
                ArrDataSaving.push({ ID: $(this).closest("tr").attr("EmpNodeId"), Val: $(this).attr("doc") });
            });

            if (ArrDataSaving.length != 0) {
                PageMethods.fnRpt(ArrDataSaving, $("#ConatntMatter_hdnLogin").val(), flg, fnRptSuccess, fnFail, flg);
            }
            else {
                alert("Please select the Report/s for download !");
            }
        }

        function fnRptSuccess(res, flg) {
            if (res.split('^')[0] == "1") {
                alert("Due to some technical reasons, we are unable to download the Reports !");
            }
            else {
                var strPath = flg == 1 ? "Raw/" : "Final/"
                window.open("../../Reports/" + strPath + res.split('^')[1], "_blank");
            }
        }




        $(document).ready(function () {

            $('#ConatntMatter_txtSearch').keyup(function () {
                var val = $(this).val().toUpperCase();
                $("#tbl_Status").find("tbody").eq(0).find("tr").css("display", "none");

                var tbl = $("#tbl_Status>tbody>tr");
                var tr;
                for (var i = 0; i < tbl.length; i++) {
                    tr = $(tbl[i]);
                    for (var j = 0; j < $(tr).find("td").length; j++) {
                        if ($(tr).find("td").eq(j).attr("Searchable") == "1") {
                            var tdText = $(tr).find("td").eq(j).html().toUpperCase();
                            if (tdText.indexOf(val) > -1) {
                                $(tr).css("display", "table-row");
                            }
                        }
                    }
                }
            });
        });

        function fnDownload() {
            window.open("../../frmDownloadExcel.aspx?flg=1&band=");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Proctoring Report</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="form-group row">
        <label class="col-2 col-form-label" for="Cycle">Designation :-</label>
        <div class="col-6">
            <asp:DropDownList ID="ddlCycle" runat="server" CssClass="form-control d-inline-block" style="width:150px" AppendDataBoundItems="true">
            <asp:ListItem Value="">ALL</asp:ListItem>
                <asp:ListItem Value="AGM">AGM</asp:ListItem>
                <asp:ListItem Value="DGM">DGM</asp:ListItem>
            </asp:DropDownList>

            <button type="button" class="btns btn-submit" onclick="fnGetStatus()"><i class="fa fa-refresh"></i> Refresh</button>
			
			<button type="button" class="btns btn-submit" onclick="fnDownload()"><i class="fa fa-download"></i> Download</button>
        </div>
    </div>
    <div id="divStatus" runat="server" style="overflow: hidden"></div>

    <div class="text-center" id="divBTNS">
        <a href="frmDashboard.aspx" class="btns btn-submit" id="anchorbtn_other1">Back</a>
    </div>


    <div id="loader" class="clsloader">
        <div class="loader"></div>
    </div>
    <div id="divScore" style="display: none;"></div>
    <div id="divDialog" style="display: none;"></div>

    <asp:HiddenField ID="hdnSelectedEmp" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnAssessorMstr" runat="server" />
    <asp:HiddenField ID="hdnScoreCardType" runat="server" />
    <asp:HiddenField ID="hdnRoleId" runat="server" />
    <asp:HiddenField ID="hdnTabSeq" Value="1" runat="server" />
</asp:Content>
