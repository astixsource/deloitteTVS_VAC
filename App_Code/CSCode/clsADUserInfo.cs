using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading.Tasks;
using System.Configuration;
using System.Security.Claims;
using RestSharp;
using System.Web.Script.Serialization;
using System.Net;
using System.Text;
using System.IO;
using Newtonsoft.Json.Linq;

/// <summary>
/// Summary description for clsADUserInfo
/// </summary>
public class clsADUserInfo
{

    private string clientId = ConfigurationSettings.AppSettings["ida:ClientId"];
    private string appKey = Convert.ToString(HttpContext.Current.Application["SSO_clientSecret"]);
    private string TenantId = ConfigurationSettings.AppSettings["ida:TenantId"];
    private string aadInstance = EnsureTrailingSlash(ConfigurationSettings.AppSettings["ida:AADInstance"]);
    private string graphResourceID = "https://graph.microsoft.com";//"https://graph.windows.net";

    public clsADUserInfo()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public string fnCreateTeamMeeting(string ExerciseName, string accessToken, string StartDate, string EndDate)
    {
        string strResp = "";
        try
        {
            DateTimeOffset StartDateTime = Convert.ToDateTime(StartDate);
            DateTimeOffset EndDateTime = Convert.ToDateTime(EndDate);
            // string postData = "{\"autoAdmittedUsers\":\"everyone\",\"allowedPresenters\":\"everyone\",\"startDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"endDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"subject\":\"" + ExerciseName + "\",\"participants\":{\"organizer\": {\"identity\":{\"user\":{\"id\":\"" + OrganizerId + "\"}}}}}";
            string postData = "{\"startDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"endDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"subject\":\"" + ExerciseName + "\"}";
            string baseUrl = "https://graph.microsoft.com/v1.0/me/onlineMeetings";
            var client = new RestClient(baseUrl);
            client.Timeout = -1;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Authorization", "Bearer " + accessToken);
            var serializer = new JavaScriptSerializer();
            // var body = serializer.Serialize(postData);
            request.AddParameter("application/json", postData, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);
            serializer.MaxJsonLength = Int32.MaxValue;
            var data = serializer.Deserialize<dynamic>(response.Content);
            string MeetingId = data["id"];
            //string str = fnUpdateTeamMeeting(accessToken, MeetingId);

            strResp = "1|" + MeetingId + "|" + data["joinWebUrl"];

        }
        catch (Exception ex)
        {
            strResp = "2|Error:" + ex.Message;
        }
        return strResp;
    }

    public string fnUpdateTeamMeeting(string accessToken, string MeetingId)
    {
        string strResp = "";
        try
        {
            string postData = "{\"recordAutomatically\": \"true\",\"lobbyBypassSettings\": {\"scope\":\"everyone\"}}";
            string baseUrl = "https://graph.microsoft.com/v1.0/me/onlineMeetings/" + MeetingId;
            var client = new RestClient(baseUrl);
            client.Timeout = -1;
            var request = new RestRequest(Method.PATCH);
            request.AddHeader("Authorization", "Bearer " + accessToken);
            var serializer = new JavaScriptSerializer();
            // var body = serializer.Serialize(postData);
            request.AddParameter("application/json", postData, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);
            serializer.MaxJsonLength = Int32.MaxValue;
            var data = serializer.Deserialize<dynamic>(response.Content);
            string JoinUrl = data["joinWebUrl"];
            strResp = "1|" + JoinUrl;
        }
        catch (Exception ex)
        {
            strResp = "2|Error:" + ex.Message;
        }
        return strResp;
    }

    
    
    public string fnGetTokenNoForUser(string userName, string password)
    {
        string strResp = "";
        try
        {

            var client = new RestClient("https://login.microsoftonline.com/b95e1a25-528c-4e2f-b119-a9ff18b251da/oauth2/v2.0/token");
            client.Timeout = -1;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Content-Type", "application/x-www-form-urlencoded");
            request.AddParameter("grant_type", "password");
            request.AddParameter("client_id", clientId);
            request.AddParameter("client_secret", appKey);
            request.AddParameter("scope", "https://graph.microsoft.com/.default");
            request.AddParameter("userName", userName);
            request.AddParameter("password", password);
            IRestResponse response = client.Execute(request);
            var JObject1 = JObject.Parse(response.Content);
            string token = JObject1["access_token"].ToString();
            strResp = "1|" + token;
        }
        catch (Exception ex)
        {
            strResp = "2|" + ex.Message;
        }
        return strResp;
    }

