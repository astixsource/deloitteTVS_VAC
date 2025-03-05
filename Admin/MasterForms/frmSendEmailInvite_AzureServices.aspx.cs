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
using Azure;
using Azure.Communication.Email;

public partial class frmSendEmailInvite : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Session["LoginID"] = 0;
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        else
        {
            if (!IsPostBack)
            {
                hdnLoginId.Value = Session["LoginID"].ToString();
                //  fnBindAssessementList();
                //fnbindgroupmaster();
                //fnbindassessor();
            }
        }
    }

    private void fnBindAssessementList()
    {

        //SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        //SqlCommand Scmd = new SqlCommand();
        //Scmd.Connection = Scon;
        //Scmd.CommandText = "spGetAssessmentCycleDetail";
        //Scmd.Parameters.AddWithValue("@CycleID", 0);
        //Scmd.Parameters.AddWithValue("@Flag", 0);
        //Scmd.CommandType = CommandType.StoredProcedure;
        //Scmd.CommandTimeout = 0;
        //SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        //DataTable dt = new DataTable();
        //Sdap.Fill(dt);

        //ListItem itm = new ListItem();
        //itm.Text = "--------";
        //itm.Value = "0";
        //ddlCycle.Items.Add(itm);
        //foreach (DataRow dr in dt.Rows)
        //{
        //    itm = new ListItem();
        //    itm.Text = dr["CycleName"].ToString();
        //    itm.Value = dr["CycleId"].ToString() + "^" + dr["flgStatus"];
        //    itm.Attributes.Add("cycledate", Convert.ToDateTime(dr["CycleStartDate"]).ToString("yyyy-MM-dd"));
        //    ddlCycle.Items.Add(itm);
        //}
    }

    //Get Scheme And Product Detail Bases on Store
    [System.Web.Services.WebMethod()]
    public static string fngetdata(int CycleId)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        DataSet Ds = null;
        string stresponse = "";
        try
        {
            string storedProcName = "";
            //if (UserType == "1")
            //{
            storedProcName = "spMailWelcomeMailGetParticipantList";
            //}
            //else if (UserType == "2")
            //{
            //    storedProcName = "spMailGetAssessorList";
            //}
            //else if (UserType == "3")
            //{

            //    storedProcName = "spMailGetEYAdminList";
            //}  
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                    new SqlParameter("@DCTypeID", CycleId)

            };
            Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);


            StringBuilder str = new StringBuilder();
            StringBuilder str1 = new StringBuilder();

            if (Ds.Tables[0].Rows.Count > 0)
            {
                string[] SkipColumn = new string[15];

                SkipColumn[0] = "EmpNodeID";
                SkipColumn[1] = "FirstName";
                SkipColumn[2] = "SurName";
                SkipColumn[3] = "flgNewMail";
                SkipColumn[4] = "flgRescheduleMail";
                SkipColumn[5] = "BandID";
                SkipColumn[6] = "CalendarStartTime";
                SkipColumn[7] = "CalendarEndTime";
                SkipColumn[8] = "UserName";
                SkipColumn[9] = "UserPassword";

                //if (UserType == "1")
                //{
                SkipColumn[10] = "ParticipantCycleMappingID";
                SkipColumn[11] = "OrientationTime";
                SkipColumn[12] = "AssessmentStartDate";
                SkipColumn[13] = "AssessmentEndDate";
                SkipColumn[14] = "DCTypeID";


                //}
                //else if (UserType == "2")
                //{
                //    SkipColumn[10] = "AssessorCycleMappingID";
                //}
                //else if (UserType == "3")
                //{
                //    SkipColumn[10] = "EYAdminCycleMappingID";
                //}


                int isSubmitted = 0;// int.Parse(Ds.Tables[1].Rows[0]["isSubmitted"].ToString());
                str.Append("<div id='dvtblbody' class='mb-3'><table id='tbldbrlist' class='table table-bordered table-sm mb-0' isSubmitted=" + isSubmitted + "><thead><tr>");

                string ss = "";

                str.Append("<th style='width:6%' >SrNo</th>");
                for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                {
                    if (SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName))
                    {
                        continue;
                    }
                    string sColumnName = Ds.Tables[0].Columns[j].ColumnName; ;

                    str.Append("<th " + ss + ">" + sColumnName + "</th>");
                }
                //str.Append("<th>Include</th>");
                str.Append("<th><input type='checkbox' value='0' id='checkAll' onclick='check_uncheck_checkbox(this.checked)' > ALL</th>");
                str.Append("</tr></thead><tbody>");

                //ss = "";
                string OldParticipantId = "0";
                for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
                {
                    string Fname = Ds.Tables[0].Rows[i]["FullName"].ToString();
                    string Calenderstarttime = "";// Ds.Tables[0].Rows[i]["CalendarStartTime"].ToString();
                    string Calenderendtime = "";// Ds.Tables[0].Rows[i]["CalendarEndTime"].ToString();
                    string OrientationTime = "";// Ds.Tables[0].Rows[i]["OrientationTime"].ToString();

                    string AssessmentStartDate = Ds.Tables[0].Rows[i]["AssessmentStartDate"].ToString();
                    string AssessmentEndDate = "";// Ds.Tables[0].Rows[i]["AssessmentEndDate"].ToString();

                    string subjectline = "";
                    string EmpNodeID = Ds.Tables[0].Rows[i]["EmpNodeID"].ToString();
                    string flgNewMail = Ds.Tables[0].Rows[i]["flgNewMail"].ToString();
                    string EmailID = Ds.Tables[0].Rows[i]["EMailID"].ToString();
                    string UserName = Ds.Tables[0].Rows[i]["UserName"].ToString();
                    string Password = Ds.Tables[0].Rows[i]["UserPassword"].ToString();
                    string DCTypeID = Ds.Tables[0].Rows[i]["DCTypeID"].ToString();
                    // string FullName = Ds.Tables[0].Rows[i]["FullName"].ToString();
                    string flgDisplayRow = "";
                    // if (flgNewMail=="1" && flgRescheduleMail=="0")
                    // {
                    //     flgDisplayRow = "1";   /// For New User mail
                    // }
                    //else if (flgNewMail == "2" && flgRescheduleMail == "0")
                    // {
                    //     flgDisplayRow = "2";   /// For Resend Mail
                    // }
                    // else if (flgNewMail == "2" && flgRescheduleMail == "1")
                    // {
                    //     flgDisplayRow = "3";   /// For Updated Scheduler Mail
                    // }

                    flgDisplayRow = "1";


                    str.Append("<tr MappingID = '0' flgNewMail='" + flgNewMail + "'  UserType = '1' EmailID = '" + EmailID + "'  EmpNodeID = '" + EmpNodeID + "' Fname ='" + Fname + "'  calenderstarttime='" + Calenderstarttime + "' calenderendtime='" + Calenderendtime + "' OrientationTime= '" + OrientationTime + "' UserName ='" + UserName + "' Password = '" + Password + "' AssessmentStartDate = '" + AssessmentStartDate + "' AssessmentEndDate = '" + AssessmentEndDate + "' DCTypeID='" + DCTypeID + "'> ");
                    str.Append("<td style='text-align:center'>" + (i + 1) + "</td>");
                    for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                    {
                        string sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                        if (SkipColumn.Contains(sColumnName))
                        {
                            continue;
                        }
                        var sData = Ds.Tables[0].Rows[i][j];

                        str.Append("<td>" + sData + "</td>");

                    }
                    if (flgNewMail == "1")
                    {
                        str.Append("<td><input type='checkbox' flg='1' value='1'></td>");
                    }
                    else
                    {
                        str.Append("<td>&nbsp;</td>");
                    }

                    str.Append("</tr>");
                }
                str.Append("</tbody></table></div>");
            }
            else
            {
                str.Append("");
            }

            stresponse = str.ToString();
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
    public static string fnSave(object udt_DataSaving)
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
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            Scon.Open();
            foreach (DataRow drow in dtDataSaving.Rows)
            {
                try
                {

                    // DateTime dt1 = Convert.ToDateTime(drow["CalenderStartTime"].ToString());   //Convert.ToDateTime("2020-05-21 16:30");
                    string CalenderStartTime = "";// dt1.ToString("yyyy-MM-dd hh:mm:ss tt");
                                                  //  DateTime dt2 = Convert.ToDateTime(drow["CalenderEndTime"].ToString()); //Convert.ToDateTime("2020-05-21 18:30");
                    string CalenderEndTime = "";// dt2.ToString("yyyy-MM-dd hh:mm:ss tt");

                    string MailTo = drow["EmailId"].ToString();
                    string UserType = drow["UserType"].ToString();
                    string FName = drow["Fname"].ToString();
                    string EmpNodeID = drow["EmpNodeID"].ToString();
                    string SchedulerFlagValue = drow["SchedulerFlagValue"].ToString();
                    string OrientationTime = drow["OrientationTime"].ToString();
                    string UserName = drow["UserName"].ToString();
                    string Password = drow["Password"].ToString();
                    string AssessmentStartDate = drow["AssessmentStartDate"].ToString();
                    string AssessmentEndDate = drow["AssessmentEndDate"].ToString();
                    string MappingID = drow["MappingID"].ToString();

                    string DCTypeID = drow["DCTypeID"].ToString();

                    string strStatus = fnSendICSFIleToUsers(EmpNodeID, FName, MailTo, UserType, CalenderStartTime, CalenderEndTime, SchedulerFlagValue, OrientationTime, UserName, Password, AssessmentStartDate, AssessmentEndDate, MappingID, DCTypeID);
                    drow["MailStatus"] = strStatus == "1" ? "Mail Sent" : strStatus;

                    if (strStatus == "1")
                    {
                        if (UserType == "1")
                        {
                            fnUpdateMailSp("spMailUpdateWelcomeMail", EmpNodeID, "1", "2", "1", Scon);
                        }

                        else if (UserType == "2")
                        {
                            fnUpdateMailSp("spMailUpdateFlagA", MappingID, "1", "2", "2", Scon);
                        }
                        else if (UserType == "2")
                        {
                            fnUpdateMailSp("spMailUpdateFlagE", MappingID, "1", "2", "3", Scon);
                        }
                    }


                }
                catch (Exception ex)
                {
                    drow["MailStatus"] = "Error-" + ex.Message;
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

    public static void fnUpdateMailSp(string SPName, string MappingID, string FlgMailState, string flgUpdate, string UserType, SqlConnection Scon1)
    {
        //  SqlConnection Scon1 = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon1;
        Scmd.CommandText = SPName;
        Scmd.Parameters.AddWithValue("@EmpNodeId", MappingID);
        Scmd.Parameters.AddWithValue("@EmpNodeType", 1);
        Scmd.Parameters.AddWithValue("@MailID", 10);

        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;

        Scmd.ExecuteNonQuery();
    }


    //fnSendICSFIleToUsers(EmpNodeID,FName,  MailTo, UserType, CalenderStartTime, CalenderEndTime, SchedulerFlagValue, OrientationTime, UserName, Password,AssessmentStartDate,AssessmentEndDate, MappingID, AdminCCEmailID);
    public static string fnSendICSFIleToUsers(string EmpNodeID, string FName, string MailTo, string UserType, string CalenderStartTime, string CalenderEndTime, string SchedulerFlagValue, string OrientationTime, string UserName, string Password, string AssessmentStartDate, string AssessmentEndDate, string MappingID, string AdminCCEmailID)
    {
        string strRespoonse = "1";
        try
        {
            //MailTo = "abhishek@astix.in";
            string TestURL = ConfigurationManager.AppSettings["WebSitePath"].ToString();
            string flgActualUser = ConfigurationManager.AppSettings["flgActualUser"].ToString();
            string fromMail = ConfigurationManager.AppSettings["FromAddress"].ToString();
            MailMessage msg = new MailMessage();
            msg.From = new MailAddress("VAC Manager<" + fromMail + ">");

            var connectionString = "endpoint=https://astixemailcommunication.india.communication.azure.com/;accesskey=" + Convert.ToString(HttpContext.Current.Application["AzureMailconnectionString"]);
            var emailClient = new EmailClient(connectionString);

            var emailRecipients = new EmailRecipients();
            if (ConfigurationSettings.AppSettings["flgActualUser"].ToString() == "1")
            {
                if (MailTo != "")
                {
                    for (int i = 0; i < MailTo.Split(',').Length; i++)
                    {
                        emailRecipients.To.Add(new EmailAddress(MailTo.Split(',')[i].Trim()));
                    }
                }

                // For BCC
                string[] BCCEmailIDs = ConfigurationSettings.AppSettings["MailBcc"].Split(',');
                if (BCCEmailIDs.Length > 1)
                {
                    for (int i = 0; i < BCCEmailIDs.Length; i++)
                    {
                        emailRecipients.BCC.Add(new EmailAddress(BCCEmailIDs[i]));
                    }
                }
                else
                {
                    emailRecipients.BCC.Add(new EmailAddress(ConfigurationSettings.AppSettings["MailBcc"]));
                }

            }
            else
            {
                MailTo = ConfigurationSettings.AppSettings["MailTo"].ToString();
                if (MailTo != "")
                {
                    for (int i = 0; i < MailTo.Split(',').Length; i++)
                    {
                        emailRecipients.To.Add(new EmailAddress(MailTo.Split(',')[i].Trim()));
                    }
                }

            }

            msg.Subject = "Reminder: Complete Your Assessment";



            StringBuilder strBody = new StringBuilder();
            strBody.Append("<font  style='COLOR: #000000; FONT-FAMILY: Arial'  size=2>");

            strBody.Append("<p>Dear " + FName + ",</p>");
            strBody.Append("<p>Trust this email finds you well. You are receiving this reminder email as you have not completed 1 or more of the assessments.</p>");
            strBody.Append("<p>This is a gentle reminder to complete all your assigned assessment.</p>");
            strBody.Append("<p>Please find your details to log in:</p>");

            strBody.Append("<p><b>URL: </b><a href=" + TestURL + ">" + TestURL + "</a></p>");
            strBody.Append("<p><b>Login ID: " + UserName + "</b></p>");
            strBody.Append("<p><b>Password: " + Password + "</b></p>");

            strBody.Append("<p>Please complete your assessment by <stromg>20th December 2024, 6:00 PM IST.<stromg></p>");
            strBody.Append("<p>If you experience any technical difficulties, please feel free to reach out to your HR Spoc: <a style = 'COLOR: #000000; FONT-weight: bold' href = mailto:Vini.Somnath@nbcbearings.in> (Vini.Somnath@nbcbearings.in)</a> or the Deloitte Team (kphalke@deloitte.com).</p>");


            strBody.Append("<p>Thank you for your time and effort.</p>");
            strBody.Append("<p><b>Regards,</b></p>");
            strBody.Append("<p><b>Team Deloitte</b></p>");


            strBody.Append("</font>");




            var emailContent = new EmailContent(msg.Subject) { PlainText = null, Html = strBody.ToString() };
            var emailMessage = new EmailMessage(
                senderAddress: ConfigurationSettings.AppSettings["MailSender"],      //The email address of the domain registered with the Communication Services resource
                recipients: emailRecipients,
                content: emailContent);


            var emailSendOperation = emailClient.Send(wait: WaitUntil.Completed, message: emailMessage);
        }
        catch (Exception ex)
        {
            strRespoonse = ex.Message;
        }
        return strRespoonse;
    }

    // 'fnSendICSFIleToUsers(EmpNodeID, FName, MailTo, UserType, CalenderStartTime, CalenderEndTime, SchedulerFlagValue, OrientationTime, UserName, Password, AssessmentStartDate, AssessmentEndDate);
    public static string fnSendICSFIleToUsers_OLD(string EmpNodeID, string FName, string MailTo, string MailType, string CalenderStartTime, string CalenderEndTime, string SchedulerFlagValue, string OrientationTime, string UserName, string Password, string AssessmentStartDate, string AssessmentEndDate, string MappingID, string DCTypeID)
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

            MailMessage msg = new MailMessage();
            msg.From = new MailAddress("TVSM VDC<" + fromMail + ">");
            // Now Contruct the ICS file using string builder


            string CCMailID = ConfigurationManager.AppSettings["MailCc"].ToString();
            // Now Contruct the ICS file using string builder
            if (flgActualUser == "2")
            {
                MailTo = ConfigurationManager.AppSettings["MailTo"].ToString();
                // CCMailID = ConfigurationManager.AppSettings["MailCc"].ToString();
                // msg.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
            }

            msg.ReplyTo = new MailAddress(fromMail);
            msg.To.Add(MailTo);
            msg.CC.Add(CCMailID);
            msg.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());


          
                msg.Subject = "TVSM Virtual DC – Login Credentials";
                     
            string path1 = HttpContext.Current.Server.MapPath("~/Images/EY-logo.png");
            StringBuilder strBody = new StringBuilder();
            if (MailType == "1")
            {

                strBody.Append("<font  style='COLOR: #000000; FONT-FAMILY: Arial'  size=2>");
                strBody.Append("<p>Dear " + FName + ",</p>");
                strBody.Append("<p>Greetings from Ernst & Young (EY) !</p>");
                strBody.Append("<p>Congratulations on being invited to participate in the Virtual Development Centre.</p>");

         


                strBody.Append("<p>To ensure that the talent is future ready and aligned with the organisation’s vision and mission, TVSM Talent Development Team has undertaken many initiatives. One of them is to conduct a “Virtual Development Centre” in association with EY (Ernst and Young). </p>");

                strBody.Append("<p>It is a daylong exercise, and you need to choose the day that works for you using the credentials mentioned below.</p>");
                strBody.Append("<p><b>URL: </b><a href=" + TestURL + ">" + TestURL + "</a></p>");
                strBody.Append("<p><b>Login ID: " + UserName + "</b></p>");
                strBody.Append("<p><b>Password: " + Password + "</b></p>");

                strBody.Append("<p>Please note that these credentials are unique to you, and you would use this across the process. Also attached is the document with the system requirements that needs to be enabled for this. A tutorial is created to help you navigate through this process. </p>");

                strBody.Append("<p>Please click here is access the link to the tutorial. </p>");
                strBody.Append("<p><a href='https://youtu.be/R-uKW0fsT9g' targer='_blank'>Tutorial Video</a></p>");
                strBody.Append("<p>Upon choosing your slot you will receive the following communication: </p>");
                strBody.Append("<table style='width:100%'>");
                strBody.Append("<tr>");
                strBody.Append("<td style='background-color:#a5a5a5;color:#ffffff'>SL No</td>");
                strBody.Append("<td style='background-color:#a5a5a5;color:#ffffff'>Communication Type</td>");
                strBody.Append("<td style='background-color:#a5a5a5;color:#ffffff'>Purpose of Communication</td>");
                strBody.Append("<td style='background-color:#a5a5a5;color:#ffffff'>Subject</td>");
                strBody.Append("</tr>");

                strBody.Append("<tr>");
                strBody.Append("<td style='background-color:#e1e1e1;'>1</td>");
                strBody.Append("<td style='background-color:#e1e1e1'>Calendar Invite</td>");
                strBody.Append("<td style='background-color:#e1e1e1'>Introduction to the EY Virtual Development Centre</td>");
                strBody.Append("<td style='background-color:#e1e1e1'>Invitation: EY Virtual DC</td>");
                strBody.Append("</tr>");

                //strBody.Append("<tr>");
                //strBody.Append("<td style='background-color:#f0f0f0'>2</td>");
                //strBody.Append("<td style='background-color:#f0f0f0'>E-mail</td>");
                //strBody.Append("<td style='background-color:#f0f0f0'>Process Details of the ELGi Virtual Development Centre</ td>");
                //strBody.Append("<td style='background-color:#f0f0f0'>Welcome to the ELGi Virtual DC Process </td>");
                //strBody.Append("</tr>");


                //strBody.Append("<tr>");
                //strBody.Append("<td style='background-color:#e1e1e1;'>3</td>");
                //strBody.Append("<td style='background-color:#e1e1e1'>E-mail</td>");
                //strBody.Append("<td style='background-color:#e1e1e1'>Sharing your ELGi Virtual DC Report</ td>");
                //strBody.Append("<td style='background-color:#e1e1e1'>Your ELGi Virtual DC Report</td>");
                //strBody.Append("</tr>");

                strBody.Append("</table>");
                strBody.Append("<p><b>What is a Virtual Assessment Centre?</b></p>");

                strBody.Append("<p>The Virtual Development Centre is a series of simulated activities that include role play, group discussion, and situation-based exercises, conducted over a virtual platform. You are suggested to be yourself and demonstrate how you would behave in these situations if they happened in your work environment. </p>");
                strBody.Append("<p>Please note that this is not a test of intelligence and there are no right or wrong way of performing in an activity. </p>");
                strBody.Append("<p>Post the Development centre, you would be provided with a report sharing the assessor observations of you in the activities and highlighting ‘what you do well’ and ‘what you can do better’, to align yourself to TVSM Competency Framework. </p>");


                //if (DCTypeID == "3")
                //{
                //    strBody.Append("<p><a href='https://youtu.be/y1HOBcayzBo' targer='_blank'>Tutorial Video</a></p>");
                //}
                //else
                //{
                //    strBody.Append("<p><a href='https://youtu.be/y1HOBcayzBo' targer='_blank'>Tutorial Video</a></p>");
                //}

               // strBody.Append("<p>In case of any queries, please feel free to contact Ms. Kalyani Krishnan <a href='mailto:Ms.KalyaniKrishnan >(kalyani.krishnan@in.ey.com)</a> or Ms. Deepa <a href='mailto:deepa1.r@in.ey.com >(deepa1.r@in.ey.com)</a></p>");

                strBody.Append("<p>In case of further questions, please reach out to Deepa (EY SPOC) at + 91 8197839110 or U Lavanya (TVSM Talent SPOC) at + 91 7397733968.</p>");
                strBody.Append("<p>All the best for the process!</p>");
                strBody.Append("<p><b>Thanks & Regards, </b></p>");
                strBody.Append("<p><b>Team EY</b></p>");

                strBody.Append("</font>");
            }
            else if (MailType == "2")
            {

                strBody.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
                strBody.Append("<p>Dear " + FName + ",</p>");

                strBody.Append("Greetings from Ernst & Young (EY) !");

                //strBody.Append("<p><b>Date:</b> " + Convert.ToDateTime(CalenderStartTime).ToString("dd/MMM/yyyy") + "</p>");
                //strBody.Append("<p><b>Time:</b> " + Convert.ToDateTime(CalenderStartTime).ToString("HH:mm") + "</p>");

                strBody.Append("<p><b>Please accept the invite and look forward to participating in the Virtual Development Centre.</b> An email detailing the process to be followed hereon shall be sent to you shortly.</p>");
              
                strBody.Append("<p><b>Best Regards</b></p>");
                strBody.Append("<p><b>Team EY</b></p>");
                strBody.Append("</font>");
            }
       



            msg.IsBodyHtml = true;

            System.Net.Mime.ContentType HTMLType = new System.Net.Mime.ContentType("text/html");
            AlternateView avCal = AlternateView.CreateAlternateViewFromString(strBody.ToString(), HTMLType);

            //LinkedResource Pic1 = new LinkedResource(path1, MediaTypeNames.Image.Jpeg);
            //Pic1.ContentId = "picture1";
            //avCal.LinkedResources.Add(Pic1);

            msg.AlternateViews.Add(avCal);
            if (MailType == "2")
            {
                StringBuilder str = new StringBuilder();
                str.AppendLine("BEGIN:VCALENDAR");
                str.AppendLine("PRODID:Meeting1");
                str.AppendLine("VERSION:2.0");
                str.AppendLine("METHOD:REQUEST");
                str.AppendLine("BEGIN:VEVENT");
                DateTime dtStartTime = Convert.ToDateTime(CalenderStartTime);
                DateTime dtEndTime = Convert.ToDateTime(CalenderEndTime);
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
            }
            if (MailType == "1")
            {
                System.Net.Mime.ContentType HTMLType1 = new System.Net.Mime.ContentType("application/pdf");
                string sPath = HttpContext.Current.Server.MapPath("~/VDCMailAttachements/EY_VDC_System_Requirements.pdf");
                Attachment objAttachement = new Attachment(sPath);

                objAttachement.Name = "EY VDC System Requirements.pdf";
                objAttachement.ContentType.MediaType = System.Net.Mime.MediaTypeNames.Application.Pdf;
                msg.Attachments.Add(objAttachement);
            }
            SmtpClient SmtpMail = new SmtpClient();
            SmtpMail.Host = MailServer;
            SmtpMail.Port = 587;
            string MUserName = MailUserName;
            string MPwd = MailPwd;
            NetworkCredential loginInfo = new NetworkCredential(MUserName, MPwd);
            SmtpMail.Credentials = loginInfo;
            SmtpMail.EnableSsl = true;
            SmtpMail.Timeout = int.MaxValue;

            SmtpMail.Send(msg);


        }
        catch (Exception ex)
        {
            strRespoonse = ex.Message;

            string sFunctioname = "EY Virtual DC – Login Credentials";
            string strSubject = "Error in EY Virtual DC – Login Credentials of " + FName;
           // clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "Send Credential Page", sFunctioname, strSubject);
            strRespoonse = ex.Message;
        }
        return strRespoonse;
    }




}