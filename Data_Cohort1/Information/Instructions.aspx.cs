using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PGM_Information_Instructions : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] == null)
        {
            Response.Redirect("../../Login.aspx");
            return;
        }
        string bandId = Session["BandID"] == null ? "0" : Session["BandID"].ToString();


    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "SpSavePageNo";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@EmpNodeID", Session["EmpNodeID"].ToString());
        Scmd.Parameters.AddWithValue("@Pgnmbr", "2");
        Scmd.CommandTimeout = 0;
        Scon.Open();
        Scmd.ExecuteNonQuery();
        Scon.Close();
        Scon.Dispose();
        if (Convert.ToString(Session["IsSelfieTaken"]) == "0" && Convert.ToString(Session["IsProctoringEnabled"]) == "1")
        {
            Response.Redirect("../../Admin/Setting/frmSelfie.aspx");
        }
        else
        {
            Response.Redirect("../Exercise/ExerciseMain.aspx?intLoginID=" + Convert.ToString(Session["LoginId"]));
        }
    }
}