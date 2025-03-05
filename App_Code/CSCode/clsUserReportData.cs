using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for clsUserReportData
/// </summary>
public class clsUserReportData
{
    public clsUserReportData()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public class clsRspMain
    {
        public string action { get; set; }
        public string timestamp { get; set; }
        public string delivery_id { get; set; }
        public string uid { get; set; }
    }
    public class clsUserReport
    {
        public string action { get; set; }
        public string timestamp { get; set; }
        public string delivery_id { get; set; }
        public string report_uri { get; set; }
        public string uid { get; set; }
        public string report_json { get; set; }
    }

    public class clsScorecard
    {
        public string UserID { get; set; }
        public string SubCompetency { get; set; }
        public string Competency { get; set; }
        public string SubCompetencyScore { get; set; }
        public string CompetencyScore { get; set; }
    }

    public static HttpWebResponse POST(string postData, string url)
    {
        try
        {
            ServicePointManager.Expect100Continue = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                   | SecurityProtocolType.Tls11
                   | SecurityProtocolType.Tls12
                   | SecurityProtocolType.Ssl3;
            byte[] byteArray = Encoding.UTF8.GetBytes(postData);
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/json";

            request.ContentLength = byteArray.Length;

            using (var stream = request.GetRequestStream())
            {
                stream.Write(byteArray, 0, byteArray.Length);
            }

            return (HttpWebResponse)request.GetResponse();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public static string fnSendRSPDetailToSM(clsRspMain objclsRspMain)
    {
        string strResp = "1|OK";//Success;
        string webhookURL = ConfigurationSettings.AppSettings["webhookURL"].ToString();
        try
        {
            HttpWebResponse response = POST(new JavaScriptSerializer().Serialize(objclsRspMain), webhookURL);
            if (response.StatusCode != HttpStatusCode.OK)
            {
                strResp = "2|" + response.StatusDescription;
                return strResp;
            }
            using (var streamReader = new StreamReader(response.GetResponseStream()))
            {
                var responseResult = streamReader.ReadToEnd();
                var data = new JavaScriptSerializer().Deserialize<dynamic>(responseResult);
                foreach (var d in data["results"])
                {
                    var errorMessage = d.Value;
                    strResp = "1|" + errorMessage;
                    if (errorMessage != "OK")
                    {
                        strResp = "2|" + errorMessage;
                    }
                }

            }
        }

        catch (Exception ex)
        {
            strResp = "2|" + ex.Message;
        }
        return strResp;
    }
    public static string fnSendUserReportToSM(clsUserReport objclsUserReport)
    {
        string strResp = "1^";//Success;
        string webhookURL = ConfigurationSettings.AppSettings["webhookURL"].ToString();
        try
        {
            HttpWebResponse response =POST(new JavaScriptSerializer().Serialize(objclsUserReport), webhookURL);
            if (response.StatusCode != HttpStatusCode.OK)
            {
                strResp = "2|" + response.StatusDescription;
                return strResp;
            }
            using (var streamReader = new StreamReader(response.GetResponseStream()))
            {
                try
                {
                    var responseResult = streamReader.ReadToEnd();
                    var data = new JavaScriptSerializer().Deserialize<dynamic>(responseResult);
                    var results = data["results"].ToString();
                    var errors = new JavaScriptSerializer().Deserialize<dynamic>(results);
                    var errorCode = data["results"].ToString();
                    var errorMessage = data["results"].ToString();
                    strResp = "1|" + errorMessage;
                    if (errorCode != "OK")
                    {
                        strResp = "1|" + errorMessage;
                    }
                }
                catch (Exception ex)
                {
                    strResp = "2|" + ex.Message;
                    return strResp;
                }
            }
        }

        catch (Exception ex)
        {
            strResp = "2|" + ex.Message;
        }
        return strResp;
    }

    public static string fnCreateReportNScorecard(DataTable dt, string UserEmailId, string Rptlink)
    {
        List<clsScorecard> lstScorecard = new List<clsScorecard>();
        foreach (DataRow drow in dt.Rows)
        {
            clsScorecard clsItem = new clsScorecard();
            clsItem.UserID = drow["UserID"].ToString(); ;
            clsItem.SubCompetency = drow["SubCompetency"].ToString();
            clsItem.Competency = drow["Competency"].ToString();
            clsItem.SubCompetencyScore = drow["SubCompetencyScore"].ToString();
            clsItem.CompetencyScore = drow["CompetencyScore"].ToString();
            lstScorecard.Add(clsItem);
        }
        clsUserReport clsReport = new clsUserReport();
        clsReport.action = "report";
        clsReport.timestamp = DateTime.Now.ToString();
        clsReport.delivery_id = Guid.NewGuid().ToString("N");
        clsReport.report_uri = Rptlink;
        clsReport.uid = UserEmailId;
        clsReport.report_json = new JavaScriptSerializer().Serialize(lstScorecard);
        string strResponse = clsUserReportData.fnSendUserReportToSM(clsReport);

        return strResponse;
    }
}