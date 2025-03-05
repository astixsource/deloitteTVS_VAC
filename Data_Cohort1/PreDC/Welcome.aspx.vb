Imports System.Data
Imports System.Data.SqlClient
Partial Class Data_Information_Welcome
    Inherits System.Web.UI.Page
    Dim intLoginID As Integer = 0
    Dim AssessmentType As Integer
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../Login.aspx")
            Return
        End If
        intLoginID = IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))

    End Sub
    Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click


        Response.Redirect("frmSlotBooking.aspx")

    End Sub

End Class
