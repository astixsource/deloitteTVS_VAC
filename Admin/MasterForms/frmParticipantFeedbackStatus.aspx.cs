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

public partial class frmParticipantFeedbackStatus : System.Web.UI.Page
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

        Scmd.CommandText = "[spGetParticipantListForFeedback]";
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
            SkipColumn = new string[6];
            SkipColumn[0] = "ParticipantAssessorMappingId";
            SkipColumn[1] = "FeedbackMeetingId";
            SkipColumn[2] = "AssessorFeedbackMeetingLink";
            SkipColumn[3] = "flgFeedbackMeetingStatus";
            SkipColumn[4] = "BEIUserName";
            SkipColumn[5] = "BEIPassword";
         
        }
          else
        {
            SkipColumn = new string[8];
            SkipColumn[0] = "ParticipantAssessorMappingId";
            SkipColumn[1] = "FeedbackMeetingId";
            SkipColumn[2] = "AssessorFeedbackMeetingLink";
            SkipColumn[3] = "flgFeedbackMeetingStatus";
            SkipColumn[4] = "BEIUserName";
            SkipColumn[5] = "BEIPassword";
            SkipColumn[6] = "AssessorEmpCode";
            SkipColumn[7] = "AssessorName";
        }

        


        if (ds.Tables[0].Rows.Count > 0)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<table id='tbl_Status' class='table table-bordered table-sm' >");
            //sb.Append("<table id='tbl_Status' class='clstbl'>");
            sb.Append("<thead >");
            string[] Collength = dt.Columns[2].ColumnName.ToString().Split('^');
            for (int k = 0; k < Collength.Length; k++)
            {
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                    {
                        string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('^');
                        if (ColSpliter[k] != "")
                        {
                            if (string.Join("", ColSpliter) == ColSpliter[k])
                            {
                                sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + "</th>");
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
                sb.Append("<tr ParticipantAssessorMappingId='" + ds.Tables[0].Rows[i]["ParticipantAssessorMappingId"].ToString() + "' FeedbackMeetingId='" + ds.Tables[0].Rows[i]["FeedbackMeetingId"].ToString() + "' flgFeedbackMeetingStatus='" + ds.Tables[0].Rows[i]["flgFeedbackMeetingStatus"].ToString() + "' MeetingDate='" + ds.Tables[0].Rows[i]["Feedback Meeting Date"].ToString() + "'  BEIUserName='" + ds.Tables[0].Rows[i]["BEIUserName"].ToString() + "'  BEIPassword='" + ds.Tables[0].Rows[i]["BEIPassword"].ToString() + "' >");
                for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                {
                    string sColumnName = ds.Tables[0].Columns[j].ColumnName;
                    if (!SkipColumn.Contains(sColumnName))
                    {
                        if (sColumnName == "Feedback Status")
                        {
                            if (RoleId > 1)
                            {
                                if (ds.Tables[0].Rows[i]["flgFeedbackMeetingStatus"].ToString() == "1")
                                {
                                    sb.Append("<td style=''><a href='" + ds.Tables[0].Rows[i]["AssessorFeedbackMeetingLink"].ToString() + "' target='_blank' onclick='fnStartMeeting(this)' iden='1'  style='color:blue;'  >Start Meeting</a><span style='display:none'> | </span><a href='" + ds.Tables[0].Rows[i]["AssessorFeedbackMeetingLink"].ToString() + "' target='_blank' onclick='fnStartMeeting(this)' iden='2' style='display:none;margin-left:5px' >Resume Meeting</a></td>");
                                }
                                else if (ds.Tables[0].Rows[i]["flgFeedbackMeetingStatus"].ToString() == "3")
                                {
                                    sb.Append("<td style=''><a href='###' onclick='fnStartMeeting(this)' iden='1'  style='color:blue;'  >End Meeting</a><span> | </span><a href='" + ds.Tables[0].Rows[i]["AssessorFeedbackMeetingLink"].ToString() + "' target='_blank' onclick='fnStartMeeting(this)' iden='2' style='color:blue;margin-left:5px' >Resume Meeting</a></td>");
                                }
                                else
                                {
                                    //sb.Append("<td style=''><a href='###' onclick='fnStartMeeting(this)' >End Meeting</a></td>");
                                    sb.Append("<td style=''>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[0] + "</td>");
                                }
                            }
                            else
                            {
                                sb.Append("<td style=''>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[0] + "</td>");
                            }
                        }
                        else if (sColumnName == "View Meeting Recording")
                        {
                            if (ds.Tables[0].Rows[i]["flgFeedbackMeetingStatus"].ToString() == "2")
                            {
                                 if (Convert.ToString(ds.Tables[0].Rows[i]["View Meeting Recording"]) == "NA")
                                {
                                    sb.Append("<td style=''><a href='###' title='Meeting Not Recorded'>Meeting Not Recorded</a></td>");
                                }
                                else if(Convert.ToString(ds.Tables[0].Rows[i]["View Meeting Recording"]) != "")
                                {
                                    sb.Append("<td style=''><a href='" + ds.Tables[0].Rows[i]["View Meeting Recording"].ToString() + "' title='Click To View MOM' target='_blank'>View MOM</a></td>");
                                }
                                else
                                {
                                    sb.Append("<td style=''><a href='###'  onclick='fnGetMeetingMOM(this)' title='Click To View MOM'  style='color: #000080;cursor:pointer'>View MOM</a></td>");
                                }
                            }
                            else
                            {
                                sb.Append("<td style=''>NA</td>");
                            }
                        }
                        else
                        {
                            sb.Append("<td style=''>" + ds.Tables[0].Rows[i][j].ToString().Split('^')[0] + "</td>");
                        }
                        
                    }
                }
            }
            sb.Append("</tr>");
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
    

    [System.Web.Services.WebMethod()]
    public static string fnStartMeeting(string ParticipantAssessorMappingId, int flgMeeting, string MeetingId, string MeetingDate,string BEIUserName,string Password)
    {
        try
        {
            string DownloadMeetingRecordingLink = "";
            //if (flgMeeting == 2)
            //{
            //    var accessToken = clsHttpRequest.GetTokenNo(BEIUserName, Password);
            //    MeetingsApi objMeetingsApi = new MeetingsApi();
            //    string StartDate = Convert.ToDateTime(MeetingDate).ToString("yyyy/MMM/dd");
            //    string EndDate = DateTime.Now.ToString("yyyy/MMM/dd");
            //    List<LogMeIn.GoToMeeting.Api.Model.MeetingHistory> lstMeetingHistory = objMeetingsApi.getHistoryMeetings(accessToken, true, Convert.ToDateTime(StartDate), Convert.ToDateTime(EndDate));
            //    foreach (var lst in lstMeetingHistory)
            //    {
            //        if (Convert.ToString(lst.meetingId) == MeetingId)
            //        {
            //            LogMeIn.GoToMeeting.Api.Model.MeetingRecording lstMeetingRecording = lst.recording;
            //            if (lstMeetingRecording != null)
            //            {
            //                DownloadMeetingRecordingLink = lstMeetingRecording.shareUrl;
            //                break;
            //            }
            //        }
            //    }
            //}
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spStartEndFeedbackMeetingByAssessor]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@ParticipantAssessorMappingId", ParticipantAssessorMappingId);
            Scmd.Parameters.AddWithValue("@flgStartMeeting", flgMeeting);
            Scmd.Parameters.AddWithValue("@DownloadMeetingRecordingLink", DownloadMeetingRecordingLink);
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();
            Scon.Dispose();
            return "0";
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