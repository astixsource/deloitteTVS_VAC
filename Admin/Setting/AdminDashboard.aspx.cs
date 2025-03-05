using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Setting_AdminMenu :  System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] == null)
        {
            Response.Redirect("../../Login.aspx");
        }
        else
        {
            LinkButton lnkBack = (LinkButton)Page.Master.FindControl("lnkBack");
            //lnkBack.Visible = false;
            string flgMenu = Session["RoleId"].ToString();

            dvLinks.InnerHtml = CreateLinks(flgMenu);
        }
    }

    private string CreateLinks(string Menuflg)
    {
        StringBuilder sb = new StringBuilder();

        dvLinks.Style.Add("font-size", "15px");
        switch (Menuflg)
        {
            case "1":
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
                sb.Append("<td rowspan='9' class='col-fst'>Manage Process</td>");
                sb.Append("<td><a href='../MasterForms/frmManageCycle.aspx' class='btn-one col-12'>Batch <br/>Creation & information</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Create new DC-1 batch</li>");
                sb.Append("<li>Edit or delete existing DC-1 batch for which the date has not surpassed yet</li>");
                
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
                sb.Append("<td><ul class='mb-0 pl-3'><li>Map User with a particular DC-1 batch</li></ul></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmScheduling.aspx' class='btn-one col-12'>Participant & Developer<br/> Mapping</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Map selected participants for a given DC-1 batch with Developers</li>");
                sb.Append("<li>View the list of developers mapped to the DC-1 batch and respective number of participants mapped</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr >");
                sb.Append("<td><a href='../MasterForms/frmScheduleMeeting.aspx' class='btn-one col-12'>Schedule<br/> Meeting</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Schedule Meeting/s for a given DC-1 batch.</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmSendEmailInvite.aspx' class='btn-one col-12'>Users Invitation Mail</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Send Invitation Mail to Users</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
  sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmSendEmailInvite_Reminders.aspx' class='btn-one col-12'>Users Reminders Mail</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Send Reminders Mail to Users</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                break;
            case "2":
                sb.Append("<table class='table table-bordered border-left-0 border-right-0'>");
                sb.Append("<tr>");
                sb.Append("<td rowspan='3' class='col-fst'>Current DC</td>");
                sb.Append("<td><a href='#' class='btn-one col-12'>Upcoming <br/>Meetingd</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Upcoming Meetings</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmPartDeveloperStatus.aspx' class='btn-one col-12'>Participant & Developer<br/>Status</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Participant & Developer Status</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td><a href='../MasterForms/frmWashUp.aspx' class='btn-one col-12'>Washup Discussion</a></td>");
                sb.Append("<td>");
                sb.Append("<ul class='mb-0 pl-3'><li>Washup Report</li></ul>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                break;
            default:
                sb.Append("No Menu for this Selection !");
                break;
        }
        return sb.ToString();
    }
}