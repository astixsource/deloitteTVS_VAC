using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MailFormat : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string ReferalUrl = "";
        ReferalUrl = Convert.ToString(Request.UrlReferrer);

        //if (Session["LoginId"] == null || ReferalUrl == "")
        //{
        //    Response.Write("<script>parent.frames.location.href='../../Login.aspx'</script>");
        //    return;
        //}
        if (Session["LoginId"] == null)
        {
            Response.Redirect("../../Login.aspx");
            return;
        }
        string bandId = Session["BandID"] == null ? "0" : Session["BandID"].ToString();
        if (bandId != "2")
        {
            Server.Transfer("../Common/frmSessionExpire.aspx");
        }

        if (Request.QueryString["ExerciseID"] == "")
            hdnExerciseID.Value = "0";
        else
            hdnExerciseID.Value = Request.QueryString["ExerciseID"];

        if(Request.QueryString["BandID"] == "")
            hdnBandID.Value = "0";
        else
            hdnBandID.Value = Request.QueryString["BandID"];

        if(Request.QueryString["ExerciseType"] == "")
            hdnExerciseType.Value = "0";
        else
            hdnExerciseType.Value = Request.QueryString["ExerciseType"];

        if(Request.QueryString["TotalTime"] == "")
            hdnTotalTime.Value = "0";
        else
            hdnTotalTime.Value = Request.QueryString["TotalTime"];

        if (Request.QueryString["RspID"] == "")
        {
            hdnRspID.Value = "0";
            Session["RspID"] = "0";
        }
        else {
            hdnRspID.Value = Request.QueryString["RspID"];
            Session["RspID"] = Request.QueryString["RspID"];
        }

        if (Request.QueryString["intLoginID"] == "")
            hdnLoginID.Value = "0";
        else
            hdnLoginID.Value = Request.QueryString["intLoginID"];

        if(Request.QueryString["ElapsedTimeMin"] == "")
            hdnTimeElapsedMin.Value = "0";
        else
            hdnTimeElapsedMin.Value = Request.QueryString["ElapsedTimeMin"];

        if(Request.QueryString["ElapsedTimeSec"] == "")
            hdnTimeElapsedSec.Value = "0";
        else
            hdnTimeElapsedSec.Value = Request.QueryString["ElapsedTimeSec"];


        if (!IsPostBack)
        {
            hdnRSPExerciseID.Value = Request.QueryString["RSPExerciseID"] == null ? "0" : Convert.ToString(Request.QueryString["RSPExerciseID"]);
            hdnIsProctoringEnabled.Value = Session["IsProctoringEnabled"] == null ? "0" : Convert.ToString(Session["IsProctoringEnabled"]);
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnExit()
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();            
            Scmd.Connection = Scon;
            Scmd.CommandText = "spManageLogoutAgEmployee";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@EmpNodeID", HttpContext.Current.Session["EmpNodeID"]);
            Scmd.CommandTimeout = 0;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();

            SqlCommand Scmd2 = new SqlCommand();
            Scmd2.Connection = Scon;
            Scmd2.CommandText = "SpINBasetExerciseDone";
            Scmd2.CommandType = CommandType.StoredProcedure;
            Scmd2.Parameters.AddWithValue("@RSPExerciseID", HttpContext.Current.Session["RSPExerciseID"]);
            Scmd2.Parameters.AddWithValue("@flgExerciseStatus", "2");
            Scmd2.CommandTimeout = 0;
            Scon.Open();
            Scmd2.ExecuteNonQuery();
            Scon.Close();

            Scon.Dispose();
            return "0";
        }
        catch (Exception ex)
        {
            return "1";
        }
    }
}