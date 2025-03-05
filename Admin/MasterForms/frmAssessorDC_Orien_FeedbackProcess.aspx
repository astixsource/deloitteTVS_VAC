<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/SiteAssessor.master" AutoEventWireup="true" CodeFile="frmAssessorDC_Orien_FeedbackProcess.aspx.cs" Inherits="Admin_MasterForms_frmAssessorDC_Orien_FeedbackProcess" %>

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
        var WashupMeetingLink = ""; var UserName = ""; var Password = ""; var MeetingId = 0;
        var Orient_AssesseeMeetLink = ""; var MeetingId = 0;
        $(document).ready(function () {
            var flgrefer = $("#ConatntMatter_hdnflgreferar").val();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            var LoginID = $("#ConatntMatter_hdnLoginId").val();
            PageMethods.fnGetParticipantDetails(LoginID, function (result) {
                $("#loader").hide();
                var sdata = $.parseJSON('[' + result + ']');
                MeetingId = sdata[0].Table[0]["Orient_MeetingID"];
                UserName = sdata[0].Table[0]["BEIUsername"];
                Password = sdata[0].Table[0]["BEIPassword"];
                Orient_AssesseeMeetLink = sdata[0].Table[0]["Orient_AssesseeMeetLink"];
                WashupMeetingLink = sdata[0].Table[0]["WashUpMeetingLink"];
            }, function (results) {
                $("#loader").hide();
                alert("Error-" + results._message);
            })

            if (flgrefer == 0) {
                fnOpenAssessorMeetingPage(2);
            } else {
                fnOpenAssessorMeetingPage(flgrefer);
            }
            if (RoleId == 4) {
                $("ul.sidebar-menu li").eq(2).hide();
            }
        })
        function fnOpenAssessorMeetingPage(flg) {
            var sessionVal = "<%=Convert.ToString(Session["LoginID"])%>";
            var sessionVal1 = "<%=Convert.ToString(Session["RoleId"])%>";
            if (sessionVal == "" || sessionVal1=="") {
                alert("Session expired. Please re-login again!!");
                window.location.href = "../../Login.aspx";
                return false;
            }
            $("#iframeposition").css("width", "100%");
            $("#hheader").html("Welcome to L&T DC-4");
            $("#hheader").closest("div").show()
            $("ul.sidebar-menu li.active").removeClass("active");
            if (flg == 1) {
                $("ul.sidebar-menu li").eq(0).addClass("active");
                var LoginId = $("#ConatntMatter_hdnLoginId").val();
                if (MeetingId == 0) {
                    $("#iframeposition")[0].innerHTML = "<br/><br/><input type='button' value='Orientation Session' title='Orientation Meeting Link Not Available.'/ class='btn btn-primary btn-lg'>";
                    //return false;
                } else {
                    var RoleId = $("#ConatntMatter_hdnRoleId").val();
                    var stext = RoleId == 4 ? "Click To Start Orientation Meeting" : "Click To Join Orientation Meeting";
                    $("#iframeposition")[0].innerHTML = "<br/><br/><input type='button' onclick='fnStartOrientationMeeting()' value='" + stext + "' class='btn btn-primary btn-lg'>"
                    //fnStartOrientationMeeting
                }
                
            }
            else if (flg == 2) {
                $("#hheader").html("UPCOMING MEETINGS");
                $("ul.sidebar-menu li").eq(1).addClass("active");
                var url = "";
                var LoginID = $("#ConatntMatter_hdnLoginId").val();
                var RoleId = $("#ConatntMatter_hdnRoleId").val();
                var sHeight = $(window).height() - ($("#hheader").closest("div").height() + $(".navbar").height() + 80);
                if ($("#ConatntMatter_hdnRoleId").val() == "3") {
                    url = "frmGetParticipantListAgAssessor.aspx?cycleid=" + $("#ConatntMatter_hdnCycleId").val() + "&LoginID=" + LoginID + "&RoleId=" + RoleId;
                } else {
                    url = "frmGetParticipantListAgEYAdmin.aspx?cycleid=" + $("#ConatntMatter_hdnCycleId").val() + "&LoginID=" + LoginID + "&RoleId=" + RoleId;
                }
                $("#iframeposition")[0].innerHTML = "<div><iframe id=\"Iframefrm\" src='" + url + "' style=\"height: " + sHeight + "px; width: 100%; background-color: #fff\" frameborder=\"0\" name=\"Iframefrm\"  ></iframe></div><div style='position:absolute;right:0;top:10px;margin-right:37px;display:none' id='divWashupbutton'><input type='button' value='Goto Meeting' class='btn btn-primary' onclick='fnStartWashupMeeting()' /></div>";
            } 
            else if (flg == 3) {
                $("ul.sidebar-menu li").eq(2).addClass("active");
                var LoginID = $("#ConatntMatter_hdnLoginId").val();
                var RoleId = $("#ConatntMatter_hdnRoleId").val();
                var CycleId = $("#ConatntMatter_hdnCycleId").val()
                $("#loader").show();
                PageMethods.fnFeedbackdata(CycleId, LoginID, function (result) {
                    $("#loader").hide();
                    $("#iframeposition").show();
                    $("#iframeposition").css({
                        "width": "70%",
                        "margin":"0px auto"
                    });
                    $("#iframeposition").html(result);
                    $("#iframeposition").prepend("<div id='tblheader'></div>");
                    if ($("#tbldbrlist").length > 0) {
                        var wid = $("#tbldbrlist").width(), thead = $("#tbldbrlist").find("thead").eq(0).html();
                        $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered table-sm mb-0' style='width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                        $("#tbldbrlist").css({ "width": wid, "min-width": wid });

                        for (i = 0; i < $("#tbldbrlist").find("th").length; i++) {
                            var th_wid = $("#tbldbrlist").find("th")[i].clientWidth;
                            $("#tblEmp_header, #tbldbrlist").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                        }
                        $("#tbldbrlist").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");

                        $('#dvtblbody').css({
                            'height': $(window).height() - 380,
                            'overflow-y': 'auto',
                            'overflow-x': 'hidden'
                        });
                    }
                }, function (results) {
                    $("#loader").hide();
                    alert("Error-" + results._message);
                })
            } else {
                $("#hheader").closest("div").hide();
                $("ul.sidebar-menu li").eq(3).addClass("active");
                var LoginID = $("#ConatntMatter_hdnLoginId").val();
                var RoleId = $("#ConatntMatter_hdnRoleId").val();
                var sHeight = $(window).height() - ($("#hheader").closest("div").height() + $(".navbar").height() + 60);
                var url = "frmA3Sheet.aspx?LoginID=" + LoginID + "&RoleId=" + RoleId + "&flgCallType=1";
                $("#iframeposition")[0].innerHTML = "<div><iframe id=\"Iframefrm\" src='" + url + "' style=\"height: " + sHeight + "px; width: 100%; background-color: #fff\" frameborder=\"0\" name=\"Iframefrm\"  ></iframe></div>";
            }
        }

        function fnStartOrientationMeeting() {
            $("#loader").show();
            var RoleId = $("#ConatntMatter_hdnRoleId").val();
            if (RoleId == 4) {
                PageMethods.fnStartMeeting(MeetingId, UserName, Password, function (result) {
                    $("#loader").hide();
                    if (result.split("|")[0] == "0") {
                        if (result.split("|")[1] != "") {
                            //$("#iframeposition")[0].innerHTML = "Orientation Session is running...";
                            window.open(result.split("|")[1]);
                        } else {
                            //$("#iframeposition")[0].innerHTML = "Orientation Session link not available!";
                        }
                    }
                    else {
                        //$("#iframeposition")[0].innerHTML = "Error-" + result.split("|")[1];
                    }
                }, function (result) {
                    $("#loader").hide();
                    //$("#iframeposition")[0].innerHTML = "Error-" + result._message;
                });
            } else {
                window.open(Orient_AssesseeMeetLink);
            }
        }
        function fnStartWashupMeeting() {
            if (WashupMeetingLink != "" && WashupMeetingLink != null) {
                window.open(WashupMeetingLink);
            } else {
                alert("WashUp Meeting Link Not Available!");
            }
        }
        function fnOpenForm(sender) {
            var ParticipantId = $(sender).closest("tr").attr("participantid");
            var ParticipantSeq = $(sender).closest("tr").attr("ParticipantSeq");
            var ParticipantName = $(sender).closest("td").prev().html().trim();
            var CycleId = $("#ConatntMatter_hdnCycleId").val();
            var cyclename = $("#ConatntMatter_hdnCycleName").val();
            var LoginId = $("#ConatntMatter_hdnLoginId").val();
            window.location.href = "frmParticipantFeedbackContainerPage.aspx?cycleid=" + CycleId + "&LoginID=" + LoginId + "&ParticipantId=" + ParticipantId + "&ParticipantName=" + ParticipantName + "&ParticipantSeq=" + ParticipantSeq;
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">

    <div class="wrapper">
        <div class="asidebar">
            <ul class="sidebar-menu">
                <li><a href="#" data-class="tab1" onclick="fnOpenAssessorMeetingPage(1)">Orientation Session</a></li>
                <li class="active"><a href="#" data-class="tab2" onclick="fnOpenAssessorMeetingPage(2)">Development Center Process</a></li>
                <li><a href="#" data-class="tab3" onclick="fnOpenAssessorMeetingPage(3)">Feedback Session</a></li>
                <%--<li><a href="#" data-class="tab4" onclick="fnOpenAssessorMeetingPage(4)">Washup Session</a></li>--%>
            </ul>
        </div>
        <div class="my-account">
            <div class="section-content">
                <div class="section-title clearfix">
                    <h3 class="text-center" id="hheader">UPCOMING MEETINGS</h3>
                    <div class="title-line-center"></div>
                </div>
                <div id="iframeposition" style="text-align: center">
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
    <asp:HiddenField runat="server" ID="hdnflgreferar" Value="0" />
    

</asp:Content>

