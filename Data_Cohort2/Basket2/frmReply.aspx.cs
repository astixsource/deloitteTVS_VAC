using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Text;
using System.IO;

public partial class frmReply : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            hdnMailOrderNo.Value = Request.QueryString["MailOrderNo"].ToString();
            hdnRspID.Value = Request.QueryString["RspID"].ToString();
            hdnRspMailInstanceID.Value = Request.QueryString["RspMailInstanceID"].ToString();

            hdnflgType.Value = Request.QueryString["flgType"].ToString();
            if (Convert.ToInt32(Request.QueryString["flgType"]) == 2)
            {
                lblFrom.InnerText = Request.QueryString["To"].ToString()==""?"NA": Request.QueryString["To"].ToString();
                txtTo.Value = Request.QueryString["MailFrom"].ToString();
                txtCc.Value = Request.QueryString["Cc"].ToString();
                txtSubject.Value ="RE: "+ Request.QueryString["MailSubject"].ToString();
            }
            else if (Convert.ToInt32(Request.QueryString["flgType"]) == 4)
            {
                lblFrom.InnerText = Request.QueryString["To"].ToString() == "" ? "NA" : Request.QueryString["To"].ToString();
                //if (lblFrom.InnerText.ToLower() != Request.QueryString["To"].ToString().ToLower())
                //{
                //    txtTo.Value = Request.QueryString["MailFrom"].ToString() + "," + Request.QueryString["To"].ToString();
                //}
                //else
                //{
                //    txtTo.Value = Request.QueryString["MailFrom"].ToString();

                //}
                txtTo.Value = Request.QueryString["MailFrom"].ToString();
                // txtTo.Value=txtTo.Value.Replace(Request.QueryString["MailFrom"].ToString()+",","");
                txtCc.Value =Request.QueryString["Cc"].ToString();
                txtSubject.Value = "RE: " + Request.QueryString["MailSubject"].ToString();
            }
            else
            {
                lblFrom.InnerText = Request.QueryString["To"].ToString() == "" ? "NA" : Request.QueryString["To"].ToString();
                txtTo.Value = "";
                txtCc.Value =Request.QueryString["Cc"].ToString();
                txtSubject.Value = "FW: " + Request.QueryString["MailSubject"].ToString();
            }

            MultiView1.ActiveViewIndex =Convert.ToInt32(Request.QueryString["MailOrderNo"].ToString());
            var sb = new StringBuilder();
            dvbody.RenderControl(new HtmlTextWriter(new StringWriter(sb)));

            string s = sb.ToString();
            string sss =Server.HtmlDecode(s);
            txtBody.Text = "<br/><br/><br/><hr/>" + sss.ToString();
          
            //txtBody.Focus();
            HtmlEditorExtender1.TargetControlID = "txtBody";
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSaveUsermailFeedback(int RspID, int RspMailInstanceID, string FeedbackMailText, string MailFrom, string MailSubject, string MailTOID, string MailCCID,string MailBCC, int flgMailResponseType,string attachments,int MailPriorty)
    {
        string MailAttachmentName = "";
        if (attachments != "")
        {
            MailAttachmentName = "1";
        }
        string strRsp = "OK";
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection con = null;
        con = new SqlConnection(strConn);

        string strcommand1 = "SpSaveUsermailFeedback";

        SqlCommand sqlcommand1 = new SqlCommand(strcommand1, con);
        sqlcommand1.Parameters.AddWithValue("@RspID", RspID);
        sqlcommand1.Parameters.AddWithValue("@RspMailInstanceID", RspMailInstanceID);
        sqlcommand1.Parameters.AddWithValue("@FeedbackMailText", FeedbackMailText);
        sqlcommand1.Parameters.AddWithValue("@MailFrom", MailFrom);
        sqlcommand1.Parameters.AddWithValue("@MailSubject", MailSubject);

        sqlcommand1.Parameters.AddWithValue("@MailTOID", MailTOID);
        sqlcommand1.Parameters.AddWithValue("@MailCCID", MailCCID);
        sqlcommand1.Parameters.AddWithValue("@MailBCCID", MailBCC);
         sqlcommand1.Parameters.AddWithValue("@MailAttachmentName", MailAttachmentName);
         sqlcommand1.Parameters.AddWithValue("@flgMailResponseType", flgMailResponseType);
        sqlcommand1.Parameters.AddWithValue("@MailPriorty", MailPriorty);
        sqlcommand1.CommandType = CommandType.StoredProcedure;
        sqlcommand1.CommandTimeout = 0;
        try
        {
            con.Open();
           // sqlcommand1.ExecuteNonQuery();
            int a = Convert.ToInt32(sqlcommand1.ExecuteScalar());
            sqlcommand1.Parameters.Clear();
            if (MailAttachmentName == "1")
            {
                for (int i = 0; i < attachments.Split('|').Length - 1; i++)
                {
                    sqlcommand1 = new SqlCommand("SpSaveNEwMailAttachmentDetails", con);
                    sqlcommand1.Parameters.AddWithValue("@RSPID", 0);
                    sqlcommand1.Parameters.AddWithValue("@NewMailResponseID", a);
                    sqlcommand1.Parameters.AddWithValue("@ActualAttachmentName", attachments.Split('|')[i].Split('@')[0].ToString());
                    sqlcommand1.Parameters.AddWithValue("@Extension", attachments.Split('|')[i].Split('@')[2]);
                    sqlcommand1.Parameters.AddWithValue("@ConvertedAttachmentName", attachments.Split('|')[i].Split('@')[1].ToString());
                    sqlcommand1.Parameters.AddWithValue("@flgMailRefStatusId", 6);

                    sqlcommand1.CommandType = CommandType.StoredProcedure;
                    sqlcommand1.CommandTimeout = 0;
                    sqlcommand1.ExecuteNonQuery();
                }
            }
            strRsp = "OK^1";
            sqlcommand1.Dispose();
            con.Close();
        }
        catch(Exception ex)
        {
            if (con.State == ConnectionState.Open)
                con.Close();

            strRsp =ex.Message +"^2";
        }
        return strRsp;
    }
}