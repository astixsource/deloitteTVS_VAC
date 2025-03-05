using Ionic.Zip;
using LogMeIn.GoToMeeting.Api;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class frmAssignExcercise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            hdnRoleId.Value = Session["RoleId"].ToString();
            hdnLogin.Value = Session["LoginId"].ToString();

            if (hdnRoleId.Value == "1")
            {
                fnBindAssessementList(0, 2, hdnRoleId.Value);
            }
            else
            {
                fnBindAssessementList(0, 1, hdnRoleId.Value);
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");

        }
    }

    private void fnBindAssessementList(int CycleID, int Flag, string RoleId)
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        if (RoleId == "1")
        {
            Scmd.CommandText = "spGetAssessmentCycleDetail";
            Scmd.Parameters.AddWithValue("@CycleID", CycleID);
            Scmd.Parameters.AddWithValue("@Flag", Flag);
        }
        else
        {
            Scmd.CommandText = "spGetCycleNameAgAssessor";
            Scmd.Parameters.AddWithValue("@LoginID", hdnLogin.Value);

        }

        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dt = new DataTable();
        Sdap.Fill(dt);

        ListItem itm;//= new ListItem();
        //itm.Text = "All";
        //itm.Value = "0";
        //ddlCycle.Items.Add(itm);
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                itm = new ListItem();
                itm.Text = dr["CycleName"].ToString() + " (" + Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy") + ")";
                itm.Value = dr["CycleId"].ToString();
                if (Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy") == DateTime.Now.ToString("dd MMM yy"))
                {
                    itm.Selected = true;
                }
                ddlCycle.Items.Add(itm);
            }

        }
        else
        {
            itm = new ListItem();
            itm.Text = "No batch mapped";
            itm.Value = "0";
            ddlCycle.Items.Add(itm);
        }

    }
    

    [System.Web.Services.WebMethod()]
    public static string frmGetStatus(string loginId, string CycleID, int RoleId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;

        Scmd.CommandText = "[spAssessorAssignGetExcerciseList]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@CycleID", CycleID);
        Scmd.Parameters.AddWithValue("@LoginId", loginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);

        return createStoretbl(ds, 1, true, RoleId);
    }
    private static string createStoretbl(DataSet ds, int headerlvl, bool IsHeader, int RoleId)
    {
        StringBuilder sbColor = new StringBuilder();
        DataTable dt = ds.Tables[0];
        // dt.Columns.Add("User Response");
        string[] SkipColumn = null;
        if (RoleId == 1)
        {
            SkipColumn = new string[11];
            SkipColumn[0] = "EmpNodeId";
            SkipColumn[1] = "Department";
            SkipColumn[2] = "Pen-Picture Descr";
            SkipColumn[3] = "EMailID";
            SkipColumn[4] = "Submitted";
            SkipColumn[5] = "DownloadMeetingLink";
            SkipColumn[6] = "BEIUserName";
            SkipColumn[7] = "BEIPassword";
            SkipColumn[8] = "MeetingId";
            SkipColumn[9] = "MeetingStartTime";
            SkipColumn[10] = "RspExerciseID";
        }
        else
        {
            SkipColumn = new string[13];
            SkipColumn[0] = "EmpNodeId";
            SkipColumn[1] = "Department";
            SkipColumn[2] = "EMailID";
            SkipColumn[3] = "Submitted";
            SkipColumn[4] = "Completion Date";
            SkipColumn[5] = "Pen-Picture Descr";
            SkipColumn[6] = "DownloadMeetingLink";
			SkipColumn[7] = "AssessorName";
            SkipColumn[8] = "BEIUserName";
            SkipColumn[9] = "BEIPassword";

            SkipColumn[10] = "MeetingId";
            SkipColumn[11] = "MeetingStartTime";
            SkipColumn[12] = "RspExerciseID";
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<table id='tbl_Status' class='table table-bordered table-sm' >");
            //sb.Append("<table id='tbl_Status' class='clstbl'>");
            sb.Append("<thead >");
            string[] Collength = dt.Columns[2].ColumnName.ToString().Split('|')[0].Split('^');
            for (int k = 0; k < Collength.Length; k++)
            {
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                        string[] ColSpliter = (dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()).Split('^');
                        if (ColSpliter[k] != "")
                        {
                            if (string.Join("", ColSpliter) == ColSpliter[k])
                            {
                                if (ColSpliter[k].Trim() == "Raw Report")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + " <input type='checkbox' onclick='fnCheckUncheck(this,1);' /></th>");
                                }
                                else if (ColSpliter[k].Trim() == "Final Report")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + " <input type='checkbox' onclick='fnCheckUncheck(this,2);' /></th>");
                                }
                                else if (ColSpliter[k].Trim() == "Emp Code")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:6.5%'>" + ColSpliter[k] + "</th>");
                                }
                                else if (ColSpliter[k].Trim() == "Participant Name")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:12%'>" + ColSpliter[k] + "</th>");
                                }
                                else if (ColSpliter[k].Trim() == "Participant Feedback Status")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:6%'>" + ColSpliter[k] + "</th>");
                                }
                                else if (ColSpliter[k].Trim() == "Pen-Picture Submission")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:6%'>" + ColSpliter[k] + "</th>");
                                }
                                else
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + "</th>");
                                }
                            }
                            else
                            {
                                string strrowspan = multilvlPopuptbl(dt, j, k);
                                sb.Append(strrowspan.Split('|')[0]);
                                j = j + Convert.ToInt32(strrowspan.Split('|')[1]) - 1;
                            }
                        }
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</thead>");
            sb.Append("<tbody>");

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                string MeetingId = Convert.ToString(ds.Tables[0].Rows[i]["MeetingId"]);
                sb.Append("<tr EmpNodeId='" + ds.Tables[0].Rows[i]["EmpNodeId"].ToString() + "' BEIUserName='" + Convert.ToString(ds.Tables[0].Rows[i]["BEIUserName"]) + "' BEIPassword='" + Convert.ToString(ds.Tables[0].Rows[i]["BEIPassword"]) + "' MeetingStartTime='" + Convert.ToString(ds.Tables[0].Rows[i]["MeetingStartTime"]) + "' MeetingId='" + Convert.ToString(ds.Tables[0].Rows[i]["MeetingId"]) + "' >");
                for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(ds.Tables[0].Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                        if (ds.Tables[0].Rows[i][j].ToString().Split('^').Length > 2)
                        {
                            sbColor.Clear();
                            switch (ds.Tables[0].Rows[i][j].ToString().Split('^')[0])
                            {
                                case "1":
                                    sbColor.Append("color: #ffffff; background-color: #ff0000; font-weight:bold");
                                    break;
                                case "2":
                                    sbColor.Append("color: #000000; background-color: #ff9b9b;");
                                    break;
                                case "3":
                                    sbColor.Append("color: #000000; background-color: #80ff80;");
                                    break;
                                case "4":
                                    sbColor.Append("color: #000000; background-color: #8080ff;");
                                    break;
                                case "5":
                                    sbColor.Append("color: #ffffff; background-color: #8000ff;");
                                    break;
                                case "6":
                                    sbColor.Append("color: #ffffff; background-color: #0000a0;");
                                    break;
                                case "11":
                                    sbColor.Append("color: #ffffff; background-color: #008800;");
                                    break;
                                case "13":
                                    sbColor.Append("color: #000000; background-color: #bfddaa;");
                                    break;
                                case "14":
                                    sbColor.Append("color: #ffffff; font-weight:bold; background-color: #a2ce84;");
                                    break;
                                default:
                                    sbColor.Append("color: #000000; background-color: transparent;");
                                    break;
                            }
                            if (ds.Tables[0].Columns[j].ColumnName.ToString().Trim() == "Report Download" && ds.Tables[0].Rows[i][j].ToString() != "")
                            {
                                sb.Append("<td style='text-align:center; " + sbColor.ToString() + "' id='td_" + i + "_" + j + "' ><input type='checkbox' doc='" + ds.Tables[0].Rows[i][j].ToString() + "'></td>");
                            }
                            else if (ds.Tables[0].Rows[i][j].ToString().Split('^')[4] == "4")
                            {
                                string sTitle= MeetingId=="0"?"title='BEI Meeting Not Scheduled'": Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? "title ='Click to View Recording '": "title ='Meeting Not Recorded By Developer'";
                                if (ds.Tables[0].Rows[i][j].ToString().Split('^')[0] == "7")
                                {
                                    //  sb.Append("<td AssessorId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[5] + "' RSPExerciseId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[3] + "' style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'><a href='#' onclick='fnViewScore(this);'  style='color: #000080;'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "</a><span style='color:#000 !important;font-weight:bold'> / </span><a href='#' onclick='fnViewBEIRemarks(this);'  style='color: #000080;'>BEI Remarks</a><span style='color:#000 !important;font-weight:bold'> / </span><a "+(Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"])!=""?"href='"+Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) + "'":"title='Recording Not Available'")+" target='_blank' style='color: #000080;'>View BEI MOM</a></td>");
                                    sb.Append("<td AssessorId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[5] + "' RSPExerciseId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[3] + "' style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'> Completed <span style='color:#000 !important;font-weight:bold'> / </span><a href='#' onclick='fnViewBEIRemarks(this);'  style='color: #000080;cursor:pointer'>BEI Remarks</a><span style='color:#000 !important;font-weight:bold'> / </span><a " + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "" && Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? " target='_blank'  href='" + Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) + "'" : (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA"? "onclick='fnGetMeetingMOM(this)'":""))+"  "+ sTitle + " style='color: #000080;"+ (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA"?"cursor:pointer":"") + "'>"+ (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) == "NA"?"Meeting Not Recorded":"View BEI MOM") + "</a></td>");
                                }
                                else if (ds.Tables[0].Rows[i][j].ToString().Split('^')[0] == "11")
                                {
                                    sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "' AssessorId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[5] + "' RSPExerciseId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[3] + "'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + " <span style='color:#000 !important;font-weight:bold'> / </span><a href='#' onclick='fnViewBEIRemarks(this);'  style='" + sbColor.ToString() + "'>BEI Remarks</a><span style='color:#000; !important'> / </span><a " + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "" && Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? " target='_blank'  href='" + Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) + "'" : (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? "onclick='fnGetMeetingMOM(this)'" : "")) + "  " + sTitle + "  style='color: #000080;" + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? "cursor:pointer" : "") + "'>" + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) == "NA" ? "Meeting Not Recorded" : "View BEI MOM") + "</a></td>");
                                }
                                else if (ds.Tables[0].Rows[i][j].ToString().Split('^')[0] == "6" || ds.Tables[0].Rows[i][j].ToString().Split('^')[0] == "17")
                                {
                                    sb.Append("<td style='" + sbColor.ToString() + "' AssessorId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[5] + "' RSPExerciseId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[3] + "' id='td_" + i + "_" + j + "'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "<span style='color:#000 !important;font-weight:bold'> / </span><a " + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "" && Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? " target='_blank'  href='" + Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) + "'" : (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? "onclick='fnGetMeetingMOM(this)'" : "")) + "  " + sTitle + "  style='color: #000080;" + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) != "NA" ? "cursor:pointer" : "") + "'>" + (Convert.ToString(ds.Tables[0].Rows[i]["DownloadMeetingLink"]) == "NA" ? "Meeting Not Recorded" : "View BEI MOM") + "</a></td>");
                                }
                                else
                                {
                                    sb.Append("<td style='" + sbColor.ToString() + "' AssessorId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[5] + "' RSPExerciseId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[3] + "' id='td_" + i + "_" + j + "'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "</td>");
                                }
                            }
                            else if (ds.Tables[0].Rows[i][j].ToString().Split('^')[0] == "7")
                            {
                                if (ds.Tables[0].Rows[i][j].ToString().Split('^')[4] == "1")
                                {
                                    // sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'><a href='#' onclick='fnViewScore(this);'  style='color: #000080;'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "</a> / <span style='color: #000080;'><a href='#' onclick='fnViewCaseStudyAnswer(this);'  style='color: #000080;'>View answers</a></span></td>");
                                    sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'> Completed / <span style='color: #000080;'><a href='#' onclick='fnViewCaseStudyAnswer(this);'  style='color: #000080;'>View answers</a></span></td>");
                                }
                                else

                                {
                                    //  sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'><a href='#' onclick='fnViewScore(this);'  style='color: #000080;'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "</a></td>");
                                    sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'>Completed</td>");
                                }

                            }
                            else if (ds.Tables[0].Rows[i][j].ToString().Split('^')[0] == "11" && ds.Tables[0].Rows[i][j].ToString().Split('^')[4] == "1")
                            {
                                
                                    // sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'><a href='#' onclick='fnViewScore(this);'  style='color: #000080;'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "</a> / <span style='color: #000080;'><a href='#' onclick='fnViewCaseStudyAnswer(this);'  style='color: #000080;'>View answers</a></span></td>");
                                    sb.Append("<td style='" + sbColor.ToString() + "' id='td_" + i + "_" + j + "'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "/ <span style='color: #ffffff;'><a href='#' onclick='fnViewCaseStudyAnswer(this);'  style='color: #ffffff;'>View answers</a></span></td>");
                               

                            }
                            else
                            {
                                sb.Append("<td style='" + sbColor.ToString() + "' AssessorId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[5] + "' RSPExerciseId='" + ds.Tables[0].Rows[i][j].ToString().Split('^')[3] + "' id='td_" + i + "_" + j + "'>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[1] + "</td>");
                            }


                        }
                        else
                        {
                            if (ds.Tables[0].Columns[j].ColumnName.ToString().Trim() == "User Response" && ds.Tables[0].Rows[i]["Report Download"].ToString() != "")
                            {
                                sb.Append("<td><a href='FileDownloadHandler.ashx?flg=1&EmpId=" + ds.Tables[0].Rows[i]["EmpNodeId"].ToString() + "&UserCode=" + ds.Tables[0].Rows[i]["Participant Code"].ToString() + "' target='_blank'>Download</a></td>");
                            }
                            else
                            {
                                if (ds.Tables[0].Columns[j].ColumnName.ToString().Trim() == "Raw Report" && ds.Tables[0].Rows[i][j].ToString() != "")
                                {
                                    sb.Append("<td style='text-align:center;' id='td_" + i + "_" + j + "' ><input type='checkbox' flg='1' doc='" + ds.Tables[0].Rows[i][j].ToString() + "'></td>");
                                }
                                else if (ds.Tables[0].Columns[j].ColumnName.ToString().Trim() == "Final Report" && ds.Tables[0].Rows[i][j].ToString() != "")
                                {
                                    sb.Append("<td style='text-align:center;' id='td_" + i + "_" + j + "' ><input type='checkbox' flg='2' doc='" + ds.Tables[0].Rows[i][j].ToString() + "'></td>");
                                }
                                else if (ds.Tables[0].Columns[j].ColumnName.ToString() == "Participant Feedback Status")
                                {
                                    //if (ds.Tables[0].Rows[i]["Submitted"].ToString() == "Yes")
                                    //{
                                    if (ds.Tables[0].Rows[i][j].ToString() == "-1")
                                        {
                                            sb.Append("<td style='text-align:center;padding-right:5px'>Pending</td>");
                                        }
                                        else
                                        {
                                            sb.Append("<td style='text-align:center;padding-right:5px'>" + (ds.Tables[0].Rows[i][j].ToString() == "0" ? "Pending" : "Completed") + "</td>");
                                        }
                                    //}
                                    //else
                                    //{
                                    //    sb.Append("<td style='text-align:center;'>Pending</td>");
                                    //}
                                }
                                else if (ds.Tables[0].Columns[j].ColumnName.ToString() == "Pen-Picture Submission")
                                {
                                    //if (ds.Tables[0].Rows[i]["Submitted"].ToString() == "Yes")
                                    //{
                                    if (RoleId == 1)
                                    {
                                        if (ds.Tables[0].Rows[i][j].ToString() == "-1")
                                        {
                                            sb.Append("<td style='text-align:center;padding-right:5px'>Pending</td>");
                                        }
                                        else
                                        {
                                            if(Convert.ToString(ds.Tables[0].Rows[i]["Final Report"]) != "")
                                            {
                                                sb.Append("<td style='text-align:center;'>" + (ds.Tables[0].Rows[i][j].ToString() == "0" ? "Pending" : "<a href='###'  empnodeid='" + ds.Tables[0].Rows[i]["empnodeid"].ToString() + "'  onclick='fnViewPenStatus(this)' >View</a>") + "<div class='clsPenpicture' style='display:none'>" + Convert.ToString(ds.Tables[0].Rows[i]["Pen-Picture Descr"]) + "</div></td>");
                                            }
                                            else
                                            {
                                                sb.Append("<td style='text-align:center;'>" + (ds.Tables[0].Rows[i][j].ToString() == "0" ? "Pending" : "<a href='###'  empnodeid='" + ds.Tables[0].Rows[i]["empnodeid"].ToString() + "'  onclick='fnSubmitPenPicturestatus(this)' >View</a>") + "<div class='clsPenpicture' style='display:none'>" + Convert.ToString(ds.Tables[0].Rows[i]["Pen-Picture Descr"]) + "</div></td>");
                                            }
                                            
                                        }
                                    }
                                    else
                                    {

                                        if (ds.Tables[0].Rows[i][j].ToString() != "-1")
                                        {
                                            sb.Append("<td style='text-align:center;' >" + (ds.Tables[0].Rows[i][j].ToString() == "0" ? "Pending&nbsp;<a href='###'  empnodeid='" + ds.Tables[0].Rows[i]["empnodeid"].ToString() + "'  onclick='fnSubmitPenPicturestatus(this)' ><i class='fa fa-pencil'></i></a>" : "<a href='###' style='text-decoration:underline;color:blue' onclick='fnViewPenStatus(this)' >View</a>") + "<div class='clsPenpicture' style='display:none'>" + Convert.ToString(ds.Tables[0].Rows[i]["Pen-Picture Descr"]) + "</div></td>");
                                        }
                                        else
                                        {
                                            sb.Append("<td style='text-align:center;' >Pending</td>");
                                        }
                                    }
                                    //}
                                    //else
                                    //{
                                    //    sb.Append("<td style='text-align:center;'>Pending</td>");
                                    //}
                                }
                                else
                                {
                                    sb.Append("<td style=''>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[0] + "</td>");
                                }
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
        else
        {
            return "<div style='font-size:13px; padding : 10px 20px; color:red; font-weight:bold;'>No Record Found !</div>";
        }
    }

    
    private static string multilvlPopuptbl(DataTable dt, int col_ind, int row_ind)
    {
        int cntr = 1;
        string str = dt.Columns[col_ind].ColumnName.ToString().Split('|')[0].Split('^')[row_ind];
        for (int i = col_ind + 1; i < dt.Columns.Count; i++)
        {
            if (str == dt.Columns[i].ColumnName.ToString().Split('|')[0].Split('^')[row_ind])
            {
                cntr++;
            }
            else
            {
                break;
            }
        }
        return " <th colspan='" + cntr + "' style='color: #ffffff; font-size: 11px; font-family: Verdana; font-weight:bold; background-color: #0080b9; border: 1px solid #dddddd;'> " + str + " </th>|" + cntr;
    }
    private string AssessorMstr(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<select>");
        sb.Append("<option value='0'>--Please Select--</option>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<option value='" + dt.Rows[i]["AssessorID"].ToString() + "'>" + dt.Rows[i]["Assessor"].ToString() + "</option>");
        }
        sb.Append("</select>");
        return sb.ToString();
    }

    private string LegendMstr(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table><tr>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            switch (dt.Rows[i]["ExerciseStatusId"].ToString())
            {
                case "1":
                    sb.Append("<td style='background-color: #ff0000; width:20px'></td><td class='clslegendlbl'>" + dt.Rows[i]["ExerciseStatus"].ToString() + "</td>");
                    break;
                case "2":
                    sb.Append("<td style='background-color: #ff9b9b; width:20px'></td><td class='clslegendlbl'>" + dt.Rows[i]["ExerciseStatus"].ToString() + "</td>");
                    break;
                case "3":
                    sb.Append("<td style='background-color: #80ff80; width:20px'></td><td class='clslegendlbl'>" + dt.Rows[i]["ExerciseStatus"].ToString() + "</td>");
                    break;
                case "4":
                    sb.Append("<td style='background-color: #8080ff; width:20px'></td><td class='clslegendlbl'>" + dt.Rows[i]["ExerciseStatus"].ToString() + "</td>");
                    break;
                case "5":
                    sb.Append("<td style='background-color: #8000ff; width:20px'></td><td class='clslegendlbl'>" + dt.Rows[i]["ExerciseStatus"].ToString() + "</td>");
                    break;
                case "6":
                    sb.Append("<td style='background-color: #0000a0; width:20px'></td><td class='clslegendlbl'>" + dt.Rows[i]["ExerciseStatus"].ToString() + "</td>");
                    break;
            }
        }
        sb.Append("</tr></table>");
        return sb.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static string fnAssignAssessor(string RSPExerciseid, string AssessorId, string LoginId)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spAssessAssignToRSPExercise]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@RSPExerciseId", RSPExerciseid);
            Scmd.Parameters.AddWithValue("@AssessorId", AssessorId);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            return "0^" + ds.Tables[0].Rows[0]["ExerciseStatusId"].ToString() + "^" + ds.Tables[0].Rows[0]["ExerciseStatus"].ToString() + "^" + ds.Tables[0].Rows[0]["IsButton"].ToString();
        }
        catch (Exception ex)
        {
            return "1";
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnViewScore(string Emp)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spViewUserScore]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@EmpNodeId", Emp);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            string[] SkipColumn = new string[1];
            SkipColumn[0] = "EmpNodeId";
            return "0^" + createtbl(ds.Tables[0], "tblScore", true, 1, SkipColumn);
        }
        catch (Exception ex)
        {
            return "1";
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnViewCaseStudyAnswr(string Emp)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spGetCaseStudyTextBoxAnswer]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@EmpNodeId", Emp);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            string[] SkipColumn = new string[1];
            SkipColumn[0] = "RspID";
            return "0^" + createtbl(ds.Tables[0], "tblCaseStudy", true, 1, SkipColumn);
        }
        catch (Exception ex)
        {
            return "1";
        }
    }




    [System.Web.Services.WebMethod()]
    public static string fnViewBEIRemarks(string Emp)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spGetBEIRemarks]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@EmpNodeId", Emp);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            string[] SkipColumn = new string[6];
            SkipColumn[0] = "ExcerciseRatingId";
            SkipColumn[1] = "RSPExcerciseId";
            SkipColumn[2] = "CmpntcyID";
            SkipColumn[3] = "SubCompetencyID";
            SkipColumn[4] = "CompetencyName";
            SkipColumn[5] = "EmpNodeID";
            return "0^" + createtbl(ds.Tables[0], "tblBEIRemarks", true, 1, SkipColumn);
        }
        catch (Exception ex)
        {
            return "1";
        }
    }


    private static string createtbl(DataTable dt, string tblname, bool IsHeader, int RowMerge_Index, string[] SkipColumn)
    {
        StringBuilder sb = new StringBuilder();
        if (IsHeader)
        {
            sb.Append("<table cellpadding='0' cellspacing='0' valign='middle'  class='table table-bordered table-sm' id='" + tblname + "'>");
            sb.Append("<thead>");
            string[] Collength = dt.Columns[0].ColumnName.ToString().Split('^');
            for (int k = 0; k < Collength.Length; k++)
            {
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                    {
                        string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('^');
                        if (ColSpliter[k] != "")
                        {
                            if (string.Join("", ColSpliter) == ColSpliter[k])
                            {
                                string swidth = "";
                                if (tblname == "tblCaseStudy")
                                {
                                    if (dt.Columns[j].ColumnName.ToString().Split('^')[0].ToLower() == "qstn")
                                    {
                                        swidth = "width:40%";
                                    }
                                }
                                if (tblname == "tblBEIRemarks")
                                {
                                    if (dt.Columns[j].ColumnName.ToString().Split('^')[0].ToLower() == "comments")
                                    {
                                        swidth = "width:50%";
                                    }
                                }
                                sb.Append("<th style='" + swidth + "' rowspan='" + ColSpliter.Length + "' class='clspopuptblhead_" + k + "_" + j + "'>" + dt.Columns[j].ColumnName.ToString().Split('^')[0] + "</th>");
                            }
                            else
                            {
                                string strrowspan = multilvlPopuptbl(dt, j, k);
                                sb.Append(strrowspan.Split('|')[0]);
                                j = j + Convert.ToInt32(strrowspan.Split('|')[1]) - 1;
                            }
                        }
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</thead>");
            sb.Append("<tbody>");
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr>");
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
                            sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                        }
                    }
                    else
                    {

                        if (tblname == "tblBEIRemarks")
                        {
                            if (j.ToString() == "7")
                            {
                                sb.Append("<td style='background-color:#f2f2f2'>" + dt.Rows[i][j].ToString() + "</td>");
                            }
                            else
                            {
                                sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                            }
                        }

                        else if (tblname == "tblCaseStudy")
                        {
                            if (j.ToString() == "2")
                            {
                                sb.Append("<td style='background-color:#f2f2f2'>" + dt.Rows[i][j].ToString() + "</td>");
                            }
                            else
                            {
                                sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                            }
                        }
                        else
                        {
                            sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                        }

                    }
                }
            }
            sb.Append("</tr>");
        }
        if (IsHeader)
        {
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        return sb.ToString();
    }

    private static string createRowMergeTbl(string[] SkipColumn, DataTable dt, string colvalue, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i != 0)
                sb.Append("<tr>");
            else
            {
                sb.Append("<td rowspan ='" + dt.Rows.Count + "'>" + colvalue + "</td>");
            }

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
                            sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                        }
                    }
                    else
                    {
                        sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
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
    public static string fnRpt(object udt_DataSaving, string LoginId, int flgRptType)
    {
        try
        {
            string strDataSaving = JsonConvert.SerializeObject(udt_DataSaving, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtDataSaving = JsonConvert.DeserializeObject<DataTable>(strDataSaving);
            dtDataSaving.TableName = "udt_DataSaving";
            if (dtDataSaving.Rows[0][0].ToString() == "0")
            {
                dtDataSaving.Rows[0].Delete();
            }

            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spDownloadUserReport]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@UserList", dtDataSaving);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@flgRptTpe", flgRptType);

            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);
            string subPath = flgRptType == 1 ? "Raw" : "Final";
            String path = HttpContext.Current.Server.MapPath("~/Reports/" + subPath + "/");
            FileInfo file = new FileInfo(path + "/" + subPath + "Reports.zip");
            if (file.Exists)
            {
                file.Delete();
            }

            using (ZipFile zip = new ZipFile())
            {
                for (int i = 0; i < dtDataSaving.Rows.Count; i++)
                {
                    file = new FileInfo(path + dtDataSaving.Rows[i][1].ToString());
                    if (file.Exists)
                    {
                        zip.AddFile(path + dtDataSaving.Rows[i][1].ToString(), "Reports");
                    }
                }
                zip.Save(path + "/" + subPath + "Reports.zip");
            }

            return "0^" + subPath + "Reports.zip";
        }
        catch (Exception ex)
        {
            return "1";
        }
    }


    protected void btnScoreCard_Click(object sender, EventArgs e)
    {
        DataTable dt_EmpId = new DataTable();
        dt_EmpId.Columns.Add("ID", typeof(string));
        dt_EmpId.Columns.Add("Val", typeof(string));

        for (int i = 0; i < hdnSelectedEmp.Value.Split('^').Length; i++)
        {
            dt_EmpId.Rows.Add(hdnSelectedEmp.Value.Split('^')[i], "");
        }

        string sp_Name = ""; string fileName = "";
        if (hdnScoreCardType.Value == "1")              //Score Card
        {
            sp_Name = "spDownloadUserScore";
            fileName = "Score-Card_" + DateTime.Now.ToString("yyyyMMddhhmmssff");
        }
        else                                           //New Score Card
        {
            sp_Name = "spDownloadUserScoreWithNewLogic";
            fileName = "New Score-Card_" + DateTime.Now.ToString("yyyyMMddhhmmssff");
        }

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = sp_Name;
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@EmpNodeIds", dt_EmpId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        DataTable dt = Ds.Tables[0];
        string[] SkipColumn = new string[1];
        SkipColumn[0] = "Document";

        string strtbl = createtbl(Ds.Tables[0], SkipColumn);

        Response.Clear();
        Response.Charset = "";
        Response.ContentEncoding = System.Text.UTF8Encoding.UTF8;
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = "application/ms-excel.xls";
        Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".xls");
        Response.Write("<html><head><style type='text/css'>" + "" + "</style></head>" + strtbl + "</html>");
        Response.Flush();
        Response.End();
    }


    protected void btnObjectiveScore_Click(object sender, EventArgs e)
    {
        DataTable dt_EmpId = new DataTable();
        dt_EmpId.Columns.Add("ID", typeof(string));
        dt_EmpId.Columns.Add("Val", typeof(string));

        for (int i = 0; i < hdnSelectedEmp.Value.Split('^').Length; i++)
        {
            dt_EmpId.Rows.Add(hdnSelectedEmp.Value.Split('^')[i], "");
        }

        string sp_Name = ""; string fileName = "";
        
            sp_Name = "spRptGetObjectiveScores";
            fileName = "ObjectiveQuestions_Score-Card_" + DateTime.Now.ToString("yyyyMMddhhmmssff");
       

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = sp_Name;
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@EmpNodeIds", dt_EmpId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        DataTable dt = Ds.Tables[0];
        string[] SkipColumn = new string[1];
        SkipColumn[0] = "QstId";

        string strtbl = createtbl(Ds.Tables[0], SkipColumn);

        Response.Clear();
        Response.Charset = "";
        Response.ContentEncoding = System.Text.UTF8Encoding.UTF8;
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = "application/ms-excel.xls";
        Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".xls");
        Response.Write("<html><head><style type='text/css'>" + "" + "</style></head>" + strtbl + "</html>");
        Response.Flush();
        Response.End();
    }

    private string createtbl(DataTable dt, string[] SkipColumn)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("<table cellpadding='0' cellspacing='0' valign='middle' style='border-left:1px solid gray; border-top:1px solid gray;' border='1' rules='all'>");
        sb.Append("<thead>");
        string[] Collength = dt.Columns[2].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = (dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()).Split('^');
                    //if (ColSpliter[k] != "")
                    //{
                    if (string.Join("", ColSpliter) == ColSpliter[k])
                    {
                        if (ColSpliter[k].Trim() == "Report Download")
                        {
                            sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + " <input type='checkbox' onclick='fnCheckUncheck(this);' /></th>");
                        }
                        else
                        {
                            sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + "</th>");
                        }
                    }
                    else
                    {
                        string strrowspan = multilvlPopuptbl(dt, j, k);
                        sb.Append(strrowspan.Split('|')[0]);
                        j = j + Convert.ToInt32(strrowspan.Split('|')[1]) - 1;
                    }
                    //}
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td style='border-right:1px solid gray; border-bottom:1px solid gray; font-size:7pt; font-family:verdana;'>" + dt.Rows[i][j].ToString() + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }



    [System.Web.Services.WebMethod()]
    public static string fnSubmitParticipantFeedbackstatus(int flgSubmit, string EmpNodeId, string LoginId)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spSubmitParticipantFeedbackstatus]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@flgSubmit", flgSubmit);
            Scmd.Parameters.AddWithValue("@PartipantId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            return "0^";
        }
        catch (Exception ex)
        {
            return "1^" + ex.Message;
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSubmitPenPictureFeedback(int flgSubmit, string EmpNodeId, string LoginId, string PenData)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spSubmitPenPictureFeedback]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@flgSubmit", flgSubmit);
            Scmd.Parameters.AddWithValue("@PartipantId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@PenFeedbackData", PenData);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            return "0^";
        }
        catch (Exception ex)
        {
            return "1^" + ex.Message;
        }
    }
}