Imports System.Data
Imports System.Data.SqlClient
Partial Class Data_Information_Welcome
    Inherits System.Web.UI.Page
    Dim intLoginID As Integer = 0
    Dim AssessmentType As Integer
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If
        intLoginID = IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))
        Dim LinkReturn = fnGetParticipantOrientationLink()
        hdnLink.Value = LinkReturn.Split("|")(0)
        hdnOTime.Value = LinkReturn.Split("|")(1)
    End Sub

    Function fnGetParticipantOrientationLink() As String
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spGetCycleOrientationTimeForAssessee]", Objcon2)
        objCom2.Parameters.Add("@LoginId", SqlDbType.Int).Value = Session("LoginId")
        Dim strReturn As String = ""
        Dim dr As SqlDataReader
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            dr = objCom2.ExecuteReader
            dr.Read()
            strReturn = dr.Item("Orient_AssesseeMeetLink") & "|" & dr.Item("EndTime")
        Catch ex As Exception
            strReturn = ex.Message
        End Try

        objCom2.Dispose()
        Objcon2.Close()
        Objcon2.Dispose()
        Return strReturn
    End Function


    <System.Web.Services.WebMethod(True)>
    Public Shared Function fnEnableAutomatically(ByVal StartTime As String) As String
        Dim dt1 As DateTime = Convert.ToDateTime(StartTime)
        Dim dt2 As DateTime = DateTime.Now
        Dim ts As TimeSpan = dt1.Subtract(dt2)
        Return IIf(ts.Ticks < 0, 0, ts.Ticks)
    End Function
    Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click


        Response.Redirect("Instructions.aspx?intLoginID=" & intLoginID)

    End Sub

End Class
