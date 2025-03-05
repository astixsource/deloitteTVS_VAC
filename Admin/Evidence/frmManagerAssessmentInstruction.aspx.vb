
Partial Class Admin_Evidence_frmManagerAssessmentInstruction
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If

        If (Request.QueryString("str") Is Nothing) Then
            Response.Redirect("frmParticipantListForRating.aspx")
            Return
        End If

    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        Response.Redirect("frmManagerAssessmentRating.aspx?str=" & Convert.ToString(Request.QueryString("str")))
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("frmParticipantListForRating.aspx")
    End Sub
End Class
