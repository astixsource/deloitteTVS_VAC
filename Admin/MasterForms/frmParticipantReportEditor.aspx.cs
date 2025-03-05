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
using System.IdentityModel.Protocols.WSTrust;

public partial class frmParticipantReportEditor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Session["LoginId"] = "5965";
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
            try
            {
                hdnLogin.Value = Session["LoginId"].ToString();
                hdnflgSave.Value = Request.QueryString["flg"];

                SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                SqlCommand Scmd = new SqlCommand();
                Scmd.Connection = Scon;
                Scmd.CommandText = "spRptGetAssessmentCycleListForReportDatEdit";
                Scmd.Parameters.AddWithValue("@LoginId", hdnLogin.Value);
                Scmd.Parameters.AddWithValue("@type", "1");
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.CommandTimeout = 0;
                SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
                DataTable dtBatch = new DataTable();
                Sdap.Fill(dtBatch);
                Scmd.Dispose();
                Sdap.Dispose();
                ListItem lst = new ListItem();
                lst.Value = "0";
                lst.Text = "---Select Batch---";
                lst.Attributes.Add("NumberOfParticipants", "0");
                ddlBatch.Items.Add(lst);
                for (int i = 0; i < dtBatch.Rows.Count; i++)
                {
                    lst = new ListItem();
                    lst.Value = dtBatch.Rows[i]["CycleId"].ToString();
                    lst.Text = dtBatch.Rows[i]["CycleName"].ToString();
/*
                    lst.Attributes.Add("NumberOfParticipants", dtBatch.Rows[i]["NumberOfParticipants"].ToString());
                    lst.Attributes.Add("MeetingId", dtBatch.Rows[i]["WashUpMeetingId"].ToString());
                    lst.Attributes.Add("MeetingLink", Convert.ToString(dtBatch.Rows[i]["WashUpMeetingLink"]));
                    lst.Attributes.Add("remainingsec", dtBatch.Rows[i]["remainingsec"].ToString());

                    lst.Attributes.Add("BEIUsername", dtBatch.Rows[i]["BEIUsername"].ToString());
                    lst.Attributes.Add("BEIPassword", dtBatch.Rows[i]["BEIPassword"].ToString());
*/

                    ddlBatch.Items.Add(lst);
                }

                //hdnSeqNo.Value = "0";
                //hdnBatch.Value = dtBatch.Rows[0]["CycleId"].ToString();
                //StringBuilder sbbtns = new StringBuilder();
                //sbbtns.Append("<a href='#' class='btn btn-primary active' ind='0' onclick='fnParticipant(this);'>Compiled</a>");
                //for (int i = 0; i < Convert.ToInt32(dtBatch.Rows[0]["NumberOfParticipants"]); i++)
                //{
                //    sbbtns.Append("<a href='#' class='btn btn-primary' ind='" + (i + 1).ToString() + "' style='margin-left:20px;' onclick='fnParticipant(this);'>P" + (i + 1).ToString() + "</a>");
                //}
                //dvBtns.InnerHtml = sbbtns.ToString();
            }
            catch (Exception ex)
            {
                SendErrorMail("Error in DPWorld : WashUp", "Error : " + ex.Message + "<br/>SP : spGetAssessmentCycleListForAssessor<br/>LoginID : " + hdnLogin.Value);
            }
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetParticipants(string CycleId, string LoginId) //Not Used
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spRptGetEmpListForReportDataEdit";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        StringBuilder sb = new StringBuilder();
        sb.Append("<option value='0'>-- Select Participant --</option>");
        for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        {
            sb.Append("<option value='" + Ds.Tables[0].Rows[i]["EmpNodeID"] + "'>" + Ds.Tables[0].Rows[i]["FullName"] + " ( " + Ds.Tables[0].Rows[i]["EmpCode"] + " )</option>");
        }

        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId, string EmpNodeId, string LoginId)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRptGetReportDataForEdit";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);

            string EmpId = "0";
            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < Ds.Tables.Count-1; i++)
            {
                string[] SkipColumn_Emp = new string[6];
                SkipColumn_Emp[0] = "EmpNodeID";
                SkipColumn_Emp[1] = "CmptncyId";
                SkipColumn_Emp[2] = "flgScoreEnable";
                SkipColumn_Emp[3] = "ident";
                SkipColumn_Emp[4] = "RecordId";
                SkipColumn_Emp[5] = "CompetencyId";
                sb.Append(CreateCompetancyTbl(Ds.Tables[i], Ds.Tables[i + 1], SkipColumn_Emp, "TblHeader_" + i.ToString(), "TblReport_" + i.ToString(), i));
                i = i + 1;
            }
            string flgFinalSubmit = Ds.Tables[Ds.Tables.Count - 1].Rows[0][0].ToString();
            return "0|" + sb.ToString()+"|"+ flgFinalSubmit;
        }
        catch (Exception ex)
        {
            // SendErrorMail("Error in BoschVDC : WashUp", "Error : " + ex.Message + "<br/>SP : spRptWashUpN<br/>CycleId : " + CycleId + "<br/>SeqNo : " + Participant);
            return "1";
        }
    }

    private static string CreateCompetancyTbl(DataTable dtHeader, DataTable dt, string[] SkipColumn, string tblHeader, string tblname, int tblIndex)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblHeader + "' class='table bg-white table-sm mb-0'>");
        sb.Append("<thead class='thead-light text-center'>");
        sb.Append("<tbody>");
        int cnt = 0; string strStyle = "";
        string flgOutputType = "1";
        for (int i = 0; i < dtHeader.Rows.Count; i++)
        {
            flgOutputType = dtHeader.Rows[0]["OutputType"].ToString();
            for (int j = 1; j < dtHeader.Columns.Count; j++)
            {
                string strIcon = ""; string ss = "";
                if (j == 2)
                {
                    ss = "style='padding-left:8px !important'";
                    strIcon = "<i class='fa fa-plus' style='margin-right:5px;cursor:pointer' onclick=\"fnShowHideTbl(this,'" + tblIndex + "')\"></i>";
                }
                
                sb.Append("<tr " + strStyle + ">");
                sb.Append("<td class='clsHeader-" + tblIndex + "_" + i + " clsheader-"+ flgOutputType+"-" + j + "' " + ss + ">" + strIcon + dtHeader.Rows[i][j].ToString() + "</td>");
                sb.Append("</tr>");
                if (j == 2)
                {
                    strStyle = "style='display:none'";
                }
            }
        }
        sb.Append("</tbody>");
        sb.Append("</table>");

        if (flgOutputType == "1" || flgOutputType == "2" || flgOutputType == "3" || flgOutputType == "4" || flgOutputType == "5")
        {

            sb.Append("<table id='" + tblname + "' class='table bg-white table-sm' " + strStyle + ">");
            sb.Append("<thead class='thead-light text-center'>");
            sb.Append("<tbody>");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (flgOutputType == "1" || flgOutputType == "5")
                {
                    for (int j = 2; j < dt.Columns.Count; j++)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td class='clsMain-" + tblIndex + "_" + i + "'><textarea   id='txtComment_" + tblIndex + "_" + i + "' style='width:100%;min-height:60px;' rows='5'  class='textEditor' SectionId='" + Convert.ToString(dt.Rows[i]["SectionId"]) + "' exerciseid='0' recordid='" + Convert.ToString(dt.Rows[i]["RecordId"]) + "'>" + Convert.ToString(dt.Rows[i][j]) + "</textarea></td>");
                        sb.Append("</tr>");
                    }
                }
                else if (flgOutputType == "2")
                {
                    sb.Append("<tr>");
                    sb.Append("<td class='clsMainParent-" + tblIndex + "_" + i + "' style='padding-left:27px !important;font-size:11pt !important;font-weight:bold'>" + Convert.ToString(dt.Rows[i]["Exercise"]) + "</td>");
                    sb.Append("</tr>");
                    for (int j = 4; j < dt.Columns.Count; j++)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td class='clsMain-" + tblIndex + "_" + i + "'><textarea   id='txtComment_" + tblIndex + "_" + i + "' style='width:100%;min-height:60px;' rows='5'  class='textEditor' SectionId='" + Convert.ToString(dt.Rows[i]["SectionId"]) + "' exerciseid='" + Convert.ToString(dt.Rows[i]["Exerciseid"]) + "' recordid='" + Convert.ToString(dt.Rows[i]["RecordId"]) + "'>" + Convert.ToString(dt.Rows[i][j]) + "</textarea></td>");
                        sb.Append("</tr>");
                    }
                }
                else if (flgOutputType == "3")
                {
                    //sb.Append("<tr>");
                    //sb.Append("<td class='clsMainParent-" + tblIndex + "_" + i + "' style='padding-left:27px !important;font-size:11pt !important;font-weight:bold'>" + Convert.ToString(dt.Rows[i]["Exercise"]) + "</td>");
                    //sb.Append("</tr>");
                    //for (int j = 4; j < dt.Columns.Count; j++)
                    //{
                        sb.Append("<tr>");
                        sb.Append("<td class='clsMain-" + tblIndex + "_" + i + "'><textarea   id='txtComment_" + tblIndex + "_" + i + "' style='width:100%;min-height:60px;' rows='5'  class='textEditor' SectionId='" + Convert.ToString(dt.Rows[i]["SectionId"]) + "' exerciseid='0' recordid='" + Convert.ToString(dt.Rows[i]["RecordId"]) + "'>" + Convert.ToString(dt.Rows[i]["Descr"]) + "</textarea></td>");
                        sb.Append("</tr>");
                    // }
                   // i = dt.Rows.Count-1;
                }
                else if (flgOutputType == "4")
                {
                   
                    //for (int j = 4; j < dt.Columns.Count; j++)
                    //{
                        sb.Append("<tr>");
                        sb.Append("<td class='clsMain-" + tblIndex + "_" + i + "'><textarea   id='txtComment_" + tblIndex + "_" + i + "' style='width:100%;min-height:60px;' rows='5'  class='textEditor' SectionId='" + Convert.ToString(dt.Rows[i]["SectionId"]) + "' exerciseid='0' recordid='" + Convert.ToString(dt.Rows[i]["RecordId"]) + "'>" + Convert.ToString(dt.Rows[i]["Descr"]) + "</textarea></td>");
                        sb.Append("</tr>");
                    //}
                    i = dt.Rows.Count - 1;
                }
                else
                {
                    sb.Append("<tr>");
                    sb.Append("<td class='clsMain-" + tblIndex + "_" + i + "' style='padding:4px 35px !important;width:32%;font-size:10.5pt !important'>" + dt.Rows[i]["CompetencyName"].ToString() + "</td>");
                    sb.Append("<td class='clsMain-" + tblIndex + "_" + i + "' style='padding:4px !important;;font-size:10pt !important'><label style='margin-bottom:.0rem !important;font-size:10pt !important'><input type='checkbox' class='clsrdoAOSAOd' name='rdocom_" + dt.Rows[i]["CompetencyId"].ToString() + "' CompetencyId='" + dt.Rows[i]["CompetencyId"].ToString() + "' value='1' " + (dt.Rows[i]["flgAOS_AOD"].ToString() == "1" ? "checked='checked'" : "") + "> AOS </label><label style='margin-bottom:.0rem !important;margin-left:20px;font-size:10pt !important'><input type='checkbox'  class='clsrdoAOSAOd' name='rdocom_" + dt.Rows[i]["CompetencyId"].ToString() + "' CompetencyId='" + dt.Rows[i]["CompetencyId"].ToString() + "' value='2'  " + (dt.Rows[i]["flgAOS_AOD"].ToString() == "2" ? "checked='checked'" : "") + " > AOP </label><label style='margin-bottom:.0rem !important;margin-left:20px;font-size:10pt !important'><input type='checkbox'  class='clsrdoAOSAOd' name='rdocom_" + dt.Rows[i]["CompetencyId"].ToString() + "' CompetencyId='" + dt.Rows[i]["CompetencyId"].ToString() + "' value='3'  " + (dt.Rows[i]["flgAOS_AOD"].ToString() == "3" ? "checked='checked'" : "") + " > AOD </label></td>");
                    sb.Append("</tr>");
                }
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
        }

        return sb.ToString();
    }
    private static string multi2lvlHeader(DataTable dt, int col_ind, int row_ind)
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
        string CompetencyId = "0";
        if (dt.Columns[col_ind].ColumnName.ToString().Split('|').Length > 1)
        {
            CompetencyId = dt.Columns[col_ind].ColumnName.ToString().Split('|')[1];
        }
        return " <th colspan='" + cntr + "' CompetencyId='" + CompetencyId + "' class='clsCol-" + col_ind + "'> " + str + " </th>|" + cntr;
    }
   
    [System.Web.Services.WebMethod()]
    public static string fnSave(string CycleId, string EmpNodeId, object obj, string LoginId, string flgSubmit)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows[0][0].ToString() == "0")
            {
                tbl.Rows.Clear();
            }

            //string str1 = JsonConvert.SerializeObject(obj1, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            //DataTable tbl1 = JsonConvert.DeserializeObject<DataTable>(str1);
            //if (tbl1.Rows[0][0].ToString() == "0")
            //{
            //    tbl1.Rows.Clear();
            //}

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRptSaveEditedReportData";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@ReportSectionSaving", tbl);
            //Scmd.Parameters.AddWithValue("@ReportIDPSaving", tbl1);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@flgSubmit", flgSubmit);
           
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            return "0|";
        }
        catch (Exception e)
        {
            return ("1|"+e.Message);
        }
    }


    public static void SendErrorMail(string sub, string msg)
    {
        try
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("astix@astixsolutions.com");
            mail.To.Add(ConfigurationManager.AppSettings["ErrMailTo"].ToString());
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

    [System.Web.Services.WebMethod()]
    public static string fnGetScore(string CycleId, string Participant)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRptWashUpN";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@PSeqNo", 0);
            Scmd.Parameters.AddWithValue("@ParticipantId", Participant);
            
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);

            string EmpId = "0";
            StringBuilder sb = new StringBuilder();
            if (Ds.Tables[0].Rows.Count > 0)
            {
                string[] SkipColumn_Emp = new string[6];
                SkipColumn_Emp[0] = "EmpNodeID";
                SkipColumn_Emp[1] = "CmptncyId";
                SkipColumn_Emp[2] = "flgScoreEnable";
                SkipColumn_Emp[3] = "ident";
                SkipColumn_Emp[4] = "flgAOSAODScore";
                SkipColumn_Emp[5] = "Moderated Score^|-2|0";

                sb.Append(CreateCompetancyTbl_Score(Ds.Tables[0], SkipColumn_Emp, "tblEmp", (Participant != "0" ? 4 : 1), Participant));
            }

            return sb.ToString();
        }
        catch (Exception ex)
        {
            //  SendErrorMail("Error in BoschVDC : WashUp", "Error : " + ex.Message + "<br/>SP : spRptWashUpN<br/>CycleId : " + CycleId + "<br/>SeqNo : " + Participant);
            return ex.Message;
        }
    }

    private static string multi2lvlHeader_Score(DataTable dt, int col_ind, int row_ind)
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
        string CompetencyId = "0";
        if (dt.Columns[col_ind].ColumnName.ToString().Split('|').Length > 1)
        {
            CompetencyId = dt.Columns[col_ind].ColumnName.ToString().Split('|')[1];
        }
        return " <th colspan='" + cntr + "' CompetencyId='" + CompetencyId + "' class='clsCol-" + col_ind + "'> " + str + " </th>|" + cntr;
    }
    private static string CreateCompetancyTbl_Score(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index, string SeqNo)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + (SeqNo == "0" ? "_Compiled" : "") + "' class='table table-bordered bg-white table-sm'>");
        sb.Append("<thead class='thead-light text-center'>");
        string[] Collength = dt.Columns[3].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim().Split('^');
                    if (dt.Columns[j].ColumnName.ToString().Contains("Moderated Score^|-2|0"))
                    {
                        continue;
                    }
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            if (ColSpliter[k] == "Competency Score")
                            {
                                sb.Append("<th rowspan='" + Collength.Length + "'>Total Score</th>");
                            }
                            else if (ColSpliter[k] == "Competency")
                            {
                                sb.Append("<th rowspan='" + Collength.Length + "' style='width:20%'>" + ColSpliter[k] + "</th>");
                            }

                            else
                            {
                                sb.Append("<th rowspan='" + Collength.Length + "'>" + ColSpliter[k] + "</th>");
                            }

                        }
                        else
                        {
                            string strrowspan = multi2lvlHeader_Score(dt, j, k);
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
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string flgScoreEnable = (dt.Columns.Contains("flgScoreEnable") == true ? Convert.ToString(dt.Rows[i]["flgScoreEnable"]) : "0");
            if (SeqNo != "0")
            {
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                        if (dt.Columns[j].ColumnName.ToString().Contains("Moderated Score^|-2|0"))
                        {
                            continue;
                        }
                        string scolname = dt.Columns[j].ColumnName.ToString().Split('|')[0];
                        if (scolname.Split('^')[1] != "")
                        {
                            sb.Append("<td flgedit='-99'>" + scolname.Split('^')[1] + "</td>");
                        }
                        else
                        {
                            if (dt.Columns[j].ColumnName.ToString() == "Participant^")
                            {
                                sb.Append("<td flgedit='-99'></td>");
                            }
                            else if (dt.Columns[j].ColumnName.ToString() == "Participant^")
                            {
                                sb.Append("<td flgedit='-99'></td>");
                            }
                            else
                            {
                                sb.Append("<td flgedit='-99'></td>");
                            }

                        }
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    if (j <= RowMerge_Index && SeqNo != "0")
                    {
                        DataTable temp_dt = dt.Select("[" + dt.Columns[j].ColumnName + "]='" + dt.Rows[i][j].ToString() + "'").CopyToDataTable();
                        if (temp_dt.Rows.Count > 1)
                        {
                            temp_dt.Columns.RemoveAt(j);
                            sb.Append(createRowMergeTbl(SkipColumn, temp_dt, dt.Rows[i][j].ToString(), RowMerge_Index - 1, SeqNo));
                            i = i + temp_dt.Rows.Count - 1;
                            break;
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "' flgedit='0'>" + dt.Rows[i][j] + "</td>");
                        }

                    }
                    else
                    {
                        if (SeqNo != "0")
                        {
                            if (j > 5)
                            {
                                sb.Append("<td class='cls-" + j + (dt.Columns[j].ColumnName == "Competency^" ? " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() : "") + "' flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "'  CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "'  flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + (dt.Columns[j].ColumnName == "Competency^" ? " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() : "") + "'>" + dt.Rows[i][j] + "</td>");
                            }
                        }
                        else
                        {
                            if (dt.Columns[j].ColumnName.ToString().Split('|').Length > 2)
                            {
                                sb.Append("<td class='cls-" + j + "'  flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "' CompetencyId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[3] + "'  flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + "'  EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "'>" + dt.Rows[i][j] + "</td>");
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

    private static string createRowMergeTbl(string[] SkipColumn, DataTable dt, string str, int RowMerge_Index, string SeqNo)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string flgScoreEnable = (dt.Columns.Contains("flgScoreEnable") == true ? Convert.ToString(dt.Rows[i]["flgScoreEnable"]) : "0");
            if (i != 0)
                sb.Append("<tr>");
            else
                sb.Append("<td class='cls-0' rowspan ='" + dt.Rows.Count + "' >" + str + "</td>");

            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (j <= RowMerge_Index && SeqNo != "0")
                    {
                        DataTable temp_dt = dt.Select("[" + dt.Columns[j].ColumnName + "]='" + dt.Rows[i][j].ToString() + "'").CopyToDataTable();
                        if (temp_dt.Rows.Count > 1)
                        {
                            temp_dt.Columns.RemoveAt(j);
                            sb.Append(createRowMergeTbl(SkipColumn, temp_dt, dt.Rows[i][j].ToString(), RowMerge_Index - 1, SeqNo));
                            i = i + temp_dt.Rows.Count - 1;
                            break;
                        }
                        else
                        {
                            if (SeqNo != "0")
                            {
                                sb.Append("<td class='cls-" + j + (dt.Columns[j].ColumnName == "Competency^" ? " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() : "") + "' flgedit='0'>" + dt.Rows[i][j] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + "' flgedit='0'>" + dt.Rows[i][j] + "</td>");
                            }
                        }

                    }
                    else
                    {
                        if (SeqNo != "0")
                        {
                            if (j > 4)
                            {
                                if (dt.Columns[j].ColumnName.ToString().Split('|')[1] != "99")
                                {
                                    sb.Append("<td class='cls-" + j + " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() + "' flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "' CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "' flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                                }
                                else if (i == 0)
                                {
                                    if (SeqNo != "0")
                                    {
                                        sb.Append("<td class='cls-" + j + " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() + "' flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "' rowspan='" + dt.Select("flgScoreEnable = '" + flgScoreEnable + "' and [" + dt.Columns[j].ColumnName + "]='" + dt.Rows[i][j].ToString() + "'").Length + "' CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "'  flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                                    }
                                    else
                                    {
                                        sb.Append("<td class='cls-" + j + " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() + "' flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "' rowspan='" + dt.Rows.Count + "' CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "'  flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                                    }
                                }
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() + "' CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "'   flgAOSAODColor='" + dt.Rows[i]["flgAOSAODScore"].ToString() + "'>" + dt.Rows[i][j] + "</td>");
                            }
                        }
                        else
                        {
                            if (dt.Columns[j].ColumnName.ToString().Split('|').Length > 2)
                            {
                                if (dt.Columns[j].ColumnName.ToString().Split('|')[2] != "99")
                                {
                                    sb.Append("<td class='cls-" + j + "' flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "' CompetencyId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[3] + "' flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                                }
                                else if (i == 0)
                                {
                                    sb.Append("<td class='cls-" + j + "' flgScoreEnable='" + flgScoreEnable + "' EmpNodeId='" + dt.Rows[i]["EmpNodeId"].ToString() + "' rowspan='" + dt.Rows.Count + "' CompetencyId='" + dt.Columns[j].ColumnName.ToString().Split('|')[1] + "' ExcersiceId='" + dt.Columns[j].ColumnName.ToString().Split('|')[2] + "' flgEdit='" + dt.Columns[j].ColumnName.ToString().Split('|')[3] + "'  flgAOSAODColor='" + dt.Rows[i][j].ToString().Split('^')[1] + "'>" + dt.Rows[i][j].ToString().Split('^')[0] + "</td>");
                                }
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                            }
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

}