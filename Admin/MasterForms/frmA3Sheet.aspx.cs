using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LogMeIn.GoToMeeting.Api;
using LogMeIn.GoToMeeting.Api.Model;
using LogMeIn.GoToMeeting.Api.Common;
using LogMeIn.GoToCoreLib.Api;
using System.Net.Mail;
using System.Net;
public partial class Mapping : System.Web.UI.Page
{
    void Page_PreInit(object sender, EventArgs e)
    {
        string flgCallType = Request.QueryString["flgCallType"] == null ? "0" : Request.QueryString["flgCallType"].ToString();
        if (flgCallType == "1")
        {
            
            string LoginId = Request.QueryString["LoginID"] == null ? "0" : Request.QueryString["LoginID"].ToString();
            Session["LoginId"] = LoginId;
            this.MasterPageFile = "~/Admin/AdminMaster/SiteFull.master";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            if (!IsPostBack)
            {
                hdnLogin.Value = Session["LoginId"].ToString();

                SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                SqlCommand Scmd = new SqlCommand();
                Scmd.Connection = Scon;
                Scmd.CommandText = "spGetAssessmentCycleListForAssessor";
                Scmd.Parameters.AddWithValue("@LoginId", hdnLogin.Value);
                Scmd.Parameters.AddWithValue("@type", "2");
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.CommandTimeout = 0;
                SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
                DataTable dtBatch = new DataTable();
                Sdap.Fill(dtBatch);
                Scmd.Dispose();
                Sdap.Dispose();
                hdnRoleId.Value = Request.QueryString["RoleId"] == null ? "0" : Request.QueryString["RoleId"].ToString();
                Session["RoleId"] = hdnRoleId.Value;
                if (Convert.ToInt32(dtBatch.Rows[0]["NumberOfParticipants"]) > 0)
                {

                    hdnSeqNo.Value = Request.QueryString["seq"] == null ? "0" : Request.QueryString["seq"].ToString();
                    hdnBatch.Value = dtBatch.Rows[0]["CycleId"].ToString();
                    StringBuilder sbbtns = new StringBuilder();
                    for (int i = 0; i < Convert.ToInt32(dtBatch.Rows[0]["NumberOfParticipants"]); i++)
                    {
                        if ((i+1).ToString() == hdnSeqNo.Value)
                        {
                            sbbtns.Append("<a href='#' class='btn btn-primary active' ind='" + (i + 1).ToString() + "' style='margin-left:20px;' onclick='fnParticipant(this);'>P" + (i + 1).ToString() + "</a>");
                        }
                        else
                        {
                            sbbtns.Append("<a href='#' class='btn btn-primary' ind='" + (i + 1).ToString() + "' style='margin-left:20px;' onclick='fnParticipant(this);'>P" + (i + 1).ToString() + "</a>");
                        }
                    }
                    dvBtns.InnerHtml = sbbtns.ToString();
                }
                else
                {
                    dvMain.InnerHtml = "No Record Found !";
                }
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId, string SeqNo,string RoleId)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetA3Detail";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@SeqNo", SeqNo);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        string[] SkipColumn = new string[2];
        SkipColumn[0] = "CmptncyId";
        SkipColumn[1] = "Score";
        
        return CreateSchedulingTbl(Ds.Tables[0], SkipColumn, "tblScheduling", 2,RoleId);
    }
    private static string CreateSchedulingTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index,string RoleId)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm clsTarget'>");
        sb.Append("<thead class='thead-light text-center'>");
        sb.Append("<tr>");
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
            {
                if (dt.Columns[j].ColumnName.ToString().Trim().Split('|').Length > 1)
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString().Split('|')[0] + "</th>");
                }
                else
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
                }
            }
        }
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim().Split('|')[0]))
                {
                    if (j > 1)
                    {
                        if (!(dt.Rows[i][j].ToString().Split('^').Length > 1))
                        {
                            sb.Append("<td class='cls-" + j + " cls-bg-gray'></td>");
                        }
                        else
                        {
                            if (RoleId == "3")
                            {
                                sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + "'><input type='text' readonly='readonly' class='clsCustomTooltip' title='" + dt.Rows[i][j].ToString().Split('^')[0] + "' value='" + dt.Rows[i][j].ToString().Split('^')[0] + "' onkeydown='fnComment(this," + dt.Columns[j].ColumnName.ToString().Trim().Split('|')[1] + "," + dt.Rows[i]["CmptncyId"] + ")' onclick='fnComment(this," + dt.Columns[j].ColumnName.ToString().Trim().Split('|')[1] + "," + dt.Rows[i]["CmptncyId"] + ")' /></td>");
                            }
                        }
                    }
                    else
                    {
                        sb.Append("<td class='cls-" + j + "' style='background:#" + getColor(dt.Rows[i]["Score"].ToString()) + "'>" + dt.Rows[i][j] + "</td>");
                    }
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string getColor(string score)
    {
        if (Convert.ToDouble(score) == 0)
            return "FFFFFF";
        else if (Convert.ToDouble(score) < 2.5)
            return "FFD9D7";
        else if (Convert.ToDouble(score) < 2.75)
            return "FFFACC";
        else
            return "CEFFDE";
    }
    [System.Web.Services.WebMethod()]
    public static string fnSave(string CycleId, string SeqNo, string exerciseid, string CmptncyId, string Comments, string LoginId)
    {
        try
        {
            HttpContext.Current.Session["LoginId"] = LoginId;
            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spUpdateA3Comments";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@SeqNo", SeqNo);
            Scmd.Parameters.AddWithValue("@exerciseid", exerciseid);
            Scmd.Parameters.AddWithValue("@CmptncyId", CmptncyId);
            Scmd.Parameters.AddWithValue("@Comments", Comments);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            return "0";
        }
        catch (Exception e)
        {
            return ("1");
        }
    }
}