    public string fnCreateCalendar(string SToken,string sSubject,string sbody,string StartDate,string EndDate,string emailAddress,string EmpName,int isattendee)
    {
        string strResp = "";
        try
        {
            string optionalAttendeeEmail = "Deepa1.R@in.ey.com";
            string optionalAttendeeName ="Deepa R";
            DateTimeOffset StartDateTime = Convert.ToDateTime(StartDate);
            DateTimeOffset EndDateTime = Convert.ToDateTime(EndDate);
            //string SToken = await GetTokenForApplication();
            clsADUserInfo obj = new clsADUserInfo();
            // string postData = "{\"autoAdmittedUsers\":\"everyone\",\"allowedPresenters\":\"everyone\",\"startDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"endDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"subject\":\"" + ExerciseName + "\",\"participants\":{\"organizer\": {\"identity\":{\"user\":{\"id\":\"" + OrganizerId + "\"}}}}}";
            //string postData = "{\"startDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"endDateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00.00000+00:00") + "\",\"subject\":\"" + ExerciseName + "\"}";
            var body = "";
            if (isattendee == 1)
            {
                 body = "{\"subject\":\"" + sSubject + "\",\"body\":{\"contentType\":\"HTML\",\"content\":\"" + sbody + "\"},\"start\":{\"dateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00") + "\",\"timeZone\":\"India Standard Time\"},\"end\":{\"dateTime\":\"" + EndDateTime.ToString("yyyy-MM-ddTHH:mm:00") + "\",\"timeZone\":\"India Standard Time\"},\"location\":{\"displayName\":\"EY\"},\"attendees\":[{\"emailAddress\":{\"address\":\"" + emailAddress + "\",\"name\":\"" + EmpName + "\"},\"type\":\"required\"},{\"emailAddress\":{\"address\":\"" + optionalAttendeeEmail + "\",\"name\":\"" + optionalAttendeeName + "\"},\"type\":\"optional\"}],\"allowNewTimeProposals\":\"false\",\"isOnlineMeeting\":\"false\",\"onlineMeetingProvider\":\"teamsForBusiness\"}";
            }
            else
            {
                body = "{\"subject\":\"" + sSubject + "\",\"body\":{\"contentType\":\"HTML\",\"content\":\"" + sbody + "\"},\"start\":{\"dateTime\":\"" + StartDateTime.ToString("yyyy-MM-ddTHH:mm:00") + "\",\"timeZone\":\"India Standard Time\"},\"end\":{\"dateTime\":\"" + EndDateTime.ToString("yyyy-MM-ddTHH:mm:00") + "\",\"timeZone\":\"India Standard Time\"},\"location\":{\"displayName\":\"EY\"},\"allowNewTimeProposals\":\"false\",\"isOnlineMeeting\":\"false\",\"onlineMeetingProvider\":\"teamsForBusiness\"}";
            }
            //                           SecurityProtocolType.Tls11 |
            //                           SecurityProtocolType.Tls12;
            //var postData = new JavaScriptSerializer().Serialize(onlineMeeting);
            string baseUrl = "https://graph.microsoft.com/v1.0/me/calendar/events";
            var client = new RestClient(baseUrl);
            client.Timeout = -1;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Authorization", "Bearer " + SToken);
            request.AddParameter("application/json", body, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);
            var serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = Int32.MaxValue;
            var data = serializer.Deserialize<dynamic>(response.Content);
            strResp ="1|"+ data["id"];
        }
        catch (Exception ex)
        {
            strResp = "2|Error in API calling-:" + ex.Message;
        }
        return strResp;
    }

    public string fnDeleteCalendar(string SToken, string P_CalendarEventId)
    {
        string strResp = "";
        try
        {
            string baseUrl = "https://graph.microsoft.com/v1.0/me/calendar/events/"+ P_CalendarEventId;
            var client = new RestClient(baseUrl);
            client.Timeout = -1;
            var request = new RestRequest(Method.DELETE);
            request.AddHeader("Authorization", "Bearer " + SToken);
            IRestResponse response = client.Execute(request);
            strResp = "1|";
        }
        catch (Exception ex)
        {
            strResp = "2|Error in API calling-:" + ex.Message;
        }
        return strResp;
    }


    private static string EnsureTrailingSlash(string value)
    {
        if (value == null)
        {
            value = string.Empty;
        }

        if (!value.EndsWith("/", StringComparison.Ordinal))
        {
            return value + "/";
        }
        return value;
    }
}