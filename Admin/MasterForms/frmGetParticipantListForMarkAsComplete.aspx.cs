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

public partial class frmGetParticipantListForMarkAsComplete : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(Session["LoginId"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }
        
        if (!IsPostBack)
        {
            hdnFlgCallFrom.Value = Request.QueryString["flgcallfrom"] == null ? "0" : Request.QueryString["flgcallfrom"].ToString();
            hdnLoginId.Value = Session["LoginId"] == null ? "0" : Session["LoginId"].ToString();
            fnBindAssessementList();
        }
    }
    private void fnBindAssessementList()
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;

        Scmd.CommandText = "spGetCycleNameAgAssessor_Admin";
        Scmd.Parameters.AddWithValue("@LoginID", Session["LoginId"]);


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
                ddlCycleName.Items.Add(itm);
            }

        }
        else
        {
            itm = new ListItem();
            itm.Text = "No cycle mapped";
            itm.Value = "0";
            ddlCycleName.Items.Add(itm);
        }

    }



    [System.Web.Services.WebMethod()]
    public static string fnUpdateMeetingStatusParticipantDetails(int CycleID, object udt_Data)
    {
        string strDataSaving = JsonConvert.SerializeObject(udt_Data, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        DataTable dtDataSaving = JsonConvert.DeserializeObject<DataTable>(strDataSaving);
        dtDataSaving.TableName = "AssessorParticipantList";

        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spCheckAssessorExerciseTime]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@CycleId", CycleID);
        Scmd.Parameters.AddWithValue("@AssessorParticipantList", dtDataSaving);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        return JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetParticipantDetails(int CycleID,int loginId,int flgCallType)
    {
        HttpContext.Current.Session["LoginId"] = loginId;
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetParticipantMeetingDetailsAgAssessor_MarkAsCompletedAsManually]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@CycleId", CycleID);
        Scmd.Parameters.AddWithValue("@LoginId", loginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
      
        return createStoretbl(ds, 1, true);
    }

   

    private static string createStoretbl(DataSet ds, int headerlvl, bool IsHeader)
    {
        DataTable dt = ds.Tables[0];

        string[] SkipColumn = new string[33];
        SkipColumn[0] = "ParticipantId";
        SkipColumn[1] = "RspExerciseID";
        SkipColumn[2] = "RspId";
        SkipColumn[3] = "ExerciseID";
        SkipColumn[4] = "flgPrepStatus";
        SkipColumn[5] = "flgMeetingStatus";
        SkipColumn[6] = "PrepActualStartTime";
        SkipColumn[7] = "AssessorMeetingLink";
        SkipColumn[8] = "PrepDefaultTime";
        SkipColumn[9] = "MeetingDefaultTime";
        SkipColumn[10] = "MeetingScheduledStartTime";
        SkipColumn[11] = "txtMeetingDisplayTime";
        SkipColumn[12] = "flgMeetingStatusP";
        SkipColumn[13] = "flgMeetingStatusA";
        SkipColumn[14] = "flgMeetingStatus";
        SkipColumn[15] = "PrepActualEndTime";
        SkipColumn[16] = "MeetingActualEndTime";
        SkipColumn[17] = "flgShowLink";
        SkipColumn[18] = "GotoUserName";
        SkipColumn[19] = "GotoPassword";
        SkipColumn[20] = "MeetingId";
        SkipColumn[21] = "AssessorName";
        SkipColumn[22] = "flgMeetingStatusE";
        SkipColumn[23] = "flgOnlineMeeting";
        SkipColumn[24] = "MeetingActualStartTime";
        SkipColumn[25] = "ExerciseStarttime";
        SkipColumn[26] = "MeetingButtonName";
        SkipColumn[27] = "ToolTipText";
        SkipColumn[28] = "flgRule";
        SkipColumn[29] = "MeetingScheduledEndTime";
        SkipColumn[30] = "IsJoinMeet";
        SkipColumn[31] = "mTime";
        SkipColumn[32] = "flgExerciseStatus";

        StringBuilder sb = new StringBuilder();
        string[] rowspanColumn = new string[0];
        sb.Append("<div id='dvtblbody'><table id='tblEmp' class='table table-bordered table-sm bg-white' style='font-size:8pt'>");
        sb.Append("<thead>");
        string[] Collength = dt.Columns[2].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr class='bg-blue text-white'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = (dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()).Split('^');
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            if (dt.Columns[j].ColumnName.ToString() == "MeetingActualStartTime")
                            {
                                sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:10%' >" + ColSpliter[k] + "</th>");
                            }
                            else if (dt.Columns[j].ColumnName.ToString() == "Status")
                            {
                                sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:25%' >" + ColSpliter[k] + "</th>");
                            }
                            else
                            {
                                sb.Append("<th rowspan='" + ColSpliter.Length + "'>" + ColSpliter[k] + "</th>");
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
            sb.Append("<th style='width:14%'>Action</th>");
            sb.Append("</tr>");
        }
        sb.Append("</thead>");
        if (ds.Tables[0].Rows.Count > 0)
        {

            sb.Append("<tbody>");
            foreach (DataRow Row in ds.Tables[0].Rows)
            {
                string flg = Convert.ToString(Row["IsJoinMeet"]);
                int RuleId = Convert.ToInt32(Row["flgrule"]);
                int flgExerciseStatus= Convert.ToInt32(Row["flgExerciseStatus"]);
                sb.Append("<tr flg='"+ flg + "'  MeetingScheduledStartTime='" + Convert.ToString(Row["MeetingScheduledStartTime"])+ "' MeetingScheduledEndTime='" + Convert.ToString(Row["MeetingScheduledEndTime"]) + "' participantid='" + Row["ParticipantId"].ToString() + "' rspid='" + Row["rspid"].ToString() + "' rspexerciseid='" + Row["rspexerciseid"].ToString() + "' exerciseid='" + Row["exerciseid"].ToString() + "' meetingid='" + Convert.ToString(Row["meetingid"]) + "' flgrule='" + Convert.ToString(Row["flgrule"]) + "' >"); 
                for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(ds.Tables[0].Columns[j].ColumnName.ToString()))
                    {
                        if (rowspanColumn.Contains(ds.Tables[0].Columns[j].ColumnName))
                        {
                            int Row_Span = 0;
                            DataRow drows = null;
                            Row_Span = dt.Select("[ParticipantId]='" + Row["ParticipantId"].ToString() + "'").Count();
                            drows = dt.Select("[ParticipantId]='" + Row["ParticipantId"].ToString() + "'")[0];
                            if (Row_Span > 1)
                            {
                                if (Row == drows)
                                {
                                    sb.Append(string.Format("<td rowspan='{0}'>{1}</td>", Row_Span, Row[ds.Tables[0].Columns[j].ColumnName]));
                                }
                            }
                            else
                            {
                                sb.Append(string.Format("<td >{1}</td>", Row_Span, Row[ds.Tables[0].Columns[j].ColumnName]));
                            }
                        }
                        else
                        {
                            if(ds.Tables[0].Columns[j].ColumnName== "MeetingActualStartTime")
                            {
                                sb.Append("<td iden='mast' style='vertical-align:middle'>" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "</td>");
                            }
                            else if (ds.Tables[0].Columns[j].ColumnName == "Participant Name")
                            {
                                sb.Append("<td iden='mast' style='vertical-align:middle'><a href='###' onclick=\"fnSHowCR('"+ Row["ParticipantId"].ToString() + "')\" title='Click to view participant CR form'>" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "</a></td>");
                            }
                            else if (ds.Tables[0].Columns[j].ColumnName == "Status")
                            {
                                sb.Append("<td iden='mstatus' style='vertical-align:middle'>" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "</td>");
                            }
                            else
                            {
                                sb.Append("<td style='vertical-align:middle'>" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "</td>");
                            }
                                

                        }
                    }
                }
               
                string stitle = (Convert.ToString(Row["MeetingButtonName"]) == "Participant Not Completed" || Convert.ToString(Row["MeetingButtonName"]) == "Meeting Upcoming") ? "title='" + Convert.ToString(Row["TooltipText"]).Replace(",", "\n") + "'" : "";
                int Row_Span1 = 0;
                DataRow drows1 = null;
                Row_Span1 = dt.Select("[meetingid]='" + Row["meetingid"].ToString() + "' and mTime='" +Row["mTime"].ToString()+"'").Count();
                drows1 = dt.Select("[meetingid]='" + Row["meetingid"].ToString() + "' and mTime='" + Row["mTime"].ToString() + "'")[0];
                string sresumeLink = "";
                if (flgExerciseStatus==2)
                {
                    sresumeLink ="Discussion Over";
                }
                else if (flgExerciseStatus ==1 || Row["status"].ToString()=="Meeting Time Over")
                {
                    sresumeLink = "<a href='###' onclick='fnStartMeeting(this)'  flg='3' rspexerciseid='" + Row["rspexerciseid"].ToString() + "' gotousername='" + Convert.ToString(Row["gotousername"]) + "' gotopassword='" + Convert.ToString(Row["gotopassword"]) + "' meetingid='" + Convert.ToString(Row["meetingid"]) + "'  flgrule='" + Convert.ToString(Row["flgrule"]) + "'  class='btn btn-primary clsaction' style='padding:0px 4px;font-size:8pt;margin-left:5px;' >Mark As Close</a>";
                }
                else
                {
                    sresumeLink = "<a href='###' onclick='fnStartMeeting(this)' flg='3' rspexerciseid='" + Row["rspexerciseid"].ToString() + "' gotousername='" + Convert.ToString(Row["gotousername"]) + "' gotopassword='" + Convert.ToString(Row["gotopassword"]) + "' meetingid='" + Convert.ToString(Row["meetingid"]) + "'  flgrule='" + Convert.ToString(Row["flgrule"]) + "'  class='btn disabled clsaction' style='padding:0px 4px;font-size:8pt;margin-left:5px;' >Meeting Upcoming</a>";
                }
               
                    /*if (Row_Span1 > 1)
                    {
                        if (Row == drows1)
                        {
                            sb.Append("<td style='vertical-align:middle' " + stitle + " rowspan='"+ Row_Span1 + "'>"+ sresumeLink + "</td>");
                        }
                    }
                    else
                    {*/
                        sb.Append("<td style='vertical-align:middle' " + stitle + ">" + sresumeLink + "</td>");
                    /*}*/
                        
               
                sb.Append("</tr>");
            }
            
        }
        

        if (ds.Tables[0].Rows.Count == 0)
        {
            return "<div style='padding : 10px 20px; color:red; font-weight:bold;'>No Record Found !</div>";
        }
        else
        {
            sb.Append("</tbody>");
            sb.Append("</table></div>");
            return sb.ToString();
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
        return " <th colspan='" + cntr + "' style='color: #ffffff; font-weight:bold; background-color: #0080b9; border: 1px solid #dddddd;'> " + str + " </th>|" + cntr;
    }


    [System.Web.Services.WebMethod()]
    public static string fnUpdateActualStartEndTime(string RSPExerciseid, string Exerciseid, string flgAction,int flgType,int RspId,int LoginId,int CycleId,string MeetingScheduledStartTime)
    {
        try
        {
            if (flgType != 3)
            {
                SqlConnection Scon = null;
                SqlCommand Scmd = null;
                
                if (flgAction == "3")
                {
                    Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                    Scmd = new SqlCommand();
                    Scmd.Connection = Scon;
                    Scmd.CommandText = "[spCreateRSPExerciseForType2MeetingByAssessor]";
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.Parameters.AddWithValue("@ExerciseId", Exerciseid);
                    Scmd.Parameters.AddWithValue("@LoginId", LoginId);
                    Scmd.Parameters.AddWithValue("@CycleId", CycleId);
                    Scmd.Parameters.AddWithValue("@MeetingScheduleStartTime", MeetingScheduledStartTime);
                    Scmd.CommandTimeout = 0;
                    Scon.Open();
                    Scmd.ExecuteNonQuery();
                    Scon.Close();
                    Scon.Dispose();
                }

                if (Exerciseid != "500")
                {
                    Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                    Scmd = new SqlCommand();
                    Scmd.Connection = Scon;
                    Scmd.CommandText = "[spCompleteIncompleteExercise_CloseExercise]";
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.Parameters.AddWithValue("@RspId", RspId);
                    Scmd.Parameters.AddWithValue("@ExerciseId", Exerciseid);
                    Scmd.CommandTimeout = 0;
                    Scon.Open();
                    Scmd.ExecuteNonQuery();
                    Scon.Close();
                    Scon.Dispose();
                }
                else
                {
                    Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                    Scmd = new SqlCommand();
                    Scmd.Connection = Scon;
                    Scmd.CommandText = "[spStartCloseFeedbackMeeting]";
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.Parameters.AddWithValue("@RspId", RspId);
                    Scmd.Parameters.AddWithValue("@flgStatus", flgType);
                    Scmd.CommandTimeout = 0;
                    Scon.Open();
                    Scmd.ExecuteNonQuery();
                    Scon.Close();
                    Scon.Dispose();
                }
            }
            string str = "";

            return str;
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
    }
}