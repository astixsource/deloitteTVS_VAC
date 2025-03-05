<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster/AdminMaster.master" AutoEventWireup="true" CodeFile="frmA3Sheet.aspx.cs" Inherits="Mapping" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script>
        var MonthArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var RoleId = 0;
        $(document).ready(function () {
            RoleId = $("#ConatntMatter_hdnRoleId").val();
            if (RoleId == 0) {
                $("#ConatntMatter_dvMain").css("height", $(window).height() - 250);
            } else {
                $("#ConatntMatter_dvMain").css("height", $(window).height() - 110);
            }
            //$("#btnSubmit").hide();
            fnGetMapping();
        });

        function fnBackPreviousPage() {
            window.location.href=""
        }
        function Tooltip(container) {
            // Tooltip only Text
            $(container).hover(function () {
                // Hover over code
                var title = $(this).attr('title');
                if (title != '' && title != undefined) {
                    $(this).data('tipText', title).removeAttr('title');
                    $('<p class="customtooltip"></p>')
                        .html(title)
                        .appendTo('body')
                        .fadeIn('slow');
                }
            }, function () {
                // Hover out code
                $(this).attr('title', $(this).data('tipText'));
                $('.customtooltip').remove();
            }).mousemove(function (e) {
                var mousex = e.pageX + 20; //Get X coordinates
                var mousey = e.pageY + 10; //Get Y coordinates
                $('.customtooltip')
                    .css({ top: mousey, left: mousex })
            });
        }
        function fnParticipant(ctrl) {
            $("#ConatntMatter_dvMain").html('');

            $("#ConatntMatter_dvBtns").find('a.active').removeClass('active');
            $(ctrl).addClass('active');
            $("#ConatntMatter_hdnSeqNo").val($(ctrl).attr("ind"));

            fnGetMapping();
        }
        function fnGetMapping() {
            var batch = $("#ConatntMatter_hdnBatch").val();
            var SeqNo = $("#ConatntMatter_hdnSeqNo").val();

            $("#dvloader").show();
            PageMethods.fnGetEntries(batch, SeqNo, RoleId,fnGetEntries_pass, fnfail);
        }
        function fnGetEntries_pass(res) {
            $("#ConatntMatter_dvMain").html(res);
            $("#ConatntMatter_dvMain").prepend("<div id='tblheader'></div>");
            if ($("#tblScheduling").length > 0) {
                var wid = $("#tblScheduling").width(), thead = $("#tblScheduling").find("thead").eq(0).html();
                $("#tblheader").html("<table id='tblEmp_header' class='table table-bordered bg-white table-sm clsTarget' style='width:" + (wid - 1) + "px;margin:0'><thead class='thead-light text-center'>" + thead + "</thead></table>");
                $("#tblScheduling").css({ "width": wid, "min-width": wid });

                for (i = 0; i < $("#tblScheduling").find("th").length; i++) {
                    var th_wid = $("#tblScheduling").find("th")[i].clientWidth;
                    $("#tblEmp_header, #tblScheduling").find("th").eq(i).css({ "min-width": th_wid, "width": th_wid });
                }
                $("#tblScheduling").css("margin-top", "-" + ($("#tblEmp_header")[0].offsetHeight) + "px");
            }

            Tooltip(".clsCustomTooltip");
            $("#dvloader").hide();
        }
        function fnfail() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        function fnComment(ctrl, excerise, Cmptncy) {
            $("#divComment").find("textarea").eq(0).val('');
            $("#divComment").find("textarea").eq(0).val($(ctrl).val());

            $("#divComment").dialog({
                modal: true,
                width: 480,
                title: "Comment :",
                buttons: {
                    "Submit": function () {
                        var CycleId = $("#ConatntMatter_hdnBatch").val();
                        var SeqNo = $("#ConatntMatter_hdnSeqNo").val();
                        var exerciseid = excerise;
                        var CmptncyId = Cmptncy;
                        var Comments = $("#divComment").find("textarea").eq(0).val().split("'").join(" ");
                        var LoginId = $("#ConatntMatter_hdnLogin").val();

                        if (Comments != "") {
                            $("#dvloader").show();
                            PageMethods.fnSave(CycleId, SeqNo, exerciseid, CmptncyId, Comments, LoginId, fnSave_pass, fnfail, ctrl);
                        }
                        else {
                            alert("Please enter Comment for Saving !");
                        }
                    },
                    Cancel: function () {
                        $(this).dialog("close");
                    }
                }
            });
        }
        function fnSave_pass(res, ctrl) {
            if (res == "0") {
                $("#dvloader").hide();
                alert("Comment saved successfully !");
                $(ctrl).val($("#divComment").find("textarea").eq(0).val());
                $(ctrl).attr("title", $("#divComment").find("textarea").eq(0).val());
                $("#divComment").dialog("close");
            }
            else {
                $("#dvloader").hide();
                alert("Due to some technical reasons, we are unable to process your request !");
            }
        }

        
    </script>
    <style>
        #ConatntMatter_dvMain {
            overflow: auto;
        }

        .table th {
            vertical-align: middle !important;
        }

        #tblScheduling th {
            color:transparent !important;
        }

        #tblScheduling td {
            padding: 0.16rem !important;
        }

        #tblScheduling td.cls-2,
        #tblScheduling td.cls-3,
        #tblScheduling td.cls-4,
        #tblScheduling td.cls-5,
        #tblScheduling td.cls-6,
        #tblScheduling td.cls-7,
        #tblScheduling td.cls-8 {
            width: 182px;
            text-align: center;
        }

        .cls-bg-gray {
            background: #eee;
        }

        .table th,
        .table td {
            border-color: #ccc !important;
        }

        input[type='text'] {
            width: 100% !important;
            border-color: transparent !important;
        }
    </style>
    <style type="text/css">
        .clsCustomTooltip {
            cursor: pointer;
        }

        .customtooltip {
            display: none;
            position: absolute;
            border: 1px solid #333;
            background-color: #161616;
            border-radius: 5px;
            padding: 10px;
            color: #fff;
            max-width: 800px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title clearfix">
        <h3 class="text-center">A3 Sheet</h3>
        <div class="title-line-center"></div>
    </div>
    <div id="dvMain" runat="server"></div>
    <div id="dvBtns" runat="server" style="padding-top:10px;"></div>
    <div id="divComment" style="display: none;">
        <textarea rows="8" maxlength="2000" style="width: 99%; border: none; background-color: #fff;"></textarea>
    </div>
    <div id="dvAlert" style="display: none;"></div>
    <div id="dvloader" class="loader_bg" style="display: block">
        <div class="loader"></div>
    </div>
    <asp:HiddenField ID="hdnUserlst" runat="server" />
    <asp:HiddenField ID="hdnBatch" runat="server" />
    <asp:HiddenField ID="hdnLogin" runat="server" />
    <asp:HiddenField ID="hdnSeqNo" runat="server" />
    <asp:HiddenField ID="hdnFlg" runat="server" />
     <asp:HiddenField ID="hdnRoleId" Value="0" runat="server" />
</asp:Content>
