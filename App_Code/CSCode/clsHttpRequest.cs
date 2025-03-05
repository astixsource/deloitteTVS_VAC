using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Web;
using LogMeIn.GoToCoreLib.Api;

public class clsHttpRequest
    {
       
        public static string GetTokenNo(string UserName,string Password)
        {
		string userName = UserName;
        string userPassword = Password;
        string consumerKey = "Wjo9NZAk0atNqHkTYpynH0eqVAY7iOm3";
        string consumerSecret = "UXLhuciAU4iIyYeA";
        var authApi = new OAuth2Api(consumerKey, consumerSecret);
        var tokenResponse = authApi.DirectLogin(userName, userPassword);
        return tokenResponse.access_token;
        }
       
    }
