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
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            if (!IsPostBack)
            { 
                hdnLogin.Value = Session["LoginId"].ToString();
                GetMaster();
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");
        }
    }

    private void GetMaster()
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAssessmentCycleDetail";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@CycleID", 0);
        Scmd.Parameters.AddWithValue("@Flag", 0);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dtBatch = new DataTable();
        Sdap.Fill(dtBatch);
        Scmd.Dispose();
        Sdap.Dispose();

        ddlBatch.Items.Add(new ListItem("-- Select --", "0"));
        foreach (DataRow dr in dtBatch.Rows)
        {
            ddlBatch.Items.Add(new ListItem(dr["CycleName"].ToString(), dr["CycleId"].ToString()));
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId, string TypeId)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spAssessmentGetDetailsForCycleMappingWithUser";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@TypeId", TypeId);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAllEmployeeDetailsForMappingToCycle";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@TypeID", TypeId);
        Sdap = new SqlDataAdapter(Scmd);
        DataTable dtBatch = new DataTable();
        Sdap.Fill(dtBatch);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbddl = new StringBuilder();
        sbddl.Append("<option value='0'>-- Select --</option>");
        for (int i = 0; i < dtBatch.Rows.Count; i++)
        {
            sbddl.Append("<option value='" + dtBatch.Rows[i]["EmpNodeID"] + "'>" + dtBatch.Rows[i]["FName"] + " ( " + dtBatch.Rows[i]["EmpCode"] + " )</option>");
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm text-center' id='tblMapping'>");
        sb.Append("<thead class='thead-light text-center'>");
        sb.Append("<tr>");
        sb.Append("<th>#</th>");
        switch (TypeId)
        {
            case "1":
                sb.Append("<th>Participant</th>");
                break;
            case "2":
                sb.Append("<th>Assessor</th>");
                break;
            case "3":
                sb.Append("<th>EY Admin</th>");
                break;
            case "4":
                sb.Append("<th>EY Super Admin</th>");
                break;
        }
        sb.Append("<th>User</th>");
        if (TypeId == "1")
        {
            sb.Append("<th></th>");
        }
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        {
            sb.Append("<tr>");
            sb.Append("<td>" + (i + 1).ToString() + "</td>");
            sb.Append("<td>" + Ds.Tables[0].Rows[i]["UserDescr"].ToString() + "</td>");
            sb.Append("<td><select iden='emp' seq='" + Ds.Tables[0].Rows[i]["SeqNo"].ToString() + "' defval='" + Ds.Tables[0].Rows[i]["EmpNodeId"].ToString() + "' EmpName='" + Ds.Tables[0].Rows[i]["EmpName"].ToString() + " ( " + Ds.Tables[0].Rows[i]["EmpCode"].ToString() + " )' style='width:90%;'>" + sbddl.ToString() + "</select></td>");
            if (TypeId == "1")
            {
                sb.Append("<td><i class='text-danger fa fa-times-circle' style='cursor: pointer;' onclick='fnRemoveMapping(this);'></i></td>");
            }
            sb.Append("</tr>");
        }
        sb.Append("<tbody>");
        sb.Append("</table>");

        return sb.ToString() + "^" + Ds.Tables[1].Rows[0][0].ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnRemoveSlot(string CycleId, string SeqNo, object obj, string flgtoKeepSlot, string LoginId)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRemoveParticipantFromBatchMapping";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@SeqNo", SeqNo);
            Scmd.Parameters.AddWithValue("@tblUserList", tbl);
            Scmd.Parameters.AddWithValue("@flgtoKeepSlot", flgtoKeepSlot);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();
            return "0^" + Ds.Tables[0].Rows[0]["IsMeetingCreated"].ToString();
        }
        catch (Exception e)
        {
            return ("1");
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnSave(string CycleId, string TypeId, object obj, string LoginId)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spAssessmentSaveDetailsForCycleMappingWithUser";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CycleId", CycleId);
            Scmd.Parameters.AddWithValue("@TypeId", TypeId);
            Scmd.Parameters.AddWithValue("@tblUserList", tbl);
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
}