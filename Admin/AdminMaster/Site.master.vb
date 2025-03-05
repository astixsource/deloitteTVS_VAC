Imports System.Data.SqlClient

Partial Class Site
    Inherits System.Web.UI.MasterPage
    Dim arrPara(0, 0) As String
    Dim objCon As SqlConnection
    Dim objCom As SqlCommand
    Dim objComm As SqlCommand
    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Dim objDr As SqlDataReader
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)

        If Session("LoginId") Is Nothing Then
            Response.Redirect("~/Login.aspx")
        End If

    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs) Handles lnkLogout.Click
        Response.Redirect("~/Login.aspx")
    End Sub
    Protected Sub lnkHome_Click(sender As Object, e As EventArgs)
        If Convert.ToString(Session("RoleId")) = "3" Then
            Response.Redirect("~/Admin/Setting/frmDashboard.aspx")
        Else
            Response.Redirect("~/Admin/Setting/AdminMenu.aspx")
        End If
    End Sub
End Class

