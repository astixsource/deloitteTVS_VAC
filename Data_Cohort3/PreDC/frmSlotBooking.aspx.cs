using LogMeIn.GoToMeeting.Api;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class frmSlotBooking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] == null)
        {
            Response.Redirect("../../Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            hdnLogin.Value = Session["LoginId"].ToString();
            hdnEmpNodeId.Value = Session["EmpNodeID"].ToString();
        }
    }


    [System.Web.Services.WebMethod()]
    public static string fnAssessmentgetAvailableSlots(string LoginId, int flg)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        string strResponse = "";
        try
        {
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spAssessmentgetAvailableSlots]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);

            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            if (flg == 2)
            {
                return JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            }
            string[] SkipColumn = new string[2];
            SkipColumn[0] = "CycleId";
            SkipColumn[1] = "SlotId";

            StringBuilder sb = new StringBuilder();
            if (ds.Tables[1].Rows.Count > 0)
            {
                string P_CalendarEventId= ds.Tables[1].Rows[0]["P_CalendarEventId"].ToString();
                string BatchDate = ds.Tables[1].Rows[0]["Batch Date"].ToString();
                string BatchId = ds.Tables[1].Rows[0]["CycleId"].ToString();
                string ParticipantId = ds.Tables[1].Rows[0]["ParticipantId"].ToString();
                string ParticipantCycleMappingId = ds.Tables[1].Rows[0]["ParticipantCycleMappingId"].ToString();
                string StartTime = ds.Tables[1].Rows[0]["Start Time"].ToString();
                string EndTime = ds.Tables[1].Rows[0]["End Time"].ToString();
                string FeedbackStartTime = ds.Tables[1].Rows[0]["Feedback Start Time"].ToString();
                string FeedbackEndTime = ds.Tables[1].Rows[0]["Feedback End Time"].ToString();
                sb.Append("<div style='margin-top:15%;'><p class='text-center alert alert-danger font-weight-bold'>Your VDC Slot is from " + StartTime + " to " + EndTime + " on " + BatchDate + ".</p>");
                sb.Append("<div class='text-center pt-3'><input type='button' id='btnReschedule' class='btns btn-submit' value='Cancel & Reschedule' onclick=\"fnCancelSlot(this,'" + ParticipantCycleMappingId + "','"+ P_CalendarEventId + "')\" /></div></div>");//<input type='button' id='btnCareer' class='btns btn-submit' value='Go To Career Reflection Form' onclick=\"fnNextpage()\" style='margin-left:10px' />
                strResponse = "0|" + sb.ToString();
            }
            else
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    sb.Append("<div id='dvtblbody'><table id='tbl_Status' class='table table-bordered table-sm bg-white'>");
                    sb.Append("<thead>");
                    sb.Append("<tr>");
                    for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                    {
                        string sColumnName = ds.Tables[0].Columns[j].ColumnName.ToString();
                        if (!SkipColumn.Contains(sColumnName))
                        {
                            sb.Append("<th>" + sColumnName + "</th>");

                        }
                    }
                    sb.Append("<th>Action</th>");
                    sb.Append("</thead>");
                    sb.Append("<tbody>");
                    string[] rowspanColumn = new string[1];
                    rowspanColumn[0] = "Batch Date";
                    foreach (DataRow Row in ds.Tables[0].Rows)
                    {
                        sb.Append("<tr CycleId='" + Row["CycleId"].ToString() + "' SlotId='" + Row["SlotId"].ToString() + "'  >");
                        for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                        {
                            string sColumnName = ds.Tables[0].Columns[j].ColumnName.ToString();
                            if (!SkipColumn.Contains(sColumnName))
                            {
                                if (rowspanColumn.Contains(sColumnName))
                                {
                                    int Row_Span = 0;
                                    DataRow drows = null;
                                    Row_Span = ds.Tables[0].Select("[" + sColumnName + "]='" + Row[sColumnName].ToString() + "'").Count();
                                    drows = ds.Tables[0].Select("[" + sColumnName + "]='" + Row[sColumnName].ToString() + "'")[0];
                                    if (Row_Span > 1)
                                    {
                                        if (Row == drows)
                                        {
                                            sb.Append(string.Format("<td rowspan='{0}'>{1}</td>", Row_Span, Row[sColumnName]));
                                        }
                                    }
                                    else
                                    {
                                        sb.Append(string.Format("<td>{1}</td>", Row_Span, Row[sColumnName]));
                                    }
                                }
                                else
                                {
                                    sb.Append("<td " + (sColumnName == "SlotsAvailable" ? "iden='slot'" : "") + ">" + Row[sColumnName].ToString() + "</td>");
                                }
                            }
                        }
                        if (Convert.ToInt32(Row["SlotsAvailable"]) > 0)
                        {
                            sb.Append("<td iden='btn' class='text-center'><input type='button' slotdate='" + Row["Batch Date"].ToString() + "' SlotDescr='" + Row["SlotDescr"].ToString() + "' value='Book' onclick='fnBookSlot(this)' class='btn btn-primary sm' style='padding:1px 15px;' /></td>");
                        }
                        else
                        {
                            sb.Append("<td></td>");
                        }
                        sb.Append("</tr>");
                    }
                    sb.Append("</tbody>");
                    sb.Append("</table></div>");
                    strResponse = "0|" + sb.ToString();
                }
                else
                {
                    strResponse = "0|<div style='padding : 10px 20px; color:red; font-weight:bold;'>No Record Found !</div>";
                }
            }
        }
        catch (Exception ex)
        {
            strResponse = "1|" + ex.Message;
        }
        finally
        {
            Scon.Dispose();
        }

        return strResponse.ToString();
    }


    [System.Web.Services.WebMethod()]
    public static string fnBookSlot(string CycleId, string SlotId, string LoginId, int flgReschudule)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            HttpContext.Current.Session["LoginId"] = LoginId;
            string storedProcName = "spAssessmentSaveIndSchedule";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@LoginId", LoginId),
                   new SqlParameter("@SlotId", SlotId),
                   new SqlParameter("@CycleId", CycleId),
                };
            DataSet Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);
            string strresponse = "";
            if (Ds.Tables[1].Rows.Count > 0)
            {
                string ParticipantCycleMappingId= Ds.Tables[1].Rows[0]["ParticipantCycleMappingId"].ToString();
                string EmpNodeId = Ds.Tables[1].Rows[0]["EmpNodeID"].ToString();
                string EmpName =Ds.Tables[1].Rows[0]["FullName"].ToString();
                string EmailId =Ds.Tables[1].Rows[0]["EmailId"].ToString();
                string StartTime = Ds.Tables[1].Rows[0]["StartTime"].ToString();
                string EndTime = Ds.Tables[1].Rows[0]["EndTime"].ToString();
                string DCTypeID = Ds.Tables[1].Rows[0]["DCTypeID"].ToString();
                string pUserName = Ds.Tables[1].Rows[0]["pUserName"].ToString();
                string pPassword = Ds.Tables[1].Rows[0]["pPassword"].ToString();
                strresponse =fnSendICSFIleToUsers(EmpName, EmailId, "1", StartTime, EndTime, flgReschudule, EmpNodeId, DCTypeID, 20, ParticipantCycleMappingId, pUserName, pPassword);
                //fnSendICSFIleToUsers(EmpName, EmailId, "2", StartTime, EndTime, flgReschudule, EmpNodeId, DCTypeID, 30);
            }
            return strresponse +"|"+ Ds.Tables[0].Rows[0][0].ToString();
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
        finally
        {
            con.Dispose();
        }
    }

    public static string fnUpdateCalendarId(string ParticipantCycleMappingId, string P_CalendarEventId)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            string storedProcName = "spUpdateCalenderInviteForParticpnat";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@ParticipantCycleMappingId", ParticipantCycleMappingId),
                   new SqlParameter("@P_CalendarEventId", P_CalendarEventId),
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

    public static string fnSendICSFIleToUsers(string FName, string MailTo, string MailType, string CalenderStartTime, string CalenderEndTime, int flgReschudule, string EmpNodeId, string DCTypeID, int MailId, string ParticipantCycleMappingId,string pUserName, string pPassword)
    {
        string strRespoonse = "1";
        try
        {

            string MailServer = ConfigurationManager.AppSettings["MailServer"].ToString();
            string MailUserName = ConfigurationManager.AppSettings["MailUser"].ToString();
            string MailPwd = ConfigurationManager.AppSettings["MailPassword"].ToString();
            string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
            string fromMail = ConfigurationManager.AppSettings["FromAddress"].ToString();
            string TestURL = ConfigurationManager.AppSettings["TestURL"].ToString();

            //MailMessage msg = new MailMessage();
            //msg.From = new MailAddress("Bosch VDC<" + fromMail + ">");
            //string CCMailID = ConfigurationManager.AppSettings["MailCc"].ToString();
            // Now Contruct the ICS file using string builder
            //if (flgActualUser == "2")
            //{
            //    MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
            //    // CCMailID = ConfigurationManager.AppSettings["MailCc"].ToString();
            //    //msg.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
            //}
            //msg.ReplyTo = new MailAddress(fromMail);
            //msg.To.Add(MailTo);
            //msg.CC.Add(CCMailID);
            //msg.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
            string Subject = "";

            if (MailType == "1")
            {
                Subject = flgReschudule == 0 ? "Invitation: EY Virtual DC " : "Invitation: EY Virtual DC Rescheduled";
            }
            else if (MailType == "2")
            {
                Subject = "Welcome to the EY Virtual DC Process";
            }

            StringBuilder strBody = new StringBuilder();


            if (MailType == "1")
            {

                strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
                strBody.Append("<p>Dear " + FName + ",</p>");
                strBody.Append("<p>Greetings from Ernst & Young (EY) !</p>");
                string strText = flgReschudule == 0 ? "scheduled" : "rescheduled";
                strBody.Append("<p>Your Virtual Development Centre (VDC) is " + strText + " to be held on:</p>");

                strBody.Append("<p><b>Date:</b> " + Convert.ToDateTime(CalenderStartTime).ToString("dd-MMM-yyyy") + "</p>");
                strBody.Append("<p><b>Time:</b> " + Convert.ToDateTime(CalenderStartTime).ToString("HH:mm") + "</p>");

                strBody.Append("<p>Please find below the login credentials ( which is same as shared earlier)</p>");
                strBody.Append("<p>URL: <a href=" + TestURL + ">" + TestURL + "</a></p>");
                strBody.Append("<p><b>Login ID:</b> " + pUserName + "</p>");
                strBody.Append("<p><b>Password:</b> " + pPassword + "</p>");



                strBody.Append("<p><b>Best Regards</b></p>");
                strBody.Append("<p><b>Team EY</b></p>");
                strBody.Append("</font>");
            }
            else if (MailType == "2")
            {

                strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
                strBody.Append("<p>Dear " + FName + ",</p>");
                strBody.Append("<p><b>Congratulations on being nominated for the Virtual Development Centre (VDC) conducted by Bosch Limited, India! </b></p>");
                strBody.Append("<p>VDC Overview:</p>");
                strBody.Append("<p>The Virtual Development Centre (VDC) is a full day long process and comprises of a mix of exercises such as role plays, interview and a case analysis.</p>");
                strBody.Append("<p>This does not require any prior preparation and is not a test of your intelligence. The VDC requires you to be yourself and demonstrate how you would behave in certain given situations, which also means that there is no right or wrong answer to a question asked in the VDC. (Please note that your laptops will have to meet with the technical requirements that have been attached in our previous communications to go through the assessment seamlessly.) </p>");
                strBody.Append("<p>Pre-requisites for the VDC:</p>");
                strBody.Append("<p>1. Career Reflection (CR): Your Career Reflection CR is a key milestone before the VDC.You are requested to fill your CR judiciously as this will enable us to know you better on the professional front and provide us with relevant conversation-starters. This will help us utilize the VDC time productively. Participants who fail to fill and save the completed Career Reflection form within one day before the VDC will not be eligible to participate. </p>");
                strBody.Append("<p>2. Pre-work for Peer-Roleplay: One of the VDC exercises is a Peer-Roleplay, in which the participants will be working in pairs to reflect upon a concrete, work-related leadership situation. This activity requires you to come prepared with a work-related problem, for discussion. Please refer to the attachment (Peer-Roleplay Briefing) for details. </p>");
                strBody.Append("<p>You would have received a calendar invite with details on date and time for your scheduled VDC. The calendar invite is meant to block your time and you do not have to accept the invite.<br/>The face-to-face interaction with the assessor will be on Microsoft Teams, embedded within the VDC platform.  </p>");
                strBody.Append("<p>We hope you have watched the tutorial video that has been sent to you in our first email. In case you haven’t, please go through it. This will enable you to go through the VDC seamlessly.</p>");// We also request you to please test the below link to see if the Teams Meeting software works on your systems.
                                                                                                                                                                                                                                     //strBody.Append("<p><u>Teams Meeting Link : </u><a href='https://support.goto.com/meeting/system-check'>https://support.goto.com/meeting/system-check</a></p>");
                strBody.Append("<p>We shall connect with you a day prior to your VDC to ensure that you are familiarized with the process and have an enjoyable experience. </p>");
                strBody.Append("<p>Thank you for your time and commitment to this important initiative.</p>");
                strBody.Append("<p>In case of any queries, please feel free to contact Ms. Kalyani Krishnan <a href='mailto:Deepa1.R@in.ey.com'>(Deepa1.R@in.ey.com)</a></p>");
                strBody.Append("<p><b>Best Regards</b></p>");
                strBody.Append("<p><b>Team EY</b></p>");
                strBody.Append("</font>");
            }


           // msg.IsBodyHtml = true;

           // System.Net.Mime.ContentType HTMLType = new System.Net.Mime.ContentType("text/html");
           // AlternateView avCal = AlternateView.CreateAlternateViewFromString(strBody.ToString(), HTMLType);

            //LinkedResource Pic1 = new LinkedResource(path1, MediaTypeNames.Image.Jpeg);
            //Pic1.ContentId = "picture1";
            //avCal.LinkedResources.Add(Pic1);

            //msg.AlternateViews.Add(avCal);
            if (MailType == "1")
            {
                clsADUserInfo obj = new clsADUserInfo();
                string strTokenRes = obj.fnGetTokenNoForUser("system.backup@astix.in", "AX@123456789");
                if (strTokenRes.Split('|')[0] == "1")
                {
                    string strCalendarRes = obj.fnCreateCalendar(strTokenRes.Split('|')[1], Subject, strBody.ToString(), CalenderStartTime, CalenderEndTime, MailTo, FName,1);
                    if (strCalendarRes.Split('|')[0] == "2")
                    {
                        strRespoonse = strTokenRes.Split('|')[1];
                        string sFunctioname = MailId == 20 ? "Invitation: EY Virtual DC" : "Welcome to the EY Virtual DC Process";
                        string strSubject = MailId == 20 ? "Error in Invitation: EY Virtual DC of " + FName : "Error in Welcome to the EY Virtual DC Process of " + FName;
                        clsSendLogMail.fnSendLogMail(strTokenRes.Split('|')[1], strTokenRes.Split('|')[1], "Slot Booking Page", sFunctioname, strSubject);
                        strRespoonse = strCalendarRes.Split('|')[1];
                    }
                    else
                    {
                        strRespoonse = fnUpdateCalendarId(ParticipantCycleMappingId, strCalendarRes.Split('|')[1]);
                        //strRespoonse = strTokenRes.Split('|')[1];
                    }
                }
                else
                {
                    strRespoonse = strTokenRes.Split('|')[1];
                    string sFunctioname = MailId == 20 ? "Invitation: EY Virtual DC" : "Welcome to the EY Virtual DC Process";
                    string strSubject = MailId == 20 ? "Error in Invitation: EY Virtual DC of " + FName : "Error in Welcome to the EY Virtual DC Process of " + FName;
                    clsSendLogMail.fnSendLogMail(strTokenRes.Split('|')[1], strTokenRes.Split('|')[1], "Slot Booking Page", sFunctioname, strSubject);
                    strRespoonse = strTokenRes.Split('|')[1];
                }
                //StringBuilder str = new StringBuilder();
                //str.AppendLine("BEGIN:VCALENDAR");
                //str.AppendLine("PRODID:Meeting1");
                //str.AppendLine("VERSION:2.0");
                //str.AppendLine("METHOD:REQUEST");
                //str.AppendLine("BEGIN:VEVENT");
                //DateTime dtStartTime = Convert.ToDateTime(CalenderStartTime);
                //DateTime dtEndTime = Convert.ToDateTime(CalenderEndTime);
                //str.AppendLine(string.Format("DTSTART:{0:yyyyMMddTHHmmss}", dtStartTime.ToUniversalTime().ToString("yyyyMMdd\\THHmmss\\Z")));
                //str.AppendLine(string.Format("DTSTAMP:{0:yyyyMMddTHHmmss}", DateTime.Now));
                //str.AppendLine(string.Format("DTEND:{0:yyyyMMddHHmmss}", dtEndTime.ToUniversalTime().ToString("yyyyMMdd\\THHmmss\\Z")));
                //str.AppendLine("LOCATION: TVSM VDC<" + fromMail + ">");
                //str.AppendLine(string.Format("UID:{0}", Guid.NewGuid()));
                //str.AppendLine(string.Format("DESCRIPTION:{0}", strBody.ToString()));
                //str.AppendLine(string.Format("X-ALT-DESC;FMTTYPE=text/html:{0}", strBody.ToString()));
                //str.AppendLine(string.Format("SUMMARY:{0}", msg.Subject));
                //str.AppendLine(string.Format("ORGANIZER:MAILTO:{0}", "TVSM VDC < " + fromMail + " >"));
                //str.AppendLine(string.Format("ATTENDEE;CN=\"{0}\";RSVP=TRUE:mailto:{1}", msg.To[0].DisplayName, msg.To[0].Address));

                //str.AppendLine("BEGIN:VALARM");
                //str.AppendLine("TRIGGER:-PT15M");
                //str.AppendLine("ACTION:DISPLAY");
                //str.AppendLine("DESCRIPTION:Reminder");
                //str.AppendLine("END:VALARM");
                //str.AppendLine("END:VEVENT");
                //str.AppendLine("END:VCALENDAR");

                //System.Net.Mime.ContentType contype = new System.Net.Mime.ContentType("text/calendar");
                //contype.Parameters.Add("method", "REQUEST");
                //contype.Parameters.Add("name", "Meeting.ics");
                //AlternateView avCal1 = AlternateView.CreateAlternateViewFromString(str.ToString(), contype);
                //msg.AlternateViews.Add(avCal1);
            }
            //       if (MailType == "2")
            //       {
            //           string sPath = HttpContext.Current.Server.MapPath("~/VDCMailAttachements/EY VDC_ Peer Role Play Preparation.pdf");
            //           System.Net.Mime.ContentType HTMLType1 = new System.Net.Mime.ContentType("application/pdf");
            //           Attachment objAttachement = new Attachment(sPath);

            //objAttachement.Name = "EY VDC_ Peer Role Play Preparation.pdf";
            //           objAttachement.ContentType.MediaType = System.Net.Mime.MediaTypeNames.Application.Pdf;
            //           msg.Attachments.Add(objAttachement);
            //       }
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

            SqlConnection Scon1 = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            Scon1.Open();
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon1;
            Scmd.CommandText = "spMailUpdateWelcomeMail";
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@EmpNodeType", 1);
            Scmd.Parameters.AddWithValue("@MailID", MailId);

            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.ExecuteNonQuery();
            Scon1.Close();
        }
        catch (Exception ex)
        {
            strRespoonse = "2|" + ex.Message;
            string sFunctioname = MailId == 20 ? "Invitation: EY Virtual DC" : "Welcome to the EY Virtual DC Process";
            string strSubject = MailId == 20 ? "Error in Invitation: EY Virtual DC of " + FName : "Error in Welcome to the EY Virtual DC Process of " + FName;
            clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "Slot Booking Page", sFunctioname, strSubject);
            strRespoonse ="2|"+ ex.Message;
        }
        return strRespoonse;
    }



    [System.Web.Services.WebMethod()]
    public static string fnAssessmentMakeSlotVacant(string ParticipantCycleMappingId,string P_CalendarEventId)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            string storedProcName = "spAssessmentMakeSlotVacant"; ;
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@ParticipantCycleMappingId", ParticipantCycleMappingId)

                };
            DataSet Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);
            clsADUserInfo obj = new clsADUserInfo();
            string strTokenRes = obj.fnGetTokenNoForUser("system.backup@astix.in", "AX@123456789");
            if (strTokenRes.Split('|')[0] == "1")
            {
                string ss = obj.fnDeleteCalendar(strTokenRes.Split('|')[1], P_CalendarEventId);
            }
            return "0|";
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
        finally
        {
            con.Dispose();
        }
    }

}