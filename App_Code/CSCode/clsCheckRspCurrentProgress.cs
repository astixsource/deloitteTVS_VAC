using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for clsCheckRspCurrentProgress
/// </summary>
public static class clsCheckRspCurrentProgress
{
    static clsCheckRspCurrentProgress()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string GetStartedAssesments(DataTable dt)
    {
        string result = "<ol>";
        foreach (DataRow dr in dt.Rows)
        {
            result += "<li>" + dr["Name"].ToString() + "</li>";
            //result += (result != "" ? dr["Name"].ToString() : dr["Name"].ToString() + ", ");
        }

        return " Following assesments are already ongoing: </br> " + result + "</ol>" + " Please continue ongoing assesments.";
    }

    public static string GetStartedAssesments(SqlDataReader dr)
    {
        string result = "<ol>";
        while (dr.Read())
        {
            result += "<li>" + dr["Name"].ToString() + "</li>";
            //result += (result != "" ? dr["Name"].ToString() : dr["Name"].ToString() + ", ");
        }

        return " Following assesments are already ongoing: </br> " + result + "</ol>" + " Please continue ongoing assesments.";
    }

}