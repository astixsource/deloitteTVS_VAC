<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster/Site.master" AutoEventWireup="true" CodeFile="frmSelfie.aspx.cs" Inherits="Admin_Setting_frmSelfie" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../../Scripts/webcamSelfieV5Main.js"></script>
    <style>
        .main-box{
            zoom:84% !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentTimer" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
     <div class="section-title">
        <h3 class="text-center">Register Selfie</h3>
        <div class="title-line-center"></div>
    </div>
    <div style="margin:auto 0">
            <table style="width:100%">
                <tr>
                    <td class="text-center" style="width:45%;vertical-align:top">
                        <div style="width:350px;">
                        <video style="width:100%;object-fit:contain" id="video" controls autoplay ></video>
                            </div>
                    </td>
                    <td colspan="2" style="vertical-align:top">
                        <div>
                            <ul>
                                <li>When you click on next, you will be directed to the next page where you will be required to click 3 selfies.</li>
                                <li>Please ensure your camera is switched on and provide Google Chrome with permission to use your camera.</li>
                                <li>Refer to the link <a href="https://support.google.com/chrome/answer/2693767?hl=en&co=GENIE.Platform%3DDesktop" target="_blank" style="color:blue;text-decoration:underline">"Enable Camera</a> to view how to enable your camera.</li>
                                <li>You are required to take 3 selfie pictures.</li>
                                <li style="list-style-type:none">
                                    <ul>
                                        <li>
                                            Facing the camera – For this picture, face and look into the camera. Ensure your face covers at least 50% of the image being clicked.
                                        </li>
                                        <li>Left side profile – For this picture, turn your head left around 30% and then look into the camera.</li>
                                        <li>Right side profile – For this picture, turn your head right around 30% and then look into the camera.</li>
                                    </ul>
                                </li>
                                <li>
                                    You will see your live picture from the camera. Then click on the ‘Click Selfie button’ to complete the picture. Review the picture taken and if it is OK, click on ‘Save Selfie’. If the picture is not clear or you wish to click again, simply repeat the process BEFORE clicking on ‘Save Selfie’.
                                </li>
                            </ul>
                        </div>
                        <div style="text-align:center">
                        <input type="button" class="btns btn-submit" value="Save Selfie & Continue" onclick="fnSaveContinue()" />
                            </div>
                    </td>
                </tr>
                <tr>
                    <td class="text-center">Facing the camera</td><td class="text-center">Left side profile </td><td class="text-center">Right side profile</td>
                </tr>
                <tr>
                    <td  class="text-center">
                        <canvas  id="myCanvas1" width="350" height="262" style="border:1px solid #c0c0c0"></canvas>
                    </td>
                    <td  class="text-center">
                        <canvas  id="myCanvas2" width="350" height="262" style="border:1px solid #c0c0c0"></canvas>
                    </td>
                    <td  class="text-center">
                        <canvas  id="myCanvas3" width="350" height="262" style="border:1px solid #c0c0c0"></canvas>
                    </td>
                </tr>
                <tr>
                    <td  class="text-center">
                        <input type="button" class="btns btn-submit" value="Take Selfie" onclick="snapshot('myCanvas1')" />
                    </td>
                    <td  class="text-center">
                        <input type="button" class="btns btn-submit" value="Take Selfie" onclick="snapshot('myCanvas2')" />
                    </td>
                    <td  class="text-center">
                        <input type="button" class="btns btn-submit" value="Take Selfie" onclick="snapshot('myCanvas3')" />
                    </td>
                </tr>
            </table>
    </div>
    <input type="hidden" id="hdnIsProctoringEnabled" value="0" runat="server" />
    <input type="hidden" id="hdnLoginID" runat="server" />
    <input type="hidden" id="hdnBandId" runat="server" />
    <input type="hidden" id="hdnFolderName" runat="server" />
</asp:Content>

