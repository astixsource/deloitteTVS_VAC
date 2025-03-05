using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
//using iTextSharp.text.pdf;
//using iTextSharp.text;
//using iTextSharp.text.html.simpleparser;

public partial class MasterForms_frmDownloadExcel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string flg = Request.QueryString["flg"] == null ? "0" : Request.QueryString["flg"].ToString();
        if (flg == "2")
        {
            string EmpNodeId = Request.QueryString["EmpNodeID"] == null ? "" : Request.QueryString["EmpNodeID"].ToString();
          //  string ParticipantName = "Mukhtyar";// Request.Form["empname"] == null ? "" : Request.Form["empname"].ToString();
            //fnDownloadCRForm(EmpNodeId);
        }
    }

   
}