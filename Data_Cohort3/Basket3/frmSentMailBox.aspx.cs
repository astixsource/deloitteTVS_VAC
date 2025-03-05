using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Text;
using System.Collections;

public partial class frmSentMailBox : System.Web.UI.Page
{

    SqlConnection con = null;
    SqlCommand cmd = null;
    DataSet ds = null;
    SqlDataAdapter da = null;
    SqlDataReader drdr = null;
    string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);

    protected void Page_Init(object sender, EventArgs e)
    {

        if (Session["LoginId"] != null)
        {
            //HttpCookie c1 = new HttpCookie("maxletterid", getMaxLetterId().ToString());
            //Response.Cookies.Add(c1);
        }
        else
        {
            Response.Write("<script>parent.frames.location.href='../Login.aspx'</script>");
        }

    }

    protected void Page_Load(object sender, EventArgs e)
    {
if (Session["RSPExerciseID"] == null)
        {
            Response.Write("<script>parent.frames.location.href='../Login.aspx'</script>");
            return;
        }
        if (!IsPostBack)
        {
          //  hdnExerciseTotalTime.Value = "90";
            SqlConnection objCon = new SqlConnection(strConn);
            SqlCommand objcom = new SqlCommand("SpReturnExerciseTimeDet", objCon);
            objcom.Parameters.AddWithValue("@RSPExerciseID", Session["RSPExerciseID"]);
            objcom.Parameters.AddWithValue("@BandID", 2);
          
            objcom.CommandTimeout = 0;
            objcom.CommandType = CommandType.StoredProcedure;
            SqlDataReader dr;
            objCon.Open();
            dr = objcom.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    // Response.Write("<script>alert('step1')</script>");
                    hdnTimeElapsedMin.Value = (dr["ElapsedTime(Min)"].ToString() == null) ? "0" : dr["ElapsedTime(Min)"].ToString();
                    hdnTimeElapsedSec.Value = (dr["ElapsedTime(Sec)"].ToString() == null) ? "0" : dr["ElapsedTime(Sec)"].ToString();
                    hdnExerciseTotalTime.Value = (dr["TotalTestTime"].ToString() == null) ? "0" : dr["TotalTestTime"].ToString();
                    int TotElapsedSeconds = Convert.ToInt32(hdnTimeElapsedMin.Value) * 60 + Convert.ToInt32(hdnTimeElapsedSec.Value);
                    // hdnCounter.Value = Convert.ToString(Convert.ToInt32(hdnExerciseTotalTime.Value) * 60 - TotElapsedSeconds);
                    string PrepRemainingTime = (dr["RemainingTime"].ToString() == null) ? "0" : dr["RemainingTime"].ToString();
                    hdnCounter.Value = Convert.ToInt32(PrepRemainingTime) < 0 ? "0" : PrepRemainingTime.ToString();
                }
                dr.Close();
                objCon.Close();
                objCon.Dispose();

            }

            //if ((Convert.ToInt32(hdnExerciseTotalTime.Value) * 60) > (Convert.ToInt32(hdnTimeElapsedMin.Value) * 60 + Convert.ToInt32(hdnTimeElapsedSec.Value)))
            //{
            //    int TimeAllotedSec = (Convert.ToInt32(hdnExerciseTotalTime.Value) * 60) - (Convert.ToInt32(hdnTimeElapsedMin.Value) * 60 + Convert.ToInt32(hdnTimeElapsedSec.Value));
            //    //  Timer2.Interval = (1000 * TimeAllotedSec)
            //    hdnCounter.Value = Convert.ToString(TimeAllotedSec);
            //}

            hdnRSPExerciseID.Value = Session["RSPExerciseID"].ToString();
            tbody1.InnerHtml = fnGetStringHTML(hdnRSPExerciseID.Value);


        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetStringHTML(string RSPExerciseID)
    {
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection sqlc1 = new SqlConnection(strConn);
        string strcommand1 = "[SpGetSentMailDetails]";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, sqlc1);
        sqlcommand1.Parameters.AddWithValue("@RSPExerciseID", RSPExerciseID);
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        SqlDataReader sqldr1 = null;
        StringBuilder strHTML = new StringBuilder();
        try
        {
            sqlc1.Open();
            sqldr1 = sqlcommand1.ExecuteReader();
            
            if (sqldr1.HasRows)
            {
                while (sqldr1.Read())
                {
                    if (sqldr1[15].ToString() == "Unread")
                    {
                        strHTML.Append("<tr style=\" font-weight:bold; font-size:12px;\" ReadStatus='" + sqldr1[16].ToString() + "'>");

                        strHTML.Append("<td style='display:none'>" + sqldr1[1].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[2].ToString() + "</td>");
                        strHTML.Append("<td style='display:none;' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'>&nbsp;</td>");

                        strHTML.Append("<td style='width:2%;' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'><img src='../../Images/Icons/UnreadImg.png'/></td>");
                        strHTML.Append("<td style='display:none;' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'>" + (sqldr1["flgAttachment"].ToString().Contains("0") == true ? "&nbsp;" : "<img src='../../Images/Icons/attachementIcon.png' title='Attachment'/>") + "</td>");
                        strHTML.Append("<td style='width:30%' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)' cellText='" + Convert.ToString(sqldr1[8].ToString()) + "'>" + (string.IsNullOrEmpty(sqldr1[8].ToString()) == true ? "&nbsp;" : sqldr1[8].ToString()) + "</td>");
                        strHTML.Append("<td style='width:46%' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)' cellText='" + Convert.ToString(sqldr1[7].ToString()) + "'>" + (string.IsNullOrEmpty(sqldr1[7].ToString()) == true ? "&nbsp;" : sqldr1[7].ToString()) + "</td>");

                        strHTML.Append("<td style='width:25%;' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'>" + (string.IsNullOrEmpty(sqldr1[15].ToString()) == true ? "&nbsp;" : sqldr1[15].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[4].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[11].ToString()) == true ? "&nbsp;" : sqldr1[11].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[6].ToString() + "</td>");
                        // strHTML.Append("<td onclick=\"fnDeleteEmail()\"><img width='15px' height='15px' title='Click to Delete' src='../../Images/Icons/DeletItems-icon.png' /></td>");
                        strHTML.Append("<td></td>");
                        strHTML.Append("<td style='display:none'><div id='dv" + sqldr1[0].ToString() + "'>" + HttpContext.Current.Server.HtmlDecode(HttpContext.Current.Server.HtmlDecode(sqldr1[5].ToString())) + "</div></td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[18].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[19].ToString() + "</td>");
                        strHTML.Append("</tr>");
                    }
                    else
                    {

                        strHTML.Append("<tr  ReadStatus='" + sqldr1[16].ToString() + "'>");

                        strHTML.Append("<td style='display:none'>" + sqldr1[1].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[2].ToString() + "</td>");
                        strHTML.Append("<td style='display:none;' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'>&nbsp;</td>");

                        strHTML.Append("<td style='width:2%;' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'><img src='../../Images/Icons/ReadImg.png'/></td>");
                        strHTML.Append("<td style='display:none' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)'>" + (sqldr1["flgAttachment"].ToString().Contains("0") == true ? "&nbsp;" : "<img src='../../Images/Icons/attachementIcon.png' title='Attachment'/>") + "</td>");
                        strHTML.Append("<td style='width:30%' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)' cellText='" + Convert.ToString(sqldr1[8].ToString()) + "'>" + (string.IsNullOrEmpty(sqldr1[8].ToString()) == true ? "&nbsp;" : sqldr1[8].ToString()) + "</td>");
                        strHTML.Append("<td style='width:46%' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)' cellText='" + Convert.ToString(sqldr1[7].ToString()) + "'>" + (string.IsNullOrEmpty(sqldr1[7].ToString()) == true ? "&nbsp;" : sqldr1[7].ToString()) + "</td>");

                        strHTML.Append("<td style='width:25%' onclick='fnOpenMailBody(" + sqldr1[0].ToString() + ",this)' >" + sqldr1[15].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[4].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + (string.IsNullOrEmpty(sqldr1[11].ToString()) == true ? "&nbsp;" : sqldr1[11].ToString()) + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[6].ToString() + "</td>");
                        //if (sqldr1[16].ToString() == "NewMail")
                        //{
                        //    strHTML.Append("<td onclick=\"fnDeleteEmail(" + sqldr1[0].ToString() + ",'1')\"><img width='15px' title='Click to Delete' height='15px' src='../../Images/Icons/DeletItems-icon.png' /></td>");
                        //}
                        //else
                        //{
                        //    strHTML.Append("<td onclick=\"fnDeleteEmail(" + sqldr1[0].ToString() + ",'0')\"><img width='15px' title='Click to Delete' height='15px' src='../../Images/Icons/DeletItems-icon.png' /></td>");
                        //}
                        strHTML.Append("<td></td>");
                        strHTML.Append("<td style='display:none'><div id='dv" + sqldr1[0].ToString() + "'>" + HttpContext.Current.Server.HtmlDecode(HttpContext.Current.Server.HtmlDecode(sqldr1[5].ToString())) + "</div></td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[18].ToString() + "</td>");
                        strHTML.Append("<td style='display:none'>" + sqldr1[19].ToString() + "</td>");
                        strHTML.Append("</tr>");


                    }

                    //hdnUserMailResponseID.Value = sqldr1[0].ToString();
                }

                sqldr1.Close();
                sqlc1.Close();

            }
        }
        catch (Exception e1)
        {
            if (sqlc1.State == ConnectionState.Open)
                sqlc1.Close();

        }
        return strHTML.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnSetSentBody(string strsentBody)
    {
        HttpContext.Current.Session["sentBody"] = strsentBody;
        return "OK";
    }

    [System.Web.Services.WebMethod()]
    public static int fnSpINBasetExerciseDone(int flgExerciseStatus)
    {
        int flgRead = 0;
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection con = null;
        con = new SqlConnection(strConn);

        string strcommand1 = "SpINBasetExerciseDone";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
        sqlcommand1.Parameters.AddWithValue("@RSPExerciseID", Convert.ToInt32(HttpContext.Current.Session["RSPExerciseID"].ToString()));
        sqlcommand1.Parameters.AddWithValue("@flgExerciseStatus", flgExerciseStatus);
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        try
        {
            con.Open();
            sqlcommand1.ExecuteNonQuery();
            sqlcommand1.Dispose();
            con.Close();
        }
        catch
        {
            if (con.State == ConnectionState.Open)
                con.Close();

        }
        return 0;
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
    public static int fnMarkDeleteStatus(int RspMailInstanceID,string status)
    {
        int flgRead = 0;
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection con = null;
        con = new SqlConnection(strConn);

        string strcommand1 = "SpUserSentMailsAction";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
        sqlcommand1.Parameters.AddWithValue("@UserMailResponseID", RspMailInstanceID);
        sqlcommand1.Parameters.AddWithValue("@flgReplyMailRefStatusID", 5);
	sqlcommand1.Parameters.AddWithValue("@flgNewMail",Convert.ToInt32(status));
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
}