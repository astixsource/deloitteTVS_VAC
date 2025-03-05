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
using LogMeIn.GoToMeeting.Api.Model;

public partial class Admin_MasterForms_frmParticipantAndAssessorMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Session["LoginID"] = 0;
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        else {
            if (!IsPostBack)
            {
                hdnLoginId.Value = Session["LoginID"].ToString();
                fnBindAssessementList();
                //fnbindgroupmaster();
                //fnbindassessor();
            }
        }
    }

    private void fnBindAssessementList()
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAssessmentCycleDetail";
        Scmd.Parameters.AddWithValue("@CycleID", 0);
        Scmd.Parameters.AddWithValue("@Flag", 0);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dt = new DataTable();
        Sdap.Fill(dt);

        ListItem itm = new ListItem();
        itm.Text = "--------";
        itm.Value = "0";
        ddlCycle.Items.Add(itm);
        foreach (DataRow dr in dt.Rows)
        {
            itm = new ListItem();
            itm.Text = dr["CycleName"].ToString() + " (" + Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy") + ")";
            itm.Value = dr["CycleId"].ToString();
            itm.Attributes.Add("cycledate", Convert.ToDateTime(dr["CycleStartDate"]).ToString("yyyy-MM-dd"));
            ddlCycle.Items.Add(itm);
            
        }
    }
    
    //Get Scheme And Product Detail Bases on Store
    [System.Web.Services.WebMethod()]
    public static string fngetdata(int CycleId,string cycledate)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        DataSet Ds = null;
        DataSet DsData = null;
        string stresponse = "";
        try
        {
            string storedProcName = "spGetAssessorParticipantForMapping";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@CycleId", CycleId),
                };
            Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);

            
            DataRow dr = Ds.Tables[1].NewRow();
            dr["AssessorId"] = "0";
            dr["AssessorName"] = "---Select---";
            Ds.Tables[1].Rows.InsertAt(dr, 0);

            StringBuilder str = new StringBuilder();
            StringBuilder str1 = new StringBuilder();

            if (Ds.Tables[0].Rows.Count > 0)
            {
                string[] SkipColumn = new string[15];
                SkipColumn[0] = "ParticipantId";
                SkipColumn[1] = "ParticipantCycleMappingId";
                SkipColumn[2] = "ParticipantAssessorMappingId";
                SkipColumn[3] = "EmpCode";
                SkipColumn[4] = "MeetingId";
                SkipColumn[5] = "ExerciseId";
                SkipColumn[6] = "ParticipantEmailId";
                SkipColumn[7] = "AssessorCycleMappingId";
                SkipColumn[8] = "AssessorTime";
                SkipColumn[9] = "PrepTime";
                SkipColumn[10] = "Mapped Assessor";
                SkipColumn[11] = "GDID";
                SkipColumn[12] = "PR Time";
                SkipColumn[13] = "Exercise StartDate";
                SkipColumn[14] = "ExerciseName";
                
                
                int isSubmitted = 0;// int.Parse(Ds.Tables[1].Rows[0]["isSubmitted"].ToString());
                str.Append("<div id='dvtblbody' class='mb-3'><table id='tbldbrlist' class='table table-bordered table-sm mb-0' isSubmitted=" + isSubmitted + "><thead><tr>");

                string ss = "";

                //str.Append("<th style='width:6%' >SrNo</th>");
                for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                {
                    if (SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName))
                    {
                        continue;
                    }
                    string sColumnName = "";

                    //ss = "style='text-align:center'";
                    if (Ds.Tables[0].Columns[j].ColumnName.ToLower() == "assessorid")
                    {
                        sColumnName = "Assessor";
                    }else if (Ds.Tables[0].Columns[j].ColumnName.ToLower() == "exercise starttime")
                    {
                        sColumnName = "Client Conversation Start Time(IST)";
                        ss = "style='width:25%'";
                    }
                    else
                    {
                        sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                    }
                     //sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                    //if (sColumnName == "Route Name")
                    //{
                    //    ss = "style='width:35%'";
                    //}
                    str.Append("<th "+ ss + ">" + sColumnName + "</th>");
                }
                //str.Append("<th style='width:30%'>Developer</th>");
                //str.Append("<th style='width:8%'></th>");
                str.Append("</tr></thead><tbody>");

                //ss = "";
                string OldParticipantId = "0";string strStyleDisplayRow = ";display:none";
                for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
                {
                    strStyleDisplayRow = ";display:none";
                    if (OldParticipantId != Ds.Tables[0].Rows[i]["ParticipantId"].ToString())
                    {
                        strStyleDisplayRow = "display:table-row";
                    }
                        string dropdownlist_at = "";
                        string time_dropdownlist = "";

                        //dropdownlist_at += "<option value='0'>--Select---</option>";
                        for (var j = 0; j < Ds.Tables[1].Rows.Count; j++)
                        {
                            if (Ds.Tables[0].Rows[i]["AssessorId"].ToString() == Ds.Tables[1].Rows[j]["AssessorId"].ToString())
                            {
                                dropdownlist_at += "<option AssessorCycleMappingId='" + Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() + "' BEIUserName='" + Ds.Tables[1].Rows[j]["BEIUserName"].ToString() + "' BEIPassword='" + Ds.Tables[1].Rows[j]["BEIPassword"].ToString() + "' AssessorEmailId='" + Ds.Tables[1].Rows[j]["AssessorEmailId"].ToString() + "' assessorname='" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "' value='" + Ds.Tables[1].Rows[j]["AssessorId"].ToString() + "'  selected>" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "</option>";
                            }
                            else
                            {
                                dropdownlist_at += "<option AssessorCycleMappingId='" + Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() + "' BEIUserName='" + Ds.Tables[1].Rows[j]["BEIUserName"].ToString() + "' BEIPassword='" + Ds.Tables[1].Rows[j]["BEIPassword"].ToString() + "' AssessorEmailId='" + Ds.Tables[1].Rows[j]["AssessorEmailId"].ToString() + "' assessorname='" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "' value='" + Ds.Tables[1].Rows[j]["AssessorId"].ToString() + "'>" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "</option>";
                            }
                        }

                        //string st = "09:00 am";
                        //string ed = "10:00 pm";

                        DateTime start = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd") + " 06:00:00");
                        DateTime end = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd") + " 20:30:00");
                        int interval = 15;
                        //List<string> lstTimeIntervals = new List<string>();
                        time_dropdownlist += "<option value='0' selected>--Select--</option>";
                        for (DateTime t_i = start; t_i <= end; t_i = t_i.AddMinutes(interval))
                        {
                            if (Ds.Tables[0].Rows[i]["exercise starttime"].ToString() == t_i.ToString("HH:mm"))
                            {
                                time_dropdownlist += "<option value='" + t_i.ToString("HH:mm") + "' selected>" + t_i.ToString("HH:mm") + "</option>";
                            }
                            else
                            {
                                time_dropdownlist += "<option value='" + t_i.ToString("HH:mm") + "'>" + t_i.ToString("HH:mm") + "</option>";
                            }
                        }


                        //lstTimeIntervals.Add(i.ToString("HH:mm tt"));


                        string ParticipantCycleMappingId = Ds.Tables[0].Rows[i]["ParticipantCycleMappingId"].ToString();
                        int flgMapped = Convert.ToInt32(Ds.Tables[0].Rows[i]["ParticipantAssessorMappingId"]);
                        //int flgStatus = Convert.ToInt32(Ds.Tables[0].Rows[i]["flgStatus"]);
                        //long flgMeeting = Convert.ToInt64(Ds.Tables[0].Rows[i]["MeetingId"]);
                        string strHightlightclass = "";
                        string strTitle = "";
                        string[] rowspanColumn = new string[2];
                        rowspanColumn[0] = "participantname";
                        rowspanColumn[0] = "exercise startdate";
                        if (flgMapped > 0)
                        {
                            strTitle = "Assessement has not started";
                            strHightlightclass = "class='clsHighlightrows'";
                        }
                        str.Append("<tr style='"+ strStyleDisplayRow + "' cycledate='" + cycledate + "' PreTime='" + Ds.Tables[0].Rows[i]["PrepTime"].ToString() + "' AssessorTime='" + Ds.Tables[0].Rows[i]["AssessorTime"].ToString() + "'  ParticipantCycleMappingId='" + Ds.Tables[0].Rows[i]["ParticipantCycleMappingId"].ToString() + "' Participantid='" + Ds.Tables[0].Rows[i]["Participantid"].ToString() + "' assessorcyclemappingid='" + Ds.Tables[0].Rows[i]["assessorcyclemappingid"].ToString() + "' participantassessormappingid='" + Ds.Tables[0].Rows[i]["participantassessormappingid"].ToString() + "' participantemailid='" + Ds.Tables[0].Rows[i]["participantemailid"].ToString() + "'  participantname='" + Ds.Tables[0].Rows[i]["participantname"].ToString() + "'  empcode='" + Ds.Tables[0].Rows[i]["empcode"].ToString() + "' ExerciseStartTime='" + Ds.Tables[0].Rows[i]["Exercise StartTime"].ToString() + "' exerciseid='" + Ds.Tables[0].Rows[i]["exerciseid"].ToString() + "'  ExerciseName='" + Ds.Tables[0].Rows[i]["ExerciseName"].ToString() + "'>");
                        //str.Append("<td style='text-align:center'>" + (i + 1) + "</td>");
                        string exerciseid = Ds.Tables[0].Rows[i]["exerciseid"].ToString();
                        for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                        {
                            string sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                            if (SkipColumn.Contains(sColumnName))
                            {
                                continue;
                            }
                            var sData = Ds.Tables[0].Rows[i][j];

                            string flgSearchable = "Searchable='0'";
                            if (Ds.Tables[0].Columns[j].ColumnName == "EmpName" || Ds.Tables[0].Columns[j].ColumnName == "EmpCode")
                            {
                                flgSearchable = "Searchable='1'";
                            }
                            //ss += "'";

                            if (Ds.Tables[0].Columns[j].ColumnName.ToLower() == "assessorid")
                            {
                                str.Append("<td style='text-align:left'><select id='ddlassessor' onchange='fnChangeAssessor(this)'  class='col-10' class='clsassessor'  AssessorCycleMappingId='0'  > " + dropdownlist_at + "<select/></td>");
                            }

                            else if (Ds.Tables[0].Columns[j].ColumnName.ToLower() == "exercise starttime")
                            {
                                str.Append("<td style='text-align:left'><select id='ddltimeslot'  class='col-10' class='clsisleadassessor'   onchange='fnChangeTimeSlot(this)' > " + time_dropdownlist + "<select/></td>");
                            }
                            //else if (Ds.Tables[0].Columns[j].ColumnName.ToLower() == "participantname")
                            //{
                            //    if (i > 0)
                            //    {
                            //        if ((Ds.Tables[0].Rows[i]["ParticipantId"].ToString() == Ds.Tables[0].Rows[i - 1]["ParticipantId"].ToString()) == false)
                            //        {
                            //            str.Append("<td class='mergerow' rowspan=" + Ds.Tables[0].Select("ParticipantId = '" + Ds.Tables[0].Rows[i]["ParticipantId"].ToString() + "'").Length + " " + flgSearchable + ">" + sData + "</td>");
                            //        }
                            //    }
                            //    else
                            //    {
                            //        str.Append("<td  class='mergerow' rowspan=" + Ds.Tables[0].Select("ParticipantId = '" + Ds.Tables[0].Rows[i]["ParticipantId"].ToString() + "'").Length + " " + flgSearchable + ">" + sData + "</td>");
                            //    }
                            //}
                            else
                            {
                                str.Append("<td " + flgSearchable + ">" + sData + "</td>");
                            }

                        }
                        str.Append("</tr>");

                    OldParticipantId = Ds.Tables[0].Rows[i]["ParticipantId"].ToString();
                }
                str.Append("</tbody></table></div>");
            }
            else
            {
                str.Append("");
            }

            stresponse = str.ToString()+"|"+ Convert.ToString(Ds.Tables[2].Rows[0]["flgstatus"]);
        }
        catch (Exception ex)
        {
            stresponse = "2|" + ex.Message;
        }
        finally
        {
            con.Dispose();
        }

        return stresponse;
    }

    [System.Web.Services.WebMethod()]
    public static string fnSave(object udt_DataSaving, string LoginId,int CycleId,int flgStatus)
    {
        string strResponse = "";
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
            dtTable.Columns.Add(new DataColumn("ParticipantCycleMappingId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("AssessorCycleMappingId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("ParticipantId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("AssessorId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("IsLeadAssessor", typeof(int)));
            dtTable.Columns.Add(new DataColumn("ExerciseId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("ExerciseStartTime", typeof(DateTime)));
            dtTable.Columns.Add(new DataColumn("ExerciseEndTime", typeof(DateTime)));
            dtTable.Columns.Add(new DataColumn("AssesseMeetingLink", typeof(string)));
            dtTable.Columns.Add(new DataColumn("AssessorMeetingLink", typeof(string)));
            dtTable.Columns.Add(new DataColumn("MeetingSlotTime", typeof(string)));
            dtTable.Columns.Add(new DataColumn("MeetingStartTime", typeof(DateTime)));
            dtTable.Columns.Add(new DataColumn("MeetingEndTime", typeof(DateTime)));
            dtTable.Columns.Add(new DataColumn("MeetingId", typeof(int)));
            dtTable.Columns.Add(new DataColumn("GDID", typeof(int)));
            dtTable.Columns.Add(new DataColumn("PRStartTime", typeof(string)));
            dtTable.Rows.Clear();

            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            Scon.Open();
            foreach (DataRow drow in dtDataSaving.Rows)
            {
                try
                {
                    string AssessorId = Convert.ToString(drow["AssessorId"]);
                    
                        int PreTime = Convert.ToInt32(drow["PreTime"].ToString());
                        DateTime dt1 = Convert.ToDateTime(drow["MeetingStartTime"].ToString());
                       
                        DateTime dt = Convert.ToDateTime(drow["MeetingStartTime"].ToString());
                        dt = dt.AddMinutes(PreTime);
                        string StartDate = dt.ToString("yyyy-MM-dd hh:mm:ss tt");
                        int AssessorTime = Convert.ToInt32(drow["AssessorTime"].ToString());
                        string endDate = dt.AddMinutes(AssessorTime).ToString("yyyy-MM-dd hh:mm:ss tt");
                       
                        DataRow dr = dtTable.NewRow();
                        dr[0] = 0;
                        dr[1] = drow["ParticipantCycleMappingId"].ToString();
                        dr[2] = drow["AssessorCycleMappingId"].ToString();
                        dr[3] = drow["ParticipantId"].ToString();
                        dr[4] = drow["AssessorId"].ToString();
                        dr[5] = drow["IsLeadAssessor"].ToString();
                        dr[6] = drow["ExerciseId"].ToString();
                        dr[7] = Convert.ToDateTime(drow["MeetingStartTime"].ToString());
                        dr[8] = Convert.ToDateTime(endDate);
                        dr[9] = "";
                        dr[10] = "";
                        dr[11] = DBNull.Value;
                        dr[12] = DBNull.Value;
                        dr[13] = DBNull.Value;
                        dr[14] = 0;
                        dr[15] = drow["gdid"].ToString();
                        dr[16] = drow["PRStartTime"].ToString();
                        dtTable.Rows.Add(dr);
                        drow["flgCreated"] = 1;
                        drow["MeetingStatus"] = AssessorId!="0"? "Mapping Done":"Mapping Pending";
                    drow["MeetingStartTime"] = AssessorId != "0" ? dt1.ToString("dd MMM hh:mm tt") : "";
                    
                }
                catch (Exception ex)
                {
                    drow["MeetingStatus"] = "Error-" + ex.Message;
                }
            }

            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spPopulateAssessorParticipantMapping]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@tblParticipant", dtTable);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@flgStatus", flgStatus);
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);


            Scmd.CommandTimeout = 0;
            Scmd.ExecuteNonQuery();
            strResponse = "0|" + JsonConvert.SerializeObject(dtDataSaving, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            Scon.Dispose();
        }
        catch (Exception ex)
        {
            strResponse = "1|" + ex.Message;
        }
        return strResponse;
    }



    public static void fnSendICSFIleToParticipant(string ExerciseName, string MailTo, string DisplayName, string StartDate, string EndDate)
    {
        string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
        string fromMail = ConfigurationManager.AppSettings["MailUser"].ToString();
        // Now Contruct the ICS file using string builder
        if (flgActualUser == "2")
        {
            MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
            DisplayName = "Participant";
        }
        MailMessage msg = new MailMessage();
        msg.From = new MailAddress("BoschAssessment<" + fromMail + ">");
        msg.To.Add(MailTo);
       
            
        msg.Subject = "Assessement Meeting -"+ ExerciseName;
        StringBuilder strBody = new StringBuilder();
        strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
        strBody.Append("<p>Dear " + DisplayName + ",</p>");
        strBody.Append("<p>Your "+ ExerciseName + " assessement meeting will start at " + StartDate + ". Request to you click on \"<b>Start Meeting</b>\" on your portal 5 minutes prior to the scheduled time to ensure system is ready for the meeting to commence.</p>");
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

    public static void fnSendICSFIleToDeveloper(string ExerciseName, string MeetingData, string MailTo, string DisplayName, string ParticipantName, string ParticipantMail, string StartDate, string EndDate, string BEIUserName, string BEIPassword)
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
        msg.From = new MailAddress("BoschAssessment<" + fromMail + ">");
        msg.To.Add(MailTo);
        
        msg.Subject = "Assessment Meeting-"+ ExerciseName;
        StringBuilder strBody = new StringBuilder();

        strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
        strBody.Append("<p>Dear " + DisplayName + ",</p>");
        strBody.Append("<p>Your "+ExerciseName+" assessement meeting have been scheduled as follows:</p>");
        strBody.Append(MeetingData);
        strBody.Append("<p>Your credential for " + ExerciseName + " are below:</p>");
        strBody.Append("<p>UserName:" + BEIUserName + "</p>");
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
        str.AppendLine("LOCATION: " + MailTo);
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

    public static List<MeetingCreated> fnCreateGotoMeeting(string ExerciseName, string accessToken, string MeetingDate, string MeetingEndDate)
    {
        MeetingRecording objMeetingRec = new MeetingRecording();
        MeetingsApi objMeetingsApi = new MeetingsApi();
        MeetingReqCreate meetingBody = new MeetingReqCreate();
        meetingBody.subject = "Assessment Meeting-"+ ExerciseName;
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