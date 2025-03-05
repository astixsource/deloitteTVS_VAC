using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
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
            LinkButton lnkHome = (LinkButton)Page.Master.FindControl("lnkHome");
            LinkButton lnkBack = (LinkButton)Page.Master.FindControl("lnkBack");
            //lnkHome.Visible = false;
            //lnkBack.Visible = false;
            string RoleId = Session["RoleId"].ToString();
            hdnLogin.Value = Session["LoginId"].ToString();
            if (RoleId == "6")
            {
                divStartOrientationMeeting.Style.Add("display", "block");
                divManageProcess.Style.Add("display", "none");
            }
        }
    }

    protected void lnkProcess_Click(object sender, EventArgs e)
    {
        Session["flgMenu"] = "1";
        Response.Redirect("~/Admin/Setting/AdminDashboard.aspx");
    }
	
	 //protected void lnkReport_Click(object sender, EventArgs e)
  //  {
  //      Session["flgMenu"] = "1";
  //       //Response.Redirect("~/Admin/Setting/ReportDashboard.aspx");
  //      Response.Redirect("~/Admin/MasterForms/frmFinalScore.aspx");
  //  }

    protected void lnkDC_Click(object sender, EventArgs e)
    {
        //SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        //SqlCommand Scmd = new SqlCommand();
        //Scmd.Connection = Scon;
        //Scmd.CommandText = "spGetAssessmentCycleListForAssessor";
        //Scmd.Parameters.AddWithValue("@LoginId", hdnLogin.Value);
        //Scmd.Parameters.AddWithValue("@type", "2");
        //Scmd.CommandType = CommandType.StoredProcedure;
        //Scmd.CommandTimeout = 0;
        //SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        //DataTable dtBatch = new DataTable();
        //Sdap.Fill(dtBatch);
        //Scmd.Dispose();
        //Sdap.Dispose();

        //if (dtBatch.Rows.Count > 0)
        //{
        //    Session["flgMenu"] = "2";
            Response.Redirect("~/Admin/masterForms/frmPartDeveloperStatus.aspx");
        //}
        //else
        //{
        //    dvErrorMsg.InnerHtml = "There is no active DC running !";
        //}
    }

    protected void lnkCaseStudyReports_Click(object sender, EventArgs e)
    {
        //SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        //SqlCommand Scmd = new SqlCommand();
        //Scmd.Connection = Scon;
        //Scmd.CommandText = "spGetAssessmentCycleListForAssessor";
        //Scmd.Parameters.AddWithValue("@LoginId", hdnLogin.Value);
        //Scmd.Parameters.AddWithValue("@type", "2");
        //Scmd.CommandType = CommandType.StoredProcedure;
        //Scmd.CommandTimeout = 0;
        //SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        //DataTable dtBatch = new DataTable();
        //Sdap.Fill(dtBatch);
        //Scmd.Dispose();
        //Sdap.Dispose();

        //if (dtBatch.Rows.Count > 0)
        //{
        //    Session["flgMenu"] = "2";
        Response.Redirect("~/Admin/masterForms/frmDownloadCasestudtyReport.aspx");
        //}
        //else
        //{
        //    dvErrorMsg.InnerHtml = "There is no active DC running !";
        //}
    }
}