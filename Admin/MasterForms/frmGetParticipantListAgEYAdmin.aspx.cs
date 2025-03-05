using LogMeIn.GoToMeeting.Api;
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

public partial class frmGetParticipantListAgEYAdmin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Session["LoginID"] = "103";
        //Session["RoleId"] = "4";
        
        if (!IsPostBack)
        {
            hdnRoleId.Value = Request.QueryString["RoleId"] == null ? "0" : Request.QueryString["RoleId"].ToString();
            hdnLoginId.Value = Request.QueryString["LoginID"] == null ? "0" : Request.QueryString["LoginID"].ToString();
            hdnCycleId.Value = Request.QueryString["cycleid"] == null ? "0" : Request.QueryString["cycleid"].ToString();
            // fnBindAssessementList();
        }
    }

    private void fnBindAssessementList()
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;

        Scmd.CommandText = "spGetCycleNameAgEYAdmin";
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
               // ddlCycleName.Items.Add(itm);
            }

        }
        else
        {
            itm = new ListItem();
            itm.Text = "No cycle mapped";
            itm.Value = "0";
           // ddlCycleName.Items.Add(itm);
        }

    }





    [System.Web.Services.WebMethod()]
    public static string fnGetParticipantDetails(int CycleID,int loginId,int flgCallType)
    {
        HttpContext.Current.Session["LoginId"] = loginId;
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetParticipantMeetingDetailsAgEYAdmin]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@CycleId", CycleID);
        Scmd.Parameters.AddWithValue("@LoginId", loginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        string strResponse = "";
        if (flgCallType == 1)
        {
            strResponse = createStoretbl(ds, 1, true);
        }
        else {
            //Discussion in Progress
            //Prep Completed, Discussion To Start
                strResponse = JsonConvert.SerializeObject(ds.Tables[0], Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        }
        return strResponse;
    }

   

    private static string createStoretbl(DataSet ds, int headerlvl, bool IsHeader)
    {
        DataTable dt = ds.Tables[0];

        string[] SkipColumn = new string[27];
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
        SkipColumn[26] = "ExerciseDate";



        if (ds.Tables[0].Rows.Count > 0)
        {
            StringBuilder sb = new StringBuilder();
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
                                if(dt.Columns[j].ColumnName.ToString()== "Date")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:9%' >" + ColSpliter[k] + "</th>");
                                }else if(dt.Columns[j].ColumnName.ToString()== "Time")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='width:9%' >" + ColSpliter[k] + "</th>");
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
                //sb.Append("<th style='width:15%'>Action</th>");
                sb.Append("</tr>");
            }
            sb.Append("</thead>");
            sb.Append("<tbody>");
            string[] rowspanColumn = new string[0];
            //rowspanColumn[0] = "ParticipantName";
            foreach (DataRow Row in ds.Tables[0].Rows)
            {
                 
                sb.Append("<tr participantid='" + Row["ParticipantId"].ToString() + "'  activity='" + Row["activity"].ToString() + "' ExerciseId='" + Row["ExerciseId"].ToString() + "'>"); 
                for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                {
                    string sColumnName = ds.Tables[0].Columns[j].ColumnName;
                    if (!SkipColumn.Contains(sColumnName.ToString()))
                    {
                        if (rowspanColumn.Contains(sColumnName))
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
                            if(sColumnName.Split('^').Length>1)
                            {
                                string sData =Convert.ToString(Row[ds.Tables[0].Columns[j].ColumnName]);
                                string StatusText = ""; string flgShowLink = "0"; string ButtonName = "";
                                string RspExerciseId = "0"; string StatusId = "0";
                                string ExerciseId = sColumnName.Split('^')[1];
                                if (sData != "")
                                {
                                    RspExerciseId = sData.Split('^')[0];
                                    StatusId = sData.Split('^')[1];
                                    StatusText = sData.Split('^')[2];
                                    flgShowLink = sData.Split('^')[3];
                                    ButtonName = sData.Split('^')[4];
                                }
                                string bgclassName = "";
                                if (StatusId == "0")
                                {
                                    if (StatusText != "")
                                    {
                                        bgclassName = "clsNotStarted";
                                    }
                                    else
                                    {
                                        bgclassName = "clsNotApplicable";
                                    }
                                }else if (StatusId == "1")
                                {
                                    bgclassName = "clsProgress";
                                }
                                else
                                {
                                    bgclassName = "clsCompleted";
                                }
                                
                                sb.Append("<td iden='mstatus'  title='" + StatusText + "' style='text-align:center' class='" + bgclassName + "'  ExerciseId='"+ ExerciseId + "' >");
                                if (flgShowLink == "1")
                                {
                                   sb.Append("<a href='###' onclick='fnStartMeeting(this)' rspexerciseid='" + RspExerciseId + "'  class='btn btn-primary' style='padding:0px 4px;font-size:8pt'>" + ButtonName + "</a>");
                                }
                                else
                                {
                                    if (StatusId == "2" && Row["activity"].ToString() != "Preparation")
                                    {
                                        sb.Append("<i class=\"fa fa-download\" aria-hidden='true' style='font-size:10pt' rspexerciseid='" + RspExerciseId + "' onclick='fnDownloadCue(this)' ></i>");
                                    }
                                    else
                                    {
                                        sb.Append(StatusText);
                                    }
                                }
                                sb.Append("</td>");
                            }
                            else
                            {
                                sb.Append("<td>" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "</td>");
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
        else
        {
            return "<div style='padding : 10px 20px; color:red; font-weight:bold;'>No Record Found !</div>";
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
        return " <th colspan='" + cntr + "' style='color: #ffffff;border:none !important; background-color: #0080b9;min-width:135px'> " + str + " </th>|" + cntr;
    }


    [System.Web.Services.WebMethod()]
    public static string fnUpdateActualStartEndTime(string RSPExerciseid, int UserTypeID, string flgAction,string GotoUserName,string GotoPassword,long Meetingid)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spUpdateActualStartEndTime]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@RSPExerciseid", RSPExerciseid);
            Scmd.Parameters.AddWithValue("@UserTypeID", UserTypeID);
            Scmd.Parameters.AddWithValue("@flgAction", flgAction);
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();
            Scon.Dispose();

            var accessToken = clsHttpRequest.GetTokenNo(GotoUserName, GotoPassword);
            MeetingsApi objMeetingsApi = new MeetingsApi();
            var strHostURL = objMeetingsApi.startMeeting(accessToken, Meetingid);

            return strHostURL.hostURL;
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
    }
}