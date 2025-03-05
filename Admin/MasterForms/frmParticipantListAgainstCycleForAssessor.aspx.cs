using Ionic.Zip;
using LogMeIn.GoToMeeting.Api;
using LogMeIn.GoToMeeting.Api.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Net.Mime;

public partial class Admin_MasterForms_frmParticipantListAgainstCycleForAssessor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Session["LoginID"] = 0;
        //if (Session["LoginID"] == null)
        //{
        //    Response.Redirect("~/Login.aspx");
        //}
        //else
        //{
        //    if (!IsPostBack)
        //    {
        //        hdnLoginId.Value = Session["LoginID"].ToString();
        //    }
        //}
      
        if (Request.QueryString["cycleid"] == null)
        {
            Response.Redirect("~/admin/masterforms/frmAssessorPreDCPostDC.aspx");
        }
        if (!IsPostBack)
        {
            hdnCycleId.Value = Request.QueryString["cycleid"] == null ? "0" : Request.QueryString["cycleid"].ToString();
            hdnCycleName.Value = Request.QueryString["cyclename"] == null ? "0" : Request.QueryString["cyclename"].ToString();
            hdnLoginId.Value = Request.QueryString["LoginId"] == null ? "" : Request.QueryString["LoginId"].ToString();
        }

    }

    [System.Web.Services.WebMethod()]
    public static string fngetdata(int CycleId, string LoginId)
    {


        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetParticipantListAgainstCycleForAssessor";//"[SpVanGetCoveragedetails]";
        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        StringBuilder str = new StringBuilder();
        if (Ds.Tables[0].Rows.Count > 0)
        {
            str.Append("<div id='dvtblbody' class='mb-3'><table id='tbldbrlist' class='table table-bordered table-sm mb-0'><thead><tr>");
           // str.Append("<th style='width:2%;'>Sr.No</th>");
            str.Append("<th style='width:7%;'>Participant Number</th>");
            str.Append("<th style='width:7%;'>Participant Name</th>");
            str.Append("<th style='width:4%;'>Details</th>");
            str.Append("<th style='width:3%;'>Repeat</th>");
            str.Append("</tr></thead><tbody>");

            for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
            {
                str.Append("<tr participantid='" + Ds.Tables[0].Rows[i]["participantid"].ToString() + "' ParticipantNumber='" + Ds.Tables[0].Rows[i]["Participant Number"].ToString() + "' ParticipantName='" + Ds.Tables[0].Rows[i]["Participant Name"].ToString() + "'> ");
               // str.Append("<td style='width:2%;text-align:center;'>" + (i + 1) + "</td>");

                str.Append("<td style='width:7%;text-align:center;'>" + Ds.Tables[0].Rows[i]["Participant Number"].ToString() + "</td>");
                str.Append("<td style='width:7%;text-align:center;'>" + Ds.Tables[0].Rows[i]["Participant Name"].ToString() + "</td>");
                str.Append("<td style='width:4%;text-align:center;'><a href='#' title='View Details' style='color:blue;text-decoration:underline;' onclick='fnView_Details(this)'>View</a></td>");
               // str.Append("<td><input type='checkbox' value='" + i + "' id='Chk_" + i + "' onclick='fnchk(this);'/></td>");
                str.Append("<td style='width:3%;text-align:center;'><input type='checkbox' disabled/></td>");
                str.Append("</tr>");
            }
            str.Append("</tbody></table>");
        }

        return str.ToString();

    }
}