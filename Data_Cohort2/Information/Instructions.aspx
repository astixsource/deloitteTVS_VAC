﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Data_Cohort2/MasterPage/SiteInstruction.master" AutoEventWireup="true" CodeFile="Instructions.aspx.cs" Inherits="PGM_Information_Instructions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .modal-body ul,
        .modal-body p {
            padding: 0px 20px;
            text-align: justify;
        }
         .modal-body {
    height: 450px;
    overflow-y: auto;
}
    </style>
    <script type="text/javascript">
        function fnLogout() {
            window.location.href = "../../Login.aspx";
        }

        function openPopup(el) {
            if ($('#' + el).attr("flg") == "1") {
                $('.modal').hide();
                $('#' + el).fadeIn(200);

                if (el == "div1") {
                    $("#hdnDiv1").val(1);
                }
                else if (el == "div2") {
                    $("#hdnDiv1").val(2);
                }
                else if (el == "div3") {
                    $("#hdnDiv1").val(3);
                }

                //$("#" + el).dialog({
                //    title: "",
                //    width: "45%",
                //    modal: true,
                //    draggable: false,
                //    resizable: false,
                //});
            }
            else {
                alert("Please, Watch the Instruction in Order !");
            }
        }

        function closePopup() {
            $('.modal').fadeOut(300);
            if ($("#hdnDiv1").val() == 1) {
                if ($('#div2').attr("flg") == "0") {
                    $('div#dv2').removeClass("disabled");
                }
                $('#div2').attr("flg", "1");
                //$("#ConatntMatter_btnSubmit").css("display", "inline-block");
            }
            else if ($("#hdnDiv1").val() == 2) {
                if ($('#div3').attr("flg") == "0") {
                    $('div#dv3').removeClass("disabled");
                }
                $('#div3').attr("flg", "1");
               // $("#ConatntMatter_btnSubmit").css("display", "inline-block");
            }
            else if ($("#hdnDiv1").val() == 3) {
                $("#ConatntMatter_btnSubmit").css("display", "inline-block");
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="section-title">
        <h3 class="text-center">Introduction</h3>
        <div class="title-line-center"></div>
    </div>

    <div class="section-content">
        <div class="row absolute-center">
            <div class="col-md-3">
                <div id="dv1" class="panel-box panel-box-default" onclick="openPopup('div1');"  flg="1">
                    <%--<div class="box-title" style="background-image: url('../../Images/instr-1.png')">--%>
                    <div class="panel-box-title">
                        <img src="../../Images/instr-1.png" />
                        <div class="panel-box-title-text">Step 1</div>
                    </div>
                    <div class="panel-footer">
                        What to Expect from the
                        <br />
                        Assessment?
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div id="dv2" class="panel-box panel-box-default disabled" onclick="openPopup('div2');"   flg="1">
                    <%--<div class="box-title" style="background-image: url('../../Images/instr-2.png')">--%>
                    <div class="panel-box-title">
                        <img src="../../Images/instr-2.png" />
                        <div class="panel-box-title-text">Step 2</div>
                    </div>
                    <div class="panel-footer">
                        Instructions to set you up
                        <br />
                        for success
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div id="dv3" class="panel-box panel-box-default disabled" onclick="openPopup('div3');"  flg="1">
                    <%--<div class="box-title" style="background-image: url('../../Images/instr-3.png')">--%>
                    <div class="panel-box-title">
                        <img src="../../Images/instr-3.png" />
                        <div class="panel-box-title-text">Step 3</div>
                    </div>
                    <div class="panel-footer">
                        Quick tips to enhance your
                        <br />
                        effectiveness.
                    </div>
                </div>
            </div>
        </div>
        <div class="m-t-25 text-center clearfix">
            <asp:Button ID="btnSubmit" runat="server" CssClass="btns btn-submit" Text="Go To Exercises" OnClick="btnSubmit_Click" Style="display: none;" />
        </div>
    </div>

    <%-- popup section start here --%>
    <div class="modal" id="div1" role="dialog" flg="1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header pt-1 pb-1">
                    <div class="close" onclick="closePopup();">&times;</div>
                </div>
                <div class="modal-body pt-0">
                    <h3 class="small-heading">What to Expect from the Assessment?</h3>
                    <ul type="disc">
                        <li>The assessment consists of series of exercises reflecting real-life, day-to-day challenges you may face</li>
                        <li>You will be playing different roles in the context of the given case background. Details of your role and situation is provided in the beginning of each activity</li>
                        <li>As part of the assessment, you will go through following exercises:
                          <ul type="circle">
                              <li><span class="font-weight-bold">Business Case Study : </span>You will get a case study that presents a complex business problem and will be required to analyze the situation and make critical business decisions based on the case presented
                              </li>
                              <li><span class="font-weight-bold">Technical Case Study : </span>You will get a case study that presents a complex technical problem (e.g., system failures, technical inefficiencies, operational hurdles) and will be required to analyze the situation and make appropriate decisions based on the technical issues described
                              </li>
                              <li><span class="font-weight-bold">In-basket Exercise : </span>You will engage in an exercise designed to assess the types of dilemmas and decisions that typically arise in a regular workday
                              </li>
                              <li><span class="font-weight-bold">Situational Judgement : </span>You will participate in Situational Judgement Tests (SJTs) that assess how you approach various situations encountered in the workplace. These tests are based on hypothetical scenarios where you will be expected to respond with what you think is the best course of action in that situation.
                              </li>
                             </ul>


                        </li>

                        <li>The total time required to complete all four exercises is 2.5 hours. You can complete them anytime within the assessment window (from [date] to [date]), after which the assessments will no longer be accessible.</li>
                         <li>You do not need to complete all the exercises in one go—you can take them at different times as per your convenience. However, once you start an exercise, you must complete it in a single sitting, as you will not be able to pause and return to it later.</li>
                        
                    </ul>
                    <div class="mt-3 text-center">
                        <input id="Button1" type="button" value="Next" class="btns btn-submit" onclick="closePopup();" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal" id="div2" role="dialog" flg="0">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header pt-1 pb-1">
                    <div class="close" onclick="closePopup();">&times;</div>
                </div>
                <div class="modal-body pt-0">
                    <h3 class="small-heading">Instructions to set you up for success:</h3>
                   <p>For each assessment, please read the section <strong>“Your task”</strong> to understand the specific requirements from you.</p>
                    <p>Use the <strong>“Start Assessment”</strong> button to begin attempting the assessment – time will start from the moment you click “Start Assessment”. Once you click, you will need to complete the full assessment within the allotted time. Please ensure you DO NOT close the window once your assessment starts as the time will still be counting down even if the window is closed.</p>
                    <p>Once you have submitted your responses, you cannot re-attempt the assessment.</p>
                    <p>You don’t need to complete all the exercises in one go—you can take them at different times as per your convenience within the assessment window.<strong> However, once you start an exercise, you must complete it in a single sitting, as you won’t be able to pause and return to it later.</strong></p>
                    <p>You will need to be mindful of the time while attempting the assessment – on exhaustion of the assigned time, the assessment will be automatically submitted, and you will be returned to the overall assessment page.</p>
                    <p>You may face situations where you may not have all requisite information. In such case, you are advised to make assumptions if necessary. Also, you can use your understanding of the workplace practices and norms.</p>
                 <p>Tab switching is restricted during the assessment. Each such attempt will result in an automatic logout. After three violations, your access will be deactivated, and you will be unable to continue the assessment</p>
               
                </div>
                    <div class="mt-3 text-center">
                        <input id="Button2" type="button" value="Next" class="btns btn-submit" onclick="closePopup();" />
                    </div>
                </div>
            </div>
        </div>
    

    <div class="modal" id="div3" role="dialog" flg="0">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header pt-1 pb-1">
                    <div class="close" onclick="closePopup();">&times;</div>
                </div>
                <div class="modal-body pt-0">
                    <h3 class="small-heading">Be Your True Self</h3>
                    <p class="mb-3">While you are to perform the responsibilities of the role assigned, you must still be yourself. Behave the way you would behave in usual workplace situations. You are not being asked to imagine yourself to be someone else nor should your decisions and actions be limited by the practices of your current organization. The idea is to ensure that you perform your role effectively. Do not try to guess what the assessment is looking for</p>
                    <h3 class="small-heading">No right or wrong answer</h3>
                    <p class="mb-3">There are multiple effective approaches you can take to deal with any situation. Also, there is no Pass or Fail declaration (or certification) and no right or wrong answer</p>
                    <h3 class="small-heading">Express and Explain yourself fully</h3>
                    <p>For assessors to understand your perspective and intent fully, respond to cases and situations professionally, completely and clearly. Since we cannot contact you post the assessment to clarify your solutions, it is strongly advised that you keep your responses detailed.</p>
                    <div class="mb-3 text-center">
                        <input id="Button3" type="button" value="Next" class="btns btn-submit" onclick="closePopup();" />
                    </div>
                </div>
            </div>
        </div>
    </div>


    <input type="hidden" id="hdnDiv1" value="0" />
    <input type="hidden" id="hdnDiv2" value="0" />
    <input type="hidden" id="hdnDiv3" value="0" />
</asp:Content>

