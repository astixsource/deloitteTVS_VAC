Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports Newtonsoft.Json
Imports System.Net
Imports System.Net.Mail
Imports System.Net.Mime
Imports System.Security.Cryptography.X509Certificates
Partial Class Admin_MasterForms_frmSendCredentialsToParticipant
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            fnfillCycleDropDown()
            '    Dim strReturnTable As String = fnDisplayLevelandCycleAgCompany()
            '   dvMain.InnerHtml = strReturnTable.Split("@")(1)
        End If
    End Sub
    Private Sub fnfillCycleDropDown()
        Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim Scmd As SqlCommand = New SqlCommand()
        Scmd.Connection = Scon
        Scmd.CommandText = "spGetAssessmentCycleDetail"
        Scmd.Parameters.AddWithValue("@CycleID", 0)
		
        Scmd.CommandType = CommandType.StoredProcedure
        Scmd.CommandTimeout = 0
        Dim Sdap As SqlDataAdapter = New SqlDataAdapter(Scmd)
        Dim dt As DataTable = New DataTable()
        Sdap.Fill(dt)
        Dim itm As ListItem = New ListItem()
        itm.Text = "- Batch Name -"
        itm.Value = "0"
        ddlCycleName.Items.Add(itm)

        For Each dr As DataRow In dt.Rows
            itm = New ListItem()
            itm.Text = dr("CycleName").ToString() & " (" + Convert.ToDateTime(dr("CycleStartDate")).ToString("dd MMM yy") & ")"
            itm.Value = dr("CycleId").ToString()
            ddlCycleName.Items.Add(itm)
        Next
    End Sub

    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetParticpantAgCycle(ByVal CycleID As Integer) As String
        Dim strTable As New StringBuilder
        Dim strReturnVal As String = 1
        Dim srlNmCntr As Int16 = 1

        Dim objCon As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom As New SqlCommand("[spGetParticipantCredentialsForMail]", objCon)
        objCom.Parameters.Add("@CycleID", SqlDbType.Int).Value = CycleID


        objCom.CommandTimeout = 0
        objCom.CommandType = CommandType.StoredProcedure

        Dim dr As SqlDataReader
        objCon.Open()
        dr = objCom.ExecuteReader()

        If dr.HasRows Then
            strTable.Append("<div id='dvtblbody'><table class='table table-bordered table-sm text-center' id='tblEmp'>")
            strTable.Append("<thead><tr>")
            strTable.Append("<th style='width:8%'>")
            strTable.Append("S. No.")
            strTable.Append("</th>")
            strTable.Append("<th>")
            strTable.Append("Participant Name")
            strTable.Append("</th>")
            strTable.Append("<th>")
            strTable.Append("Participant Code")
            strTable.Append("</th>")

            strTable.Append("<th>")
            strTable.Append("Participant EmailID")
            strTable.Append("</th>")

            strTable.Append("<th>")
            strTable.Append("Secondary EmailID")
            strTable.Append("</th>")

            strTable.Append("<th style='width:10%'>")
            strTable.Append("Action")
            strTable.Append("</th>")
            strTable.Append("</tr></thead>")
            strTable.Append("<tbody>")

            While dr.Read

                strTable.Append("<tr flgactive = 1>")
                strTable.Append("<td>")
                    strTable.Append(srlNmCntr)
                    strTable.Append("</td>")

                    strTable.Append("<td>")
                    strTable.Append(dr.Item("ParticipantName"))
                    strTable.Append("</td>")

                    strTable.Append("<td>")
                    strTable.Append(dr.Item("Empcode"))
                    strTable.Append("</td>")

                    strTable.Append("<td>")
                strTable.Append(dr.Item("EmailId"))
                strTable.Append("</td>")

                strTable.Append("<td>")
                strTable.Append(dr.Item("SecondaryEmailID"))
                strTable.Append("</td>")


                strTable.Append("<td>")

                strTable.Append("<input type=checkbox  ParticipantID = '" & dr.Item("EmpNodeID") & "' ParticipantEmailID = '" & dr.Item("EmailId") & "'  UserName='" & dr.Item("UserName") & "' Password='" & dr.Item("Password") & "'  SecondaryEmailID = '" & dr.Item("SecondaryEmailID") & "'>")

                strTable.Append("</td>")
                strTable.Append("</tr>")
                    srlNmCntr = srlNmCntr + 1

            End While
            strTable.Append("</tbody>")
            strTable.Append("</table></div>")

        Else
            strTable.Append("<div class='text-danger text-center'>")
            strTable.Append("No Record Found...")
            strTable.Append("</div>")
        End If

        '    strReturnVal = "1@" & HttpContext.Current.Server.HtmlDecode(strTable.ToString)
        strReturnVal = "1~" & strTable.ToString
        Return strReturnVal
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnSendMailToParticipantAgCycle(ByVal CycleID As Integer, ByVal objDetails As Object) As String
        Dim strReturn As String = ""

        Dim tblParticipant As New DataTable()
        tblParticipant.TableName = "tblParticipant"
        Dim settings As New JsonSerializerSettings()
        settings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore
        Dim strTable As String = JsonConvert.SerializeObject(objDetails, settings.ReferenceLoopHandling)
        tblParticipant = JsonConvert.DeserializeObject(Of DataTable)(strTable)
        Dim ParticipantNodeID As Integer
        Dim EmailID As String
        Dim UserName As String
        Dim Pwd As String
        Dim SecondaryEmailID As String

        For Each rows In tblParticipant.Rows
            ParticipantNodeID = rows("ParticipantID").ToString
            EmailID = rows("ParticipantEmailID").ToString
            UserName = rows("UserName").ToString
            Pwd = rows("Password").ToString
            SecondaryEmailID = rows("SecondaryEmailID").ToString
            strReturn = fnSendMailToParticipant(CycleID, ParticipantNodeID, EmailID, UserName, Pwd, SecondaryEmailID)
        Next

        Return strReturn
    End Function
    <System.Web.Services.WebMethod()>
    Public Shared Function fnSendMailToParticipant(ByVal CycleID As Integer, ByVal ParticipantNodeID As Integer, ByVal MailTo As String, ByVal UserName As String, ByVal Pwd As String, ByVal SecondaryEmailID As String) As String
        Dim strcon As String
        Dim con As SqlConnection
        Dim cmd As SqlCommand
        Dim strReturn As String = ""
        Dim flgActualUser As Integer = System.Configuration.ConfigurationManager.AppSettings("flgActualUser")
        Dim fromMail As String = System.Configuration.ConfigurationManager.AppSettings("MailUser")
        If flgActualUser = 2 Then
            MailTo = System.Configuration.ConfigurationManager.AppSettings("MailTo")
        End If

        Dim smtpMail As SmtpClient
        Dim objMail As MailMessage
        Dim strMail As String = ""
        strMail = "<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>"
        strMail &= "<p>Dear Participant,</p>"
        strMail &= "<p>Please click on the following link to access the portal:</p>"
        strMail &= "<p><b>Link : </b><a href=https://www.ey-virtualsolutions.com/LT_DevelopmentCentre/DC1//> https://www.ey-virtualsolutions.com/LT_DevelopmentCentre/DC1/ </a></p>"
        strMail &= "<p><b>User Name :</b> " & UserName & "</p>"
        strMail &= "<p><b>Password :</b> " & Pwd & "</p>"
        strMail &= "<p>Please note, if due to any network faliure, you are logged out of the portal- you can use the same credentials to login again. Your progress will be saved.</p>"
        strMail &= "<p>We wish you all the best!</p>"

        strMail &= "<p><i>Note: This is a system generated email. Do not reply directly to this email.<i/></p>"
        strMail &= "</FONT>"

        '//////////////End Of EY Welcome Mail/////////////////////////////////////////

        objMail = New MailMessage

        objMail.From = New MailAddress("LTAssessment<" & fromMail & ">")

        objMail.Subject = "Invitation Mail For Assessment"

        objMail.Headers.Add("X-MC-Track", "noopens,noclicks")
        objMail.IsBodyHtml = True
        objMail.Body = strMail.ToString
        smtpMail = New SmtpClient()
        smtpMail.Host = System.Configuration.ConfigurationManager.AppSettings("MailServer")
        smtpMail.Port = 587
        Dim loginInfo As NetworkCredential
        loginInfo = New NetworkCredential()
        loginInfo.UserName = System.Configuration.ConfigurationManager.AppSettings("MailUser")
        loginInfo.Password = System.Configuration.ConfigurationManager.AppSettings("MailPassword")
        smtpMail.UseDefaultCredentials = False
        smtpMail.Credentials = loginInfo
        smtpMail.EnableSsl = True
        ' ServicePointManager.ServerCertificateValidationCallback = Function(s As Object, certificate As X509Certificate, chain As X509Chain, sslPolicyErrors As SslPolicyErrors) True

        objMail.To.Add(MailTo)
        objMail.CC.Add(SecondaryEmailID)

        Try

            smtpMail.Send(objMail)

            strcon = ConfigurationManager.ConnectionStrings("strConn").ToString()
            con = New SqlConnection(strcon)
            cmd = New SqlCommand()

            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.CommandText = "spMailUpdateLog"
            cmd.Parameters.AddWithValue("@CycleId", CycleID)
            cmd.Parameters.AddWithValue("@EmpNodeID", ParticipantNodeID)
            cmd.Parameters.AddWithValue("@MailType", 1)
            cmd.Connection = con
            con.Open()
            cmd.ExecuteNonQuery()
            strReturn = "1~"

        Catch ex As Exception
            strcon = ConfigurationManager.ConnectionStrings("strConn").ToString()
            con = New SqlConnection(strcon)
            cmd = New SqlCommand()

            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.CommandText = "spMailExceptionLog"
            cmd.Parameters.AddWithValue("@CycleId", CycleID)
            cmd.Parameters.AddWithValue("@EmpNodeID", ParticipantNodeID)
            cmd.Parameters.AddWithValue("@Error", ex.Message)
            cmd.Connection = con
            con.Open()
            cmd.ExecuteNonQuery()
            strReturn = "2~"
        Finally
            cmd.Dispose()
            con.Close()
        End Try
        Return strReturn
    End Function
End Class
