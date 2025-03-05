using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
public partial class frmInbox : System.Web.UI.Page
{
    SqlConnection con = null;
    SqlCommand cmd = null;
    DataSet ds = null;
    SqlDataAdapter da = null;
    SqlDataReader drdr = null;
    string strConn =Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
    string[,] arrPara;
    // clsConnection.clsConnection objAdo;

    protected void Page_Load(object sender, EventArgs e)
    {
        string ExerciseID = ((Request.QueryString["ExerciseID"] == null) ? "0" : Request.QueryString["ExerciseID"]);
        if (Session["LoginId"] == null || Session["BandID"] == null)
        {
            Response.Write("<script>parent.frames.location.href='../../Login.aspx'</script>");
            return;
        }
        if (!IsPostBack)
        {
            int BandID = 2;// ((Session["BandID"] == null) ? 0 : Convert.ToInt32(Session["BandID"]));
            int ExerciseType = ((Request.QueryString["ExerciseType"] == null) ? 0 : Convert.ToInt32(Request.QueryString["ExerciseType"]));
            hdnExerciseTotalTime.Value = ((Request.QueryString["TotalTime"] == null) ? "0" : Request.QueryString["TotalTime"]);
            hdnRspID.Value = ((Request.QueryString["RspID"] == null) ? "0" : Request.QueryString["RspID"]);
            hdnLoginID.Value = ((Session["LoginId"] == null) ? "0" : Session["LoginId"].ToString());
            hdnExerciseID.Value = ExerciseID;
            SqlConnection objCon = new SqlConnection(strConn);
            SqlCommand objcom = new SqlCommand("spRspExerciseManage", objCon);
            objcom.Parameters.AddWithValue("@RspID", Convert.ToInt32(hdnRspID.Value));
            objcom.Parameters.AddWithValue("@ExerciseID", Convert.ToInt32(ExerciseID));
            objcom.Parameters.AddWithValue("@LoginId", Convert.ToInt32(hdnLoginID.Value));
            objcom.Parameters.AddWithValue("@BandID", BandID);
            objcom.CommandTimeout = 0;
            objcom.CommandType = CommandType.StoredProcedure;
            SqlDataReader dr;
            objCon.Open();
            dr = objcom.ExecuteReader();

            int PrepStatus = 0; 

        if (dr.HasRows)
        {
            while (dr.Read())
            {
                    // Response.Write("<script>alert('step1')</script>");
                    //hdnTimeElapsedMin.Value = (dr["ElapsedTime(Min)"].ToString() == null) ? "0" : dr["ElapsedTime(Min)"].ToString();
                    //hdnTimeElapsedSec.Value = (dr["ElapsedTime(Sec)"].ToString() == null) ? "0" : dr["ElapsedTime(Sec)"].ToString();
                    //int TotElapsedSeconds = Convert.ToInt32(hdnTimeElapsedMin.Value) * 60 + Convert.ToInt32(hdnTimeElapsedSec.Value);
                    //hdnCounter.Value = Convert.ToString(Convert.ToInt32(hdnExerciseTotalTime.Value) * 60 - TotElapsedSeconds);
                    hdnExerciseStatus.Value = (dr["flgExerciseStatus"].ToString() == null) ? "0" : dr["flgExerciseStatus"].ToString();
                hdnRSPExerciseID.Value = (dr["RSPExerciseID"].ToString() == null) ? "0" : dr["RSPExerciseID"].ToString();
                Session["RSPExerciseID"] = hdnRSPExerciseID.Value;
                PrepStatus = dr["PrepStatus"] == null ? 0 : Convert.ToInt32(dr["PrepStatus"]);
                string PrepRemainingTime = (dr["PrepRemainingTime"].ToString() == null) ? "0" : dr["PrepRemainingTime"].ToString();
                if (PrepStatus == 2) {
                    hdnCounter.Value = "0";
                }
                else {
                    hdnCounter.Value = Convert.ToInt32(PrepRemainingTime) < 0? "0":PrepRemainingTime.ToString();
                }
            }
            dr.Close();
            objCon.Close();
            objCon.Dispose();

        }
            //if (PrepStatus == 0)
            //{
            //    int RspExerciseId = Convert.ToInt32(hdnRSPExerciseID.Value.ToString());

            //    fnUpdateActualStartEndTime(RspExerciseId, 1, 1);
            //}

        }

        SqlConnection sqlc1 = new SqlConnection(strConn);
        string strcommand1 = "[SpGetUserMailsInInbox]";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, sqlc1);
      //  sqlcommand1.Parameters.AddWithValue("@RspExerciseID", Convert.ToInt32(Session["RSPExerciseID"].ToString()));
              sqlcommand1.Parameters.AddWithValue("@RspExerciseID", hdnRSPExerciseID.Value);
        //sqlcommand1.Parameters.AddWithValue("@LoginID", Convert.ToInt32(Session["LoginID"]));
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        SqlDataReader sqldr1 = null;
        try
        {
            sqlc1.Open();
            sqldr1 = sqlcommand1.ExecuteReader();
            StringBuilder strHTML = new StringBuilder();
            int cntcount = 0;
            if (sqldr1.HasRows)
            {
                //  Response.Write("<script>alert('step2')</script>");
                while (sqldr1.Read())
                {
                    if (sqldr1[15].ToString() == "Unread")
                    {

                        if (sqldr1[19].ToString() == "1")
                        {
                            strHTML.Append("<tr class='clsRowBgColor' style=\" font-weight:bold; font-size:12px;\" flgPriorty='" + sqldr1["flgPriorty"].ToString() + "' ReadStatus='" + sqldr1[15].ToString() + "'>");
                        }

                        else
                        {
                            strHTML.Append("<tr style=\" font-weight:bold; font-size:12px;\" flgPriorty='" + sqldr1["flgPriorty"].ToString() + "' ReadStatus='" + sqldr1[15].ToString() + "'>");
                        }
                        strHTML.Append("<td style='display:none'>" + sqldr1[0].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[1].ToString() + "</td>");

                        strHTML.Append("<td style='display:none' onclick='fnOpenMailBody(this)'>&nbsp;</td>");

                        strHTML.Append("<td style='width:2%;' onclick='fnOpenMailBody(this)'><img src='../../Images/Icons/UnreadImg.png'/></td>");
                        strHTML.Append("<td style='width:2%;' onclick='fnOpenMailBody(this)'>" + (sqldr1["flgAttachment"].ToString().Contains("0") == true ? "&nbsp;" : "<img src='../../Images/Icons/attachementIcon.png' title='Attachment'/>") + "</td>");
                        strHTML.Append("<td style='width:25%' onclick='fnOpenMailBody(this)'>" + (string.IsNullOrEmpty(sqldr1[5].ToString()) == true ? "" : sqldr1[5].ToString()) + "</td>");
                        strHTML.Append("<td style='width:40%' onclick='fnOpenMailBody(this)'>" + (string.IsNullOrEmpty(sqldr1[6].ToString()) == true ? "" : sqldr1[6].ToString()) + "</td>");

                        strHTML.Append("<td style='width:14%'>" + (string.IsNullOrEmpty(sqldr1["ReceivingDate"].ToString()) == true ? "" : sqldr1["ReceivingDate"].ToString()) + "</td>");
                        strHTML.Append("<td style='width:14%' onclick='fnOpenMailBody(this)'>" + (string.IsNullOrEmpty(sqldr1["MailDate"].ToString()) == true ? "" : sqldr1["MailDate"].ToString()) + "</td>"); strHTML.Append("<td style='display:none'>" + sqldr1[3].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[10].ToString()) == true ? "" : sqldr1[10].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[7].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[5].ToString()) == true ? "" : sqldr1[5].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[6].ToString()) == true ? "" : sqldr1[6].ToString()) + "</td>");
                        strHTML.Append("<td style='width:2%;display:none' onclick='fnRowHighlight(this)'><i class='fa fa-flag'></i></td>");
                        strHTML.Append("</tr>");

                    }
                    else
                    {
                        if (sqldr1[19].ToString() == "1")
                        {
                            strHTML.Append("<tr class='mail-row-after-click clsRowBgColor' style=\"font-size:12px;cursor:default !important\" flgPriorty='" + sqldr1["flgPriorty"].ToString() + "' ReadStatus='" + sqldr1[15].ToString() + "'>");
                            //  strHTML.Append("<tr class='clsRowBgColor' style=\"font-size:12px;\" ReadStatus='" + sqldr1[15].ToString() + "'>");
                        }
                        else
                        {
                            strHTML.Append("<tr class='mail-row-after-click' style=\"font-size:12px;cursor:default !important;\" flgPriorty='" + sqldr1["flgPriorty"].ToString() + "' ReadStatus='" + sqldr1[15].ToString() + "'>");
                        }

                        // strHTML.Append("<tr style=\"font-size:12px;\" ReadStatus='" + sqldr1[15].ToString() + "'>");

                        strHTML.Append("<td style='display:none'>" + sqldr1[0].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[1].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>&nbsp;</td>");
                        strHTML.Append("<td style='width:2%;'><img src='../../Images/Icons/ReadImg.png'/></td>");
                        strHTML.Append("<td style='width:2%;'>" + (sqldr1["flgAttachment"].ToString().Contains("0") == true ? "&nbsp;" : "<img src='../../Images/Icons/attachementIcon.png' title='Attachment'/>") + "</td>");
                        strHTML.Append("<td style='width:25%'>" + (string.IsNullOrEmpty(sqldr1[5].ToString()) == true ? "" : sqldr1[5].ToString()) + "</td>");
                        strHTML.Append("<td style='width:40%'>" + (string.IsNullOrEmpty(sqldr1[6].ToString()) == true ? "" : sqldr1[6].ToString()) + "</td>");

                        strHTML.Append("<td style='width:14%'>" + (string.IsNullOrEmpty(sqldr1["ReceivingDate"].ToString()) == true ? "" : sqldr1["ReceivingDate"].ToString()) + "</td>");
                        strHTML.Append("<td style='width:14%' onclick='fnOpenMailBody(this)'>" + (string.IsNullOrEmpty(sqldr1["MailDate"].ToString()) == true ? "" : sqldr1["MailDate"].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[3].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[10].ToString()) == true ? "" : sqldr1[10].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[7].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[5].ToString()) == true ? "" : sqldr1[5].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[6].ToString()) == true ? "" : sqldr1[6].ToString()) + "</td>");
                        strHTML.Append("<td style='width:2%;display:none'><i class='fa fa-flag'></i></td>");
                        strHTML.Append("</tr>");
                    }
                    cntcount++;
                }
                hdnGrdRowcnt.Value = cntcount.ToString();
                tbody1.InnerHtml = strHTML.ToString();
                sqldr1.Close();
                sqlc1.Close();

            }
        }
        catch (Exception e1)
        {
            Response.Write(e1.Message);
            if (sqlc1.State == ConnectionState.Open)
                sqlc1.Close();

        }

        //  fnBindPriority();
    }

    private void fnBindPriority()
    {
        SqlConnection objCon = new SqlConnection(strConn);
        SqlCommand objcom = new SqlCommand("spGetPriorityMaster", objCon);
        objcom.CommandTimeout = 0;
        objcom.CommandType = CommandType.StoredProcedure;
        SqlDataAdapter da = new SqlDataAdapter(objcom);
        DataTable dt = new DataTable();

        da.Fill(dt);

        ddlPrority.DataTextField = "PriorityName";
        ddlPrority.DataValueField = "PriorityId";
        ddlPrority.DataSource = dt;
        ddlPrority.DataBind();
        dt.Dispose();
        objCon.Close();
        objCon.Dispose();

    }

    [System.Web.Services.WebMethod()]
    public static string fnUpdateTime(int ExerciseID)
    {
        try
        {
            classUsedForExerciseSave ObjclassUsedForExerciseSave = new classUsedForExerciseSave();
            ObjclassUsedForExerciseSave.SpUpdateElaspedTime(ExerciseID);
        }
        catch (Exception ex) { }


        return "0";
    }

    [System.Web.Services.WebMethod()]
    public static string fnUpdateTime1(int ExerciseID)
    {
        try
        {
            classUsedForExerciseSave ObjclassUsedForExerciseSave = new classUsedForExerciseSave();
            ObjclassUsedForExerciseSave.SpUpdateElaspedTime1(ExerciseID);
        }
        catch (Exception ex) { }


        return "0";
    }


    [System.Web.Services.WebMethod()]
    public static int fnMarkReaddStatus(int RspMailInstanceID, int flgMailResponseType)
    {
        int flgRead = 0;
        string strConn =Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection con = null;
        con = new SqlConnection(strConn);

        string strcommand1 = "SpUpdateREadUsermailFeedback";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
        sqlcommand1.Parameters.AddWithValue("@RspMailInstanceID", RspMailInstanceID);
        sqlcommand1.Parameters.AddWithValue("@flgMailResponseType", flgMailResponseType);
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        try
        {
            con.Open();
            sqlcommand1.ExecuteNonQuery();
            flgRead = 1;
            sqlcommand1.Dispose();
            con.Close();
        }
        catch
        {
            if (con.State == ConnectionState.Open)
                con.Close();

            flgRead = 0;
        }
        return flgRead;
    }


    [System.Web.Services.WebMethod()]
    public static int fnSpINBasetExerciseDone(int flgExerciseStatus, int flgTimeOver)
    {
        int flgRead = 0;
        string strConn =Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection con = null;
        con = new SqlConnection(strConn);

        string strcommand1 = "SpINBasetExerciseDone";
        int RspExerciseId = Convert.ToInt32(HttpContext.Current.Session["RSPExerciseID"].ToString());
        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
        sqlcommand1.Parameters.AddWithValue("@RSPExerciseID", Convert.ToInt32(HttpContext.Current.Session["RSPExerciseID"].ToString()));
        sqlcommand1.Parameters.AddWithValue("@flgExerciseStatus", flgExerciseStatus);
        sqlcommand1.Parameters.AddWithValue("@flgTimeOver", flgTimeOver);
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        try
        {
            con.Open();
            sqlcommand1.ExecuteNonQuery();
            sqlcommand1.Dispose();
            con.Close();
          //  fnUpdateActualStartEndTime(RspExerciseId, 1, 1);
            fnUpdateActualStartEndTime(RspExerciseId, 1, 2);
        }
        catch
        {
            if (con.State == ConnectionState.Open)
                con.Close();

        }
        return 0;
    }


    [System.Web.Services.WebMethod()]
    public static int fnUpdateMultiMailflgReadLater(int RspexerciseId, int RspMailInstanceID, int flgMailHighlight)
    {
        int flgRead = 0;
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection con = null;
        con = new SqlConnection(strConn);

        string strcommand1 = "spUpdateMultiMailflgReadLater";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
        sqlcommand1.Parameters.AddWithValue("@RspExcersiseID", RspexerciseId);
        sqlcommand1.Parameters.AddWithValue("@RspMailInstanceID", RspMailInstanceID);
        sqlcommand1.Parameters.AddWithValue("@flgMailHighlight", flgMailHighlight);
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        try
        {
            con.Open();
            sqlcommand1.ExecuteNonQuery();
            flgRead = 1;
            sqlcommand1.Dispose();
            con.Close();
        }
        catch
        {
            if (con.State == ConnectionState.Open)
                con.Close();

            flgRead = 0;
        }
        return flgRead;
    }

    [System.Web.Services.WebMethod()]
    public static string fnStartMeetingTimer(int RSPExerciseID, int MeetingDefaultTIME)
    {
        string strReturn = "";
        try
        {
            using (SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"])))
            {
                using (SqlCommand command = new SqlCommand("spAssesmentCheckDiscussionStarted", Scon))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandTimeout = 0;
                    command.Parameters.AddWithValue("@RspExerciseID", RSPExerciseID);
                    command.Parameters.AddWithValue("@MeetingDefaultTIME", MeetingDefaultTIME);
                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            strReturn = "0|" + dt.Rows[0]["flgReturnVal"].ToString() + "|" + Convert.ToString(dt.Rows[0]["RemainingTimeMeeting"]) + "|" + dt.Rows[0]["flgMeetingStatusP"].ToString() + "|" + dt.Rows[0]["flgMeetingStatusA"].ToString() + "|" + Convert.ToString(dt.Rows[0]["PrepRemainingTime"]);
                        }
                    }

                }
            }
        }
        catch(Exception ex)
        {
            strReturn = "1|" + ex.Message;
        }
        return strReturn;
    }


        [System.Web.Services.WebMethod()]
public static int fnUpdateActualStartEndTime(int RspexerciseId, int UserTypeID, int flgAction)
{
    int flgRead = 0;
    string strReturn = "";
    string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
    SqlConnection con = null;
    con = new SqlConnection(strConn);

    string strcommand1 = "spUpdateActualStartEndTime";

    SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
    sqlcommand1.Parameters.AddWithValue("@RspExerciseID", RspexerciseId);
    sqlcommand1.Parameters.AddWithValue("@UserTypeID", UserTypeID);
    sqlcommand1.Parameters.AddWithValue("@flgAction", flgAction);
    sqlcommand1.CommandType = CommandType.StoredProcedure;
    sqlcommand1.CommandTimeout = 0;
    try
    {
        con.Open();
        sqlcommand1.ExecuteNonQuery();
        strReturn = "1^";
        sqlcommand1.Dispose();
        con.Close();
    }
    catch
    {
        if (con.State == ConnectionState.Open)
            con.Close();
        strReturn = "2^";
        flgRead = 0;
    }
    return flgRead;
}

}

