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

public partial class frmParticipantFeedbackContainerPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginID"] == null && Request.QueryString["LoginID"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        //if (Request.QueryString["cycleid"] == null)
        //{
        //    Response.Redirect("~/admin/masterforms/frmAssessorPreDCPostDC.aspx");
        //}
        if (!IsPostBack)
        {
            if (Session["LoginId"] != null)
            {
                hdnLoginId.Value = Session["LoginId"] == null ? "0" : Session["LoginId"].ToString();
            }
            else if (Request.QueryString["LoginID"] != null)
            {
                hdnLoginId.Value = Request.QueryString["LoginID"] == null ? "0" : Request.QueryString["LoginID"].ToString();
            }
            hdnParticipantId.Value = Request.QueryString["ParticipantId"] == null ? "0" : Request.QueryString["ParticipantId"].ToString();
            hdnSeqNo.Value = Request.QueryString["ParticipantSeq"] == null ? "0" : Request.QueryString["ParticipantSeq"].ToString();
            hdnCycleId.Value = Request.QueryString["cycleid"] == null ? "0" : Request.QueryString["cycleid"].ToString();
            tdParticipantName.InnerHtml ="Participant :"+ Request.QueryString["ParticipantName"] == null ? "" : Request.QueryString["ParticipantName"].ToString();
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetParticipantDetails(int Participantid,int CycleId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetFeedbackPartipantDetail]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@EmpNodeId", Participantid);
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        string strResponse = JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });

        return strResponse;
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId, string SeqNo)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetA3Detail";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@SeqNo", SeqNo);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        string[] SkipColumn = new string[2];
        SkipColumn[0] = "CmptncyId";
        SkipColumn[1] = "Score";

        return CreateSchedulingTbl(Ds.Tables[0], SkipColumn, "tblScheduling", 2);
    }
    private static string CreateSchedulingTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm clsTarget'>");
        sb.Append("<thead class='thead-light text-center'>");
        sb.Append("<tr>");
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
            {
                if (dt.Columns[j].ColumnName.ToString().Trim().Split('|').Length > 1)
                {
                    sb.Append("<th style='width:15%;font-size:8pt'>" + dt.Columns[j].ColumnName.ToString().Split('|')[0] + "</th>");
                }
                else
                {
                    sb.Append("<th style='width:15%'>" + dt.Columns[j].ColumnName.ToString() + "</th>");
                }
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
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim().Split('|')[0]))
                {
                    if (j > 1)
                    {
                        if (dt.Rows[i][j].ToString() == "")
                        {
                            sb.Append("<td class='cls-" + j + " cls-bg-gray'></td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "' >" + Convert.ToString(dt.Rows[i][j]).Split('^')[0] + "</td>");
                        }
                    }
                    else
                    {
                        sb.Append("<td class='cls-" + j + "' style='background:#" + getColor(dt.Rows[i]["Score"].ToString()) + ";text-align:left'>" + dt.Rows[i][j] + "</td>");
                    }
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string getColor(string score)
    {
        if (Convert.ToDouble(score) == 0)
            return "FFFFFF";
        else if (Convert.ToDouble(score) < 2.5)
            return "FFD9D7";
        else if (Convert.ToDouble(score) < 2.75)
            return "FFFACC";
        else
            return "CEFFDE";
    }

    [System.Web.Services.WebMethod()]
    public static string fnStartMeeting(int flgMeeting, long MeetingId, string BEIUsername, string BEIPassword)
    {
        try
        {
            if (flgMeeting == 1)
            {
                //fnUpdateActualStartEndTime(RSPExerciseid, 3, "3");
                var accessToken = clsHttpRequest.GetTokenNo(BEIUsername, BEIPassword);
                MeetingsApi objMeetingsApi = new MeetingsApi();
                var strHostURL = objMeetingsApi.startMeeting(accessToken, MeetingId);
                return "0|" + strHostURL.hostURL;
            }
            else
            {
                return "0|";
            }
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnUpdateActualStartEndTime(string RSPExerciseid, int UserTypeID, string flgAction)
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
            return "0";
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fngetdata(int CycleId, string LoginId)
    {


        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetParticipantListAgainstCycleForAssessor";//"[SpVanGetCoveragedetails]";
        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        StringBuilder str = new StringBuilder();
        if (Ds.Tables[0].Rows.Count > 0)
        {
            str.Append("<div id='dvtblbody' class='mb-3'><table id='tbldbrlist' class='table table-bordered table-sm mb-0'><thead><tr>");
            // str.Append("<th style='width:2%;'>Sr.No</th>");
            str.Append("<th style='width:7%;'>Participant Number</th>");
            str.Append("<th style='width:7%;'>Participant Name</th>");
            str.Append("<th style='width:4%;'>Details</th>");
            str.Append("<th style='width:3%;'>Repeat</th>");
            str.Append("</tr></thead><tbody>");

            for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
            {
                str.Append("<tr participantid='" + Ds.Tables[0].Rows[i]["participantid"].ToString() + "' ParticipantNumber='" + Ds.Tables[0].Rows[i]["Participant Number"].ToString() + "' ParticipantName='" + Ds.Tables[0].Rows[i]["Participant Name"].ToString() + "'> ");
                // str.Append("<td style='width:2%;text-align:center;'>" + (i + 1) + "</td>");

                str.Append("<td style='width:7%;text-align:left;;padding-left:10px'>" + Ds.Tables[0].Rows[i]["Participant Number"].ToString() + "</td>");
                str.Append("<td style='width:7%;text-align:left;padding-left:10px'>" + Ds.Tables[0].Rows[i]["Participant Name"].ToString() + "</td>");
                str.Append("<td style='width:4%;text-align:center;'><a href='#' title='View Details' style='color:blue;text-decoration:underline;' onclick='fnView_Details(this)'>View</a></td>");
                // str.Append("<td><input type='checkbox' value='" + i + "' id='Chk_" + i + "' onclick='fnchk(this);'/></td>");
                str.Append("<td style='width:3%;text-align:center;'><input type='checkbox' disabled/></td>");
                str.Append("</tr>");
            }
            str.Append("</tbody></table>");
        }
        else
        {
            str.Append("No Record Found!!");
        }

        return str.ToString();

    }

    [System.Web.Services.WebMethod()]
    public static string fnGetFeedbackBoxMatrix(int CycleId, string ParticipantId)
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetFeedbackBoxMatrix";//"[SpVanGetCoveragedetails]";
        Scmd.Parameters.AddWithValue("@EmpNodeId", ParticipantId);// LoginId);
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        string[] SkipColumn = new string[2];
        SkipColumn[0] = "ParticipantId";
        SkipColumn[1] = "Rown";

        StringBuilder str = new StringBuilder();
        if (Ds.Tables[0].Rows.Count > 0)
        {
            str.Append("<div id='dvtblbody' class='mb-3' ><table id='tbldbrlist' class='table table-bordered table-sm mb-0'><thead><tr>");
            int cnt = 0;
            for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
            {
                if (!SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string bgcolor = "";
                    if (cnt == 0)
                    {
                        bgcolor = "background-color:#a8d08d;";
                    }else if (cnt == 1)
                    {
                        bgcolor = "background-color:#5b9bd5;";
                    }
                    else if (cnt == 2)
                    {
                        bgcolor = "background-color:#ed7d31;";
                    }
                    str.Append("<th style='"+ bgcolor + "'>" + Ds.Tables[0].Columns[j].ColumnName + "</th>");
                    cnt++;
                }
            }

            str.Append("</tr></thead><tbody>");

            for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
            {
                str.Append("<tr rown='" + Ds.Tables[0].Rows[i]["rown"].ToString() + "' > ");
cnt = 0;
                for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                            var bgclassName = "";
                        if (cnt == 0)
                        {
                            bgclassName = "background-color:#e2efd9;";
                        }
                        else if (cnt == 1)
                        {
                            bgclassName = "background-color:#deeaf6;";
                        }
                        else if (cnt == 2)
                        {
                            bgclassName = "background-color:#fbe4d5;";
                        }
                        str.Append("<td style='text-align:left;"+ bgclassName + "'>");
                                str.Append(Ds.Tables[0].Rows[i][j].ToString());
                            str.Append("</td>");
                        cnt++;
                    }
                }
                str.Append("</tr>");
            }
            str.Append("</tbody></table>");
        }
        else
        {
            str.Append("No Record Found!!");
        }

        return str.ToString();

    }
}