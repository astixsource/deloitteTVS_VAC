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
public partial class M3_Rating_RatingStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //LinkButton lnkHome = (LinkButton)Page.Master.FindControl("lnkHome");
        //lnkHome.Visible = false;
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            if (!IsPostBack)
            {
                //string sss = DateTime.Now.ToString("yyyyMMddTHHmmssZ");
                hdnLogin.Value = Session["LoginId"].ToString();
                DateTime Start_date = DateTime.Now;
                DateTime Start_Time = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd") + " 10:30:00");
                int Date_Range = 2;
                int Time_Range = 16;

                string[] SkipHoliday = new string[0];
                //SkipHoliday[0] = "Sat";
                //SkipHoliday[0] = "Sun";

                fnCreatePlan(Start_date, Start_Time, Date_Range, Time_Range, SkipHoliday);
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");
        }
    }

    private void fnCreatePlan(DateTime Start_date, DateTime Start_Time, int Date_Range, int Time_Range, string[] SkipHoliday)
    {
        divStatus.InnerHtml = CreateWeekTimetbl(Start_date, Start_Time, Date_Range, Time_Range, SkipHoliday);
    }
    private string CreateWeekTimetbl(DateTime Start_date, DateTime Start_Time, int Date_Range, int Time_Range, string[] SkipHoliday)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='clstbl' style='width:100%'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        for (int j = 0; j < Date_Range; j++)
        {
            if (j == 0)
            {
                sb.Append("<th style='width:150px'>Time Slot</th>");
            }
            else
            {
                sb.Append("<th>" + Start_date.AddDays(j - 1).ToString("dd-MMM, ddd") + "</th>");
            }
        }

        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        int cnt = 0;
        for (int i = 0; i < Time_Range + 1; i++)
        {
            cnt++;
            sb.Append("<tr tr_index='" + (i + 1).ToString() + "'>");
            for (int j = 0; j < Date_Range; j++)
            {
                if (j == 0)
                {
                    Start_Time = Start_Time.AddMinutes(30);
                    sb.Append("<td style='min-width:120px'>" + Start_Time.ToString("HH:mm")+" - "+ Start_Time.AddMinutes(30).ToString("HH:mm") + "</td>");
                }
                else
                {
                    if (!SkipHoliday.Contains(Start_date.AddDays(j - 1).ToString("ddd")))
                    {
                        if (Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm")) < Convert.ToDateTime(Start_Time))
                        {
                            if (cnt >= Time_Range)
                            {
                                sb.Append("<td flgBlocked='1' flgLocked='1' dd='" + Start_Time.ToString("dd-MMM-yyyy") + "' class='clsPast' hr='" + Start_Time.ToString("HH") + "' mm='" + Start_Time.ToString("mm") + "'></td>");
                            }
                            else
                            {
                                sb.Append("<td style='text-align:left;padding-left:5px' iden='Action' dd='" + Start_Time.ToString("yyyy-MM-dd") + "' flgBlocked='0' flgLocked='0' class='clsOpen clsdivdroppable'  hr='" + Start_Time.ToString("HH") + "' mm='" + Start_Time.ToString("mm") + "' ></td>");
                            }
                        }
                        else
                        {
                            sb.Append("<td flgBlocked='0' flgLocked='1' dd='" + Start_Time.ToString("dd-MMM-yyyy") + "' class='clsPast' hr='" + Start_Time.ToString("HH") + "' mm='" + Start_Time.ToString("mm") + "'></td>");
                        }
                    }
                    else
                    {
                        sb.Append("<td flgBlocked='0' flgLocked='1' dd='" + Start_Time.ToString("yyyy-MM-dd") + "' class='clsPast' hr='" + Start_Time.ToString("HH") + "' mm='" + Start_Time.ToString("mm") + "'></td>");
                    }
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static object fnGetDetail(string loginId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetParticipantAgAssessor]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@AssessorLoginID", loginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);

        if (ds.Tables[0].Rows.Count > 0)
        {
            object obj = JsonConvert.SerializeObject(ds.Tables[0], Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            return obj;
        }
        else
            return "";
    }

    [System.Web.Services.WebMethod()]
    public static string fnSave(object udt_DataSaving, string LoginId)
    {
        string strResponse = "";
        //DateTime dt = Convert.ToDateTime(DateTime.Now.ToString("yyy-MM-dd") + " 13:30");
        //string StartDate = dt.ToString("yyyy-MM-dd hh:mm:ss tt");
        //string endDate = dt.AddHours(1).AddMinutes(30).ToString("yyyy-MM-dd hh:mm:ss tt");
        //fnSendICSFIleToParticipant("13:30", "", "", StartDate, endDate);
        try
        {
            string strDataSaving = JsonConvert.SerializeObject(udt_DataSaving, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtDataSaving = JsonConvert.DeserializeObject<DataTable>(strDataSaving);
            dtDataSaving.TableName = "tblMeetingData";
            if (dtDataSaving.Rows[0][0].ToString() == "0")
            {
                dtDataSaving.Rows[0].Delete();
            }

            DataTable dtTable = new DataTable();
            dtTable.Columns.Add(new DataColumn("ParticipantAssessorMappingId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("AssesseMeetingLink", typeof(string)));
            dtTable.Columns.Add(new DataColumn("AssessorMeetingLink", typeof(string)));
            dtTable.Columns.Add(new DataColumn("MeetingSlotTime", typeof(string)));
            dtTable.Columns.Add(new DataColumn("MeetingStartTime", typeof(DateTime)));
            dtTable.Columns.Add(new DataColumn("MeetingId", typeof(int)));
            dtTable.Rows.Clear();
            
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            Scon.Open();
            foreach (DataRow drow in dtDataSaving.Rows)
            {
                try
                {
                    dtTable.Rows.Clear();
                    DateTime dt = Convert.ToDateTime(drow["MeetingStartTime"].ToString() + " " + drow["MeetingSlotTime"].ToString());
                    string StartDate = dt.ToString("yyyy-MM-dd hh:mm:ss tt");
                    string endDate = dt.AddHours(1).AddMinutes(30).ToString("yyyy-MM-dd hh:mm:ss tt");
                    string AssesseMailTo = Convert.ToString(drow["AssesseeMail"]);

                    string AssessName = Convert.ToString(drow["AssesseeName"]);
                    string AssesseeSecondaryMailID = Convert.ToString(drow["AssesseeSecondaryMailID"]);
                    string BEIUserName = Convert.ToString(drow["BEIUserName"]);
                    string BEIPassword = Convert.ToString(drow["BEIPwd"]);
                    var accessToken = clsHttpRequest.GetTokenNo(BEIUserName, BEIPassword);
                    List<MeetingCreated> lstMeetingCreated = fnCreateGotoMeeting(accessToken, StartDate, endDate);
                    drow["AssesseMeetingLink"] = lstMeetingCreated[0].joinURL;
                    drow["MeetingId"] = lstMeetingCreated[0].meetingid;
                    //MeetingsApi objMeetingsApi = new MeetingsApi();
                    //var strHostURL = objMeetingsApi.startMeeting(accessToken, lstMeetingCreated[0].meetingid);
                    drow["AssessorMeetingLink"] =""; //strHostURL.hostURL;

                    // string DialingNumber = lstMeetingCreated[0].conferenceCallInfo.Split('\n')[0];
                    // string AccessCode = lstMeetingCreated[0].conferenceCallInfo.Split('\n')[1];

                    DataRow dr = dtTable.NewRow();
                    dr[0] = drow["ParticipantAssessorMappingId"].ToString();
                    dr[1] = lstMeetingCreated[0].joinURL;
                    dr[2] = "";
                    dr[3] = drow["MeetingSlotTime"].ToString();
                    dr[4] = drow["MeetingStartTime"].ToString();
                    dr[5] = lstMeetingCreated[0].meetingid;
                    dtTable.Rows.Add(dr);

                    SqlCommand Scmd = new SqlCommand();
                    Scmd.Connection = Scon;
                    Scmd.CommandText = "[spPopulateMeetingTimeSlotMstr]";
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.Parameters.AddWithValue("@tblMeetingData", dtTable);
                    Scmd.Parameters.AddWithValue("@LoginId", LoginId);
                    Scmd.CommandTimeout = 0;
                    Scmd.ExecuteNonQuery();
                    drow["flgCreated"] = 1;
                    drow["MeetingStatus"] = "Meeting Scheduled";

                    fnSendICSFIleToParticipant(drow["MeetingSlotTime"].ToString(), AssesseMailTo, AssessName, StartDate, endDate, AssesseeSecondaryMailID);
                    string strMailToDeveloper = ("<table><tr><td>" + AssessName + "</td><td>:</td><td>" + drow["MeetingSlotTime"].ToString() + "</td></tr></table>");
                    string AssessorMail = Convert.ToString(drow["AssessorMail"]);
                    string AssessorName = Convert.ToString(drow["AssessorName"]);
                    string AssessorSecondaryEmailID = Convert.ToString(drow["AssessorSecondaryMailID"]);
                    fnSendICSFIleToDeveloper(strMailToDeveloper.ToString(), AssessorMail, AssessorName, AssessName, AssesseMailTo, StartDate, endDate, AssessorSecondaryEmailID, BEIUserName,BEIPassword);
                }
                catch (Exception ex)
                {
                    drow["MeetingStatus"] = "Error-" + ex.Message;
                }
            }
            strResponse = "0|" + JsonConvert.SerializeObject(dtDataSaving, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            Scon.Dispose();
        }
        catch (Exception ex)
        {
            strResponse = "1|" + ex.Message;
        }
        return strResponse;
    }


    public static void fnSendICSFIleToParticipant(string MeetingSlot, string MailTo, string DisplayName, string StartDate, string EndDate,string AssesseeSecondaryMailID)
    {
        string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
        string fromMail =ConfigurationManager.AppSettings["MailUser"].ToString();
        // Now Contruct the ICS file using string builder
        if (flgActualUser == "2")
        {
            MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
            DisplayName = "Participant";
        }
        MailMessage msg = new MailMessage();
        msg.From = new MailAddress("LTAssessment<" + fromMail + ">");
        msg.To.Add(MailTo);
        msg.CC.Add(AssesseeSecondaryMailID);
        msg.Subject = "Assessment Meeting";
        StringBuilder strBody = new StringBuilder();
        strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
        strBody.Append("<p>Dear " + DisplayName + ",</p>");
        strBody.Append("<p>Your BEI will start at " + MeetingSlot + ". Request to you click on \"<b>Start Meeting</b>\" on your portal 5 minutes prior to the scheduled time to ensure system is ready for the meeting to commence. </p>");
        strBody.Append("<p>Thanks</p>");
        strBody.Append("</font>");
        msg.IsBodyHtml = true;

        System.Net.Mime.ContentType HTMLType = new System.Net.Mime.ContentType("text/html");
        AlternateView avCal = AlternateView.CreateAlternateViewFromString(strBody.ToString(), HTMLType);
        msg.AlternateViews.Add(avCal);

        StringBuilder str = new StringBuilder();
        str.AppendLine("BEGIN:VCALENDAR");
        str.AppendLine("PRODID:Meeting1");
        str.AppendLine("VERSION:2.0");
        str.AppendLine("METHOD:REQUEST");
        str.AppendLine("BEGIN:VEVENT");
        DateTime dtStartTime = Convert.ToDateTime(StartDate);
        DateTime dtEndTime = Convert.ToDateTime(EndDate);
        str.AppendLine(string.Format("DTSTART:{0:yyyyMMddTHHmmss}", dtStartTime.ToUniversalTime().ToString("yyyyMMdd\\THHmmss\\Z")));
        str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmss}", DateTime.Now));
        str.AppendLine(string.Format("DTEND:{0:yyyyMMddHHmmss}", dtEndTime.ToUniversalTime().ToString("yyyyMMdd\\THHmmss\\Z")));
        str.AppendLine("LOCATION: " + msg.From.Address);
        str.AppendLine(string.Format("UID:{0}", Guid.NewGuid()));
        str.AppendLine(string.Format("DESCRIPTION:{0}", strBody.ToString()));
        str.AppendLine(string.Format("X-ALT-DESC;FMTTYPE=text/html:{0}", strBody.ToString()));
        str.AppendLine(string.Format("SUMMARY:{0}", msg.Subject));
        str.AppendLine(string.Format("ORGANIZER:MAILTO:{0}", msg.From.Address));
        str.AppendLine(string.Format("ATTENDEE;CN=\"{0}\";RSVP=TRUE:mailto:{1}", msg.To[0].DisplayName, msg.To[0].Address));

        str.AppendLine("BEGIN:VALARM");
        str.AppendLine("TRIGGER:-PT15M");
        str.AppendLine("ACTION:DISPLAY");
        str.AppendLine("DESCRIPTION:Reminder");
        str.AppendLine("END:VALARM");
        str.AppendLine("END:VEVENT");
        str.AppendLine("END:VCALENDAR");

        System.Net.Mime.ContentType contype = new System.Net.Mime.ContentType("text/calendar");
        contype.Parameters.Add("method", "REQUEST");
        contype.Parameters.Add("name", "Meeting.ics");
        AlternateView avCal1 = AlternateView.CreateAlternateViewFromString(str.ToString(), contype);
        msg.AlternateViews.Add(avCal1);
        SmtpClient SmtpMail = new SmtpClient();
        SmtpMail.Host = ConfigurationManager.AppSettings["MailServer"].ToString();
        SmtpMail.Port = 25;
        string UserName = ConfigurationManager.AppSettings["MailUser"].ToString();
        string Pwd = ConfigurationManager.AppSettings["MailPassword"].ToString();
        NetworkCredential loginInfo = new NetworkCredential(UserName, Pwd);
        SmtpMail.Credentials = loginInfo;
        SmtpMail.EnableSsl = true;
        SmtpMail.Timeout = int.MaxValue;
        SmtpMail.Send(msg);
    }

    public static void fnSendICSFIleToDeveloper(string MeetingData, string MailTo, string DisplayName, string ParticipantName, string ParticipantMail, string StartDate, string EndDate,string AssessorSecondaryEmailID,string BEIUserName,string BEIPassword)
    {
        string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
        string fromMail = ConfigurationManager.AppSettings["MailUser"].ToString();
        // Now Contruct the ICS file using string builder
        if (flgActualUser == "2")
        {
            MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
            DisplayName = "Developer";
        }
        MailMessage msg = new MailMessage();
        msg.From = new MailAddress("LTAssessment<" + fromMail + ">");
        msg.To.Add(MailTo);
        msg.CC.Add(AssessorSecondaryEmailID);
        msg.Subject = "Assessment Meeting";
        StringBuilder strBody = new StringBuilder();
        
        strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
        strBody.Append("<p>Dear " + DisplayName + ",</p>");
        strBody.Append("<p>Your BEI have been scheduled as follows:</p>");
        strBody.Append(MeetingData);
        strBody.Append("<p>Your credential for BEI are below:</p>");
        strBody.Append("<p>UserName:"+ BEIUserName + "</p>");
        strBody.Append("<p>Password:" + BEIPassword + "</p>");
        strBody.Append("<p>Request to you click on \"Start Meeting\" on your portal 5 minutes prior to the scheduled time to ensure system is ready for the meeting to commence.</p>");
        strBody.Append("<p>Thanks</p>");
		strBody.Append("</font>");
		msg.IsBodyHtml = true;
		System.Net.Mime.ContentType HTMLType = new System.Net.Mime.ContentType("text/html");
        AlternateView avCal = AlternateView.CreateAlternateViewFromString(strBody.ToString(), HTMLType);
        msg.AlternateViews.Add(avCal);

        StringBuilder str = new StringBuilder();
        str.AppendLine("BEGIN:VCALENDAR");
        str.AppendLine("PRODID:Meeting1");
        str.AppendLine("VERSION:2.0");
        str.AppendLine("METHOD:REQUEST");
        str.AppendLine("BEGIN:VEVENT");
        DateTime dtStartTime = Convert.ToDateTime(StartDate);
        DateTime dtEndTime = Convert.ToDateTime(EndDate);
        str.AppendLine(string.Format("DTSTART:{0:yyyyMMddTHHmmss}", dtStartTime.ToUniversalTime().ToString("yyyyMMdd\\THHmmss\\Z")));
        str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmss}", DateTime.Now));
        str.AppendLine(string.Format("DTEND:{0:yyyyMMddHHmmss}", dtEndTime.ToUniversalTime().ToString("yyyyMMdd\\THHmmss\\Z")));
        str.AppendLine("LOCATION: " + msg.From.Address);
        str.AppendLine(string.Format("UID:{0}", Guid.NewGuid()));
        str.AppendLine(string.Format("DESCRIPTION:{0}", strBody.ToString()));
        str.AppendLine(string.Format("X-ALT-DESC;FMTTYPE=text/html:{0}", strBody.ToString()));
        str.AppendLine(string.Format("SUMMARY:{0}", msg.Subject));
        str.AppendLine(string.Format("ORGANIZER:MAILTO:{0}", MailTo));
        str.AppendLine(string.Format("ATTENDEE;CN=\"{0}\";RSVP=TRUE:mailto:{1}", ParticipantName, ParticipantMail));

        str.AppendLine("BEGIN:VALARM");
        str.AppendLine("TRIGGER:-PT15M");
        str.AppendLine("ACTION:DISPLAY");
        str.AppendLine("DESCRIPTION:Reminder");
        str.AppendLine("END:VALARM");
        str.AppendLine("END:VEVENT");
        str.AppendLine("END:VCALENDAR");

        System.Net.Mime.ContentType contype = new System.Net.Mime.ContentType("text/calendar");
        contype.Parameters.Add("method", "REQUEST");
        contype.Parameters.Add("name", "Meeting.ics");
        AlternateView avCal1 = AlternateView.CreateAlternateViewFromString(str.ToString(), contype);
        msg.AlternateViews.Add(avCal1);
		
        SmtpClient SmtpMail = new SmtpClient();
        SmtpMail.Host = ConfigurationManager.AppSettings["MailServer"].ToString();
        SmtpMail.Port = 25;
        string UserName = ConfigurationManager.AppSettings["MailUser"].ToString();
        string Pwd = ConfigurationManager.AppSettings["MailPassword"].ToString();
        NetworkCredential loginInfo = new NetworkCredential(UserName, Pwd);
        SmtpMail.Credentials = loginInfo;
        SmtpMail.EnableSsl = true;
        SmtpMail.Timeout = int.MaxValue;
        SmtpMail.Send(msg);
    }
    public static List<MeetingCreated> fnCreateGotoMeeting(string accessToken, string MeetingDate, string MeetingEndDate)
    {
        MeetingRecording objMeetingRec = new MeetingRecording();
        MeetingsApi objMeetingsApi = new MeetingsApi();
        MeetingReqCreate meetingBody = new MeetingReqCreate();
        meetingBody.subject = "Assessment Meeting";
        meetingBody.meetingtype = MeetingType.scheduled;
        meetingBody.passwordrequired = false;
        DateTime dtStartTime = Convert.ToDateTime(MeetingDate).ToUniversalTime();
        DateTime dtEndTime = Convert.ToDateTime(MeetingEndDate).ToUniversalTime();
        meetingBody.starttime = dtStartTime;
        meetingBody.endtime = dtEndTime;
        meetingBody.conferencecallinfo = "hybrid";
        meetingBody.timezonekey = "Asia/Calcutta";
        //OrganizersApi oapi = new OrganizersApi();
        //List<Organizer> lst = oapi.getOrganizerByEmail(accessToken, "jyoti@astixsolutions.com");
        //List<string> lst1 = new List<string>();
        //lst1.Add(lst[0].organizerKey.ToString());
        //meetingBody.coorganizerKeys = lst1;
        List<MeetingCreated> lstMeetingCreated = objMeetingsApi.createMeeting(accessToken, meetingBody);
        return lstMeetingCreated;
    }
}