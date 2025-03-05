using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_frmDashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Dim panelLogout As Panel
        //panelLogout = DirectCast(Page.Master.FindControl("panelLogout"), Panel)
        //panelLogout.Visible = False

        LinkButton lnkHome = (LinkButton)Page.Master.FindControl("lnkHome");
        //lnkHome.Visible = false;

        if (Session["LoginId"] == null)
        {
            Response.Redirect("../../login.aspx");
            return;
        }

        int roleId = (Session["RoleId"] == null ? 0 : Convert.ToInt32(Session["RoleId"]));

        dvLinks.InnerHtml = CreateLinks(roleId);
    }

    private string CreateLinks(int roleId)
    {
        StringBuilder sb = new StringBuilder();
        switch (roleId)
        {
            case 1:
                dvLinks.Style.Add("font-size", "15px");

                sb.Append("<table class='table table-bordered border-left-0 border-right-0'>");
                sb.Append("<tr>");
                sb.Append("<td style='width:170px; color:#044d91; text-align:center; font-weight: 500;text-transform: uppercase;'>View Status</td>");
                sb.Append("</td>");
                sb.Append("<td style='line-height:'><a href='../Setting/frmAssignExcercise.aspx' class='btn-one col-12'>Participant <br/>Exercise Status</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>View the progress of participant exercise and developer rating</li>");
                sb.Append("<li>Download the assessment report of participants for previous DC-4 batches</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td colspan='3' class='border-0'><div class='bg-primary' style='height:4px;'>&nbsp;</div></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td rowspan='8' style='width:170px; color:#044d91; text-align:center; font-weight: 500;text-transform: uppercase;'>Manage Process</td>");
                sb.Append("<td><a href='../MasterForms/frmManageCycle.aspx' class='btn-one col-12'>Batch <br/>Creation & information</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Create new DC-4 batch</li>");
                sb.Append("<li>Edit or delete existing DC-4 batch for which the date has not surpassed yet</li>");
                sb.Append("<li>View the number of participants and developers mapped</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmManageEmployeeDetails.aspx' class='btn-one col-12'>Manage User <br/>Information</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Create new user information</li>");
                sb.Append("<li>Edit or delete existing users for which the assement has not started as yet</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmMapping.aspx' class='btn-one col-12'>Batch Mapping <br/>With User</a></td>");
                sb.Append("<td><ul class='mb-0 pl-3'><li>Map User with a particular DC-4 batch</li></ul></td>");
                sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmMapping.aspx?flg=2' class='btn-one col-12'>Batch Mapping <br/>With Developer</a></td>");
                //sb.Append("<td><ul class='mb-0 pl-3'><li>Map developers with a particular DC-4 batch</li></ul></td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmMapping.aspx?flg=3' class='btn-one col-12'>Batch Mapping <br/>With EY Admin</a></td>");
                //sb.Append("<td><ul class='mb-0 pl-3'><li>Map EY Admin with a particular DC-4 batch</li></ul></td>");
                //sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmScheduling.aspx' class='btn-one col-12'>Participant & Developer<br/> Mapping</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Map selected participants for a given DC-4 batch with Developers</li>");
                sb.Append("<li>View the list of developers mapped to the DC-4 batch and respective number of participants mapped</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmScheduleMeeting.aspx' class='btn-one col-12'>Schedule<br/> Meeting</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Schedule Meeting/s for a given DC-4 batch.</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmSendEmailInvite.aspx' class='btn-one col-12'>Users Invitation Mail</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Send Invitation Mail to Users</li></ul>");                
                sb.Append("</td>");
                sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmSendReminderToAssessorForPenPictureFeedback.aspx' class='btn-one col-12'>Developer Reminder Mail</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Send Reminder to Developer for Pen Picture Feedback Status</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");

                /*sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmParticipantFeedbackStatus.aspx' class='btn-one col-12'>Participant Feedback</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Please click here to conduct feedback meeting for a given DC-4 batch</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");*/

                sb.Append("</table>");
                //btnGI.Style.Add("display", "none");
                btnGI.Attributes.Add("style", "display:none");
                return sb.ToString();
            case 3:
                dvLinks.Style.Add("font-size", "15px");
                pgsubtitle.InnerHtml = "Assessor Home Page";

                sb.Append("<table class='table table-bordered border-left-0 border-right-0'>");
                //sb.Append("<tr>");
                //sb.Append("<td rowspan='2' style='width:170px; color:#044d91; text-align:center; font-weight: 500;text-transform: uppercase;'>View Status</td>");
                //sb.Append("<td style='width:235px'><a href='../Setting/frmAssignExcercise.aspx' class='btn-one col-12'>Participant <br/>Exercise Status</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>View participant progress on a given DC-4 batch</li>");
                //sb.Append("<li>Download automatically generated report of participants (available for previous DC-4 batches)</li>");
                //sb.Append("<li>Access shortcut to manage BEI scheduling</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");

                //sb.Append("<tr>");
                //sb.Append("<td><a href='#' class='btn-one col-12' id='btncasesutdy_one'>Case <br/>Study</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Please click here for Case Study reading.</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");

                //sb.Append("<tr>");
               // sb.Append("<td colspan='3' class='border-0'><div class='bg-primary' style='height:4px;'>&nbsp;</div></td>");
                //sb.Append("</tr>");


               
                //sb.Append("<tr>");
                //sb.Append("<td rowspan='4' style='width:170px; color:#044d91; text-align:center; font-weight: 500;text-transform: uppercase;'>Manage Process</td>");
                //sb.Append("<td><a href='../MasterForms/frmGetParticipantListAgAssessor.aspx' class='btn-one col-12'>Start Meeting</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Click here to start meeting with participants mapped to you</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");

               // sb.Append("<tr>");              
               //sb.Append("<td><a href='../Evidence/RatingStatus.aspx' class='btn-one col-12'>Participant <br/>Rating</a></td>");
               //sb.Append("<td>");
               // sb.Append("<ul class='mb-0 pl-3'>");
               // sb.Append("<li>Complete rating of cues based</li></ul>");
               // sb.Append("</td>");
               // sb.Append("</tr>");

                sb.Append("<tr>");
                sb.Append("<td><a href='../Evidence/frmParticipantListForRating.aspx' class='btn-one col-12'>Manager Assessment Form</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'>");
                sb.Append("<li>Complete rating of cues based</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");

                sb.Append("</table>");

                return sb.ToString();
            case 4:
                sb.Append("<a href='Pearson/UserResultUplaodByPearson.aspx' class='btn-one'>Upload Result</a>");
                return sb.ToString();
            case 6:
                dvLinks.Style.Add("font-size", "15px");

                sb.Append("<table class='table table-bordered border-left-0 border-right-0'>");
                //sb.Append("<tr>");
                //sb.Append("<td style='width:170px; color:#044d91; text-align:center; font-weight: 500;text-transform: uppercase;'>View Status</td>");
                //sb.Append("</td>");
                //sb.Append("<td style='line-height:'><a href='../Setting/frmAssignExcercise.aspx' class='btn-one col-12'>Participant <br/>Exercise Status</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>View the progress of participant exercise and developer rating</li>");
                //sb.Append("<li>Download the assessment report of participants for previous DC-4 batches</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td colspan='3' class='border-0'><div class='bg-primary' style='height:4px;'>&nbsp;</div></td>");
                //sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style='width:170px; color:#044d91; text-align:center; font-weight: 500;text-transform: uppercase;'>Manage Process</td>");
                //sb.Append("<td><a href='../MasterForms/frmManageCycle.aspx' class='btn-one col-12'>Batch <br/>Creation & information</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Create new DC-4 batch</li>");
                //sb.Append("<li>Edit or delete existing DC-4 batch for which the date has not surpassed yet</li>");
                //sb.Append("<li>View the number of participants and developers mapped</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmManageEmployeeDetails.aspx' class='btn-one col-12'>Manage User <br/>Information</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Create new user information</li>");
                //sb.Append("<li>Edit or delete existing users for which the assement has not started as yet</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmMapping.aspx' class='btn-one col-12'>Batch Mapping <br/>With User</a></td>");
                //sb.Append("<td><ul class='mb-0 pl-3'><li>Map User with a particular DC-4 batch</li></ul></td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmMapping.aspx?flg=2' class='btn-one col-12'>Batch Mapping <br/>With Developer</a></td>");
                //sb.Append("<td><ul class='mb-0 pl-3'><li>Map developers with a particular DC-4 batch</li></ul></td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmMapping.aspx?flg=3' class='btn-one col-12'>Batch Mapping <br/>With EY Admin</a></td>");
                //sb.Append("<td><ul class='mb-0 pl-3'><li>Map EY Admin with a particular DC-4 batch</li></ul></td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmScheduling.aspx' class='btn-one col-12'>Participant & Developer<br/> Mapping</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Map selected participants for a given DC-4 batch with Developers</li>");
                sb.Append("<li>View the list of developers mapped to the DC-4 batch and respective number of participants mapped</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmScheduleMeeting.aspx' class='btn-one col-12'>Schedule<br/> Meeting</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Schedule Meeting/s for a given DC-4 batch.</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmSendCredentialsToParticipant.aspx' class='btn-one col-12'>Participant Invitation Mail</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Send Invitation Mail to Mapped participant</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");
                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmSendReminderToAssessorForPenPictureFeedback.aspx' class='btn-one col-12'>Developer Reminder Mail</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Send Reminder to Developer for Pen Picture Feedback Status</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");

                //sb.Append("<tr>");
                //sb.Append("<td><a href='../MasterForms/frmParticipantFeedbackStatus.aspx' class='btn-one col-12'>Participant Feedback</a></td>");
                //sb.Append("<td>");
                //sb.Append("<ul class='mb-0 pl-3'><li>Please click here to conduct feedback meeting for a given DC-4 batch</li></ul>");
                //sb.Append("</td>");
                //sb.Append("</tr>");

                sb.Append("</table>");
                //btnGI.Style.Add("display", "none");
                btnGI.Attributes.Add("style", "display:none");
                return sb.ToString();
            default:
                sb.Append("<a href='../login.aspx' class='btn-one'>Logout</a>");
                return sb.ToString();
        }

    }
}