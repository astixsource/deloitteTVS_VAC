Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports Newtonsoft.Json
Imports System.Net
Imports System.Net.Mail
Imports System.Net.Mime
Imports System.Security.Cryptography.X509Certificates
Partial Class Admin_MasterForms_frmSendReminderToAssessorForPenPictureFeedback
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
        Scmd.Parameters.AddWithValue("@Flag", 2)
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
            itm.Text = dr("CycleName").ToString()
            itm.Value = dr("CycleId").ToString()
            ddlCycleName.Items.Add(itm)
        Next
    End Sub

    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetAssessorDetailsAgCycle(ByVal CycleID As Integer) As String
        Dim strTable As New StringBuilder
        Dim strReturnVal As String = 1
        Dim srlNmCntr As Int16 = 1

        Dim objCon As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom As New SqlCommand("[spGetDataForReminderMail_PenPicture_Assessor]", objCon)
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
            strTable.Append("Developer Name")
            strTable.Append("</th>")

            strTable.Append("<th>")
            strTable.Append("Developer Emp Code")
            strTable.Append("</th>")

            strTable.Append("<th>")
            strTable.Append("Participant Feedback Status")
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
                strTable.Append(dr.Item("AssessorName"))
                strTable.Append("</td>")

                strTable.Append("<td>")
                strTable.Append(dr.Item("AssessorEmpCode"))
                strTable.Append("</td>")


                strTable.Append("<td style='cursor:pointer;COLOR: #000080;FONT-SIZE: 8;' onclick='fnParticipantlist(" & dr.Item("AssessorID") & ")'><i>View Status</i>")
                strTable.Append("</td>")

                strTable.Append("<td>")
                strTable.Append("<input type=checkbox  AssessorID = '" & dr.Item("AssessorID") & "' AssessorEmailID = '" & dr.Item("AssessorEmail") & "' AssessorSecondaryEmailID = '" & dr.Item("AssessorSecondaryEmail") & "' >")
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
    Public Shared Function fnSendMailToAssessorAgCycle(ByVal CycleID As Integer, ByVal objDetails As Object, ByVal CycleDate As String) As String
        Dim strReturn As String = ""

        Dim tblAssessor As New DataTable()
        tblAssessor.TableName = "tblAssessor"
        Dim settings As New JsonSerializerSettings()
        settings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore
        Dim strTable As String = JsonConvert.SerializeObject(objDetails, settings.ReferenceLoopHandling)
        tblAssessor = JsonConvert.DeserializeObject(Of DataTable)(strTable)
        Dim AssessorNodeID As Integer
        Dim EmailID As String
        Dim UserName As String
        Dim Pwd As String
        Dim AssessorSecondaryEmailID As String

        For Each rows In tblAssessor.Rows
            AssessorNodeID = rows("AssessorID").ToString
            EmailID = rows("AssessorEmailID").ToString
            AssessorSecondaryEmailID = rows("AssessorSecondaryEmailID").ToString
            strReturn = fnSendMailToAssessor(CycleID, AssessorNodeID, EmailID, AssessorSecondaryEmailID, CycleDate)
        Next

        Return strReturn
    End Function
    <System.Web.Services.WebMethod()>
    Public Shared Function fnSendMailToAssessor(ByVal CycleID As Integer, ByVal AssessorNodeID As Integer, ByVal MailTo As String, ByVal MailCC As String, ByVal CycleDate As String) As String
        Dim strcon As String
        Dim con As SqlConnection
        Dim cmd As SqlCommand
        Dim strReturn As String = ""
        Dim flgActualUser As Integer = System.Configuration.ConfigurationManager.AppSettings("flgActualUser")
        Dim fromMail As String = System.Configuration.ConfigurationManager.AppSettings("MailUser")
        If flgActualUser = 2 Then
            MailTo = System.Configuration.ConfigurationManager.AppSettings("MailTo")
        End If


        Dim objCon As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom As New SqlCommand("[spGetDataForReminderMail_PenPicture_Assessee]", objCon)
        objCom.Parameters.Add("@AssessorId", SqlDbType.Int).Value = AssessorNodeID
        objCom.Parameters.Add("@CycleID", SqlDbType.Int).Value = CycleID


        objCom.CommandTimeout = 0
        objCom.CommandType = CommandType.StoredProcedure

        Dim dr As SqlDataReader
        objCon.Open()
        Dim strMail As String = ""

        Dim FBStatus As String = ""
        Dim PPStatus As String = ""
        Dim FBColorCode As String = ""
        Dim PPColorCode As String = ""
        strMail = "<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>"
        strMail &= "<p>Dear Developer,</p>"
        strMail &= "<p>Please find below the status of <b><u>Feedback and Pen-Picture</u></b> of participants for DC-1 dated " & CycleDate & ".</p>"
        dr = objCom.ExecuteReader()
        strMail &= "<table width=50% border=1 style='COLOR: #000080;FONT-SIZE: 12px; FONT-FAMILY: Arial' cellspacing=0 cellpadding=3>"
        strMail &= "<tr>"
        strMail &= "<th style='text-align:center'>Participant Name"
        strMail &= "</th>"

        strMail &= "<th style='text-align:center'>Feedback Status"
        strMail &= "</th>"

        strMail &= "<th style='text-align:center'>Pen Picture Status"
        strMail &= "</th>"
        strMail &= "</tr>"

        While dr.Read
            strMail &= "<tr>"
            strMail &= "<td style='text-align:center'>" & dr.Item("ParticipantName")
            strMail &= "</td>"

            If dr.Item("FeedbackStatus") = 0 Then
                FBStatus = "Pending"
                FBColorCode = "ff2020"
            Else
                FBStatus = "Completed"
                FBColorCode = "006464"
            End If

            If dr.Item("PenPictureStatus") = 0 Then
                PPStatus = "Pending"
                PPColorCode = "ff2020"
            Else
                PPStatus = "Completed"
                PPColorCode = "006464"
            End If
            strMail &= "<td style='text-align:center;COLOR:#" & FBColorCode & "'>" & FBStatus
            strMail &= "</td>"

            strMail &= "<td style='text-align:center;COLOR:#" & PPColorCode & "'>" & PPStatus
            strMail &= "</td>"
            strMail &= "</tr>"
        End While
        strMail &= "</table>"

        strMail &= "<p>Please note, if you have already provided feedback, you are requested to update the status on the portal.</p>"
        strMail &= "<p>Once feedback status is reflected on the portal, you are also requested to submit the pen-picture</p>"

        strMail &= "<br><p>Thank You</p>"

        Dim smtpMail As SmtpClient
        Dim objMail As MailMessage


        strMail &= "<p><i>Note: This is a system generated email. Do not reply directly to this email.<i/></p>"
        strMail &= "</FONT>"


        objMail = New MailMessage

        objMail.From = New MailAddress("LTAssessment<" & fromMail & ">")

        objMail.Subject = "Gentle reminder for feedback and pen-picture"

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
        objMail.CC.Add(MailCC)

        Try

            smtpMail.Send(objMail)

            strcon = ConfigurationManager.ConnectionStrings("strConn").ToString()
            con = New SqlConnection(strcon)
            cmd = New SqlCommand()

            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.CommandText = "spMailUpdateLog"
            cmd.Parameters.AddWithValue("@CycleId", CycleID)
            cmd.Parameters.AddWithValue("@EmpNodeID", AssessorNodeID)
            cmd.Parameters.AddWithValue("@MailType", 2)
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
            cmd.Parameters.AddWithValue("@EmpNodeID", AssessorNodeID)
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

    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetParticipantListAgAsssessor(ByVal AssessorNodeID As Integer, ByVal CycleID As Integer) As String
        Dim objCon As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom As New SqlCommand("[spGetDataForReminderMail_PenPicture_Assessee]", objCon)
        objCom.Parameters.Add("@AssessorId", SqlDbType.Int).Value = AssessorNodeID
        objCom.Parameters.Add("@CycleID", SqlDbType.Int).Value = CycleID


        objCom.CommandTimeout = 0
        objCom.CommandType = CommandType.StoredProcedure

        Dim dr As SqlDataReader
        objCon.Open()
        Dim strMail As String = ""
        Dim strReturn As String = ""
        Dim FBStatus As String = ""
        Dim PPStatus As String = ""
        Dim PPColorCode As String = ""
        Dim FBColorCode As String = ""
        strMail = "<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>"

        dr = objCom.ExecuteReader()

        If dr.HasRows Then


            strMail &= "<table width=100% border=1 style='COLOR: #000080;FONT-SIZE: 12px; FONT-FAMILY: Arial' cellspacing=0 cellpadding=3>"
            strMail &= "<tr>"
            strMail &= "<th style='text-align:center' width='40%'>Participant Name"
            strMail &= "</th>"

            strMail &= "<th style='text-align:center' width='30%'>Feedback Status"
            strMail &= "</th>"

            strMail &= "<th style='text-align:center' width='30%'>Pen Picture Status"
            strMail &= "</th>"
            strMail &= "</tr>"

            While dr.Read
                strMail &= "<tr>"
                strMail &= "<td style='text-align:center'>" & dr.Item("ParticipantName")
                strMail &= "</td>"

                If dr.Item("FeedbackStatus") = 0 Then
                    FBStatus = "Pending"
                    FBColorCode = "ff2020"
                Else
                    FBStatus = "Completed"
                    FBColorCode = "006464"
                End If

                If dr.Item("PenPictureStatus") = 0 Then
                    PPStatus = "Pending"
                    PPColorCode = "ff2020"
                Else
                    PPStatus = "Completed"
                    PPColorCode = "006464"
                End If
                strMail &= "<td style='text-align:center;COLOR:#" & FBColorCode & "'>" & FBStatus
                strMail &= "</td>"

                strMail &= "<td style='text-align:center;COLOR:#" & PPColorCode & "'>" & PPStatus
                strMail &= "</td>"
                strMail &= "</tr>"
            End While
            strMail &= "</table>"
            strReturn = "1~" & strMail.ToString
        Else
            strMail &= "1~" & "No Record Found..."
        End If
        Return strReturn
    End Function
End Class
