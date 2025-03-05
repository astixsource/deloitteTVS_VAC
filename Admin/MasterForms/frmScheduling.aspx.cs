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
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            if (!IsPostBack)
            {
                hdnLogin.Value = Session["LoginId"].ToString();
                GetMaster();
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");
        }
    }

    private void GetMaster()
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAssessmentCycleDetail";
        Scmd.Parameters.AddWithValue("@CycleID", 0);
        Scmd.Parameters.AddWithValue("@Flag", 2);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dtBatch = new DataTable();
        Sdap.Fill(dtBatch);
        Scmd.Dispose();
        Sdap.Dispose();

        ddlBatch.Items.Add(new ListItem("-- Select --", "0"));
        foreach (DataRow dr in dtBatch.Rows)
        {
            ddlBatch.Items.Add(new ListItem(dr["CycleName"].ToString(), dr["CycleId"].ToString()));
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetParticipants(string CycleId)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetParticipantListForCycle";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CysleId", CycleId);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        StringBuilder sb = new StringBuilder();
        sb.Append("<option value='0'>All</option>");
        for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        {
            sb.Append("<option value='" + Ds.Tables[0].Rows[i]["EmpNodeID"] + "'>" + Ds.Tables[0].Rows[i]["FName"] + " ( " + Ds.Tables[0].Rows[i]["EmpCode"] + " )</option>");
        }
        
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId, string Participant)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spAssessmentPopulateAssessorParticipantMapping";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@ParticipantId", Participant);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        string[] SkipColumn = new string[9];
        SkipColumn[0] = "ParticipantAssessorMappingId";
        SkipColumn[1] = "ParticipantId";
        SkipColumn[2] = "AssessorId";
        SkipColumn[3] = "TypeId";
        SkipColumn[4] = "EYAdminId";
        SkipColumn[5] = "DateForWorking";
        SkipColumn[6] = "EYSuperAdminId";
		SkipColumn[7] = "EY Admin";
        SkipColumn[8] = "EY Super Admin";
        return CreateSchedulingTbl(Ds.Tables[0], SkipColumn, "tblScheduling", 2) + "^" + Ds.Tables[1].Rows[0][0].ToString();
    }
    private static string CreateSchedulingTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index)
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
                sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
            }
        }
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr MappingId='" + dt.Rows[i]["ParticipantAssessorMappingId"].ToString() + "' ParticipantId='" + dt.Rows[i]["ParticipantId"].ToString() + "' Exercise='" + dt.Rows[i]["Exercise/Event"].ToString() + "' Participant='" + dt.Rows[i]["Participant Name"].ToString() + "' typeId='" + dt.Rows[i]["TypeId"].ToString() + "' strDate='" + dt.Rows[i]["DateForWorking"].ToString() + "'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (j <= RowMerge_Index)
                    {
                        DataTable temp_dt = dt.Select("[" + dt.Columns[j].ColumnName + "]='" + dt.Rows[i][j].ToString() + "'").CopyToDataTable();
                        if (temp_dt.Rows.Count > 1)
                        {
                            temp_dt.Columns.RemoveAt(j);
                            sb.Append(createRowMergeTbl(SkipColumn, temp_dt, dt.Rows[i][j].ToString(), RowMerge_Index - 1));
                            i = i + temp_dt.Rows.Count - 1;
                            break;
                        }
                        else
                        {
                            if (j > 8 && dt.Rows[i][j].ToString() == "")
                            {
                                sb.Append("<td class='cls-" + j + " cls-bg-gray'>" + dt.Rows[i][j] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                            }
                        }
                    }
                    else
                    {
                        if (j > 8 && dt.Rows[i][j].ToString() == "")
                        {
                            sb.Append("<td class='cls-" + j + " cls-bg-gray'>" + dt.Rows[i][j] + "</td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                        }
                    }
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string createRowMergeTbl(string[] SkipColumn, DataTable dt, string str, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i != 0)
                sb.Append("<tr MappingId='" + dt.Rows[i]["ParticipantAssessorMappingId"].ToString() + "' ParticipantId='" + dt.Rows[i]["ParticipantId"].ToString() + "' Exercise='" + dt.Rows[i]["Exercise/Event"].ToString() + "' Participant='" + str + "' typeId='" + dt.Rows[i]["TypeId"].ToString() + "' strDate='" + dt.Rows[i]["DateForWorking"].ToString() + "'>");
            else
                sb.Append("<td rowspan ='" + dt.Rows.Count + "' >" + str + "</td>");

            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (j <= RowMerge_Index)
                    {
                        DataTable temp_dt = dt.Select("[" + dt.Columns[j].ColumnName + "]='" + dt.Rows[i][j].ToString() + "'").CopyToDataTable();
                        if (temp_dt.Rows.Count > 1)
                        {
                            temp_dt.Columns.RemoveAt(j);
                            sb.Append(createRowMergeTbl(SkipColumn, temp_dt, dt.Rows[i][j].ToString(), RowMerge_Index - 1));
                            i = i + temp_dt.Rows.Count - 1;
                            break;
                        }
                        else
                        {
                            if (j > 7 && dt.Rows[i][j].ToString() == "")
                            {
                                sb.Append("<td class='cls-" + (j + 1).ToString() + " cls-bg-gray'>" + dt.Rows[i][j] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + (j + 1).ToString() + "'>" + dt.Rows[i][j] + "</td>");
                            }
                        }

                    }
                    else
                    {
                        if (j > 7 && dt.Rows[i][j].ToString() == "")
                        {
                            sb.Append("<td class='cls-" + (j + 1).ToString() + " cls-bg-gray'>" + dt.Rows[i][j] + "</td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + (j + 1).ToString() + "'>" + dt.Rows[i][j] + "</td>");
                        }
                    }
                }
            }
            if (i != (dt.Rows.Count - 1))
            {
                sb.Append("</tr>");
            }
        }
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnSave(string CycleId, object obj, string LoginId)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSaveSchedulingData";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@tmpAssessorParticipantMapping", tbl);
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