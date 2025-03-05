Imports System.Data.SqlClient
Imports System.Web.Security
Imports System.Web
Imports System.Data

Partial Class frmLogout
    Inherits System.Web.UI.Page
    Dim arrPara(0, 1) As String

    Dim objCon As SqlConnection
    Dim objCom As SqlCommand
    Dim objADO As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Public lngID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
Dim RSPID As String = IIf(IsNothing(Session("RspId")), "0", Convert.ToString(Session("RspId")))
        Dim strConn As String = Convert.ToString(HttpContext.Current.Application("DbConnectionString"))
        Dim objCon As New SqlConnection(strConn)
        Dim objcom As New SqlCommand("spDeleteCurrentlyInProgressRSP", objCon)
        objcom.Parameters.AddWithValue("@RSPID", RSPID)
        objcom.Parameters.AddWithValue("@ExerciseId", "0")
        objcom.CommandType = CommandType.StoredProcedure
        objcom.CommandTimeout = 0
        objCon.Open()
        objcom.ExecuteNonQuery()
        objCon.Close()
        objCon.Dispose()

        'ReDim arrPara(0, 1)
        'arrPara(0, 0) = Session("LoginId")
        'arrPara(0, 1) = 1
        'Try
        '    objCon = New SqlConnection
        '    objcom = New SqlCommand
        '    objADO.RunSP("SPKillInActiveSessions", arrPara, 1, objCon, objcom)
        'Catch
        'Finally
        '    objADO.CloseConnection(objCon, objcom)
        'End Try
        'FormsAuthentication.SignOut()

        Session.Abandon()
        Session.RemoveAll()
        Response.Redirect("~/Login.aspx")
        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "popup", "<script language='javascript'>FnLogOut();</script>")

    End Sub
End Class
