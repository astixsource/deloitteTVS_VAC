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
        Scmd.CommandText = "spGetAssessmentCycleDetailForFinalSubmit";
        //  Scmd.Parameters.AddWithValue("@CycleID", 0);
        // Scmd.Parameters.AddWithValue("@Flag", 0);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dtBatch = new DataTable();
        Sdap.Fill(dtBatch);
        Scmd.Dispose();
        Sdap.Dispose();
        ListItem lst = new ListItem();
        lst.Text = "--Select--";
        lst.Value = "0";

        ddlBatch.Items.Add(lst);
        foreach (DataRow dr in dtBatch.Rows)
        {
            lst = new ListItem();
            lst.Text = dr["CycleName"].ToString();
            lst.Value = dr["CycleId"].ToString();
            lst.Attributes.Add("VacantParticipantSlot", dr["VacantParticipantSlot"].ToString());
            lst.Attributes.Add("VacantAssessorSlot", dr["VacantAssessorSlot"].ToString());
            ddlBatch.Items.Add(lst);
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spAssessmentPopulateAssessorParticipantMapping";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
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
        return CreateSchedulingTbl(Ds.Tables[0], SkipColumn, "tblScheduling", 2);
    }
    private static string CreateSchedulingTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<div id='dvtblbody'><table id='" + tblname + "' class='table table-bordered bg-white table-sm clsTarget'>");
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
        sb.Append("</table></div>");
        return sb.ToString();
    }
    private static string createRowMergeTbl(string[] SkipColumn, DataTable dt, string str, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i != 0)
                sb.Append("<tr>");
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
    public static string fnSaveOLD(string CycleId, string TypeId, object obj, string LoginId)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spAssessmentSaveDetailsForCycleMappingWithUser";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@TypeId", TypeId);
            Scmd.Parameters.AddWithValue("@tblUserList", tbl);
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


    [System.Web.Services.WebMethod()]
    public static string fnSave(string LoginId, int CycleId)
    {
        string strResponse = "";
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        try
        {
            Scon.Open();
            DataSet DsData = null;
            string storedProcName = "spGetMeetingAssessorParticipantList";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@CycleId", CycleId),
                };
            DsData = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, Scon, sp);


            DataTable dtTable = new DataTable();

            dtTable.Columns.Add(new DataColumn("AssessorName", typeof(string)));
            dtTable.Columns.Add(new DataColumn("ExerciseName", typeof(string)));
            dtTable.Columns.Add(new DataColumn("MeetingStartTime", typeof(string)));
            dtTable.Columns.Add(new DataColumn("MeetingStatus", typeof(string)));
            dtTable.Columns.Add(new DataColumn("ParticipantName", typeof(string)));
            dtTable.Columns.Add(new DataColumn("Role", typeof(string)));
            dtTable.Rows.Clear();



            string OldBEIUserName = "0"; var accessToken1 = "";
            if (DsData.Tables.Count == 0)
            {
                return "2|No Record Found For Meeting!";
            }
            if (DsData.Tables[0].Rows.Count > 0)
            {
                string accessToken = "";
                clsADUserInfo obj = new clsADUserInfo();
                foreach (DataRow drow in DsData.Tables[0].Rows)
                {
                    DataRow dr = dtTable.NewRow();
                    try
                    {
                        string ParticipantAssessorMappingId = drow["ParticipantAssessorMappingId"].ToString();
                        string AssessorCycleMappingId = drow["AssessorCycleMappingId"].ToString();
                        string GDId = drow["GDID"].ToString();
                        string ExerciseId = drow["ExerciseID"].ToString();
                        string AssessorName = Convert.ToString(drow["AssessorName"]);
                        string AssesseeName = Convert.ToString(drow["AssesseeName"]);
                        string RoleId = Convert.ToString(drow["BandId"]);
                        string ExerciseName = Convert.ToString(drow["ExerciseName"]);
                        string StartDate = drow["MeetingStartTime"].ToString();
                        string endDate = drow["MeetingEndTime"].ToString();
                        dr[0] = AssessorName;
                        dr[1] = ExerciseName;
                        dr[2] = StartDate;
                        dr[4] = AssesseeName;
                        dr[5] = RoleId;

                        string BEIUserName = Convert.ToString(drow["UserName"]);
                        string BEIPassword = Convert.ToString(drow["Password"]);
                        
                        string strrep = "";
                        if (OldBEIUserName != BEIUserName)
                        {
                            strrep = obj.fnGetTokenNoForUser(BEIUserName, BEIPassword);
                            if (strrep.Split('|')[0] == "1")
                            {
                                accessToken = strrep.Split('|')[1];
                            }
                            else
                            {
                                dr["MeetingStatus"] = "Error-" + strrep.Split('|')[1];
                                continue;
                            }
                        }
                        OldBEIUserName = BEIUserName;
                        string strTeamResponse = obj.fnCreateTeamMeeting(ExerciseName, accessToken, StartDate, endDate);
                        if (strTeamResponse.Split('|')[0] == "1")
                        {
                            string AssesseMeetingLink = strTeamResponse.Split('|')[2];
                            string MeetingId = strTeamResponse.Split('|')[1];
                            string AssessorMeetingLink = AssesseMeetingLink;

                            SqlCommand Scmd = new SqlCommand();
                            Scmd.Connection = Scon;
                            Scmd.CommandText = "[spCreateMeetingLinkForAssessorParticipant]";
                            Scmd.CommandType = CommandType.StoredProcedure;
                            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
                            Scmd.Parameters.AddWithValue("@ParticipantAssessorMappingId", ParticipantAssessorMappingId);
                            Scmd.Parameters.AddWithValue("@AssessorCycleMappingId", AssessorCycleMappingId);
                            Scmd.Parameters.AddWithValue("@GDId", GDId);
                            Scmd.Parameters.AddWithValue("@ExerciseId", ExerciseId);
                            Scmd.Parameters.AddWithValue("@AssesseMeetingLink", AssesseMeetingLink);
                            Scmd.Parameters.AddWithValue("@AssessorMeetingLink", AssessorMeetingLink);
                            Scmd.Parameters.AddWithValue("@MeetingId", MeetingId);
                            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
                            Scmd.Parameters.AddWithValue("@MeetingSTartTime", StartDate);
                            Scmd.Parameters.AddWithValue("@MeetingEndTime", endDate);
                            Scmd.CommandTimeout = 0;
                            Scmd.ExecuteNonQuery();
                            dr[3] = "Meeting Scheduled";
                        }
                        else
                        {
                            dr["MeetingStatus"] = "Error-" + strrep.Split('|')[1];
                        }
                    }
                    catch (Exception ex)
                    {
                        dr["MeetingStatus"] = "Error-" + ex.Message;
                    }
                    dtTable.Rows.Add(dr);
                }
                dtTable.DefaultView.Sort = "ParticipantName asc";
                dtTable = dtTable.DefaultView.ToTable(true);
                strResponse = "0|" + JsonConvert.SerializeObject(dtTable, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
                Scon.Dispose();

                fnSendICSFIleToUsers(CycleId.ToString());
            }
            else
            {
                strResponse = "2|No Record Found For Meeting!";
            }


        }
        catch (Exception ex)
        {
            strResponse = "1|Error : " + ex.Message;
        }
        finally
        {
            Scon.Dispose();
        }
        return strResponse;
    }

    public static List<MeetingCreated> fnCreateGotoMeeting(string ExerciseName, string accessToken, string MeetingDate, string MeetingEndDate)
    {
        MeetingRecording objMeetingRec = new MeetingRecording();
        MeetingsApi objMeetingsApi = new MeetingsApi();
        MeetingReqCreate meetingBody = new MeetingReqCreate();
        meetingBody.subject = ExerciseName + " Meeting Discussion";
        meetingBody.meetingtype = MeetingType.scheduled;
        meetingBody.passwordrequired = false;
        DateTime dtStartTime = Convert.ToDateTime(MeetingDate).ToUniversalTime();
        DateTime dtEndTime = Convert.ToDateTime(MeetingEndDate).ToUniversalTime();
        meetingBody.starttime = dtStartTime;
        meetingBody.endtime = dtEndTime;
        meetingBody.conferencecallinfo = "hybrid";
        meetingBody.timezonekey = "Asia/Calcutta";
        List<MeetingCreated> lstMeetingCreated = objMeetingsApi.createMeeting(accessToken, meetingBody);
        return lstMeetingCreated;
    }

    [System.Web.Services.WebMethod()]
    public static string fnSendICSFIleToUsers(string CycleId)
    {
        string strRespoonse = "Mail Sent Successfully";
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            Scon.Open();
            DataSet DsData = null;
            string storedProcName = "spGetOrientationMeetingDetailForMail";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@CycleId", CycleId),
                };
            DsData = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, Scon, sp);

            StringBuilder str = new StringBuilder();
            int cnt = 0;
            string CycleDate = "";
            foreach (DataRow drow1 in DsData.Tables[1].Rows)
            {
                CycleDate = Convert.ToDateTime(drow1["Orient_MeetingStartTime"]).ToString("dd-MMM-yyyy");
                string StartDate = Convert.ToDateTime(drow1["Orient_MeetingStartTime"]).ToString("HH:mm");
                string MeetingLink = Convert.ToString(drow1["Orient_AssesseeMeetLink"]);
                if (cnt == 0)
                {
                    str.Append("<p>Your morning orientaion meeting is started by :</p>");
                }
                else
                {
                    str.Append("<p>Your after noon orientaion meeting is started by :</p>");
                }
                str.Append("<p>Start At : " + StartDate + "</p>");
                str.Append("<p>Orientaion Meeting Link : <a href='" + MeetingLink + "' target='_blank'>" + MeetingLink + "</a></p><br>");
                cnt++;
            }

            string MailServer = ConfigurationManager.AppSettings["MailServer"].ToString();
            string MailUserName = ConfigurationManager.AppSettings["MailUser"].ToString();
            string MailPwd = ConfigurationManager.AppSettings["MailPassword"].ToString();
            string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
            string fromMail = ConfigurationManager.AppSettings["FromAddress"].ToString();

            foreach (DataRow drow1 in DsData.Tables[0].Rows)
            {
                MailMessage msg = new MailMessage();
                msg.From = new MailAddress("TVSM VDC<" + fromMail + ">");
                // Now Contruct the ICS file using string builder
                string MailTo = Convert.ToString(drow1["EMailID"]);
                string Assessor = Convert.ToString(drow1["Assessor"]);

                // Now Contruct the ICS file using string builder
                if (flgActualUser == "2")
                {
                    MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
                }

                msg.To.Add(MailTo);
                msg.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());

                msg.Subject = "EY Virtual DC – Orientation Meeting - " + CycleDate;
                StringBuilder strBody = new StringBuilder();
                strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
                strBody.Append("<p>Dear " + Assessor + ",</p>");
                strBody.Append(str);
                strBody.Append("<p><b>Regards</b></p>");
                strBody.Append("<p><b>Team EY</b></p>");
                strBody.Append("</font>");
                msg.Body = strBody.ToString();
                msg.IsBodyHtml = true;
                SmtpClient SmtpMail = new SmtpClient();
                SmtpMail.Host = MailServer;
                SmtpMail.Port = 587;
                string MUserName = MailUserName;
                string MPwd = MailPwd;
                NetworkCredential loginInfo = new NetworkCredential(MUserName, MPwd);
                SmtpMail.Credentials = loginInfo;
                SmtpMail.EnableSsl = false;
                SmtpMail.Timeout = int.MaxValue;

                SmtpMail.Send(msg);

            }
            if (DsData.Tables[0].Rows.Count == 0)
            {
                strRespoonse = "No Record Found!";
            }
        }
        catch (Exception ex)
        {
            strRespoonse = "Error-" + ex.Message;
        }
        return strRespoonse;
    }

    [System.Web.Services.WebMethod()]
    public static string fnSendICSFIleToUsers_New(string CycleId)
    {
        string strRespoonse = "Mail Sent Successfully";
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            Scon.Open();
            DataSet DsData = null;
            string storedProcName = "spGetOrientationMeetingDetailForMail";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@CycleId", CycleId),
                };
            DsData = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, Scon, sp);

            StringBuilder str = new StringBuilder();
            int cnt = 0;
            string CycleDate = "";
            string StartDate = "";
            string EndDate = "";
            foreach (DataRow drow1 in DsData.Tables[1].Rows)
            {
                CycleDate = Convert.ToDateTime(drow1["Orient_MeetingStartTime"]).ToString("dd-MMM-yyyy");
                StartDate = Convert.ToDateTime(drow1["Orient_MeetingStartTime"]).ToString("HH:mm");
                EndDate = Convert.ToDateTime(drow1["Orient_MeetingEndTime"]).ToString("HH:mm");
                string MeetingLink = Convert.ToString(drow1["Orient_AssesseeMeetLink"]);
                if (cnt == 0)
                {
                    str.Append("<p>Your morning orientaion meeting is started by :</p>");
                }
                else
                {
                    str.Append("<p>Your after noon orientaion meeting is started by :</p>");
                }
                str.Append("<p>Start At : " + StartDate + "</p>");
                str.Append("<p>Orientaion Meeting Link : <a href='" + MeetingLink + "' target='_blank'>" + MeetingLink + "</a></p><br>");
                cnt++;
            }
            string CalenderStartTime = CycleDate + " " + StartDate;
            string CalenderEndTime = CycleDate + " " + EndDate;
            string MailServer = ConfigurationManager.AppSettings["MailServer"].ToString();
            string MailUserName = ConfigurationManager.AppSettings["MailUser"].ToString();
            string MailPwd = ConfigurationManager.AppSettings["MailPassword"].ToString();
            string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
            string fromMail = ConfigurationManager.AppSettings["FromAddress"].ToString();
            clsADUserInfo obj = new clsADUserInfo();
            string strTokenRes = obj.fnGetTokenNoForUser("Uma.Naveen@astix.in", "AX@12345");// (TM_UserId, TM_Password);
            foreach (DataRow drow1 in DsData.Tables[0].Rows)
            {
                MailMessage msg = new MailMessage();
                msg.From = new MailAddress("TVSM VDC<" + fromMail + ">");
                // Now Contruct the ICS file using string builder

                string AssessorCycleMappingId = Convert.ToString(drow1["AssessorCycleMappingId"]);
                string MailTo = Convert.ToString(drow1["EMailID"]);
                string Assessor = Convert.ToString(drow1["Assessor"]);
                string TM_UserId = Convert.ToString(drow1["TM_UserId"]);
                string TM_Password = Convert.ToString(drow1["TM_Password"]);

                // Now Contruct the ICS file using string builder
                if (flgActualUser == "2")
                {
                    MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
                }

                //msg.To.Add(MailTo);
                //msg.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());

                //msg.Subject = "EY Virtual DC – Orientation Meeting - " + CycleDate;
                string Subject = "EY Virtual DC – Orientation Meeting - " + CycleDate;
                StringBuilder strBody = new StringBuilder();
                strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
                strBody.Append("<p>Dear " + Assessor + ",</p>");
                strBody.Append(str);
                strBody.Append("<p><b>Regards</b></p>");
                strBody.Append("<p><b>Team EY</b></p>");
                strBody.Append("</font>");


                
                if (strTokenRes.Split('|')[0] == "1")
                {
                    string strCalendarRes = obj.fnCreateCalendar(strTokenRes.Split('|')[1], Subject, strBody.ToString(), CalenderStartTime, CalenderEndTime, MailTo, Assessor,2);
                    if (strCalendarRes.Split('|')[0] == "2")
                    {
                        strRespoonse = strCalendarRes.Split('|')[1];
                    }
                    else
                    {
                        strRespoonse = fnUpdateCalendarId(AssessorCycleMappingId, strCalendarRes.Split('|')[1]);
                    }
                }
                

                //msg.Body = strBody.ToString();
                //msg.IsBodyHtml = true;
                //SmtpClient SmtpMail = new SmtpClient();
                //SmtpMail.Host = MailServer;
                //SmtpMail.Port = 587;
                //string MUserName = MailUserName;
                //string MPwd = MailPwd;
                //NetworkCredential loginInfo = new NetworkCredential(MUserName, MPwd);
                //SmtpMail.Credentials = loginInfo;
                //SmtpMail.EnableSsl = true;
                //SmtpMail.Timeout = int.MaxValue;

                //SmtpMail.Send(msg);

            }
            if (DsData.Tables[0].Rows.Count == 0)
            {
                strRespoonse = "No Record Found!";
            }
        }
        catch (Exception ex)
        {
            strRespoonse = "Error-" + ex.Message;
        }
        return strRespoonse;
    }
    public static string fnUpdateCalendarId(string AssessorCycleMappingId, string P_CalendarEventId)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            string storedProcName = "spUpdateCalenderInviteForAssessor";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@AssessorCycleMappingId", AssessorCycleMappingId),
                   new SqlParameter("@Ass_CalendarEventId", P_CalendarEventId),
                };
            DataSet Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);

            return "1|";
        }
        catch (Exception ex)
        {
            return "2|" + ex.Message;
        }
        finally
        {
            con.Dispose();
        }
    }

}