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

public partial class frmManagerAssessmentRating : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["LoginId"] == null || Session["RoleId"] == null)
        {
            Response.Redirect("../../Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            hdnRoleId.Value = Session["RoleId"].ToString();
            hdnLogin.Value = Session["LoginId"].ToString();
           
            frmGetUserDetail(Request.QueryString["str"].ToString().Split('^')[0], Request.QueryString["str"].ToString().Split('^')[1]);
        }
    }

    private void frmGetUserDetail(string EmpNodeID,string CycleId)
    {
        StringBuilder sb = new StringBuilder();
        using (SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"])))
        {
            using (SqlCommand command = new SqlCommand("spRspGetManagerFeedbackResponses", Scon))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 0;
                command.Parameters.AddWithValue("@EmpNodeID", EmpNodeID);
                command.Parameters.AddWithValue("@CycleId", CycleId);
                command.Parameters.AddWithValue("@LoginID", hdnLogin.Value);
                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    using (DataSet ds = new DataSet())
                    {
                        da.Fill(ds);

                        if (ds.Tables[0].Rows.Count > 0)
                        {

                            sb.Append("<div style='margin:2px 5px;width: 99%;display: inline-block;vertical-align: top;'><table id='tbl_Ans_Positive' class='table table-bordered table-sm bg-white clsAns mb-0'>");
                            sb.Append("<thead>");
                            sb.Append("<tr>");
                            sb.Append("<th>Competency</th>");
                            sb.Append("<th>Question</th>");
                            for (int c = 0; c < ds.Tables[1].Rows.Count; c++)
                            {
                                sb.Append("<th style='text-align:center;width:6%' id='score_" + ds.Tables[1].Rows[c]["RatingId"].ToString() + "'>" + ds.Tables[1].Rows[c]["RatingScale"].ToString() + "</th>");
                            }
                            sb.Append("</tr>");
                            sb.Append("</thead>");
                            sb.Append("<tbody>");
                            var OldBehaviourHeaderText1 = "";
                            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                            {

                                sb.Append("<tr>");
                                string cls = "";
                                if (Convert.ToString(ds.Tables[0].Rows[i]["Qstn"]) != "")
                                {
                                    cls = "pl-2";
                                }
                                sb.Append("<td class='p-1 " + cls + "'>" + ds.Tables[0].Rows[i]["Competency"].ToString() + "</td>");
                                sb.Append("<td class='p-1 " + cls + "' bid='" + ds.Tables[0].Rows[i]["RspExerciseQstnId"].ToString() + "'>" + ds.Tables[0].Rows[i]["Qstn"].ToString() + "</td>");

                                for (int c = 0; c < ds.Tables[1].Rows.Count; c++)
                                {                                    
                                    if (ds.Tables[1].Rows[c]["RatingId"].ToString() == Convert.ToString(ds.Tables[0].Rows[i]["AnswrVal"]))
                                    {
                                        sb.Append("<td class='p-1 " + cls + "' style='text-align:center;vertical-align:middle' bid='" + ds.Tables[0].Rows[i]["RspDetID"].ToString() + "'><input type='radio' bid='" + ds.Tables[0].Rows[i]["RspDetID"].ToString() + "' value='" + ds.Tables[1].Rows[c]["RatingId"].ToString() + "' checked name='rdoBeh_" + ds.Tables[0].Rows[i]["RspDetID"].ToString() + "' /></td>");
                                    }
                                    else
                                    {
                                        sb.Append("<td class='p-1 " + cls + "' style='text-align:center;vertical-align:middle' bid='" + ds.Tables[0].Rows[i]["RspDetID"].ToString() + "'><input type='radio' bid='" + ds.Tables[0].Rows[i]["RspDetID"].ToString() + "' value='" + ds.Tables[1].Rows[c]["RatingId"].ToString() + "' name='rdoBeh_" + ds.Tables[0].Rows[i]["RspDetID"].ToString() + "' /></td>");
                                    }
                                }

                                sb.Append("</tr>");
                            }
                            sb.Append("</tbody>");
                            sb.Append("</table></div>");

                            divBody.InnerHtml= sb.ToString();

                        }

                        if (ds.Tables[2].Rows.Count == 1)
                        {
                            hdnRSPExId.Value = ds.Tables[2].Rows[0]["RspID"].ToString();
                            tdUserCode.InnerHtml = ds.Tables[2].Rows[0]["EmpName"].ToString() + "-" + ds.Tables[2].Rows[0]["EMpCode"].ToString();
                        }
                        
                    }
                }

            }
        }

        
        //StringBuilder sbParticipant = new StringBuilder();
        //int flgAssessorStart = 0;

        //for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        //{
        //    string strSelected = "";
        //    if (hdnRSPExId.Value == ds.Tables[0].Rows[i]["RspExerciseID"].ToString())
        //    {
        //        flgAssessorStart = Convert.ToInt32(ds.Tables[0].Rows[i]["flgAssessorStart"]);
        //        strSelected = "Selected='selected'";
        //    }
        //    sbParticipant.Append("<option value='" + ds.Tables[0].Rows[i]["RspExerciseID"].ToString() + "' " + strSelected + ">" + ds.Tables[0].Rows[i]["EmpName"].ToString() + "-" + ds.Tables[0].Rows[i]["UserCode"].ToString() + "</option>");
        //}
        //string flgCallFrom = hdnflgCallFrom.Value;
        //string flgAssessorType = Request.QueryString["flgAssessorType"] == null ? "1" : Request.QueryString["flgAssessorType"].ToString();
        //if (flgCallFrom == "2")
        //{
        //    sb.Append("<div class='text-center mt-3'><a href='#' onclick='fnSubmit()' id='btnFinalSubmit' class='btn btn-outline-light'>Final Submit</a></div>");
        //}
        //else
        //{

        //    sb.Append("<div class='text-center mt-3'>");
        //    if (flgAssessorType == "1")
        //    {
        //        if (flgAssessorStart == 0)
        //        {
        //            sb.Append("<a href='###' MeetingId='" + ds.Tables[0].Rows[0]["MeetingId"].ToString() + "'  MeetingLink='" + Convert.ToString(ds.Tables[0].Rows[0]["AssessorMeetingLink"]) + "'  onclick='fnStartMeeting(this)'  class='btn btn-outline-light btn-sm' id='btnMeeting1' style='margin-bottom:2px;'>Start Meeting</a> <a href='###' MeetingId='" + ds.Tables[0].Rows[0]["MeetingId"].ToString() + "'  MeetingLink='" + Convert.ToString(ds.Tables[0].Rows[0]["AssessorMeetingLink"]) + "'  onclick='fnStartMeeting(this)'  class='btn btn-outline-light btn-sm' id='btnMeeting2' style='margin-left:5px;margin-bottom:2px;display:none'>Resume Meeting</a>");
        //        }
        //        else if (flgAssessorStart == 1)
        //        {
        //            sb.Append("<a href='###' MeetingId='" + ds.Tables[0].Rows[0]["MeetingId"].ToString() + "'  MeetingLink='" + Convert.ToString(ds.Tables[0].Rows[0]["AssessorMeetingLink"]) + "'   onclick='fnStartMeeting(this)'  class='btn btn-outline-light btn-sm' id='btnMeeting1' style='margin-bottom:2px;'>End Meeting For Participant</a> <a href='###' MeetingId='" + ds.Tables[0].Rows[0]["MeetingId"].ToString() + "'  MeetingLink='" + Convert.ToString(ds.Tables[0].Rows[0]["AssessorMeetingLink"]) + "'  onclick='fnStartMeeting(this)'  class='btn btn-outline-light btn-sm' id='btnMeeting2' style='margin-left:5px;margin-bottom:2px;'>Resume Meeting</a>");
        //        }
        //        else
        //        {
        //            //sb.Append("<a href='###' class='btn btn-primary btn-sm' id='btnMeeting1'>Meeting Finished</a>");
        //        }
        //        sb.Append("<a href='###' MeetingId='" + ds.Tables[0].Rows[0]["MeetingId"].ToString() + "' MeetingLink='" + Convert.ToString(ds.Tables[0].Rows[0]["AssessorMeetingLink"]) + "' onclick='fnCloseExit(1)' style='margin-left:4px;'  class='btn btn-outline-light btn-sm' id='btnMeeting3' title='Click here when completely finished with this exercise. Note ratings can also be completed later.'>Close & Exit</a>");
        //    }
        //    else
        //    {
        //        sb.Append("<a href='" + Convert.ToString(ds.Tables[0].Rows[0]["AssessorMeetingLink"]) + "'  target='_blank'  class='btn btn-outline-light btn-sm' id='btnMeeting1' style='margin-bottom:2px;'>Join Meeting</a>");
        //        sb.Append("<a href='###' MeetingId='" + ds.Tables[0].Rows[0]["MeetingId"].ToString() + "' onclick='fnCloseExit(2)' style='margin-left:4px;'  class='btn btn-outline-light btn-sm' id='btnMeeting3' title='Click here when completely finished with this exercise. Note ratings can also be completed later.'>Close & Exit</a>");
        //    }

        //    sb.Append("</div>");
        //}

        //string sLegends = "<div style='width:100%;padding:1px 4px;margin-top:330px;font-weight:bold;color:#fff'><table style='width:100%;font-size:7.5pt'><tr><td style='height:15px;width:35px' class='clsSaveRating'></td><td>Save Rating</td><td style='height:15px;width:35px' class='clstdHighlighted'></td><td> Highlight Competency</td></tr></table></div>";
        //divbtnsLeft.InnerHtml = sb.ToString() + sLegends;
       
    }

    

    
    [System.Web.Services.WebMethod()]
    public static object fnGetDetailRpt(string ExcerciseRatingDetId, string RSPExerciseId, string LoginId, string Competency)
    {
        HttpContext.Current.Session["LoginId"] = LoginId;
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spRatingAssessorGetQuestionDetail]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@ExerciseMultiMailID", ExcerciseRatingDetId);
        Scmd.Parameters.AddWithValue("@RSPExerciseId", RSPExerciseId);
        Scmd.Parameters.AddWithValue("@LoginId", LoginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);

        if (ds.Tables[0].Rows.Count > 0)
        {

            return createStoretbl(ds, ExcerciseRatingDetId, Competency);
        }
        else
            return "";
    }

    private static string createStoretbl(DataSet ds, string ExcerciseRatingDetId, string Competency)
    {
        DataTable dt = ds.Tables[0];
        DataTable dtComments = ds.Tables[1];
        DataTable dtUserResponse = ds.Tables[2];
        DataTable dtScores = ds.Tables[3];
        string[] SkipColumn = new string[8];
        SkipColumn[0] = "ExcerciseRatingDetId";
        SkipColumn[1] = "ID";
        SkipColumn[2] = "ExcerciseRatingDetId_Positive";
        SkipColumn[3] = "ExcerciseRatingDetId_Negative";
        SkipColumn[4] = "AnsVal_Positive";
        SkipColumn[5] = "AnsVal_Negative";
        SkipColumn[6] = "BehaviourID_Positive";
        SkipColumn[7] = "BehaviourID_Negative";

        StringBuilder sb = new StringBuilder();
        StringBuilder sbScore = new StringBuilder();
        string PositiveExample = "";
        string NegativeExample = "";
        string OverallInsight = "";
        string OverallScore = "";
        string ScoreId = "0";
        string FinalScoreStatement = "";
        int ScoreStatementId = 0;
        int cnt = 1;
        if (dtUserResponse.Rows.Count > 0)
        {
            sb.Append("<div style='background-color:#deeaf6;font-size:11pt;font-weight:bold;padding:2px 4px'>User Response</div>");
            sb.Append("<div style='padding:6px;border:1px solid #deeaf6;border-bottom:2px solid #deeaf6;margin-bottom:6px'><table style='width:100%'>");
            foreach (DataRow drow in dtUserResponse.Rows)
            {
                sb.Append("<tr><td style='font-weight:bold;font-size:10pt;padding:2px;width:4%;vertical-align:top'>Q" + cnt.ToString() + " : </td><td style='font-size:11pt;padding:2px'>" + drow[1].ToString() + "</td></tr>");
                sb.Append("<tr><td style=';padding:2px;font-weight:bold;font-size:10pt;vertical-align:top'>Ans : </td><td style='font-size:10pt;padding:2px'>" + drow[2].ToString() + "</td></tr>");
                cnt++;
            }
            sb.Append("</table></div>");
        }
        if (dtComments.Rows.Count > 0)
        {
            PositiveExample = Convert.ToString(dtComments.Rows[0]["PositiveExample"]);
            //NegativeExample = Convert.ToString(dtComments.Rows[0]["NegativeExample"]);
            //OverallInsight = Convert.ToString(dtComments.Rows[0]["OverallInsight"]);
            OverallScore = Convert.ToString(dtComments.Rows[0]["OverallScore"]);
            ScoreId = "0";// Convert.ToString(dtComments.Rows[0]["ScoreId"]);
           // FinalScoreStatement = Convert.ToString(dtComments.Rows[0]["FinalScoreStatement"]);
            //ScoreStatementId = Convert.ToInt32(dtComments.Rows[0]["ScoreStatementId"]);
        }
        //string[] arrScore = new string[5];
        //arrScore[0] = "5";
        //arrScore[1] = "4";
        //arrScore[2] = "3";
        //arrScore[3] = "2";
        //arrScore[4] = "1";

        //string[] arrScoreDetails = new string[5];
        //arrScoreDetails[0] = "Strong";
        //arrScoreDetails[1] = "Relative Strength";
        //arrScoreDetails[2] = "Proficient";
        //arrScoreDetails[3] = "Needs Development";
        //arrScoreDetails[4] = "Needs Significant Development";

        //string[] arrScoreBehaviour = new string[5];
        //arrScoreBehaviour[0] = "4";
        //arrScoreBehaviour[1] = "3";
        //arrScoreBehaviour[2] = "2";
        //arrScoreBehaviour[3] = "1";
        //arrScoreBehaviour[4] = "-1";

        //string[] arrScoreBehaviourDetails = new string[5];
        //arrScoreBehaviourDetails[0] = "Strongly display";
        //arrScoreBehaviourDetails[1] = "Adequately display";
        //arrScoreBehaviourDetails[2] = "Partially displayed";
        //arrScoreBehaviourDetails[3] = "Not displayed";
        //arrScoreBehaviourDetails[4] = "No opportunity to observe the behaviour";

        DataRow[] dRowsOverallScore = dtScores.Select("ScoreType=1");

        sbScore.Append("<option value='0' selected>--Select Score--</option>");
        for (int c = 0; c < dRowsOverallScore.Length; c++)
        {
            if (dRowsOverallScore[c]["Score"].ToString() == OverallScore)
            {
                sbScore.Append("<option value='" + dRowsOverallScore[c]["Score"].ToString() + "' selected>" + dRowsOverallScore[c]["ScoreText"].ToString() + "</option>");
            }
            else
            {
                sbScore.Append("<option value='" + dRowsOverallScore[c]["Score"].ToString() + "' >" + dRowsOverallScore[c]["ScoreText"].ToString() + "</option>");
            }
        }

        //if (PositiveExample == "")
        //{
        //    PositiveExample = "Assessor Comments Not Available";
        //}
        //if (PositiveExample != "")
        //{
        //    sb.Append("<div style='border:1px solid #b0b0b0;padding:2px;margin:0px 5px;font-size:8pt'>" + PositiveExample + "</div>");
        //}

        DataRow[] dRowsBehScore = dtScores.Select("ScoreType=2");
        if (ds.Tables[0].Rows.Count > 0)
        {
            
            sb.Append("<div style='margin:2px 5px;width: 99%;display: inline-block;vertical-align: top;'><table id='tbl_Ans_Positive' class='table table-bordered table-sm bg-white clsAns mb-0'>");
            sb.Append("<thead>");
            sb.Append("<tr>");
            sb.Append("<th>Behaviour</th>");
            for (int c = 0; c < dRowsBehScore.Length; c++)
            {
                sb.Append("<th style='text-align:center' id='score_"+ dRowsBehScore[c]["Score"].ToString() + "'>"+ dRowsBehScore[c]["ScoreText"].ToString() + "</th>");
            }
            sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tbody>");
            var OldBehaviourHeaderText1 = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                
                sb.Append("<tr>");
                string cls = "";
                if (Convert.ToString(dt.Rows[i]["Cues"]) != "")
                {
                    cls = "pl-3";
                }
                        sb.Append("<td class='p-1 "+ cls + "' bid='" + dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "'>" + dt.Rows[i]["Cues"].ToString() + "</td>");
                   
                for (int c = 0; c < dRowsBehScore.Length; c++)
                {
                    if (dRowsBehScore[c]["Score"].ToString() == Convert.ToString(dt.Rows[i]["AnsVal"]))
                    {
                        sb.Append("<td class='p-1 " + cls + "' bid='" + dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "'><input type='radio' bid='" + dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "' value='"+ dRowsBehScore[c]["Score"].ToString() + "' checked name='rdoBeh_"+ dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "' /></td>");
                    }
                    else
                    {
                        sb.Append("<td class='p-1 " + cls + "' bid='" + dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "'><input type='radio' bid='" + dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "' value='"+ dRowsBehScore[c]["Score"].ToString() + "' name='rdoBeh_" + dt.Rows[i]["ExcerciseRatingDetId"].ToString() + "' /></td>");
                    }
                }
               
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table></div>");

            //drowsPositives = ds.Tables[0].Select("BehaviourTypeId=2");
            //sb.Append("<div style='margin:2px 5px;width: 48%;display: inline-block;vertical-align: top;'><table id='tbl_Ans_Negative' class='table table-bordered table-sm bg-white clsAns mb-0'>");
            //sb.Append("<thead>");
            //sb.Append("<tr>");
            //sb.Append("<th>Negative Behaviour</th>");
            //sb.Append("</tr>");
            //sb.Append("</thead>");
            //sb.Append("<tbody>");
            //string OldBehaviourHeaderText = "";
            //for (int i = 0; i < drowsPositives.Length; i++)
            //{
            //    if (Convert.ToString(drowsPositives[i]["BehaviourHeaderText"]) != OldBehaviourHeaderText)
            //    {
            //        sb.Append("<tr><td class='p-1' style='font-weight:bold'>"+ Convert.ToString(drowsPositives[i]["BehaviourHeaderText"]) + "</td></tr>");
            //    }
            //    OldBehaviourHeaderText = Convert.ToString(drowsPositives[i]["BehaviourHeaderText"]);
            //    sb.Append("<tr>");
            //    string cls = "";
            //    if (Convert.ToString(drowsPositives[i]["BehaviourHeaderText"]) != "")
            //    {
            //        cls = "pl-3";
            //    }

            //    if (Convert.ToString(drowsPositives[i]["AnsVal"]) != "")
            //        {
            //            sb.Append("<td class='p-1 " + cls + "' bid='" + drowsPositives[i]["ExcerciseRatingDetId"].ToString() + "'><input type='checkbox' name='rdoB_" + drowsPositives[i]["ID"].ToString() + "'  flg='1' btypeid='1'  onclick='fnclickBehaviour(this)'  value='" + drowsPositives[i]["BehaviourID"].ToString() + "' " + (drowsPositives[i]["AnsVal"].ToString()==drowsPositives[i]["BehaviourID"].ToString()? " checked='checked'" : "") + "  /> " + drowsPositives[i]["Behaviour Text"].ToString() + "</td>");
            //        }
            //        else
            //        {
            //            sb.Append("<td class='p-1 " + cls + "' bid='" + drowsPositives[i]["ExcerciseRatingDetId"].ToString() + "'><input type='checkbox' name='rdoB_" + drowsPositives[i]["ID"].ToString() + "'  flg='1' btypeid='1'  onclick='fnclickBehaviour(this)'   value='" + drowsPositives[i]["BehaviourID"].ToString() + "'  /> " + drowsPositives[i]["Behaviour Text"].ToString() + "</td>");
            //        }


            //    sb.Append("</tr>");
            //}
            //sb.Append("</tbody>");
            //sb.Append("</table></div>");

        }
        sb.Append("<div style='margin-top:10px'><table style='width:100%'><tr><td style='font-weight:bold;width:10%'>Overall Score : </td><td style='padding-left:5px;;width:40%'><select id='ddl_" + ExcerciseRatingDetId + "' style='border:1px solid #bbb;text-align:left'>" + sbScore + "</select></td></tr></table></div>");
        sb.Append("<div style='margin-top:10px'><table id='tbl_Comments' class='clsAns'>");
        sb.Append("<tr><td style='font-weight:bold'>Remarks:</td></tr>");
        sb.Append("<tr><td><textarea rows='2' style='width:100%' id='txtPositiveExample'>" + PositiveExample + "</textarea></td></tr>");
        //sb.Append("<tr><td style='font-weight:bold'>Negative Examples of Behavior:</td></tr>");
        //sb.Append("<tr><td><textarea rows='2' style='width:100%' id='txtNegativeExample'>" + NegativeExample + "</textarea></td></tr>");
        //sb.Append("<tr><td style='font-weight:bold'>Overall Insights:</td></tr>");
        //sb.Append("<tr><td><textarea rows='2' style='width:100%' id='txtOverallInsight'>" + OverallInsight + "</textarea></td></tr>");
        sb.Append("</table></div>");
        return sb.ToString();
    }

    private static string createScoreStatement(DataTable dt, int ScoreStatementId)
    {

        StringBuilder sb = new StringBuilder();
        if (dt.Rows.Count > 0)
        {

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<label>");
                sb.Append("<input type='radio'  " + (ScoreStatementId == Convert.ToInt32(dt.Rows[i]["ScoreStatementId"]) ? "" : "disabled='disabled'") + " " + (ScoreStatementId == Convert.ToInt32(dt.Rows[i]["ScoreStatementId"]) ? "checked='checked'" : "") + " value='" + dt.Rows[i]["ScoreStatementId"].ToString() + "' name='rdoscorestatement' onclick='fnSelectScoreStatement(this)'>  " + dt.Rows[i]["ScoreStatement"].ToString());
                sb.Append("</label>");
            }
        }
        return sb.ToString();
    }

    private static string createCuetbl(DataTable dt)
    {

        string[] SkipColumn = new string[1];
        SkipColumn[0] = "ExcerciseRatingDetId";
        StringBuilder sb = new StringBuilder();
        if (dt.Rows.Count > 0)
        {

            sb.Append("<table style='width:100%;border-style:none' border='0'>");
            sb.Append("<tbody>");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<tr ExerciseCompetencyPLMapID='" + dt.Rows[i]["ExerciseCompetencyPLMapID"].ToString() + "' PLID='" + dt.Rows[i]["PLID"].ToString() + "' >");
                sb.Append("<td style='border-top:none'>" + dt.Rows[i]["Cue"].ToString() + "</td>");
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");

        }
        return sb.ToString();
    }


    [System.Web.Services.WebMethod()]
    public static string fnStartMeeting(string RSPExerciseid, int flgMeeting, string MeetingId, int RoleId)
    {
        try
        {
            if (flgMeeting == 1)
            {
                if (RoleId == 3)
                {
                    fnUpdateActualStartEndTime(RSPExerciseid, 2, "3");
                }
                else
                {
                    fnUpdateActualStartEndTime(RSPExerciseid, 3, "3");
                }

                return "0|";
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
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
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
    public static string fnSave(object udt_DataSaving, string LoginId, string RspID, string Status)
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

           

            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spUpdateManagerFeedbackResponses]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@RspActualAnswerDetail", dtDataSaving);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@RspID", RspID);
            Scmd.Parameters.AddWithValue("@Status", Status);


            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scmd.Dispose();
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
    public static string fnFinalSubmit(string RSPExerciseid, string LoginId)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAssessorFinalSubmit]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@RSPExerciseid", RSPExerciseid);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.Parameters.AddWithValue("@Remarks", "");
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();
            Scon.Dispose();
            return "0";
        }
        catch (Exception ex)
        {
            return "1";
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnRatingAssessorSaveSubCompetencyScore(string ExcerciseRatingDetId, string AnsVal)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAssessorSaveSubCompetencyScore]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@ExcerciseRatingDetId", ExcerciseRatingDetId);
            Scmd.Parameters.AddWithValue("@AnsVal", AnsVal);
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();
            Scon.Dispose();
            return "0";
        }
        catch (Exception ex)
        {
            return "1";
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnRatingAssessorSavePLListForSubCompetency(int ExcerciseRatingDetId, int ExerciseCompetencyPLMapID, int RatingId)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAssessorSavePLListForSubCompetency]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@ExcerciseRatingDetId", ExcerciseRatingDetId);
            Scmd.Parameters.AddWithValue("@ExerciseCompetencyPLMapID", ExerciseCompetencyPLMapID);
            Scmd.Parameters.AddWithValue("@RatingId", RatingId);
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
    public static string fnFinalReview(string RSPExerciseid, string LoginId)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAssessorGetRSPExerciseFullDetail_PopUp]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.Parameters.AddWithValue("@RSPExerciseId", RSPExerciseid);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            return "0|" + CreateFinalReviewQuestion(ds.Tables[0]);
        }
        catch (Exception ex)
        {
            return "1|";
        }
    }


    private static string CreateFinalReviewQuestion(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt_temp = dt.DefaultView.ToTable(true, "QstnID", "Question");
        for (int i = 0; i < dt_temp.Rows.Count; i++)
        {
            DataTable dt_filter = dt.Select("[QstnID]='" + dt_temp.Rows[i]["QstnID"].ToString() + "'").CopyToDataTable();
            sb.Append("<div class='clsReviewBlock'>");
            if (i == dt_temp.Rows.Count - 1)
            {
                sb.Append("<div class='clsReviewHead' flg='0' onclick='fnShowHideReviewBlock(this);'>");
                sb.Append("<table style='width:100%'>");
                sb.Append("<tr>");
                sb.Append("<td class='clsMaillbl' style='width: 20px; padding-top:4px;'><img alt='' src='../../Images/Icons/iconDel.gif' style='width: 12px; cursor: pointer;' /></td>");
                if (dt_temp.Rows[i]["Question"].ToString().Length > 60)
                {
                    sb.Append("<td class='clsMaillbl' style='padding-top:4px; font-weight:100;'>" + dt_temp.Rows[i]["Question"].ToString().Replace("'", "\"").Replace("<br>", " ").Substring(0, 60) + "</td>");
                }
                else
                {
                    sb.Append("<td class='clsMaillbl' style='padding-top:4px; font-weight:100;'>" + dt_temp.Rows[i]["Question"].ToString().Replace("'", "\"").Replace("<br>", " ") + "</td>");
                }
                //sb.Append("<td class='clsMaillbl' style='padding-top:4px;padding-right:3px;color:#000;font-weight:bold;text-align:right'>Final Score : " + dt_temp.Rows[i]["FinalScore"].ToString() + "</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</div>");
                sb.Append("<div class='clsReviewBody'>" + CreateFinalReviewQuestionWiseResponse(dt_filter) + "</div>");
            }
            else
            {
                sb.Append("<div class='clsReviewHead' flg='1' onclick='fnShowHideReviewBlock(this);'>");
                sb.Append("<table style='width:100%'>");
                sb.Append("<tr>");
                sb.Append("<td class='clsMaillbl' style='width: 20px; padding-top:4px;'><img alt='' src='../../Images/Icons/iconAdd.gif' style='width: 12px; cursor: pointer;' /></td>");
                if (dt_temp.Rows[i]["Question"].ToString().Length > 60)
                {
                    sb.Append("<td class='clsMaillbl' style='padding-top:4px; font-weight:100;'>" + dt_temp.Rows[i]["Question"].ToString().Replace("'", "\"").Replace("<br>", " ").Substring(0, 60) + "</td>");
                }
                else
                {
                    sb.Append("<td class='clsMaillbl' style='padding-top:4px; font-weight:100;'>" + dt_temp.Rows[i]["Question"].ToString().Replace("'", "\"").Replace("<br>", " ") + "</td>");
                }
                // sb.Append("<td class='clsMaillbl' style='padding-top:4px;padding-right:3px;color:#000; font-weight:bold;text-align:right'>Final Score : " + dt_temp.Rows[i]["FinalScore"].ToString() + "</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</div>");
                sb.Append("<div class='clsReviewBody' style='display:none;'>" + CreateFinalReviewQuestionWiseResponse(dt_filter) + "</div>");
            }
            sb.Append("</div>");
        }

        return sb.ToString();
    }

    private static string CreateFinalReviewQuestionWiseResponse(DataTable dt)
    {
        string[] SkipColumn = new string[6];
        SkipColumn[0] = "QstnID";
        SkipColumn[1] = "Question";
        SkipColumn[2] = "MailOrderNo";
        SkipColumn[3] = "ResponseDetId";
        SkipColumn[4] = "FinalScore";
        SkipColumn[5] = "Selected Response";

        if (dt.Rows.Count > 0)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<table id='tbl_Response' class='clstblResponse'>");
            sb.Append("<thead >");
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('^')[0].Trim()))
                {
                    sb.Append("<th style=''>" + dt.Columns[j].ColumnName.ToString().Split('^')[0] + "</th>");
                }
            }
            sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tbody>");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                switch (dt.Rows[i]["Selected Response"].ToString())
                {
                    case "High":
                        sb.Append("<tr class='clsAnsYes'>");
                        break;
                    case "Medium":
                        sb.Append("<tr class='clsAnsYes'>");
                        break;
                    case "Low":
                        sb.Append("<tr class='clsAnsPartialYes'>");
                        break;
                    default:
                        sb.Append("<tr class='clsAnsNo'>");
                        break;
                }

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                    {
                        if (dt.Rows[i][j].ToString() == "Negative Behaviour")
                        {
                            sb.Append("<td style='background-color:#ffc6c6'>" + dt.Rows[i][j].ToString().Replace("'", "\"") + "</td>");
                        }
                        else
                        {
                            sb.Append("<td>" + dt.Rows[i][j].ToString().Replace("'", "\"") + "</td>");
                        }

                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
            return sb.ToString();
        }
        else
        {
            return "<div style='font-size:13px; padding : 10px 20px; color:red; font-weight:bold;'>No Record Found !</div>";
        }
    }
}