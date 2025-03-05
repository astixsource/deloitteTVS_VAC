using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


public partial class frmMailBody : System.Web.UI.Page
{
    int getActiveIndex = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Session["LoginId"] == null)
        //{
        //    Response.Redirect("Login.aspx");
        //    return;
        //}
        getActiveIndex =  Convert.ToInt32(Request.QueryString["getActiveIndex"]);
        if (getActiveIndex < MultiView1.Views.Count)
        {
            MultiView1.ActiveViewIndex = getActiveIndex;
        }        
    }
   
}