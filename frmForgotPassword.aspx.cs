using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class frmForgotPassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        bool isValid = false;
        /*
        try
        {
            hdnErrorMessage.Value = "";
            if (!IsPostBack)
            {
                if (!string.IsNullOrWhiteSpace(Request.QueryString["u"]) && !string.IsNullOrWhiteSpace(Request.QueryString["t"]))
                {
                    string userPart = Request.QueryString["u"].ToString();
                    string timePart = Request.QueryString["t"].ToString();

                    DateTime linkGenTime = DateTime.MinValue;
                    if (DateTime.TryParseExact(Base64Decode(timePart), "ddMMyyyyHHmmss", null, System.Globalization.DateTimeStyles.None, out linkGenTime) && linkGenTime > DateTime.Now.AddHours(-12))
                    {
                        var userParts = Base64Decode(userPart).Split(';').ToList();
                        if (userParts.Count >= 3)
                        {
                            string userId = userParts[0];
                            string username = userParts[1];
                            userParts.RemoveAt(0);
                            userParts.RemoveAt(0);

                            string pass = String.Join(",", userParts.ToArray());

                            DataSet ds = new DataSet();
                            using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]))
                            {
                                using (SqlCommand cmd = new SqlCommand("spGetUserDetailsBasedOnUserName", con))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandTimeout = 0;
                                    cmd.Parameters.AddWithValue("@UserName", username);
                                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                                    {
                                        da.Fill(ds);
                                    }
                                }
                            }
                            if(ds.Tables[0].Rows[0][0].ToString() == "1" && ds.Tables[1].Rows[0]["Password"].ToString() != pass)
                            {
                                hdnErrorMessage.Value = "This link is already used. Please generate new reset link.";
                            }
                            if (ds.Tables[0].Rows[0][0].ToString() == "1" && ds.Tables[1].Rows[0]["UserId"].ToString() == userId && ds.Tables[1].Rows[0]["Password"].ToString() == pass)
                            {
                                hdnUserId.Value = userId;
                                txtUserName.Value = username;
                                isValid = true;
                                hdnErrorMessage.Value = "";
                                hdnOldValue.Value = ds.Tables[1].Rows[0]["Password"].ToString();
                            }
                        }
                    }
                    else
                    {
                        hdnErrorMessage.Value = "This link is expired. Please generate new reset link.";
                    }
                }
                else
                {
                    hdnErrorMessage.Value = "Required elements are missing. Please generate new reset link.";
                }

            }
        }
        catch(Exception ex)
        {
            hdnErrorMessage.Value = "Invalid reset link. Please generate new reset link.";
            isValid = false;
        }
        if (!isValid)
        {
            //Response.Redirect("frmLogin.aspx");
        }
        */
    }

    private static string Base64Decode(string base64EncodedData)
    {
        var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
        return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
    }

}