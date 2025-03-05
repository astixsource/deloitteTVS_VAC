<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmCaseStudyTools.aspx.cs" Inherits="Admin_MasterForms_frmCaseStudyTools" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        $(function () {
            //  $(".user_nav").hide();
        });
        function fnExerciseView(flg) {
            if (flg == 1) {
                window.open("ExerciseView/GroupDiscussion_Content.html")
            }
            else if (flg == 2) {
                window.open("ExerciseView/CaseStudy_Content.html")
            }
            else if (flg == 3) {
                window.open("ExerciseView/RolePlayInternal_Content.html")
            } else if (flg == 4) {
                window.open("ExerciseView/RolePlayExternal_Content.html")
            }
            else if (flg == 5) {
                window.open("ExerciseView/FactFinding_Content.html")
            }
        }

        function fnDvCompanyBackground() {
            window.open("ExerciseView/Background_Content.html")
        }
        function fnAssessorGuideGroupDiscussion() {
            /*  window.open("AssessorGuide/AssessorGuideGD.xlsx")*/
            window.open("AssessorGuide/AssessorGuide-GD.pdf")
        }
        function fnAssessorGuideCaseDiscussion() {
            window.open("AssessorGuide/AssessorGuide-CaseAnalysis.pdf")
        }
        function fnAssessorGuideRolePlayinternal() {
            window.open("AssessorGuide/AssessorGuide-InternalRolePlay.pdf")
        }
        function fnAssessorGuideRolePlayExternal() {
            window.open("AssessorGuide/AssessorGuide-ExternalRolePlay.pdf")
        }
        function fnAssessorGuideCBI() {
            window.open("AssessorGuide/CBI.pdf")
        }
        function fnAssessorGuideFACTFINDING() {
            window.open("AssessorGuide/AssessorGuide-FactFindingExercise.pdf")
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Exercise</h3>
        <div class="title-line-center"></div>
    </div>
    <div class="row absolute-center">
        <div class="col-md-4">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-1.png" />
                    <div class="panel-box-title-text">
                        <small>Company Background</small>
                    </div>
                </div>
                <div class="panel-footer">
                    <input type='button' class='btn' value="View" onclick="fnDvCompanyBackground()">
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-2.png" />
                    <div class="panel-box-title-text">
                        <small>Group Discussion</small>
                    </div>
                </div>
                <div class="panel-footer row m-0 pl-0 pr-0">
                    <div class="col-5">
                        <input type='button' class='btn' value="View" onclick="fnExerciseView(1)">
                    </div>
                    <div class="col-7">
                        <input type='button' class='btn' value="Assessor Guide" onclick="fnAssessorGuideGroupDiscussion()">
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-3.png" />
                    <div class="panel-box-title-text">
                        <small>Case Study</small>
                    </div>
                </div>
                <div class="panel-footer row m-0 pl-0 pr-0">
                    <div class="col-5">
                        <input type='button' class='btn' value="View" onclick="fnExerciseView(2)">
                    </div>
                    <div class="col-7">
                        <input type='button' class='btn' value="Assessor Guide" onclick="fnAssessorGuideCaseDiscussion()">
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-4.png" />
                    <div class="panel-box-title-text">
                        <small>Role Play Internal</small>
                    </div>
                </div>
                <div class="panel-footer row m-0 pl-0 pr-0">
                    <div class="col-5">
                        <input type='button' class='btn' value="View" onclick="fnExerciseView(3)">
                    </div>
                    <div class="col-7">
                        <input type='button' class='btn' value="Assessor Guide" onclick="fnAssessorGuideRolePlayinternal()">
                    </div>
                </div>
            </div>
        </div>
   
        <div class="col-md-4">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-5.png" />
                    <div class="panel-box-title-text">
                        <small>Role Play External</small>
                    </div>
                </div>
                <div class="panel-footer row m-0 pl-0 pr-0">
                    <div class="col-5">
                        <input type='button' class='btn' value="View" onclick="fnExerciseView(4)">
                    </div>
                    <div class="col-7">
                        <input type='button' class='btn' value="Assessor Guide" onclick="fnAssessorGuideRolePlayExternal()">
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-5.png" />
                    <div class="panel-box-title-text">
                        <small>Fact Finding</small>
                    </div>
                </div>
                <div class="panel-footer row m-0 pl-0 pr-0">
                    <div class="col-5">
                        <input type='button' class='btn' value="View" onclick="fnExerciseView(5)">
                    </div>
                    <div class="col-7">
                        <input type='button' class='btn' value="Assessor Guide" onclick="fnAssessorGuideFACTFINDING()">
                    </div>
                </div>

            </div>
        </div>

         <div class="col-md-3">
            <div class="panel-box panel-box-default">
                <div class="panel-box-title">
                    <img src="../../Images/instr-5.png" />
                    <div class="panel-box-title-text">
                        <small>CBI</small>
                    </div>
                </div>
                <div class="panel-footer">
                    <input type='button' class='btn' value="Assessor Guide" onclick="fnAssessorGuideCBI()">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

