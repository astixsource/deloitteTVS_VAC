Partial Class Set1_Basket_frmBasket_Instructions
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If

    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim BasketExcersiseID As Integer = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        Dim ExerciseType As Integer = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        Dim TimeAlloted As Integer = IIf(IsNothing(Request.QueryString("TotalTime")), 0, Request.QueryString("TotalTime"))
        Dim RspID As Integer = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        Dim intLoginID As Integer = Session("LoginId") ' IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))
        'Dim ElapsedTimeMin As Integer = IIf(IsNothing(Request.QueryString("ElapsedTimeMin")), 0, Request.QueryString("ElapsedTimeMin"))
        'Dim ElapsedTimeSec As Integer = IIf(IsNothing(Request.QueryString("ElapsedTimeSec")), 0, Request.QueryString("ElapsedTimeSec"))

        ' Response.Redirect("MailFormat.aspx?ExerciseID=" & BasketExcersiseID & "&ElapsedTimeMin=" & ElapsedTimeMin & "&ElapsedTimeSec=" & ElapsedTimeSec & "&TotalTime=" & TimeAlloted & "&RspID=" & RspID & "&BandID=1" & "&ExerciseType=" & ExerciseType & "&intLoginID=" & intLoginID)
        Response.Redirect("MailFormat.aspx?ExerciseID=" & BasketExcersiseID & "&TotalTime=" & TimeAlloted & "&RspID=" & RspID & "&BandID=1" & "&ExerciseType=" & ExerciseType & "&intLoginID=" & intLoginID)
    End Sub
    'Protected Sub btnBack_Click(sender As Object, e As EventArgs) Handles btnBack.Click
    '    Dim intLoginID As Integer = IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))
    '    Response.Redirect("../Main/frmExerciseMain.aspx?intLoginID=" & intLoginID)
    'End Sub
End Class
