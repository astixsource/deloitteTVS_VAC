using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class frmChangePassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Session("username")
        if (Session["username"] == null)
        {
            Response.Redirect("Login.aspx");
            return;
        }
        if (!IsPostBack)
        {
            string EmpID1 = Request["EmpNodeID"] == null ? "0" : Request["EmpNodeID"].ToString();
            if (Session["username"] != null)
            {
                hdnIsDistributor.Value = "0";// Session["SalesNodeType"] == null || Convert.ToString(Session["SalesNodeType"])!="150" ? "0" : "1";
                txtUserName.Value = Convert.ToString(Session["username"]);
                //Response.Redirect("../FrmLogout.aspx");

                if (Session["flgPasswordExpired"].ToString() == "1")
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Password expired! Last password was changed 60 days ago. Please change your password first.";
                }
                else if (Session["flgPasswordExpired"].ToString() == "2")
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Please change your password first!";
                }
                else
                {
                    hdnShowLaterButton.Value = "1";
                }
            }
        }
    }

}