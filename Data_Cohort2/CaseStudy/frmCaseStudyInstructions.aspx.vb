
Partial Class frmCaseStudyInstructions
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim ReferalUrl As String
        ReferalUrl = Convert.ToString(Request.UrlReferrer)
        If (Session("LoginId") Is Nothing Or Session("BandID") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If
        'Dim panelLogout As Panel
        'panelLogout = DirectCast(Page.Master.FindControl("panelLogout"), Panel)
        'panelLogout.Visible = False

    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim ExcersiseID As Integer = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        Dim ExerciseType As Integer = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        Dim TimeAlloted As Integer = IIf(IsNothing(Request.QueryString("TotalTime")), 0, Request.QueryString("TotalTime"))
        Dim RspID As Integer = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        Dim intLoginID As Integer = IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))
        Dim ElapsedTimeMin As Integer = IIf(IsNothing(Request.QueryString("ElapsedTimeMin")), 0, Request.QueryString("ElapsedTimeMin"))
        Dim ElapsedTimeSec As Integer = IIf(IsNothing(Request.QueryString("ElapsedTimeSec")), 0, Request.QueryString("ElapsedTimeSec"))
        Dim BandID As String = IIf(IsNothing(Session("BandID")), "0", Convert.ToString(Session("BandID")))
        Response.Redirect("CaseStudy.aspx?ExerciseID=" & ExcersiseID & "&ElapsedTimeMin=" & ElapsedTimeMin & "&ElapsedTimeSec=" & ElapsedTimeSec & "&TotalTime=" & TimeAlloted & "&RspID=" & RspID & "&BandID=" & BandID & "&ExerciseType=3" & "&intLoginID=" & intLoginID)


    End Sub
End Class
