using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using DocumentFormat.OpenXml.EMMA;

/// <summary>
/// Summary description for WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    public WebService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod]
    public string fnValidateUserInboxStatus(string RspExerciseID)
    {
        string strRep = "0";
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection objCon = new SqlConnection(strConn);
        SqlCommand objcom = new SqlCommand("spValidateUserInboxStatus", objCon);
        objcom.Parameters.AddWithValue("@RspExerciseID", RspExerciseID);
        objcom.CommandTimeout = 0;
        objcom.CommandType = CommandType.StoredProcedure;
        SqlDataReader dr;
        try {
            objCon.Open();
            dr = objcom.ExecuteReader();
            if (dr.HasRows)
            {
                dr.Read();
                strRep = dr[0].ToString();
            }
            dr.Close();
        }
        catch(Exception ex)
        {
            strRep = "0";
        }
        finally
        {
            objcom.Dispose();
            objCon.Close();
            objCon = null;
        }

        return strRep;
    }

    [WebMethod]
    public string fnDeleteCurrentlyInProgressRSP()
    {
        string strRep = "0";
        string RSPID = Session["RspId"] == null ? "0" : Session["RspId"].ToString();
        string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
        SqlConnection objCon = new SqlConnection(strConn);
        SqlCommand objcom = new SqlCommand("spDeleteCurrentlyInProgressRSP", objCon);
        objcom.Parameters.AddWithValue("@RSPID", RSPID);
        objcom.Parameters.AddWithValue("@ExerciseId", 0);
        objcom.CommandTimeout = 0;
        objcom.CommandType = CommandType.StoredProcedure;
        try
        {
            objCon.Open();
            objcom.ExecuteNonQuery();
            strRep = "1";
        }
        catch (Exception ex)
        {
            strRep = "0";
        }
        finally
        {
            objcom.Dispose();
            objCon.Close();
            objCon = null;
        }

        return strRep;
    }

    [WebMethod(EnableSession = true)]
    public string fnSaveAssessmentViolationByParticipants(string ViolationText, string ViolationAt, int? flg = 0)
    {
        string strRep = "0";
        string NodeId = HttpContext.Current.Session["EmpNodeID"] == null ? "0" : HttpContext.Current.Session["EmpNodeID"].ToString();
        using (SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"])))
        {
            using (SqlCommand command = new SqlCommand("spSaveAssessmentViolationByParticipants", Scon))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 0;
                command.Parameters.AddWithValue("@ViolationText", ViolationText);
                command.Parameters.AddWithValue("@ViolationAt", ViolationAt);
                command.Parameters.AddWithValue("@NodeId", NodeId);
                command.Parameters.AddWithValue("@flg", flg);
                Scon.Open();
                command.ExecuteNonQuery();
                Scon.Close();
            }
        }
        return strRep;
    }

}
