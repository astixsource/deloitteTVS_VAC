<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmViewDetail.aspx.cs" Inherits="Admin_MasterForms_frmViewDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .card-header {
            cursor: pointer;
            text-align: center;
        }

            .card-header:hover,
            .card-header:active,
            .card-header.active {
                background: #007BFF;
                color: #FFF;
            }

        body {
            overflow: hidden !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#loader").show();
            var Participantid = $("#ConatntMatter_hdnparticipantid").val();
            //  alert(Participantid);
            PageMethods.fnGetParticipantDetails(Participantid, function (result) {
                $("#loader").hide();
                var sdata = $.parseJSON('[' + result + ']');
                var FullName = sdata[0].Table[0]["FullName"];
                var CVDocName = sdata[0].Table[0]["CVDocName"];
                var PhototDocName = sdata[0].Table[0]["PhototDocName"];
                var VideoFileName = sdata[0].Table[0]["VideoFileName"];
                var OrgStrucutreDocName = sdata[0].Table[0]["OrgStructureDocName"];

                // alert(FullName);
                var CVPath = "../../Files/" + CVDocName;
                //  alert(CVPath);
                $("#divUploadedCV").show();
                //$("#divUploadedCV")[0].innerHTML = "<a href='###' sfilepath='" + CVPath + "' sfilename='" + CVDocName + "' class=\"btn btn-primary btn-lg\" style=\"width:100%\" onclick='fnShowFile(this)' class=\"btn btn-primary btn-lg\" style=\"width:100%\" >Personal Information Sheet</a>";
                $("#divUploadedCV")[0].innerHTML = "<a href='###' sfilepath='" + CVPath + "' file='" + CVPath + "' class=\"btn btn-primary btn-lg\" style=\"width:100%\" onclick='fnShowPDF(this, 1)' class=\"btn btn-primary btn-lg\" style=\"width:100%\" >Personal Information Sheet</a>";
                $("#divUploadedCV1").html("<div id='divPdflst'></div><iframe src='' style='vertical-align: middle; background-color: White; width: 100%; height: 100%; border: 0;'></iframe>");
                // $("#divUploadedCV1").html("<div id='divPdflst'><span class='text-success ml-3 fa fa-file-text pointer' file='" + CVPath + "' onclick='fnShowPDF(this, 1);' style='padding-right: 6px; font-size: 20px;'></span><span file='" + CVPath + "' onclick='fnShowPDF(this,1);'> Personal Information Sheet</span></div><iframe src='' style='vertical-align: middle; background-color: White; width: 100%; height: 95%; border: 0;'></iframe>");


                var OrgStrucutreDocNamePath = "../../Files/" + OrgStrucutreDocName;
                // alert(OrgStrucutreDocNamePath);
                $("#divUploadedOrg").show();
                $("#divUploadedOrg")[0].innerHTML = "<a href='###' sfilepath='" + OrgStrucutreDocNamePath + "' sfilename='" + OrgStrucutreDocName + "' class=\"btn btn-primary btn-lg\" style=\"width:100%\" onclick='fnShowFile(this)' >Organisation Structure</a>";
                // $("#divUploadedOrg").html("<span class='text-success ml-3 fa fa-file-text pointer' file='" + OrgStrucutreDocNamePath + "' onclick='fnShowPDF(this, 3);' style='padding-right: 6px; font-size: 20px;'></span><span file='" + OrgStrucutreDocNamePath + "' onclick='fnShowPDF(this, 3);'>Organisation Structure</span>");

                var PhototDocNamePath = "../../Files/" + PhototDocName;
                $("#dvImgDialog").html("<img src='" + PhototDocNamePath + "' style='width:150px; height: 150px;'/>");
                // $("#dvImgDialog")[0].innerHTML ="<img src='../../Files/" + PhototDocNamePath + "' style='width:150px; height: 150px;'/>";

                $("#divName").html(FullName);



            }, function (results) {
                $("#loader").hide();
                alert("Error-" + results._message);
            })
        });


        function fnShowFile(sender) {
            var sfilename = $(sender).attr("sfilename");
           // alert(sfilename);
            if (sfilename.trim() == "") {
                alert("File not uploaded");
                return false;
            }

            else if (sfilename == "../../Files/") {
                alert("File not uploaded");
                return false;
            }
            else if (sfilename == "../../Files/null") {
                alert("File not uploaded");
                return false;
            }
            else {
                $(sender)[0].href = $(sender).attr("sfilepath");
                $(sender).attr("target", "_blank");
                $(sender).click();
            }
        }
    </script>

    <script>
        function fnShowPDF(ctrl, cntr) {
            var filename = $(ctrl).attr("file");
            //var sfilename = $(sender).attr("sfilename");
           // alert(sfilename);
          //  alert(filename);
            if (filename == "../../Files/") {
                alert("File not uploaded");
                return false;
            }
            else if (filename == "../../Files/null") {
                alert("File not uploaded");
                return false;
            }
            else {
                $("#divUploadedCV1").find("iframe").eq(0).attr("src",filename);
                document.getElementById("iframe").src =  + filename;
                $("#divpdflst").hide();
                //$("#dvPdfDialog")[0].style.display = "block";
                //$("#dvPdfDialog").dialog({
                //    title: "CV",
                //    resizable: false,
                //    height: $(window).height(),
                //    width: "90%",
                //    modal: true,
                //    open: function () {
                //        $("body").css("overflow", "hidden");
                //        $("#iFramePdf").height(($(window).height() - 50) + "px");
                //    },
                //    close: function () {
                //        document.getElementById("iFramePdf").src = "";
                //    }
                //});

            }
            //if (cntr == 1) {
            //    $("#dvPdfDialog").dialog("option", "title", "CV");
            //}
            //else {
            //    $("#dvPdfDialog").dialog("option", "title", "Org Structure");
            //}
        }

    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Participants Information</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="row">
        <div class="col-md-3">
            <div id="dvImgDialog" class="text-center"></div>
            <div id="divName" class="text-center mb-3" style="font-weight: bold; font-size: large;"></div>
            <h5 id="divUploadedOrg"></h5>
        </div>
        <div class="col-md-9">
            <div id="divUploadedCV" class="d-inline-block">
            </div>
           <%-- <div class="pull-right">
                <a href="##" id="btnprev" class="btns btn-cancel fa fa-arrow-left"></a>
                <a href="##" id="btnnext" class="btns btn-cancel fa fa-arrow-right"></a>
            </div>--%>
            <div class="w-100"></div>
            <div id="divUploadedCV1" class="border mt-2 mb-2" style="height: 350px;"></div>



        </div>
    </div>
    <%--<div class="text-center">
        <input type="button" id="btnback" value="Go Back" onclick="FnClose(1)" class="btns btn-submit" />
    </div>--%>



    <div id="dvPdfDialog" style="display: none">
        <iframe src="" id="iFramePdf" style="vertical-align: middle; background-color: White; width: 100%; height: 100%; border: 0;"></iframe>
    </div>




    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMenuId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnMailFlag" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleName" Value="" />
    <asp:HiddenField runat="server" ID="hdnOrientationMeetingLink" Value="" />
    <asp:HiddenField runat="server" ID="hdnFeedbacksessionMeetingLink" Value="" />
    <asp:HiddenField runat="server" ID="hdnparticipantid" Value="0" />
</asp:Content>

