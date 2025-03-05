<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLeft.aspx.cs" Inherits="frmLeft" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <!-- viewport meta to Content-Type -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <!-- viewport meta to reset Web-app inital scale -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="grey" />

    <!-- viewport meta to reset iPhone inital scale -->
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0," />

    <!-- For All Device CSS -->
    <link href="../../CSS/font-awesome.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/InboxSite.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        body {
            background: #43B02A;
            overflow-x: hidden;
            overflow-y: auto;
            margin: 0;
            padding-right: 2px;
        }

        .btn.btn-cancel {
            border: 1px solid #0371c0;
            background: #e9e9e9;
            color: #044d91;
            text-align: center;
            padding: 10px 20px;
            position: relative;
            display: inline-block;
            border-radius: 3px;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            text-decoration: none;
            outline: none;
            -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            -webkit-transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

            .btn.btn-cancel:hover {
                border: 1px solid #0371c0;
                background: #e1e1e1;
                color: #044d91;
                text-decoration: none;
                -webkit-box-shadow: 0 7px 14px rgba(0, 0, 0, 0.18), 0 5px 5px rgba(0, 0, 0, 0.12);
                -moz-box-shadow: 0 7px 14px rgba(0, 0, 0, 0.18), 0 5px 5px rgba(0, 0, 0, 0.12);
                box-shadow: 0 7px 14px rgba(0, 0, 0, 0.18), 0 5px 5px rgba(0, 0, 0, 0.12);
            }
    </style>
    <!-- For All Device Jquery -->
    <script src="../../Scripts/jquery.min-3.6.0.js.js" type="text/javascript"></script>
    <%--<script src="../../Scripts/Calender.js"></script>--%>

    <script type="text/javascript">
        $(function () {
            //$("#bottom-btn2").css({
            //    "margin-top": $(window).height() - ($(".accordion").outerWidth() + 145) + "px"
            //});
            $("#bottom-btn2").css({
                position: "absolute",
                left: "0",
                bottom: "10px",
                width: "100%"
            });
        });


        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });

        function fnOpen(boxNo) {

            if (parseInt(boxNo) == 1) {
                parent.fnStartLoading();
                var sURL = "frmInbox.aspx?ExerciseID=" + parent.parent.document.getElementById("ConatntMatter_hdnExerciseID").value + "&TotalTime=" + parent.parent.document.getElementById("ConatntMatter_hdnTotalTime").value + "&RspID=" + parent.parent.document.getElementById("ConatntMatter_hdnRspID").value + "&BandID=" + parent.parent.document.getElementById("ConatntMatter_hdnBandID").value + "&ExerciseType=" + parent.parent.document.getElementById("ConatntMatter_hdnExerciseType").value + "&intLoginID=" + parent.parent.document.getElementById("ConatntMatter_hdnLoginID").value

                parent.parent.frames[1].location = sURL;
            }
            else if (parseInt(boxNo) == 2) {
                parent.fnStartLoading();
                parent.parent.frames[1].location = "frmSentMailBox.aspx";
            }
            else if (parseInt(boxNo) == 4) {
                parent.fnLeftPopup(4);
            }
            else if (parseInt(boxNo) == 5) {
                parent.fnLeftPopup(5);
            }
            else if (parseInt(boxNo) == 6) {
                parent.fnLeftPopup(6);
            }
            else if (parseInt(boxNo) == 7) {
                parent.fnLeftPopup(7);
            }
          
            $("html, body").animate({ scrollTop: 0 }, "slow");
        }

        //--modified code
        function fnlogout() {
            var r = confirm("Do you want to exit?");
            if (r == true) {
                parent.fnlogout();
            }
        }
        function fnSuccessSaveSession(res) {
            parent.fnlogout();
        }
        function fnFail(res) {
        }

        function fnDvContextBrief() {
            //window.open("ContextBrief.html", "", "width=1200,statusbar=no,resizable=no,toolbar=no,scrollbars=yes")
            //window.open("../Common/ContextBrief.html")
            window.parent.location.href = "../Exercise/ExerciseMain.aspx";
        }
    </script>

    <script type="text/javascript">
        document.onmousedown = disableclick;
        status = "Right Click Disabled";
        function disableclick(event) {
        }
    </script>

</head>
<body oncontextmenu="return false;">
    <form id="frmlft" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <div class="accordion" id="accordion">
            <div class="card">
                <div class="card-header">
                    <span><i class="fa fa-comments"></i>Mail</span>
                    <i class="fa fa-chevron-down toggly"></i>
                </div>
                <div class="card-body">
                    <ul>
                        <li><a href="#" onclick="fnOpen(1)"><i class="fa fa-inbox"></i>Inbox <span class="badge badge-pill badge-primary"></span></a></li>
                        <li><a href="#" onclick="fnOpen(2)"><i class="fa fa-paper-plane"></i>Sent</a></li>
                        <%-- <li><a href="#" onclick="fnOpen(3)"><i class="fa fa-file"></i>Drafts <span class="badge badge-pill badge-info"></span></a></li>
                        <li><a href="#" onclick="fnOpen(4)"><i class="fa fa-trash"></i>Deleted Items</a></li>--%>
                    </ul>
                </div>
            </div>
          <%--  <div class="card">
                <div class="card-header">
                    <a href="#" onclick="fnOpen(4)">Brief</a>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <a href="#" onclick="fnOpen(5)">March Calendar</a>
                </div>
            </div>--%>
           <%-- <div class="card">
                <div class="card-header">
                    <a href="#" onclick="fnOpen(6)">Sanjit’s Calendar</a>
                </div>
            </div>--%>
            <%--<div class="card">
                <div class="card-header">
                    <a href="#" onclick="fnOpen(7)">ORGANIZATION CHART</a>
                </div>
            </div>--%>
        </div>
        <div id="bottom-btn2" class="p-2">
            <a href="##" id="Button2" class="btn btn-cancel w-100" onclick="fnDvContextBrief()">Back</a>
        </div>
        <asp:HiddenField ID="HiddenField1" runat="server" />
    </form>
</body>
</html>
