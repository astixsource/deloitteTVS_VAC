
Partial Class frmThanks
    Inherits System.Web.UI.Page

    Protected Sub btnCLose_Click(sender As Object, e As EventArgs)
        Response.Redirect("../../login.aspx")
    End Sub
End Class
