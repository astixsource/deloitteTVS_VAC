using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class frmLeft : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "SpMailCount";
        Scmd.CommandType = CommandType.StoredProcedure;
        //Scmd.Parameters.AddWithValue("@RspExerciseID", Session["RSPExerciseID"].ToString());
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet ds = new DataSet();
       // Sdap.Fill(ds);

       // HiddenField1.Value = ds.Tables[0].Rows[0][0].ToString() + "|" + ds.Tables[1].Rows[0][0].ToString() + "|" + ds.Tables[2].Rows[0][0].ToString();
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
            Scon.Dispose();
            
            return "0";
        }
        catch (Exception ex)
        {
            return "1";
        }
    }


    
}