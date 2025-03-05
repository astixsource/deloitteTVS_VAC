using Ionic.Zip;
using LogMeIn.GoToMeeting.Api;
using LogMeIn.GoToMeeting.Api.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_MasterForms_frmViewDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
         
        if (!IsPostBack)
        {
            hdnCycleId.Value = Request.QueryString["cycleid"] == null ? "0" : Request.QueryString["cycleid"].ToString();
            hdnCycleName.Value = Request.QueryString["cyclename"] == null ? "0" : Request.QueryString["cyclename"].ToString();
            hdnLoginId.Value = Request.QueryString["LoginId"] == null ? "" : Request.QueryString["LoginId"].ToString();
            hdnparticipantid.Value = Request.QueryString["participantid"] == null ? "" : Request.QueryString["participantid"].ToString();
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetAssessmentCycleListForAssessor(int stype, int loginId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetAssessmentCycleListForAssessor]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@LoginId", loginId);
        Scmd.Parameters.AddWithValue("@type", stype);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        string strResponse = JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });

        return strResponse;
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetParticipantDetails(int Participantid)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetEmployeeDetail]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@EmployeeId", Participantid);
        //Scmd.Parameters.AddWithValue("@LoginId", loginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        string strResponse = JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });

        return strResponse;
    }
}