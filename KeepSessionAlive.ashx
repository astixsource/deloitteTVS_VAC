<%@ WebHandler Language="C#" Class="KeepSessionAlive" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Data;
using System.Data.SqlClient;

public class KeepSessionAlive : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        context.Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
        context.Response.Cache.SetNoStore();
        context.Response.Cache.SetNoServerCaching();
        string NodeId = context.Session["EmpNodeID"] == null ? "0" : context.Session["EmpNodeID"].ToString();
        if (NodeId != "0")
        {
            string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
            SqlConnection con = new SqlConnection(strConn);
            SqlCommand cmd = new SqlCommand("spUpdateCurrentUserLoggingTime", con);
            cmd.Parameters.AddWithValue("@NodeId", Convert.ToInt32(NodeId));
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 0;
            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) {
                    
                }
            finally
            {
                cmd.Dispose();
                con.Close();
                con.Dispose();

            }
        }

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}