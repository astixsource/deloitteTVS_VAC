
Imports System.Data
Imports System.Data.SqlClient

Partial Class CaseStudyTechInstructions2
    Inherits System.Web.UI.Page

    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Public ExerciseID As Integer
    Public ExerciseType As Integer
    Public TimeAlloted As Integer
    Public RspID As Integer
    Public LoginID As Integer
    Public BandID As Integer
    Dim arrPara(0, 1) As String
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If

        ExerciseID = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        ExerciseType = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        TimeAlloted = IIf(IsNothing(Request.QueryString("TotalTime")), 0, Request.QueryString("TotalTime"))
        RspID = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))

        BandID = 2 ' IIf(IsNothing(Request.QueryString("BandID")), 0, Request.QueryString("BandID"))
        hdnRspID.Value = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        hdnLoginID.Value = Convert.ToString(Session("LoginId"))
        ' hdnPageNmbr.Value = IIf(IsNothing(Request.QueryString("PGNmbr")), 0, Request.QueryString("PGNmbr"))

        If Not IsPostBack = True Then
            hdnIsProctoringEnabled.Value = IIf(IsNothing(Session("IsProctoringEnabled")), 0, Session("IsProctoringEnabled"))
            hdnLoginID.Value = Convert.ToString(Session("LoginId"))
        End If




    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function fnStartMeetingTimer(ByVal RSPExerciseID As Integer, ByVal MeetingDefaultTIME As Integer) As String
        Dim strReturn As String = 1

        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spAssesmentCheckDiscussionStarted]", Objcon2)
        objCom2.Parameters.Add("@RspExerciseID", SqlDbType.Int).Value = RSPExerciseID
        objCom2.Parameters.Add("MeetingDefaultTIME", SqlDbType.Int).Value = MeetingDefaultTIME
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Dim da As New SqlDataAdapter(objCom2)
        Dim dt As New DataTable
        Try
            da.Fill(dt)
            strReturn = "0|" & dt.Rows(0)("flgReturnVal") & "|" & dt.Rows(0)("RemainingTimeMeeting") & "|" & dt.Rows(0)("flgMeetingStatusP") & "|" & dt.Rows(0)("flgMeetingStatusA") & "|" & dt.Rows(0)("PrepRemainingTime")
        Catch ex As Exception
            strReturn = "1|" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function


    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("../Exercise/ExerciseMain.aspx")
    End Sub

    Protected Sub btnNext_Click(sender As Object, e As EventArgs)
        Dim ExcersiseID As Integer = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        Dim RspID As Integer = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        Dim intLoginID As Integer = IIf(IsNothing(Session("LoginId")), "0", Convert.ToString(Session("LoginId")))
        Dim BandID As String = IIf(IsNothing(Session("BandID")), "0", Convert.ToString(Session("BandID")))
        Response.Redirect("CaseStudyInstructions_Technical2.aspx?ExerciseID=" & ExcersiseID & "&RspID=" & RspID & "&BandID=" & BandID & "&intLoginID=" & intLoginID)
    End Sub
End Class
