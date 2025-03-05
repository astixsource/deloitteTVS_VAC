using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Xml;
using System.IO;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Activities.Expressions;

public partial class Login : System.Web.UI.Page
{
    SqlConnection con = null;
    SqlCommand cmd = null;
    DataSet ds = null;
    SqlDataAdapter da = null;
    SqlDataReader drdr = null;
    string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
    int intlogin = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["LoginId"] = null;
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
            Response.Cache.SetNoStore();

            string csrfToken = Guid.NewGuid().ToString();
            Session["CsrfToken"] = csrfToken;

            HttpCookie antiForgeryCookie = new HttpCookie("__RequestVerificationToken", csrfToken)
            {
                HttpOnly = true,
                Secure = Request.IsSecureConnection
            };

            Response.Cookies.Add(antiForgeryCookie);

            btnSubmit.Attributes.Add("onclick", "javascript:return fnValidate()");
        }
        //btnReset.Attributes.Add("onclick", "javascript:return fnReset()");
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        string storedCsrfToken = Session["CsrfToken"] as string;
        string receivedCsrfToken = Request.Form["csrfToken"];
        string cookieCsrfToken = Request.Cookies["__RequestVerificationToken"].Value;
        if (string.IsNullOrEmpty(storedCsrfToken) ||
        string.IsNullOrEmpty(receivedCsrfToken) ||
        string.IsNullOrEmpty(cookieCsrfToken) ||
        receivedCsrfToken != storedCsrfToken ||
        cookieCsrfToken != storedCsrfToken)
        {
            lblloginmsg.Text = "Error : Invalid CSRF Token !!!";
            return;
        }
        string strTicket = "";
        int sameuser = 0;

        SqlConnection con = new SqlConnection(strConn);
        cmd = new SqlCommand("spSecUserLogin", con);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@UserName", txtUserName.Value.ToString().Trim());
        cmd.Parameters.AddWithValue("@UserPwd", txtPwd.Value.ToString().Trim());
        cmd.Parameters.AddWithValue("@SessionIdNw", Session.SessionID);
        cmd.Parameters.AddWithValue("@IPAddress", Request.ServerVariables["REMOTE_ADDR"]);
        cmd.Parameters.AddWithValue("@BrwsrVer", Request.Browser.Type);
        cmd.Parameters.AddWithValue("@ScrRsltn", hdnRes.Value);

        int flgForChk = 0;
        int flgConfirmation = 0;
        int PageNmbr = 0;
        int roleId = 0;

        int ElapsedTimeMin = 0;
        int ElapsedTimeSec = 0;
        int flgExcersiseStatus = 0;
        int ExerciseID = 0;
        int TotalTime = 0;
        int RspId = 0;
        int flgOpenStatus = 0;
        int FinalStatus = 0;
        int FeedbackStatus = 0;
        int FlashFeedbackStatus = 0;
        int flgUserType = 0;
        int PassChangeFirst = 0;
        bool varAuthenticate = false;
        string flgPageToOpen = "0";
        try
        {
            con.Open();
            drdr = cmd.ExecuteReader();


            if (drdr.HasRows)
            {
                dvAlertDialog.InnerHtml = "Please check if you are already logged-in at another tab/browser/device. In that case, please logout from your running session before you try to relogin.</br>In case you had lost internet connectivity, please wait for 2 minutes before you can relogin.";
                Page.ClientScript.RegisterStartupScript(Page.GetType(), "Dialog", "<script language='javascript'>ShowRunningAssesments();</script>");
                return;
            }
            drdr.NextResult();

            int UserNodeID = 0;
            if (drdr.HasRows)
            {
                while (drdr.Read())
                {

                    if (drdr["ActiveStatus"].ToString() == "False")
                    {
                        txtUserName.Value = "";
                        txtPwd.Value = "";
                        flgForChk = 0;
                        lblloginmsg.Text = "Your account is inactive. Please contact support to active it.";
                        return;
                    }
                    /*
                                        if (drdr["FinalStatus"].ToString() == "2")
                                        {
                                            txtUserName.Value = "";
                                            txtPwd.Value = "";
                                            lblloginmsg.Text = "You have already completed your exercises with these user credentials.";
                                            return;
                                        }*/
                    if (drdr["IsBlocked"].ToString() == "1")
                    {
                        txtUserName.Value = "";
                        txtPwd.Value = "";
                        flgForChk = 0;
                        lblloginmsg.Text = "Your account is locked. Please contact support or wait for 30 minutes to unlock it.";
                        return;
                    }
                    if (drdr["IsBrowserSwitching"].ToString() == "1")
                    {
                        txtUserName.Value = "";
                        txtPwd.Value = "";
                        flgForChk = 0;
                        lblloginmsg.Text = "Your account has been locked due to switching browsers during the assessment. Please contact support to regain access.";
                        return;
                    }

                    if (drdr["LoginResult"].ToString() == "1")
                    {
                        txtUserName.Value = "";
                        txtPwd.Value = "";
                        flgForChk = 0;
                        int attemptsLeft = 5 - Convert.ToInt32(drdr["NoOfInCorrectPasswordAttempts"]);
                        lblloginmsg.Text = "Invalid Username or Password.<br />After " + attemptsLeft.ToString() + " more unsuccessfull attempt" + (attemptsLeft > 1 ? "s" : "") + " your account will be locked.";
                        return;
                    }
                    else if (drdr["LoginResult"].ToString() == "2" || drdr["LoginResult"].ToString() == "3")
                    {

                        Session["LoginId"] = drdr["LoginId"].ToString();

                        string guid = Guid.NewGuid().ToString();
                        Session["AuthToken"] = guid;
                        // now create a new cookie with this guid value
                        //HttpCookie obj = new HttpCookie("AuthToken", guid);
                        // obj.Domain ="ey-virtualsolutions.com";
                        //Response.Cookies.Add(obj);
                        Response.Cookies.Add(new HttpCookie("AuthToken", guid));

                        Session["RoleId"] = drdr["RoleID"].ToString();
                        Session["CycleId"] = drdr["CycleId"].ToString();
                        roleId = Convert.ToInt32(drdr["RoleID"].ToString());
                        Session.Timeout = 120;
                        strTicket = drdr["LoginId"].ToString();
                        intlogin = Convert.ToInt32(drdr["LoginId"].ToString());

                        UserNodeID = Convert.ToInt32(drdr["UserNodeID"].ToString());
                        Session["EmpNodeID"] = UserNodeID;
                        Session["FinalLinkStatus"] = drdr["FinalLinkStatus"].ToString();
                        Session["UserLoginId"] = txtUserName.Value.ToString().Trim();

                        Session["EmpName"] = drdr["EmpName"].ToString();
                        Session["username"] = drdr["UserName"].ToString();
                        Session["EmpEmailId"] = drdr["EmailID"].ToString();
                        Session["ActiveStatus"] = drdr["ActiveStatus"].ToString();
                        Session["RspID"] = drdr["RspID"].ToString();
                        Session["BandID"] = drdr["BandID"].ToString();
                        PageNmbr = Convert.ToInt32(drdr["PgNmbr"].ToString());
                        Session["GradeId"] = drdr["GradeId"].ToString();
                        flgPageToOpen = Convert.ToString(drdr["flgPageToOpen"]);
                        flgConfirmation = Convert.ToInt32(drdr["flgConfirmation"].ToString());
                        Session["flgConfirmation"] = flgConfirmation;
                        Session["flgUserType"] = drdr["flgUserType"].ToString();
                        Session["IsProctoringEnabled"] = drdr["IsProctoringEnabled"].ToString();
                        Session["IsSelfieTaken"] = drdr["IsSelfieTaken"].ToString();

                        flgUserType = Convert.ToInt32(drdr["flgUserType"]);
                        FinalStatus = Convert.ToInt32(drdr["FinalStatus"].ToString());
                        //FeedbackStatus = Convert.ToInt32(drdr["FeedbackStatus"].ToString());
                        //FlashFeedbackStatus = Convert.ToInt32(drdr["FlashFeedbackStatus"].ToString());

                        PageNmbr = Convert.ToInt32(drdr["PgNmbr"].ToString());
                        PassChangeFirst = Convert.ToInt32(drdr["flgPasswordExpired"].ToString());
                        Session["flgPasswordExpired"] = drdr["flgPasswordExpired"].ToString();

                        RspId = Convert.ToInt32(drdr["RspID"].ToString());
                        flgOpenStatus = Convert.ToInt32(drdr["flgOpenStatus"].ToString());
                        flgForChk = 1;

                        varAuthenticate = true;
                    }
                }
            }
            drdr.NextResult();




            if (drdr.HasRows)
            {
                drdr.Read();
                ElapsedTimeMin = Convert.ToInt32(drdr["ElapsedTime(Min)"].ToString());
                ElapsedTimeSec = Convert.ToInt32(drdr["ElapsedTime(Sec)"].ToString());
                flgExcersiseStatus = Convert.ToInt32(drdr["flgExerciseStatus"].ToString());
                ExerciseID = Convert.ToInt32(drdr["ExerciseId"].ToString());
                RspId = Convert.ToInt32(drdr["RspID"].ToString());

            }

            if (intlogin == 0)
            {
                lblloginmsg.Text = "Invalid Username or Password !!!";
                txtUserName.Value = "";
                txtPwd.Value = "";
                return;
            }

            else
            {
                if (flgForChk == 1)
                {
                    if (drdr.HasRows)
                    {
                        drdr.Read();
                        ElapsedTimeMin = Convert.ToInt32(drdr["ElapsedTime(Min)"].ToString());
                        ElapsedTimeSec = Convert.ToInt32(drdr["ElapsedTime(Sec)"].ToString());
                        flgExcersiseStatus = Convert.ToInt32(drdr["flgExerciseStatus"].ToString());
                        ExerciseID = Convert.ToInt32(drdr["ExerciseId"].ToString());
                        RspId = Convert.ToInt32(drdr["RspID"].ToString());

                    }
                }
                if (varAuthenticate)
                {
                    if (PassChangeFirst == 0)
                    {
                        if (roleId == 1 || roleId == 6)
                        {
                            Response.Redirect("Admin/Setting/AdminMenu.aspx");
                        }
                        //else if (roleId == 3)
                        //{
                        //    Response.Redirect("Admin/Evidence/frmParticipantListForRating.aspx");
                        //}
                        else
                        {
                            string pFolderName = "";
                            //pFolderName = "Data";
                            if (Session["BandID"].ToString() == "1")
                            {
                                pFolderName = "Data_Cohort1";
                            }
                            else if (Session["BandID"].ToString() == "2")
                            {
                                pFolderName = "Data_Cohort2";
                            }
                            else if (Session["BandID"].ToString() == "3")
                            {
                                pFolderName = "Data_Cohort3";
                            }
                            flgPageToOpen = "2";
                            if (flgPageToOpen == "2" || flgPageToOpen == "3")
                            {
                                if (flgUserType == 1 || flgUserType == 3)
                                {
                                    if (PageNmbr == 0)
                                    {
                                        Response.Redirect(pFolderName + "/Information/Welcome.aspx?intLoginID=" + Session["LoginId"]);
                                    }
                                    else
                                    {
                                        Response.Redirect(pFolderName + "/Exercise/ExerciseMain.aspx?intLoginID=" + Session["LoginId"]);
                                    }
                                }
                                else
                                {
                                    Response.Redirect("Admin/Evidence/frmManagerAssessmentBackground.aspx");
                                }
                            }
                            else
                            {
                                Response.Redirect(pFolderName + "/PreDC/Welcome.aspx?intLoginID=" + Session["LoginId"]);
                                // Response.Redirect("PreDC/Welcome.aspx?intLoginID=" + Session["LoginId"]);
                            }

                        }
                    }
                    else
                    {
                        Response.Write("<script language=javascript>window.location.href='frmChangePassword.aspx';</script>");
                    }



                }

                else
                {
                    lblloginmsg.Text = "Invalid username or password!!!";
                    txtUserName.Value = "";
                    txtPwd.Value = "";

                }
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
        finally
        {
            con.Close();
            txtUserName.Value = "";
            txtPwd.Value = "";
        }
    }



}