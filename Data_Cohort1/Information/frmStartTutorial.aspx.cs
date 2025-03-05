using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PGM_Information_frmStartTutorial : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["LoginId"] == null)
        {
            //Response.Write("<script>parent.frames.location.href='../Login.aspx'</script>");
            Response.Redirect("~/Login.aspx");
        }

    }
}
  
  
