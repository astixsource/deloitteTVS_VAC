<%@ Application Language="C#" %>

<script RunAt="server">

    protected void Application_BeginRequest(Object sender, EventArgs e)
    {
        if (!Request.IsSecureConnection)
        {
            // Response.Redirect(Request.Url.AbsoluteUri.Replace("http:", "https:"));
        }
    }

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

        // Code that runs on application startup
        // Get the Key Vault URI from configuration
        if (Application["DbConnectionString"] == null)
        {
            string keyVaultUri = ConfigurationManager.AppSettings["_AzureKeyVaultUri"];
            string _server = ConfigurationManager.AppSettings["_server"];
            string _database =ConfigurationManager.AppSettings["_database"];
            string _tenantId = ConfigurationManager.AppSettings["_tenantId"];
            string _clientId = ConfigurationManager.AppSettings["_clientId"];
            string _token = "";
            string connectionString = "";
            Application["DbConnectionString"] = "";
            // Initialize the SecretClient
            // var secretClient = new Azure.Security.KeyVault.Secrets.SecretClient(new Uri(keyVaultUri), new Azure.Identity.DefaultAzureCredential());
            ////string _clientSecret = secretClient.GetSecret("DeloitteProdDBConnection").Value.Value;
            //// Application["_clientSecret"] = _clientSecret;

            // Retrieve the secrets
            string _dbUserName = "sqladmin";// secretClient.GetSecret("Secret-PRODDB-Username").Value.Value;
            string _dbPassword = "SAFF@31324FASD$";// secretClient.GetSecret("Secret-PRODDB-Password").Value.Value;
            // Construct the SQL connection string
            connectionString = "server=" + _server + ";database=" + _database + ";uid=" + _dbUserName + ";pwd=" + _dbPassword + ";connection timeout=0";



            // Acquire token using Azure.Identity
            //var credential = new Azure.Identity.ClientSecretCredential(_tenantId, _clientId, _clientSecret);
            //var token = credential.GetToken(new Azure.Core.TokenRequestContext(new[] { "https://database.windows.net/.default" }));
            //_token=token.Token;
            //// Connection string
            //connectionString = "Server="+_server+";Database="+_database+";Authentication=Active Directory AccessToken";


            // Store the connection string in a globally accessible location
            Application["DbConnectionString"] = connectionString;


            if (string.IsNullOrEmpty(connectionString))
            {
                throw new Exception("Connection string is not initialized.");
            }

        }
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }

</script>
