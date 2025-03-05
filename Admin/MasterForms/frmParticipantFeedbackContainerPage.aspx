<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteAssessor.master" AutoEventWireup="true" CodeFile="frmParticipantFeedbackContainerPage.aspx.cs" Inherits="frmParticipantFeedbackContainerPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .asidebar {
            background: #004074;
            left: 0;
            top: 0;
            position: absolute;
            width: 240px !important;
            z-index: 99;
        }

        .my-account {
            margin-left: 226px !important;
            z-index: 899;
        }
         .cls-bg-gray {
            background: #eee;
        }

        .asidebar ul > li > a {
            margin-bottom: .25rem;
            border-bottom: none;
        }

        ul.sidebar-menu > li.has-submenu > ul.lvl {
            padding: 0;
            list-style-type: none;
            display: none;
        }

            ul.sidebar-menu > li.has-submenu > ul.lvl > li {
                padding-left: 12px;
                font-size: .85rem;
                background: #EDF3F8;
            }

                ul.sidebar-menu > li.has-submenu > ul.lvl > li:hover,
                ul.sidebar-menu > li.has-submenu > ul.lvl > li > a:hover {
                    color: #194597 !important;
                    background: #F4F5F9;
                    font-weight: bold;
                }

        ul.lvl > li > a {
            color: #464646 !important;
        }

            ul.lvl > li > a.active {
                color: #194597 !important;
                font-weight: bold;
            }

        table.Financials-tbl {
            width: 60% !important;
        }

            table.Financials-tbl > tbody > tr > td:first-child {
                text-align: left;
            }

            table.Financials-tbl > tbody > tr > td:last-child {
                width: 100px;
                text-align: center;
            }

        .my-account {
            z-index: 899;
        }
    </style>
    <script>
        $(function () {
            $("#tbl-fst-td > tbody > tr > td:first-child").css("text-align", "left");
            ///* ------------------ for tabs-1 script ------------------ */
            $('#ContextBrief_contant .my-account > .tab-pane:first, #CaseStudy_contant .my-account > .tab-pane:first, #AudioRole_contant .my-account > .tab-pane:first, #VideoRole_contant .my-account > .tab-pane:first').show();

            //$('ul.sidebar-menu > li > a').click(function () {
            //    $('.lvl-sec').slideUp(200);
            //    $('.lvl').slideUp(200);
            //    if ($(this).parent().hasClass('active')) {
            //        $('ul.sidebar-menu > li').removeClass('active');
            //        $(this).parent().removeClass('active');
            //    } else {
            //        $('ul.sidebar-menu > li').removeClass('active');
            //        $(this).next('.lvl-sec').slideDown(200);
            //        $(this).next('.lvl').slideDown(200);
            //        $(this).parent().addClass('active');
            //    }
            //    $('.my-account > .tab-pane').hide();
            //    $('.' + $(this).data('class')).fadeIn();
            //});
            //$('ul.lvl-sec > li > a').click(function () {
            //    if ($(this).hasClass('active')) {
            //        $(this).removeClass('active');
            //    } else {
            //        $('ul.lvl-sec > li > a').removeClass('active');

            //        $(this).addClass('active');
            //    }
            //    $('.my-account > .tab-pane').hide();
            //    $('.' + $(this).data('class')).fadeIn();
            //});

        });
        var PhototDocNamePath = ""; var CVPath = ""; var CVDocName = "";
        var UserName = ""; var Password = ""; var MeetingId = 0;
        $(document).ready(function () {
            $("#loader").show();
            var Participantid = $("#ConatntMatter_hdnParticipantId").val();
            var CycleId = $("#ConatntMatter_hdnCycleId").val()
            PageMethods.fnGetParticipantDetails(Participantid,CycleId, function (result) {
                $("#loader").hide();
                var sdata = $.parseJSON('[' + result + ']');
                MeetingId = sdata[0].Table[0]["MeetingId"];
                var PhototDocName = sdata[0].Table[0]["PhototDocName"];
                 UserName = sdata[0].Table[0]["UserName"];
                 Password = sdata[0].Table[0]["Password"];
                 CVDocName = sdata[0].Table[0]["CVDocName"];
                CVPath = "../../Files/" + CVDocName;
                 PhototDocNamePath = "../../Files/" + PhototDocName;
                
                fnOpenAssessorMeetingPage(3);
            }, function (results) {
                $("#loader").hide();
                alert("Error-" + results._message);
            })
            
        })
        function fnOpenAssessorMeetingPage(flg) {
            var sessionVal = "<%=Convert.ToString(Session["LoginID"])%>";
            if (sessionVal == "") {
                alert("Session expired. Please re-login again!!");
                window.location.href = "../../Login.aspx";
                return false;
            }
            // $("#hheader").html("Welcome to L&T DC-4");
            $("ul.sidebar-menu li.active").removeClass("active");
            if (flg == 1) {
                $("ul.sidebar-menu li").eq(0).addClass("active");
                $("#iframeposition")[0].innerHTML = "<table style='width:100%'><tr><td style='vertical-align:top'><div id=\"divUploadedCV\" class='col-8'><a href='###' sfilepath='" + CVPath + "' sfilename='" + CVDocName + "' class=\"btn btn-primary btn-lg\" style=\"width:100%\" onclick='fnShowFile(this)' class=\"btn btn-primary btn-lg\" style=\"width:100%\" >Personal Information Sheet</a></div></td><td><div class='col-3'><img src='" + PhototDocNamePath + "' style='width:150px; height: 150px;'/></div></td></tr></table>";
            }
            else if (flg == 2) {
                $("ul.sidebar-menu li").eq(1).addClass("active");
              var LoginID = $("#ConatntMatter_hdnLoginId").val();
              var ParticipantId = $("#ConatntMatter_hdnParticipantId").val();
              var CycleId = $("#ConatntMatter_hdnCycleId").val();
              $("#loader").show();
              PageMethods.fnGetFeedbackBoxMatrix(CycleId, ParticipantId, function (result) {
                  $("#loader").hide();
                  $("#iframeposition").show();
                  $("#iframeposition").html(result);
              }, function (results) {
                  $("#loader").hide();
                  alert("Error-" + results._message);
              })
                
               
            } else if (flg == 3) {
                $("ul.sidebar-menu li").eq(2).addClass("active");
                var url = "";
                var LoginID = $("#ConatntMatter_hdnLoginId").val();
                var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
                var CycleId = $("#ConatntMatter_hdnCycleId").val()
                $("#loader").show();
                PageMethods.fnGetEntries(CycleId, SeqNo, function (result) {
                    $("#loader").hide();
                    $("#iframeposition").show();
                    $("#iframeposition").html(result);
                }, function (results) {
                    $("#loader").hide();
                    alert("Error-" + results._message);
                })

            } else {
                $("ul.sidebar-menu li").eq(3).addClass("active");
                $("#iframeposition").show();
                $("#iframeposition").html("Coming Soon");
            }
        }
        function fnBack() {
            var CycleId = $("#ConatntMatter_hdnCycleId").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            window.location.href = "frmAssessorDC_Orien_FeedbackProcess.aspx?cycleid=" + CycleId + "&LoginID=" + LoginId + "&flgreferar=3";
        }
        function fnShowFile(sender) {
            var sfilename = $(sender).attr("sfilename");
            if (sfilename.trim() == "") {
                alert("File not uploaded");
                return false;
            } else {
                $(sender)[0].href = $(sender).attr("sfilepath");
                $(sender).attr("target", "_blank");
                $(sender).click();
            }
        }
        function fnView_Details(ctrl) {

            //var vanNodeType = $(ctrl).closest("tr").attr("ActivityID");
            var CycleId = $("#ConatntMatter_hdnCycleId").val();
            var cyclename = $("#ConatntMatter_hdnCycleName").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            var participantid = $(ctrl).closest("tr").attr("participantid");
            var sName = $(ctrl).closest("td").prev().html();
            // alert(CycleId);

            //     window.location.href = "/Admin/MasterForms/frmViewDetail.aspx?cycleid=" + CycleId + "&cyclename=" + cyclename + "&LoginId=" + LoginId; // For Local Machine

            $("#divView").dialog({
                title: "View Detail :- " + sName,
                width: "80%",
                height: "450",
                position: { my: 'center', at: 'center', of: window },
                modal: true,
                draggable: false,
                resizable: false,
                open: function () {
                    var sURL = "frmViewDetail.aspx?cycleid=" + CycleId + "&cyclename=" + cyclename + "&LoginId=" + LoginId + "&participantid=" + participantid; // For Server Update
                    $("#iframeopentools1").attr("src", sURL);
                }, close: function () {
                    $("#iframeopentools1")[0].src = "about:blank";
                }
            });
        }

        function fnStartMeeting(sender) {

                if (parseInt(MeetingId) == 0) {
                    alert("Meeting Not Available");
                    return false;
                }
                $("#btnMeeting1").html("Close Meeting");
                $("#btnMeeting2").show();
                fnSetMeetingStatus(sender, 1, MeetingId);
        }

        function fnSetMeetingStatus(sender, flgMeeting, MeetingId) {
            $("#loader").show();
            PageMethods.fnStartMeeting(flgMeeting, MeetingId, UserName, Password, function (result) {
                $("#loader").hide();
                if (result.split("|")[0] == "0") {
                    //if (flgMeeting == 2) {
                    //    alert("Meeting Finished Successfully");
                    //    $("#btnMeeting2").hide();
                    //    $(sender).html("Meeting Finished");
                    //    $(sender).removeAttr("onclick");
                    //    $(sender).removeAttr("href");
                    //}
                    //else {
                        if (result.split("|")[1] != "") {
                            window.open(result.split("|")[1]);
                        } else {
                            alert("Meeting Not Available!");
                        }
                    //}
                }
                else {
                    alert("Error-" + result.split("^")[1]);
                }
            }, function (result) {
                $("#loader").hide();
                alert("Error-" + result._message);
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">

    <div class="wrapper">
        <div class="asidebar">
            <ul class="sidebar-menu">
                <li><a href="#" data-class="tab1" onclick="fnOpenAssessorMeetingPage(1)">CV</a></li>
                <li class="active"><a href="#" data-class="tab2" onclick="fnOpenAssessorMeetingPage(2)">3-Box Matrix</a></li>
                <li><a href="#" data-class="tab3" onclick="fnOpenAssessorMeetingPage(3)">A3 Sheet</a></li>
                <li><a href="#" data-class="tab4" onclick="fnOpenAssessorMeetingPage(4)">IDP Template</a></li>
            </ul>
        </div>
        <div class="my-account">
            <div class="section-content">
                <div class="section-title clearfix">
                    <table style="width:100%" >
                        <tr>
                            <td id="tdParticipantName" runat="server" style="vertical-align:top">
                            </td>
                            <td style="vertical-align:top;width:350px">
                                <input type="button" class="btn btn-primary" value="Back" onclick="fnBack()" />
                                <input type="button" class="btn btn-primary" value="Goto Meeting" onclick="fnStartMeeting(this)" />
                            </td>
                        </tr>
                    </table>
                    
                </div> 
                <div id="iframeposition" style="text-align: center;">
                </div>
            </div>
        </div>
    </div>
    <div id="divView" style="display: none">
        <iframe id="iframeopentools1" border="0" scroll="no" style="width: 100%; height: 350px; border: none; overflow: hidden"></iframe>
    </div>
    <asp:HiddenField runat="server" ID="hdnRoleId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnCycleName" Value="" />
    <asp:HiddenField runat="server" ID="hdnOrientationMeetingLink" Value="" />
    <asp:HiddenField runat="server" ID="hdnFeedbacksessionMeetingLink" Value="" />
    <asp:HiddenField runat="server" ID="hdnBEIUsername" Value="" />
    <asp:HiddenField runat="server" ID="hdnBEIPassword" Value="" />
    <asp:HiddenField runat="server" ID="hdnMeetingId" Value="" />
    <asp:HiddenField runat="server" ID="hdnLoginId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnParticipantId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnSeqNo" Value="0" />
    

</asp:Content>

