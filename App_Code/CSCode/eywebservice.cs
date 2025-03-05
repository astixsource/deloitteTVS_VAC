using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;
using System.Text;

/// <summary>
/// Summary description for dmswebservice
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class eywebservice : System.Web.Services.WebService
{

    public eywebservice()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    public string fnChangePassword(string UserName, string OldPassword, string NewPassword)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand cmd = null;
        cmd = new SqlCommand("SpChangePassword", con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 0;
        cmd.Parameters.AddWithValue("@LoginID", Session["LoginID"].ToString());
        cmd.Parameters.AddWithValue("@UserName", UserName);
        cmd.Parameters.AddWithValue("@OldPassword", HttpUtility.HtmlEncode(OldPassword));
        cmd.Parameters.AddWithValue("@NewPassword", HttpUtility.HtmlEncode(NewPassword));
        string intRep = "";
        try
        {
            con.Open();
            string intRep1 = "0";
            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                intRep1 = dt.Rows[0]["flgPasswordUpdated"].ToString() + "-" + dt.Rows[0]["flgPrevUsedPass"].ToString();
            }
            intRep = "1^" + intRep1.ToString();
        }
        catch (Exception ex)
        {
            intRep = "2^" + ex.Message;
        }
        finally
        {
            cmd.Dispose();
            con.Close();
            con.Dispose();
        }


        return intRep;
    }

    [WebMethod(EnableSession = true)]
    public string fnResetPassword(string UserId, string NewPassword)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand cmd = null;
        cmd = new SqlCommand("spReSetPassword", con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 0;
        cmd.Parameters.AddWithValue("@UserId", UserId);
        cmd.Parameters.AddWithValue("@NewPassword", HttpUtility.HtmlEncode(NewPassword));
        string intRep = "";
        try
        {
            con.Open();
            string intRep1 = "0";
            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                intRep1 = dt.Rows[0]["flgPasswordUpdated"].ToString() + "-" + dt.Rows[0]["flgPrevUsedPass"].ToString();
            }
            intRep = "1^" + intRep1.ToString();
        }
        catch (Exception ex)
        {
            intRep = "2^" + ex.Message;
        }
        finally
        {
            cmd.Dispose();
            con.Close();
            con.Dispose();
        }


        return intRep;
    }

    [WebMethod(EnableSession = true)]
    public string fnGetUserdetailForResetLink(string UserName)
    {
        string result = "";

        using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]))
        {
            using (SqlCommand cmd = new SqlCommand("spGetUserDetailsBasedOnUserName", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 0;
                cmd.Parameters.AddWithValue("@UserName", UserName);
                try
                {
                    DataSet ds = new DataSet();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }

                    if (ds.Tables[0].Rows[0][0].ToString() == "1")
                    {

                        string Password = ds.Tables[1].Rows[0]["Password"].ToString();
                        // string emailId = ConfigurationManager.AppSettings["MailTo"];
                        string MailSubject = ConfigurationManager.AppSettings["MailSubject"];
                        string mailflg = ConfigurationManager.AppSettings["mailflg"];
                        string emailId = "";
                        if (mailflg == "0")
                        {
                             emailId = ConfigurationManager.AppSettings["Test_MailTo"];
                        }
                        else
                        {
                             emailId = ds.Tables[1].Rows[0]["EmailId"].ToString();
                        }
                        //emailId = "harit@astixsolutions.com";

                        if (ds.Tables[1].Rows[0]["IsBlocked"].ToString() == "1")
                        {
                            result = "4^Your account is locked. Please contact support to unlock it.";
                        }
                        else if (string.IsNullOrWhiteSpace(emailId))
                        {
                            result = "5^Email id does not exist for your account. Please contact support.";
                        }
                        else
                        {
                            string resetLink = ConfigurationManager.AppSettings["PhysicalPath"] + "/frmForgotPassword.aspx?u=" + Base64Encode(ds.Tables[1].Rows[0]["UserId"].ToString() + ";" + UserName + ";" + ds.Tables[1].Rows[0]["Password"].ToString()) + "&t=" + Base64Encode(DateTime.Now.ToString("ddMMyyyHHmmss"));
                            // string mailResponse = clsMail.fnSendmail(emailId, "", "ODPDG E360 - Password Reset Link", "Please click <a href=" + resetLink + ">here</a> to reset your password.", "");
                            string mailResponse = clsMail.fnSendmail_ForgetPassword(emailId, "", MailSubject, UserName, Password, "Please click <a href=" + resetLink + ">here</a> to reset your password.", "");
                            if (mailResponse.Split('^')[1] == "1")
                            {
                                result = "1^Reset Password Details on mail sent successfully.";

                            }
                            else
                            {
                                result = "6^Email sending failed. Please try again. Message: " + mailResponse.Split('^')[0];
                            }
                        }
                    }
                    else
                    {
                        result = "3^Username does not exist.";
                    }
                }
                catch (Exception ex)
                {
                    result = "2^Some technical error: " + ex.Message;
                }
            }
        }

        return result;
    }

    private static string Base64Encode(string plainText)
    {
        var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
        return HttpUtility.UrlEncode(System.Convert.ToBase64String(plainTextBytes));
    }

}
