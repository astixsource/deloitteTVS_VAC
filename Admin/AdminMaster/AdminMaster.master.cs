using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminMaster :  System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    //protected void lnkLogout_Click(object sender, EventArgs e)
    //{
    //    Response.Redirect("~/Admin/Common/frmLogout.aspx");
    //}

    //protected void lnkHome_Click(object sender, EventArgs e)
    //{
    //    Response.Redirect("~/Admin/Setting/AdminMenu.aspx");
    //}

    //protected void lnkBack_Click(object sender, EventArgs e)
    //{
    //    if (Session["flgMenu"].ToString() == "2")
    //    {
    //        Response.Redirect("~/Admin/MasterForms/frmPartDeveloperStatus.aspx");
    //    }
    //    else
    //    {
    //        Response.Redirect("~/Admin/Setting/AdminDashboard.aspx");
    //    }
    //}
}
