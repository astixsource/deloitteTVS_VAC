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
using System.IO;
using ClosedXML.Excel;

public partial class Mapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] == null)
        {
            Response.Redirect("../../Login.aspx");
            return;
        }
        else if (Session["LoginId"].ToString() == "0")
        {
            Response.Redirect("../../Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            hdnLogin.Value = Session["LoginId"].ToString();
            GetMaster();
        }
    }

    private void GetMaster()
    {
        //SqlCommand Scmd = new SqlCommand();
        //Scmd.Connection = Scon;
        //Scmd.CommandText = "spGetAllEmployeeDetailsForMappingToCycle";
        //Scmd.CommandType = CommandType.StoredProcedure;
        //Scmd.CommandTimeout = 0;
        //Scmd.Parameters.AddWithValue("@TypeID", hdnFlg.Value);
        //SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        //DataSet Ds = new DataSet();
        //Sdap.Fill(Ds);
        //Scmd.Dispose();
        //Sdap.Dispose();

        //StringBuilder sb = new StringBuilder();
        //sb.Append("<option value='0'>-- Select --</option>");
        //for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        //{
        //    sb.Append("<option value='" + Ds.Tables[0].Rows[i]["EmpNodeID"] + "'>" + Ds.Tables[0].Rows[i]["FName"] + " ( " + Ds.Tables[0].Rows[i]["EmpCode"] + " )</option>");
        //}
        //hdnUserlst.Value = sb.ToString();

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAssessmentCycleDetail";
        Scmd.Parameters.AddWithValue("@CycleID", 0);
        Scmd.Parameters.AddWithValue("@Flag", 0);
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
            ddlBatch.Items.Add(new ListItem(dr["CycleName"].ToString() + " ( " + Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy") + " )", dr["CycleId"].ToString()));
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRptGetParticipantDeveloperStatus";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);

            string[] SkipColumn = new string[2];
            SkipColumn[0] = "EmpNodeID";
            SkipColumn[1] = "ParticipantCycleMappingId";

            string[] ColorCode = new string[4];
            ColorCode[0] = "#B1B1B1";
            ColorCode[1] = "#FFFACC";
            ColorCode[2] = "#CEFFDE";
            ColorCode[3] = "#fecddf";

            string[] strIcon = new string[8];
            strIcon[0] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[1] = "";// "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[2] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[3] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[4] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[5] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[6] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            strIcon[7] = "<i class='fa fa-download' onclick='fnAssessorRating(this);' style='padding-left:20px;'></i>";
            return CreateSchedulingTbl(Ds.Tables[0], SkipColumn, "tblScheduling", 2, ColorCode, strIcon) + "~" + Ds.Tables[1].Rows[0][0].ToString();
        }
        catch (Exception ex)
        {
            SendErrorMail("Error in Bosch : Part Dev Status", "Error : " + ex.Message + "<br/>SP : spRptGetParticipantDeveloperStatus<br/>CycleId : " + CycleId);
            return "|";
        }
    }
    private static string CreateSchedulingTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index, string[] ColorCode, string[] strIcon)
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
                if (dt.Columns[j].ColumnName.ToString().Trim().Split('^').Length > 1)
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "</th>");
                }
                else
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
                }
            }
        }
        //sb.Append("<th>Action</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr empId='"+ dt.Rows[i]["EmpNodeID"].ToString() + "'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (j <= RowMerge_Index)
                    {
                            if (dt.Rows[i][j].ToString().Split('^').Length > 1)
                            {
                                if (dt.Rows[i][j].ToString().Split('^')[3] == "1")
                                {
                                    sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                                }
                                else
                                {
                                    if (dt.Rows[i][j].ToString().Split('^')[1] == "2")
                                    {
                                        if (dt.Rows[i][j].ToString().Split('^')[5] == "1")
                                        {
                                            sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                                        }
                                        else
                                        {
                                            sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + " " + strIcon[Convert.ToInt32(dt.Columns[j].ColumnName.ToString().Split('^')[1])] + "</td>");
                                        }
                                    }
                                    else
                                    {
                                        sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                                    }
                                }
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                            }
                    }
                    else
                    {
                        if (dt.Rows[i][j].ToString().Split('^').Length > 1)
                        {
                            if (dt.Rows[i][j].ToString().Split('^')[3] == "1")
                            {
                                sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                            }
                            else
                            {
                                if (dt.Rows[i][j].ToString().Split('^')[1] == "2")
                                {
                                    if (dt.Rows[i][j].ToString().Split('^')[5] == "1")
                                    {
                                        sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "<i class='fa fa-file-text' style='padding-left:20px;color:green;cursor:default' title='Rating Done' ></i></td>");
                                    }
                                    else
                                    {
                                        sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + " " + strIcon[Convert.ToInt32(dt.Columns[j].ColumnName.ToString().Split('^')[1])] + "</td>");
                                    }
                                }
                                else
                                {
                                    sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                                }
                            }
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                        }
                    }
                }
            }
           // sb.Append("<td class='cls-99'><input type='radio' name='Participant' onclick='fnSelectPart();' /></td>");
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string createRowMergeTbl(string[] SkipColumn, DataTable dt, string str, int RowMerge_Index, string[] ColorCode, string[] strIcon)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i != 0)
                sb.Append("<tr empId='" + dt.Rows[i]["EmpNodeID"].ToString() + "'>");
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
                            sb.Append(createRowMergeTbl(SkipColumn, temp_dt, dt.Rows[i][j].ToString(), RowMerge_Index - 1, ColorCode, strIcon));
                            i = i + temp_dt.Rows.Count - 1;
                            break;
                        }
                        else
                        {
                            if (dt.Rows[i][j].ToString().Split('^').Length > 1)
                            {
                                if (dt.Rows[i][j].ToString().Split('^')[3] == "1")
                                {
                                    sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "<a href='#' class='btn btn-primary clstdbtn' onclick='fnGotoMeeting(this);'>Join<br/>Meeting</a></td>");
                                }
                                else
                                {
                                    if (dt.Rows[i][j].ToString().Split('^')[1] == "2")
                                    {
                                        if (dt.Rows[i][j].ToString().Split('^')[5] == "1")
                                        {
                                            sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "<i class='fa fa-file-text' style='padding-left:20px;color:green'></i></td>");
                                        }
                                        else
                                        {
                                            sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + " " + strIcon[Convert.ToInt32(dt.Columns[j].ColumnName.ToString().Split('^')[1])] + "</td>");
                                        }
                                    }
                                    else
                                    {
                                        sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                                    }
                                }
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + (j + 1).ToString() + "'>" + dt.Rows[i][j] + "</td>");
                            }
                        }

                    }
                    else
                    {
                        if (dt.Rows[i][j].ToString().Split('^').Length > 1)
                        {
                            if (dt.Rows[i][j].ToString().Split('^')[3] == "1")
                            {
                                sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "<a href='#' class='btn btn-primary' onclick='fnGotoMeeting(this);'>Join<br/>Meeting</a></td>");
                            }
                            else
                            {
                                if (dt.Rows[i][j].ToString().Split('^')[1] == "2")
                                {
                                    if (dt.Rows[i][j].ToString().Split('^')[5] == "1")
                                    {
                                        sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "<i class='fa fa-file-text' style='padding-left:20px;color:green;cursor:default' title='Rating Done' ></i></td>");
                                    }
                                    else
                                    {
                                        sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + " " + strIcon[Convert.ToInt32(dt.Columns[j].ColumnName.ToString().Split('^')[1])] + "</td>");
                                    }
                                }
                                else
                                {
                                    sb.Append("<td class='cls-" + j + " clsCustomTooltip' RspExcersiceId='" + dt.Rows[i][j].ToString().Split('^')[0] + "' style='cursor:pointer; background:" + ColorCode[Convert.ToInt32(dt.Rows[i][j].ToString().Split('^')[1])] + "' fileName='" + dt.Rows[i]["Participant Name"].ToString() + "_" + dt.Columns[j].ColumnName.ToString().Split('^')[2] + "' title='" + GetToolTip(dt.Rows[i][j].ToString().Split('^')[2]) + "'>" + dt.Rows[i][j].ToString().Split('^')[4] + "</td>");
                                }
                            }
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
                sb.Append("<td class='cls-99'><input type='radio' name='Participant' onclick='fnSelectPart();' /></td>");
                sb.Append("</tr>");
            }
        }
        return sb.ToString();
    }
    private static string GetToolTip(string str)
    {
        String[] strArr = str.ToString().Split('|');
        StringBuilder sb = new StringBuilder();
        sb.Append("<table class=\"clstooltiptbl\">");
        sb.Append("<tr>");
        sb.Append("<th></th><th>Scheduled</th><th>Actual</th>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td>Preparation Time </td><td>" + (strArr[0] == "-"?"": strArr[0]) + "</td><td>" + (strArr[1] == "-" ? "" : strArr[1]) + "</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td>Meeting Time</td><td>" + (strArr[2] == "-" ? "" : strArr[2]) + "</td><td>" + (strArr[3] == "-" ? "" : strArr[3]) + "</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td>Assessor Name</td><td colspan=\"2\">" + strArr[4] + "</td>");
        sb.Append("</tr>");
        //sb.Append("<tr>");
        //sb.Append("<td>EYAdmin Name</td><td colspan=\"2\">" + strArr[5] + "</td>");
        //sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td>Status</td><td colspan=\"2\">" + strArr[6] + "</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        return sb.ToString();
    }
    //[System.Web.Services.WebMethod()]
    //public static string fnInBasket(string RspExcersice, string LoginId)
    //{
    //    try
    //    {
    //        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
    //        SqlCommand Scmd = new SqlCommand();
    //        Scmd.Connection = Scon;
    //        Scmd.CommandText = "spGetInBasketBasketReponseScore";
    //        Scmd.CommandType = CommandType.StoredProcedure;
    //        Scmd.Parameters.AddWithValue("@RSPExerciseId", RspExcersice);
    //        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
    //        Scmd.CommandTimeout = 0;
    //        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
    //        DataSet Ds = new DataSet();
    //        Sdap.Fill(Ds);
    //        string[] SkipColumn = new string[3];
    //        SkipColumn[0] = "NodeID";
    //        SkipColumn[1] = "Pros";
    //        SkipColumn[2] = "Cons";
    //        return "0^" + CreateInBasketTbl(Ds.Tables[0], SkipColumn, "tblInBasket");
    //    }
    //    catch (Exception e)
    //    {
    //        return ("1");
    //    }
    //}
    //private static string CreateInBasketTbl(DataTable dt, string[] SkipColumn, string tblname)
    //{
    //    StringBuilder sb = new StringBuilder();
    //    StringBuilder sb_disabled = new StringBuilder();
    //    sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm'>");
    //    sb.Append("<thead class='thead-light text-center'>");
    //    sb.Append("<tr>");
    //    for (int j = 0; j < dt.Columns.Count; j++)
    //    {
    //        if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
    //        {
    //            sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
    //        }
    //    }
    //    sb.Append("<th>Comments</th>");
    //    sb.Append("</tr>");
    //    sb.Append("</thead>");
    //    sb.Append("<tbody>");
    //    for (int i = 0; i < dt.Rows.Count; i++)
    //    {
    //        sb.Append("<tr competencyId='" + dt.Rows[i]["NodeID"] + "'>");
    //        for (int j = 0; j < dt.Columns.Count; j++)
    //        {
    //            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim().Split('|')[0]))
    //            {
    //                if (dt.Columns[j].ColumnName.ToString().Trim().Split('|')[0] == "FinalScore")
    //                {
    //                    //sb.Append("<td class='cls-" + j + "' style='vertical-align:middle'><input type='text' onkeypress='return isNumericWithOneDecimal(event, this)' onmousedown='whichButton(event)' onkeydown='return noCTRL(event)' value='" + dt.Rows[i][j] + "'></td>");
    //                    //sb.Append("<td class='cls-" + j + "' defval='" + dt.Rows[i][j] + "'>" + sbScore.ToString() + "</td>");
    //                    string score = "2.50";
    //                    if (dt.Rows[i][j].ToString() != "" && Convert.ToDouble(dt.Rows[i][j]) > 1.40)
    //                    {
    //                        score = dt.Rows[i][j].ToString();
    //                    }
    //                    sb.Append("<td class='cls-" + j + "'><i class='fa fa-minus-circle pointer' onclick='fnMinusScore(this);'></i><span class='clsScore'>" + score + "</span><i class='fa fa-plus-circle pointer' onclick='fnAddScore(this);'></i></td>");
    //                }
    //                else
    //                {
    //                    sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
    //                }
    //            }
    //        }
    //        sb.Append("<td class='cls-99'><span>Pros : </span><input type='text' iden='Pros' value='" + dt.Rows[i]["Pros"] + "' onkeydown='fnProsCons(this,1);' onclick='fnProsCons(this,1);'/><br/><span>Cons : </span><input type='text' iden='Cons' value='" + dt.Rows[i]["Cons"] + "'  onkeydown='fnProsCons(this,1);' onclick='fnProsCons(this,2);'/></td>");
    //        sb.Append("</tr>");
    //    }
    //    sb.Append("</tbody>");
    //    sb.Append("</table>");
    //    return sb.ToString();
    //}
    //[System.Web.Services.WebMethod()]
    //public static string fnSaveInBasketEval(object obj, string LoginId, string CycleId)
    //{
    //    try
    //    {
    //        string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
    //        DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
    //        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
    //        SqlCommand Scmd = new SqlCommand();
    //        Scmd.Connection = Scon;
    //        Scmd.CommandText = "spPopulateRSPInsbasketResponse";
    //        Scmd.CommandType = CommandType.StoredProcedure;
    //        Scmd.Parameters.AddWithValue("@udt_InBasketResponse", tbl);
    //        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
    //        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
    //        Scmd.CommandTimeout = 0;
    //        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
    //        DataSet Ds = new DataSet();
    //        Sdap.Fill(Ds);
    //        return "0";
    //    }
    //    catch (Exception e)
    //    {
    //        return ("1");
    //    }
    //}
    //[System.Web.Services.WebMethod()]
    //public static string fnMarkInbasketFinalSubmit(string LoginId, string RspExerciseId)
    //{
    //    SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
    //    try
    //    {
    //        SqlCommand Scmd = new SqlCommand();
    //        Scmd.Connection = Scon;
    //        Scmd.CommandText = "spMarkInbasketFinalSubmit";
    //        Scmd.CommandType = CommandType.StoredProcedure;
    //        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
    //        Scmd.Parameters.AddWithValue("@RspExerciseId", RspExerciseId);
    //        Scmd.CommandTimeout = 0;
    //        Scon.Open();
    //        Scmd.ExecuteNonQuery();
    //        return "0";
    //    }
    //    catch (Exception e)
    //    {
    //        return "1";
    //    }
    //    finally
    //    {
    //        Scon.Dispose();
    //    }
    //}

    [System.Web.Services.WebMethod()]
    public static string fnGotoMeeting(string RspExcersice, string batch)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spGetAssesseMeetingLink";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", batch);
            Scmd.Parameters.AddWithValue("@RspExerciseId", RspExcersice);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            return "0^" + Ds.Tables[0].Rows[0][0].ToString();
        }
        catch (Exception e)
        {
            return ("1");
        }
    }
    protected void btnDownload_Click(object sender, EventArgs e)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spRatingAssessorGetRSPExerciseFullDetail_PopUp";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@RSPExerciseId", hdnRSPExcersice.Value);
        Scmd.Parameters.AddWithValue("@LoginId", hdnLogin.Value);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        string[] SkipColumn = new string[1];
        SkipColumn[0] = "QstnID";

        DataTable dt = Ds.Tables[0];
        try
        {
            using (XLWorkbook wb = new XLWorkbook())
            {
                int i = 0, j = 0, m = 1, n = 1;
                string strSheetName = "Rating";
                var ws = wb.Worksheets.Add(strSheetName);
                for (j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                    {
                        ws.Cell(m, n).Value = dt.Columns[j].ColumnName.ToString().Split('|')[0];
                        ws.Cell(m, n).Style.Fill.BackgroundColor = XLColor.FromHtml("#D2D5D7");
                        ws.Cell(m, n).Style.Font.FontColor = XLColor.FromHtml("#000");
                        ws.Cell(m, n).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                        ws.Cell(m, n).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                        ws.Cell(m, n).Style.Font.Bold = true;
                        ws.Cell(m, n).Style.Alignment.WrapText = true;
                        //ws.Cell(m, n).Style.Font.FontName = "Arial";
                        //ws.Cell(m, n).Style.Font.FontSize = 10;

                        n++;
                    }
                }

                m++;
                if (dt.Rows.Count > 0)
                {
                    int cnt = 0; int startcnt = 2; string OldCompetency = "";
                    for (i = 0; i < dt.Rows.Count; i++, m++)
                    {
                        n = 1;
                        for (j = 0; j < dt.Columns.Count; j++)
                        {
                            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                            {
                                ws.Cell(m, n).Value = "'" + dt.Rows[i][j].ToString();
                                ws.Cell(m, n).Style.Fill.BackgroundColor = XLColor.FromHtml("#F1F2F3");
                                ws.Cell(m, n).Style.Font.FontColor = XLColor.FromHtml("#000");
                                ws.Cell(m, n).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                                if (dt.Columns[j].ColumnName.ToString().Trim() == "FinalScore")
                                {
                                    ws.Cell(m, n).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                                }
                                ws.Cell(m, n).Style.Alignment.WrapText = true;

                                n++;
                            }
                        }
                        if (OldCompetency != "")
                        {
                            if (OldCompetency != dt.Rows[i]["Competency"].ToString())
                            {
                                
                                ws.Range(ws.Cell(startcnt, 1), ws.Cell(startcnt + (cnt-1), 1)).Merge();
                                ws.Range(ws.Cell(startcnt, 4), ws.Cell(startcnt + (cnt - 1), 4)).Merge();
                                ws.Range(ws.Cell(startcnt, 5), ws.Cell(startcnt + (cnt - 1), 5)).Merge();
                                ws.Range(ws.Cell(startcnt, 6), ws.Cell(startcnt + (cnt - 1), 6)).Merge();
                                ws.Range(ws.Cell(startcnt, 6), ws.Cell(startcnt + (cnt - 1), 6)).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                                startcnt = startcnt + (cnt);
                                cnt = 0;
                            }
                        }

                        cnt++;
                        OldCompetency = dt.Rows[i]["Competency"].ToString();
                    }
                    ws.Range(ws.Cell(startcnt, 1), ws.Cell(startcnt + (cnt - 1), 1)).Merge();
                    ws.Range(ws.Cell(startcnt, 4), ws.Cell(startcnt + (cnt - 1), 4)).Merge();
                    ws.Range(ws.Cell(startcnt, 5), ws.Cell(startcnt + (cnt - 1), 5)).Merge();
                    ws.Range(ws.Cell(startcnt, 6), ws.Cell(startcnt + (cnt - 1), 6)).Merge();
                    ws.Range(ws.Cell(startcnt, 6), ws.Cell(startcnt + (cnt - 1), 6)).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                    startcnt = startcnt + (cnt);
                    cnt = 0;
                }
                else
                {
                    n = 1;
                    for (j = 0; j < dt.Columns.Count; j++)
                    {
                        if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                        {
                            ws.Cell(m, n).Value = "";
                            ws.Cell(m, n).Style.Fill.BackgroundColor = XLColor.FromHtml("#F1F2F3");
                            ws.Cell(m, n).Style.Font.FontColor = XLColor.FromHtml("#000");
                            ws.Cell(m, n).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                            ws.Cell(m, n).Style.Alignment.WrapText = true;

                            n++;
                        }
                    }
                    m++;
                }

                IXLCell cell3 = ws.Cell(1, 1);
                IXLCell cell4 = ws.Cell(dt.Rows.Count + 1, dt.Columns.Count - 1);
                ws.Range(cell3, cell4).Style.Font.FontName = "Calibri Light";
                ws.Range(cell3, cell4).Style.Font.FontSize = 9.5;
                ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                ws.Columns(1, 1).Width = 30;
                ws.Columns(2, 2).Width = 60;
                ws.Columns(3, 3).Width = 30;
                ws.Columns(4, 4).Width = 12;

                //Export the Excel file.
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + hdnFileName.Value + "_" + DateTime.Now.ToString("dd_MMM_yyyy_hhmmsstt") + ".xlsx");
                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    wb.SaveAs(MyMemoryStream);
                    MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                    HttpContext.Current.Response.Flush();
                    HttpContext.Current.Response.End();
                }
            }
        }
        catch (Exception ex)
        {
            //
        }
        finally
        {
            Sdap.Dispose();
            Scmd.Dispose();
            Scon.Dispose();
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnShowInBasketMails(string RspExcersice)
    {
        string strresponse = "";
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spGetParticipantInBoxExerciseDetail";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@RSPExerciseId", RspExcersice);
            //Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);

            string[] SkipColumn = new string[3];
            SkipColumn[0] = "UserMailResponseID";
            SkipColumn[1] = "Pros";
            SkipColumn[2] = "Cons";
            StringBuilder str = new StringBuilder();
            //str.Append("<div class='clsEvaluation'><input class='btn btn-primary' value='Evaluation' RspExcersiceId='" + RspExcersice + "' onclick='fnInBasket(this)' type='button' /></div>");
            foreach (DataRow drow in Ds.Tables[0].Rows)
            {
				string MailPriority = drow["PriorityName"].ToString();
                str.Append("<div class='clsMailParent'><div class='clsMailHeader'>" + drow["MailName"].ToString() + "</div>");
                DataRow[] dChildrows = Ds.Tables[1].Select("UserMailResponseID=" + drow["UserMailResponseID"].ToString());
                foreach (DataRow dChildrow in dChildrows)
                {
                    str.Append("<div class='clsMailSuject'>");
                    str.Append("<table>");
                    str.Append("<tr>");
                    str.Append("<td>From</td><td>:</td><td>" + dChildrow["MailFrom"].ToString() + "</td>");
                    str.Append("</tr>");
                    str.Append("<tr>");
                    str.Append("<td>To</td><td>:</td><td>" + dChildrow["MailTo"].ToString() + "</td>");
                    str.Append("</tr>");
                    str.Append("<tr>");
                    str.Append("<td>Cc</td><td>:</td><td>" + dChildrow["MailCc"].ToString() + "</td>");
                    str.Append("</tr>");
                    str.Append("<tr>");
                    str.Append("<td>BCc</td><td>:</td><td>" + dChildrow["MailBCC"].ToString() + "</td>");
                    str.Append("</tr>");
                    str.Append("<tr>");
                    str.Append("<td>Subject</td><td>:</td><td>" + dChildrow["MailSubject"].ToString() + "</td>");
                    str.Append("</tr>");
					 str.Append("<tr>");
                    str.Append("<td>Mail Priority</td><td>:</td><td>" + MailPriority + "</td>");
                    str.Append("</tr>");
                    str.Append("</table>");
                    str.Append("</div>");
                    str.Append("<div class='clsMailMailBody'>" + HttpUtility.HtmlDecode(dChildrow["MailText"].ToString()) + "</div>");
                }
                str.Append("</div>");
            }
            strresponse = "0|" + str.ToString();
        }
        catch (Exception e)
        {
            strresponse = "1|" + e.Message;
        }
        return strresponse;
    }

    [System.Web.Services.WebMethod()]
    public static string fnStartMeeting(long MeetingId, string BEIUsername, string BEIPassword)
    {
        try
        {
            var accessToken = clsHttpRequest.GetTokenNo(BEIUsername, BEIPassword);
            MeetingsApi objMeetingsApi = new MeetingsApi();
            var strHostURL = objMeetingsApi.startMeeting(accessToken, MeetingId);
            string hUrl = strHostURL.hostURL;
            return "0|" + hUrl;
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
    }

    public static void SendErrorMail(string sub, string msg)
    {
        try
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("LTDC4@astixsolutions.com");
            mail.To.Add(ConfigurationManager.AppSettings["ErrorMailTo"].ToString());
            mail.Subject = sub;
            mail.Body = msg;
            mail.IsBodyHtml = true;

            SmtpClient SmtpServer = new SmtpClient(ConfigurationManager.AppSettings["MailServer"].ToString());
            SmtpServer.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["MailUser"].ToString(), ConfigurationManager.AppSettings["MailPassword"].ToString());
            SmtpServer.Port = 25;
            SmtpServer.EnableSsl = false;
            SmtpServer.Send(mail);
        }
        catch (Exception ex)
        {
            //
        }
    }
}