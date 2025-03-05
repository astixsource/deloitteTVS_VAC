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

public partial class Admin_MasterForms_frmAssessorDC_Orien_FeedbackProcess : System.Web.UI.Page
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
                Session["LoginId"] = hdnLoginId.Value;
            }
            if (Session["RoleId"] != null)
            {
                hdnRoleId.Value = Session["RoleId"] == null ? "0" : Session["RoleId"].ToString();
            }
            else if (Request.QueryString["RoleId"] != null)
            {
                hdnRoleId.Value = Request.QueryString["RoleId"] == null ? "0" : Request.QueryString["RoleId"].ToString();
                Session["RoleId"] = hdnRoleId.Value;
            }
            hdnflgreferar.Value = Request.QueryString["flgreferar"] == null ? "0" : Request.QueryString["flgreferar"].ToString();
            hdnCycleId.Value = Request.QueryString["cycleid"] == null ? "0" : Request.QueryString["cycleid"].ToString();
            hdnCycleName.Value = Request.QueryString["cyclename"] == null ? "0" : Request.QueryString["cyclename"].ToString();
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetParticipantDetails(int loginId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetAssessmentCycleListForAssessor]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@LoginId", loginId);
        Scmd.Parameters.AddWithValue("@type", 2);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        string strResponse = JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });

        return strResponse;
    }

    [System.Web.Services.WebMethod()]
    public static string fnStartMeeting(long MeetingId,string BEIUsername,string BEIPassword)
    {
        try
        {
                    string hUrl = "";
                        var accessToken = clsHttpRequest.GetTokenNo(BEIUsername, BEIPassword);
                        MeetingsApi objMeetingsApi = new MeetingsApi();
                        var strHostURL = objMeetingsApi.startMeeting(accessToken, MeetingId);
                        hUrl= strHostURL.hostURL;
                    return "0|" + hUrl;
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
    public static string fnFeedbackdata(int CycleId, string LoginId)
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetFeedbackParticipantList";//"[SpVanGetCoveragedetails]";
        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        string[] SkipColumn = new string[3];
        SkipColumn[0] = "ParticipantId";
        SkipColumn[1] = "flgStatus";
        SkipColumn[2] = "ParticipantSeq";
        

        StringBuilder str = new StringBuilder();
        if (Ds.Tables[0].Rows.Count > 0)
        {
            str.Append("<div id='dvtblbody' class='mb-3' ><table id='tbldbrlist' class='table table-bordered table-sm mb-0'><thead><tr>");
            for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
            {
                if (!SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    str.Append("<th>"+ Ds.Tables[0].Columns[j].ColumnName + "</th>");
                }
            }
                    
            str.Append("</tr></thead><tbody>");

            for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
            {
                str.Append("<tr ParticipantSeq='" + Ds.Tables[0].Rows[i]["ParticipantSeq"].ToString() + "' participantid='" + Ds.Tables[0].Rows[i]["participantid"].ToString() + "' > ");

                for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                        if(Ds.Tables[0].Columns[j].ColumnName== "Feedback Session")
                        {
                            string StatusId = Ds.Tables[0].Rows[i]["flgStatus"].ToString();
                            string bgclassName = "";
                            if (StatusId == "0")
                            {
                                bgclassName = "clsNotStarted";
                            }
                            else if (StatusId == "1")
                            {
                                bgclassName = "clsProgress";
                            }
                            else
                            {
                                bgclassName = "clsCompleted";
                            }
                            str.Append("<td class='"+ bgclassName + "'>");
                            if (StatusId == "1")
                            {
                                str.Append("<a href='###' onclick='fnOpenForm(this)'  class='btn btn-primary' style='padding:4px 5px;font-size:8pt'>" + Ds.Tables[0].Rows[i][j].ToString() + "</a>");
                            }
                            else
                            {
                                str.Append(Ds.Tables[0].Rows[i][j].ToString());
                            }
                            str.Append("</td>");
                        }
                        else
                        {
                            str.Append("<td>" + Ds.Tables[0].Rows[i][j].ToString() + "</td>");
                        }
                        
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