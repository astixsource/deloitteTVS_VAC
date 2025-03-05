using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Generalist_PreDC_frmCareerReflection : System.Web.UI.Page
{
    void Page_PreInit(object sender, EventArgs e)
    {
        string strCallType = Request.QueryString["flgcallfrom"] == null ? "0" : Request.QueryString["flgcallfrom"].ToString();
        if (strCallType == "1")
        {
            this.MasterPageFile = "~/TP1MFG/PreDC/SiteFull.master";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string strCallType = Request.QueryString["flgcallfrom"] == null ? "0" : Request.QueryString["flgcallfrom"].ToString();
        if (strCallType == "0")
        {
            if (Session["LoginId"] == null)
            {
                Response.Redirect("../../Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                hdnLogin.Value = Session["LoginId"].ToString();
                hdnEmpNodeId.Value = Session["EmpNodeID"].ToString();
                hdnEmpName.Value = Session["EmpName"].ToString();
            }
        }
        else
        {
            hdnEmpNodeId.Value = Request.QueryString["EmpNodeID"] == null ? "0" : Request.QueryString["EmpNodeID"].ToString();
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetCareerReflectionProfileData(string EmpNodeId)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            string storedProcName = "spGetCareerReflectionProfileData";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@EmpNodeId", EmpNodeId)
                };
            DataSet Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);

            return "0|~|" + JsonConvert.SerializeObject(Ds, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore }); 
        }
        catch (Exception ex)
        {
            return "1|~|Error : " + ex.Message;
        }
        finally
        {
            con.Dispose();
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSaveCareerReflectionProfileData(string LoginId, string FullName, string TotExperience,string BoschExperience,string NoOfReportingMembers
        ,string Level,string Function,string CareerPath,string FactorsToMotivate,string Achievements,string KeyEventsAndExperiences,
        string KeyLearnings,string PhotoFileName)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            HttpContext.Current.Session["LoginId"] = LoginId;
            string storedProcName = "spSaveCareerReflectionProfileData";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@LoginId", LoginId),
                   new SqlParameter("@FullName", FullName),
                   new SqlParameter("@TotExperience", TotExperience),
                    new SqlParameter("@BoschExperience", BoschExperience),
                     new SqlParameter("@NoOfReportingMembers", NoOfReportingMembers),
                      new SqlParameter("@Level", Level),
                       new SqlParameter("@Function", Function),
                       new SqlParameter("@CareerPath", CareerPath),
                       new SqlParameter("@FactorsToMotivate", FactorsToMotivate),
                       new SqlParameter("@Achievements", Achievements),
                       new SqlParameter("@KeyEventsAndExperiences", KeyEventsAndExperiences),
                       new SqlParameter("@KeyLearnings", KeyLearnings),
                       new SqlParameter("@PhotoFileName", PhotoFileName)

                };
            DataSet Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);

            return "0|Saved Successfully";
        }
        catch (Exception ex)
        {
            return "1|Error : " + ex.Message;
        }
        finally
        {
            con.Dispose();
        }
    }
}