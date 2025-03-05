
Partial Class frmThanks
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim panelLogout As Panel
        panelLogout = DirectCast(Page.Master.FindControl("panelLogout"), Panel)
        panelLogout.Visible = False

        Dim ReferalUrl As String
        ReferalUrl = Convert.ToString(Request.UrlReferrer)
        If (Session("LoginId") Is Nothing Or ReferalUrl = "") Then
            Response.Redirect("Login.aspx")
            Return
        End If

        Session.Abandon()
        Session.Clear()
    End Sub

End Class
