using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Generalist_PreDC_frmThanksForCareerReflection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        else {
            if (!IsPostBack)
            {
                hdnLogin.Value = Session["LoginID"].ToString();
            }
        }
    }

    [System.Web.Services.WebMethod()]
    public static string spMarkPRPRead(string LoginId, int flg)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            string storedProcName = "spMarkPRPRead";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@LoginId", LoginId),
                       new SqlParameter("@flgPRPReadStatus", flg)
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