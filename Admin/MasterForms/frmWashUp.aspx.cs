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
public partial class Mapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
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
                Scmd.CommandText = "spGetAssessmentCycleListForAssessor";
                Scmd.Parameters.AddWithValue("@LoginId", hdnLogin.Value);
                Scmd.Parameters.AddWithValue("@type", "4");
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
                    lst.Attributes.Add("NumberOfParticipants", dtBatch.Rows[i]["NumberOfParticipants"].ToString());
                    lst.Attributes.Add("MeetingId", dtBatch.Rows[i]["WashUpMeetingId"].ToString());
                    lst.Attributes.Add("MeetingLink", Convert.ToString(dtBatch.Rows[i]["WashUpMeetingLink"]));
                    lst.Attributes.Add("remainingsec", "");

                    lst.Attributes.Add("BEIUsername", "");
                    lst.Attributes.Add("BEIPassword", "");


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
                GetMaster();
            }
            catch (Exception ex)
            {
                SendErrorMail("Error in DPWorld : WashUp", "Error : " + ex.Message + "<br/>SP : spGetAssessmentCycleListForAssessor<br/>LoginID : " + hdnLogin.Value);
            }
        }
    }
    //private void GetMaster()
    //{
    //    SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
    //    SqlCommand Scmd = new SqlCommand();
    //    Scmd.Connection = Scon;
    //    Scmd.CommandText = "spGetCompetencyList";
    //    Scmd.CommandType = CommandType.StoredProcedure;
    //    Scmd.CommandTimeout = 0;
    //    SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
    //    DataTable dtBatch = new DataTable();
    //    Sdap.Fill(dtBatch);
    //    Scmd.Dispose();
    //    Sdap.Dispose();

    //    ddlCompetency.Items.Add(new ListItem("-- Select --", "0"));
    //    foreach (DataRow dr in dtBatch.Rows)
    //    {
    //        ddlCompetency.Items.Add(new ListItem(dr["Descr"].ToString(), dr["NodeID"].ToString()));
    //    }
    //}

    private void GetMaster()
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetExerciseList";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dtBatch = new DataTable();
        Sdap.Fill(dtBatch);
        Scmd.Dispose();
        Sdap.Dispose();

        ddlExercises.Items.Add(new ListItem("-- Select --", "0"));
        foreach (DataRow dr in dtBatch.Rows)
        {
            ddlExercises.Items.Add(new ListItem(dr["ExerciseName"].ToString(), dr["ExerciseID"].ToString()));
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetParticipants(string CycleId) //Not Used
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetParticipantListForCycle";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CysleId", CycleId);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        StringBuilder sb = new StringBuilder();
        sb.Append("<option value='0'>-- Select --</option>");
        for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        {
            sb.Append("<option value='" + Ds.Tables[0].Rows[i]["EmpNodeID"] + "'>" + Ds.Tables[0].Rows[i]["FName"] + " ( " + Ds.Tables[0].Rows[i]["EmpCode"] + " )</option>");
        }

        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId, string Participant)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = Participant != "0" ? "spRptWashUpN" : "spRptWashUp_Compiled";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@PSeqNo", Participant);
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
                


                sb.Append(CreateCompetancyTbl(Ds.Tables[0], SkipColumn_Emp, "tblEmp", (Participant != "0" ? 4 : 1), Participant));
                EmpId = Ds.Tables[0].Rows[0]["EmpNodeID"].ToString();
            }
            sb.Append("|");
            if (Participant == "0")
            {
                sb.Append("<table style='width:100%'><tr><td style='vertical-align:top !important'>");
            }
            if (Ds.Tables[0].Rows.Count > 0)
            {
                string[] SkipColumn_Score = new string[4];
                SkipColumn_Score[0] = "CmptncyId";
                SkipColumn_Score[1] = "Color";
                SkipColumn_Score[2] = "Ordr";
                SkipColumn_Score[3] = "flgAOSAODScore";

                sb.Append(CreateOverallCompTbl(Ds.Tables[1], SkipColumn_Score, "tblScore"));
            }

            if (Participant == "0")
            {
                sb.Append("</td><td></td><td style='vertical-align:top !important'>");
                if (Ds.Tables[5].Rows.Count > 0)
                {
                    string[] SkipColumn_Score = new string[4];
                    SkipColumn_Score[0] = "ExerciseId";
                    SkipColumn_Score[1] = "Color";
                    SkipColumn_Score[2] = "Ordr";
                    SkipColumn_Score[3] = "flgAOSAODScore";
                    sb.Append(CreateOverallExericseTbl(Ds.Tables[5], SkipColumn_Score, "tblExerciseWiseAvgScore"));
                }

                sb.Append("</td><td></td><td style='vertical-align:top !important'>");
                if (Ds.Tables[4].Rows.Count > 0)
                {
                    string[] SkipColumn_Score = new string[4];
                    SkipColumn_Score[0] = "ExerciseId";
                    SkipColumn_Score[1] = "Color";
                    SkipColumn_Score[2] = "Ordr";
                    SkipColumn_Score[3] = "flgAOSAODScore";
                    sb.Append(CreateAssessorMaster(Ds.Tables[4], SkipColumn_Score, "tblAssessorMstr"));
                }
                sb.Append("</td></tr></table>");
            }
            StringBuilder sb1 = new StringBuilder();
            //if (Participant != "0")
            //{
            //    string[] SkipColumn_Score = new string[4];
            //    SkipColumn_Score[0] = "RspID";
            //    SkipColumn_Score[1] = "EmpNodeID";
            //    SkipColumn_Score[2] = "CriteriaId";
            //    SkipColumn_Score[3] = "ReadinessLevelId";
            //    sb1.Append(CreateCompetencyCriteriaMaster(Ds.Tables[5], SkipColumn_Score, "tblCompetencyCriteriaMstr"));

            //    sb1.Append(CreateReadinessMaster(Ds.Tables[6], SkipColumn_Score, "tblReadinessMstr"));
            //}

            
            string FinalComments = "";
            if (Participant != "0")
            {
                if (Ds.Tables[4].Rows.Count > 0)
                {
                    FinalComments = Convert.ToString(Ds.Tables[4].Rows[0][0]);
                }
            }

            string flWashupCompleted = "0";
            if (Ds.Tables[3].Rows.Count > 0)
            {
                flWashupCompleted = Ds.Tables[3].Rows[0][0].ToString();
            }
            if (Ds.Tables[2].Rows.Count > 0)
            {
                return "0|" + sb.ToString() + "|" + EmpId + "|" + Ds.Tables[2].Rows[0][0].ToString() + "|" + flWashupCompleted + "|" + FinalComments+"|"+ sb1.ToString();
            }
            else
            {
                return "0|" + sb.ToString() + "|" + EmpId + "||" + flWashupCompleted + "|" + FinalComments+"|";
            }
        }
        catch (Exception ex)
        {
          //  SendErrorMail("Error in BoschVDC : WashUp", "Error : " + ex.Message + "<br/>SP : spRptWashUpN<br/>CycleId : " + CycleId + "<br/>SeqNo : " + Participant);
            return "1|"+ex.Message;
        }
    }
    private static string CreateOverallCompTbl(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm mb-0' style='margin-bottom:2px'>");
        sb.Append("<thead class='thead-light text-center'>");
        string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim().Split('^');
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            sb.Append("<th rowspan='" + ColSpliter.Length + "'>" + ColSpliter[k] + "</th>");
                        }
                        else
                        {
                            string strrowspan = multi2lvlHeader(dt, j, k);
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
            string flgAOSAODColor = (dt.Columns.Contains("flgAOSAODScore") == true ? Convert.ToString(dt.Rows[i]["flgAOSAODScore"]) : "");
            sb.Append("<tr CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "' flgAOSAODColor='" + flgAOSAODColor + "' color='" + dt.Rows[i]["Color"].ToString() + "'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='cls-" + j + " clsComp_" + dt.Rows[i]["CmptncyId"].ToString() + "' CompetencyId='" + dt.Rows[i]["CmptncyId"].ToString() + "' flgAOSAODColor='" + flgAOSAODColor + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    private static string CreateOverallExericseTbl(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm mb-0' style='margin-bottom:2px'>");
        sb.Append("<thead class='thead-light text-center'>");
        string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim().Split('^');
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            sb.Append("<th rowspan='" + ColSpliter.Length + "'>" + ColSpliter[k] + "</th>");
                        }
                        else
                        {
                            string strrowspan = multi2lvlHeader(dt, j, k);
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
            string flgAOSAODColor = (dt.Columns.Contains("flgAOSAODScore") == true ? Convert.ToString(dt.Rows[i]["flgAOSAODScore"]) : "");
            sb.Append("<tr ExerciseId='" + dt.Rows[i]["ExerciseId"].ToString() + "' flgAOSAODColor='" + flgAOSAODColor + "' >");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='cls-" + j + " clsExercise_" + dt.Rows[i]["ExerciseId"].ToString() + "' ExerciseId='" + dt.Rows[i]["ExerciseId"].ToString() + "' flgAOSAODColor='" + flgAOSAODColor + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    private static string CreateCompetencyCriteriaMaster(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm mb-0 mt-3' style='margin-bottom:2px'>");
        sb.Append("<thead class='text-center'>");
        string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr style='background-color:#808080 !important;color:#ffffff'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim().Split('^');
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            sb.Append("<th rowspan='" + ColSpliter.Length + "'>" + ColSpliter[k] + "</th>");
                        }
                        else
                        {
                            string strrowspan = multi2lvlHeader(dt, j, k);
                            sb.Append(strrowspan.Split('|')[0]);
                            j = j + Convert.ToInt32(strrowspan.Split('|')[1]) - 1;
                        }
                    }
                }
            }
            sb.Append("<th rowspan='1'>OverAll Score</th>");
            sb.Append("</tr>");
        }
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr CriteriaId='" + dt.Rows[i]["CriteriaId"].ToString() + "'  rspid='" + dt.Rows[i]["rspid"].ToString() + "'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (dt.Columns[j].ColumnName.ToLower() == "competency theme")
                    {
                        if (i > 0)
                        {
                            if ((dt.Rows[i]["competency theme"].ToString() == dt.Rows[i - 1]["competency theme"].ToString()) == false)
                            {
                                sb.Append("<td class='mergerow' rowspan=" + dt.Select("[competency theme] = '" + dt.Rows[i]["competency theme"].ToString() + "'").Length + " >" + dt.Rows[i][j] + "</td>");
                            }
                        }
                        else
                        {
                            sb.Append("<td  class='mergerow' rowspan=" + dt.Select("[competency theme] = '" + dt.Rows[i]["competency theme"].ToString() + "'").Length + " >" + dt.Rows[i][j] + "</td>");
                        }
                    }
                    else if (dt.Columns[j].ColumnName.ToLower() == "behavior")
                    {
                        if (i > 0)
                        {
                            if ((dt.Rows[i]["behavior"].ToString() == dt.Rows[i - 1]["behavior"].ToString()) == false)
                            {
                                sb.Append("<td class='mergerow' rowspan=" + dt.Select("[behavior] = '" + dt.Rows[i]["behavior"].ToString() + "'").Length + " >" + dt.Rows[i][j] + "</td>");
                            }
                        }
                        else
                        {
                            sb.Append("<td  class='mergerow' rowspan=" + dt.Select("[behavior] = '" + dt.Rows[i]["behavior"].ToString() + "'").Length + " >" + dt.Rows[i][j] + "</td>");
                        }
                    }
                    else if (dt.Columns[j].ColumnName.ToLower() == "rating")
                    {
                        sb.Append("<td class='cls-" + j + "' ><select style='width:99%'><option value='H' " + (Convert.ToString(dt.Rows[i]["rating"]) == "H" ? " selected" : "") + "  >H</option><option value='M' " + (Convert.ToString(dt.Rows[i]["rating"]) == "M" ? " selected" : "") + ">M</option><option value='L' " + (Convert.ToString(dt.Rows[i]["rating"]) == "L" ? " selected" : "") + " >L</option></select></td>");
                    }
                    else
                    {
                        sb.Append("<td class='cls-" + j + "' >" + dt.Rows[i][j] + "</td>");
                    }
                }
            }
            if (i == 0)
            {
                sb.Append("<td rowspan='" + dt.Rows.Count + "' class='clsovscore text-center'>0</td>");
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    private static string CreateReadinessMaster(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm mb-0 mt-2' style='margin-bottom:2px'>");
        sb.Append("<thead class='thead-light text-center'>");
        string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
        sb.Append("<tr style='font-size:13pt'>");
        sb.Append("<th colspan='3' style='background-color:#ffff00;color:#000000;text-align:left;font-size:12pt !important'>Readiness level</th>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<th style='width:15%'></th>");
        sb.Append("<th style='width:15%'>Type yes againts </br>the most approriate option</th>");
        sb.Append("<th>Reason/Justification</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr ReadinessLevelId='" + dt.Rows[i]["ReadinessLevelId"].ToString() + "'  rspid='" + dt.Rows[i]["rspid"].ToString() + "'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (dt.Columns[j].ColumnName.ToLower() == "readiness level")
                    {
                       
                      sb.Append("<td  class='mergerow' style='padding:5px !important'><label style='margin:0px'><input type='radio' empnodeid='" + dt.Rows[i]["empnodeid"] + "'  rspid='" + dt.Rows[i]["rspid"] + "' "+ (Convert.ToString(dt.Rows[i]["Most_Appropriate_Option"])!=""?" checked":"") + "  value='" + dt.Rows[i]["readinesslevelid"] + "' name='rdoreadness' />  " + dt.Rows[i][j] + "</label></td>");
                    }
                    else
                    {
                        sb.Append("<td class='cls-" + j + "' ><input type='text' style='width:99%' placeholder='type here' value='"+ Convert.ToString(dt.Rows[i][j]) +  "' /></td>");
                    }
                }
            }
           
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }


    private static string CreateAssessorMaster(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm mb-0' style='margin-bottom:2px'>");
        sb.Append("<thead class='thead-light text-center'>");
        string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    string[] ColSpliter = dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim().Split('^');
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            sb.Append("<th rowspan='" + ColSpliter.Length + "'>" + ColSpliter[k] + "</th>");
                        }
                        else
                        {
                            string strrowspan = multi2lvlHeader(dt, j, k);
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
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='cls-" + j + "' >" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    private static string CreateCompetancyTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index, string SeqNo)
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
                    if(dt.Columns[j].ColumnName.ToString().Contains("Moderated Score^|-2|0"))
                    {
                        continue;
                    }
                    if (ColSpliter[k] != "")
                    {
                        if (string.Join("", ColSpliter) == ColSpliter[k])
                        {
                            if(ColSpliter[k]== "Competency Score")
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
                            string strrowspan = multi2lvlHeader(dt, j, k);
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
                                sb.Append("<td flgedit='-99'>P" + SeqNo + "</td>");
                            }
                            else if (dt.Columns[j].ColumnName.ToString() == "Participant^")
                            {
                                sb.Append("<td flgedit='-99'>P" + SeqNo + "</td>");
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
    [System.Web.Services.WebMethod()]
    public static string fnGetCompetencyComment(string batch, string ExerciseId, string Emp)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRatingAssessorGetCompListMappedToExercise";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", batch);
            Scmd.Parameters.AddWithValue("@EmpNodeId", Emp);
            Scmd.Parameters.AddWithValue("@ExerciseId", ExerciseId);
            Scmd.Parameters.AddWithValue("@LoginId", 0);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);

            StringBuilder sb = new StringBuilder();
            string[] SkipColumn_Score = new string[3];
            SkipColumn_Score[0] = "ExerciseAssessorComId";
            SkipColumn_Score[1] = "Comments";
            SkipColumn_Score[2] = "CompId";

            if (ExerciseId != "0")
            {
                return "0|" + sb.Append(CreateCompCommentTbl(Ds.Tables[0], SkipColumn_Score, "tblCompComment"));
            }
            else
            {
                return "0|" + (ExerciseId == "0" ? "" : "No Excersice Found !");
            }
            
        }
        catch (Exception ex)
        {
            return "1";
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSaveRSPCmptncyComments(string batch, string Competency, string LoginId, string SeqNo, string Comments)
    {
        string str = "0";
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSaveRSPCmptncyComments";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@SeqNo", SeqNo);
            Scmd.Parameters.AddWithValue("@CycleId", batch);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@Comments", Comments);
            Scmd.Parameters.AddWithValue("@CmptncyId", Competency);
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();
        }
        catch (Exception ex)
        {
            str = "1|" + ex.Message;
        }

        return str;
    }
    private static string CreateCompCommentTbl(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            StringBuilder sb_disabled = new StringBuilder();
            sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm' style='margin-bottom:2px'>");
            sb.Append("<thead class='thead-light text-center'>");
            string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
            for (int k = 0; k < Collength.Length; k++)
            {
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                        if (dt.Columns[j].ColumnName == "UpdatedBehaviourText")
                        {
                            sb.Append("<th>Comments</th>");
                        }
                        else
                        {
                            sb.Append("<th  style='width:18%'>" + dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim() + "</th>");
                        }

                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</thead>");
            sb.Append("<tbody>");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<tr  ExcerciseRatingDetId='" + dt.Rows[i]["ExerciseAssessorComId"].ToString() + "'   CompId='" + dt.Rows[i]["CompId"].ToString() + "'>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                    {
                        if (dt.Columns[j].ColumnName == "UpdatedBehaviourText")
                        {
                            sb.Append("<td class='cls-" + j + "'  ><textarea class='textEditor' style='width:100%' rows='2' onchange='fnCmntChange(this)' >" + dt.Rows[i][j] + " </textarea></td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "'  >" + dt.Rows[i][j] + " </td>");
                        }

                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        else
        {
            sb.Append("Assessor rating is not available!!");
        }
        return sb.ToString();
    }

    private static string CreateCompCommentTbl1(DataTable dt, string[] SkipColumn, string tblname)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-bordered bg-white table-sm' style='margin-bottom:2px'>");
        sb.Append("<thead class='thead-light text-center'>");
        string[] Collength = dt.Columns[1].ColumnName.ToString().Split('|')[0].Split('^');
        for (int k = 0; k < Collength.Length; k++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim() + "</th>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string sicon =Convert.ToString(dt.Rows[i]["BehaviourText"])!=""?( dt.Rows[i]["BehaviourTypeId"].ToString() == "1" ? "<i class='fa fa-hand-o-up' style='color:green'  title='Positive'></i> " : "<i class='fa fa-hand-o-down' style='color:red' title='Negative'></i> ") :"";
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (dt.Columns[j].ColumnName.ToString() == "BehaviourText")
                    {
                        if (dt.Rows[i][j].ToString().Length > 52)
                        {
                            sb.Append("<td class='cls-" + j + "' title='" + dt.Rows[i][j].ToString() + "' ExerciseID='" + dt.Rows[i]["ExerciseID"].ToString() + "' onclick='fndsplyComment(this)' style='cursor:pointer;'>" + sicon + dt.Rows[i][j].ToString().Substring(0, 50) + " ...</td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "' title='" + dt.Rows[i][j].ToString() + "'  ExerciseID='" + dt.Rows[i]["ExerciseID"].ToString() + "'  onclick='fndsplyComment(this)' style='cursor:pointer;'>" + sicon + dt.Rows[i][j] + " </td>");
                        }
                    }
                    else
                    {
                        if (dt.Rows[i][j].ToString().Length > 52)
                        {
                            sb.Append("<td class='cls-" + j + "' title='" + dt.Rows[i][j].ToString() + "' ExerciseID='" + dt.Rows[i]["ExerciseID"].ToString() + "' onclick='fndsplyComment(this)' style='cursor:pointer;'>" + dt.Rows[i][j].ToString().Substring(0, 50) + " ...</td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + j + "' title='" + dt.Rows[i][j].ToString() + "'  ExerciseID='" + dt.Rows[i]["ExerciseID"].ToString() + "'  onclick='fndsplyComment(this)' style='cursor:pointer;'>"+ dt.Rows[i][j] + " </td>");
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

    [System.Web.Services.WebMethod()]
    public static string fnSaveScoreFromWashUp(string CycleId, string EmpNodeId, object obj, string LoginId, string flgSubmit)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows[0][0].ToString() == "0")
            {
                tbl.Rows.Clear();
            }

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSaveScoreFromWashUp";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@udt_ScoreDataSaving", tbl);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            if (flgSubmit == "1")     //Interim
            {
                Scmd.Parameters.AddWithValue("@flgSubmit", "0");
            }
            else //Final
            {
                Scmd.Parameters.AddWithValue("@flgSubmit", "2");
            }
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            string ss = JsonConvert.SerializeObject(Ds.Tables[0], Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            return "0|" + ss;
        }
        catch (Exception e)
        {
            return ("1");
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnSave(string CycleId, string EmpNodeId, object obj, object obj1, string LoginId, string flgSubmit)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows[0][0].ToString() == "0")
            {
                tbl.Rows.Clear();
            }

            string str1 = JsonConvert.SerializeObject(obj1, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl1 = JsonConvert.DeserializeObject<DataTable>(str1);
            if (tbl1.Rows[0][0].ToString() == "0")
            {
                tbl1.Rows.Clear();
            }

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spIntegrationSheetSaveAdditionalInfo";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@tmpCriteriaRating", tbl);
            Scmd.Parameters.AddWithValue("@tmpReadinessResponse", tbl1);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@flgStatus", flgSubmit);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            //string ss = JsonConvert.SerializeObject(Ds.Tables[0], Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            return "0|";
        }
        catch (Exception e)
        {
            return ("1");
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSaveCommts(string CycleId, string EmpNodeId, object obj, string LoginId, string flgSubmit)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows[0][0].ToString() == "0")
            {
                tbl.Rows.Clear();
            }

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRatingAssessorSaveExerciseAndCompWiseResponse";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@udt_ExerciseAndCompWiseResponseSaving", tbl);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@flgStatus", flgSubmit);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            //string ss = JsonConvert.SerializeObject(Ds.Tables[0], Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            return "0|";
        }
        catch (Exception e)
        {
            return ("1");
        }
    }


    [System.Web.Services.WebMethod()]
    public static string fnSaveBK(string CycleId, string EmpNodeId, object obj, object obj1, string LoginId, string flgSubmit)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows[0][0].ToString() == "0")
            {
                tbl.Rows.Clear();
            }

            string str1 = JsonConvert.SerializeObject(obj1, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl1 = JsonConvert.DeserializeObject<DataTable>(str1);
            if (tbl1.Rows[0][0].ToString() == "0")
            {
                tbl1.Rows.Clear();
            }

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spIntegrationSheetSaveAdditionalInfo";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@tmpCriteriaRating", tbl);
            Scmd.Parameters.AddWithValue("@tmpReadinessResponse", tbl1);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@flgStatus", flgSubmit);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            //string ss = JsonConvert.SerializeObject(Ds.Tables[0], Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            return "0|";
        }
        catch (Exception e)
        {
            return ("1");
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSaveWashupCmptncyTrafficLight(string CycleId, string EmpNodeId, int flgColor, string LoginId, int CmptncyId)
    {
        try
        {

            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSaveWashupCmptncyTrafficLight";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeId);
            Scmd.Parameters.AddWithValue("@CmptncyId", CmptncyId);
            Scmd.Parameters.AddWithValue("@flgColor", flgColor);
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
    public static string fnStartMeeting(string MeetingId, string BEIUsername, string BEIPassword)
    {
        try
        {
            //BEIUsername = "vacassessor5@gmail.com";
            //BEIPassword = "Astix@12345";
            //var accessToken = clsHttpRequest.GetTokenNo(BEIUsername, BEIPassword);
            ///MeetingsApi objMeetingsApi = new MeetingsApi();
            //var strHostURL = objMeetingsApi.startMeeting(accessToken, MeetingId);
            return "0|";// + strHostURL.hostURL;
        }
        catch (Exception ex)
        {
            return "1|" + ex.Message;
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
    public static object fnGetDetailRpt(string EmpNodeid, string CycleId, string CmptncyId, string ExerciseId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetRSPRatingResponseDetail]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@EmpNodeid", EmpNodeid);
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@CmptncyId", CmptncyId);
        Scmd.Parameters.AddWithValue("@ExerciseId", ExerciseId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);

        if (ds.Tables[1].Rows.Count > 0)
        {
            return createStoretbl(ds, CmptncyId, ExerciseId);
        }
        else
            return "";
    }

    private static string createStoretbl(DataSet ds, string ExcerciseRatingDetId, string ExerciseId)
    {
        DataTable dt = ds.Tables[0];
        DataTable dtComments = ds.Tables[1];
        string[] SkipColumn = new string[8];
        SkipColumn[0] = "ExcerciseRatingDetId";
        SkipColumn[1] = "AnsVal";
        SkipColumn[2] = "Exercise";
        SkipColumn[3] = "ExerciseID";
        SkipColumn[4] = "RspExerciseID";
        SkipColumn[5] = "Comments";
        SkipColumn[6] = "ExcerciseRatingId";
        SkipColumn[7] = "BehaviourTypeId";

        StringBuilder sb = new StringBuilder();
        StringBuilder sbScore = new StringBuilder();
        int cnt = 1;
        sb.Append("<table id='dvMainContent' style='margin-bottom:5px;overflow:auto;width:100%; border-spacing: 3px;border-collapse: separate;'>");
        DataTable dtExercises = ds.Tables[0].DefaultView.ToTable(true, "ExerciseID", "Exercise");
        for (int excnt = 0; excnt < dtExercises.Rows.Count; excnt++)
        {
            sb.Append("<tr style='background-color:#d9d9d9;'>");

            sb.Append("<td style='font-size:10pt;font-weight:bold;padding:2px 5px;vertical-align:middle'><i class='fa fa-" + (ExerciseId != dtExercises.Rows[excnt]["ExerciseId"].ToString() ? "plus" : "minus") + "' style='font-size:12pt;cursor:pointer;margin-right:5px' onclick=\"fnExpandDataCompetency(this,'" + dtExercises.Rows[excnt]["ExerciseId"].ToString() + "')\"><i/> " + dtExercises.Rows[excnt]["Exercise"].ToString() + "</td>");
            sb.Append("</tr>");

            sb.Append("<tr id='trCom_" + dtExercises.Rows[excnt]["ExerciseId"].ToString() + "' " + (ExerciseId != dtExercises.Rows[excnt]["ExerciseId"].ToString() ? "style='display:none'" : "") + ">");
            sb.Append("<td  style='font-size:10pt;font-weight:bold;padding:5px 5px;vertical-align:middle;border-bottom:2px solid #000'>");
            DataRow[] drows = dt.Select("ExerciseId=" + dtExercises.Rows[excnt]["ExerciseId"].ToString());
DataRow[] drowsComments = dtComments.Select("ExerciseId=" + dtExercises.Rows[excnt]["ExerciseId"].ToString());
            if (drows.Count() > 0)
            {
                sb.Append("<div style='margin-top:5px;margin-bottom:5px;height:auto;overflow:auto;width:100%;border:1px solid #000'><table id='tbl_Ans'  class='clsAns' style='width:100%'>");

                sb.Append("<thead style='background-color:#e9ecef'>");
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('^')[0].Trim()))
                    {
                        sb.Append("<th class='clsRating_" + j.ToString() + "'>" + dt.Columns[j].ColumnName.ToString().Split('^')[0] + "</th>");
                    }
                }
                sb.Append("</tr>");
                sb.Append("</thead>");
                sb.Append("<tbody>");
                string strOldBehaiour = "";
                for (int i = 0; i < drows.Count(); i++)
                {
                    if (drows[i]["BehaviourTypeId"].ToString()!= strOldBehaiour)
                    {
                        if (drows[i]["BehaviourTypeId"].ToString() == "1")
                        {
                            sb.Append("<tr EvidenceId='" + drows[i]["ExcerciseRatingDetId"].ToString() + "'><td>Positive Behaviour</td></tr>");
                        }
                        else
                        {
                            sb.Append("<tr EvidenceId='" + drows[i]["ExcerciseRatingDetId"].ToString() + "'><td>Negative Behaviour</td></tr>");
                        }
                    }
                    strOldBehaiour = drows[i]["BehaviourTypeId"].ToString();
                    sb.Append("<tr EvidenceId='" + drows[i]["ExcerciseRatingDetId"].ToString() + "'>");
                    for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                    {
                        if (!SkipColumn.Contains(ds.Tables[0].Columns[j].ColumnName.ToString()))
                        {
                                    sb.Append("<td class='clsInput' style='text-align:center'><textarea style='width:100%' rows='2' >"+ drows[i][j].ToString() + "</textarea></td>");
                        }
                    }
                    sb.Append("</tr>");
                }
                sb.Append("</tbody>");
                sb.Append("</table></div>");

                sb.Append("<div style='margin-top:10px'><table id='tbl_Comments' class='clsAns' style='width:100%'>");
                sb.Append("<tr><td style='font-weight:bold;font-size:9pt !important'>Score Statement:</td></tr>");
                sb.Append("<tr><td><textarea rows='2' style='width:100%' id='txtPositiveExample' ExcerciseRatingId='"+ drowsComments[0]["ExcerciseRatingId"].ToString() + "'>" + Convert.ToString(drowsComments[0]["FinalScoreStatement"]) + "</textarea></td></tr>");
                //sb.Append("<tr><td style='font-weight:bold'>Overall Insights:</td></tr>");
                // sb.Append("<tr><td><textarea rows='2' style='width:100%' id='txtOverallInsight'>" + OverallInsight + "</textarea></td></tr>");
                sb.Append("</table></div>");

            }
            else
            {
                sb.Append("<div style='margin:10px 10px' class='text-center'>No Rating Done By Assessor</div>");
            }
            sb.Append("</td></tr>");
            //sb.Append("<div style='margin-top:5px;' id='divOscore'><table style='width:100%'><tr><td style='font-weight:bold;width:10%'>Overall Score : </td><td style='padding-left:5px'><select id='ddl_" + ExcerciseRatingDetId + "' style='border:1px solid #bbb;text-align:center;width:120px'>" + sbScore + "</select></td><td style='font-weight:bold;width:8%'>Comments : </td><td style='padding-left:5px'><textarea id='txtarea_" + ExcerciseRatingDetId + "' rows='2' style='width:100%'>" + Comments + "</textarea></td></tr></table></div>");
        }
        sb.Append("</table>");
        return sb.ToString();
    }


    [System.Web.Services.WebMethod()]
    public static string fnRecalculateOverallScore(string CycleId) //Not Used
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        string strres = "0|";
        try
        {
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRecalculateOverallScore";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();
        }
        catch (Exception ex)
        {
            strres = "2|" + ex.Message;
        }
        finally
        {
            Scon.Dispose();
        }
        return strres;
    }

    [System.Web.Services.WebMethod()]
    public static string fnSaveRating(object udt_DataSaving, string LoginId, string ComptencyId, object udt_RatingCommentsDetail)
    {
        try
        {
            HttpContext.Current.Session["LoginId"] = LoginId;
            string strDataSaving = JsonConvert.SerializeObject(udt_DataSaving, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtDataSaving = JsonConvert.DeserializeObject<DataTable>(strDataSaving);
            dtDataSaving.TableName = "udt_DataSaving";
            if (dtDataSaving.Rows[0][0].ToString() == "0")
            {
                dtDataSaving.Rows[0].Delete();
            }

            string strRatingCommentsDetail = JsonConvert.SerializeObject(udt_RatingCommentsDetail, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtRatingCommentsDetail = JsonConvert.DeserializeObject<DataTable>(strRatingCommentsDetail);
            dtRatingCommentsDetail.TableName = "udt_RatingCommentsDetail";
            if (dtRatingCommentsDetail.Rows[0][0].ToString() == "0")
            {
                dtRatingCommentsDetail.Rows[0].Delete();
            }

            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAdminSaveQuestionResponse]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@udt_DataSaving", dtDataSaving);
            Scmd.Parameters.AddWithValue("@RatingCommentsDetail", dtRatingCommentsDetail);
            Scmd.Parameters.AddWithValue("@ComptencyId", ComptencyId);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);

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
}