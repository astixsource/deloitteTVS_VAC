Imports System.Data
Imports System.Data.SqlClient
Imports System.Text

Partial Class Site
    Inherits System.Web.UI.MasterPage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        'hdnAssmntType.Value = Session("AssessmentType")
        'hdnLngID.Value = Session("SelectedLngID")
        'fnfillLanguage()
    End Sub
    'Private Sub fnfillLanguage()

    '    Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    '    Dim Scmd As SqlCommand = New SqlCommand()
    '    Scmd.Connection = Scon
    '    Scmd.CommandText = "spFillDropDownForLanguage"

    '    Scmd.CommandType = CommandType.StoredProcedure
    '    Scmd.CommandTimeout = 0
    '    Dim Sdap As SqlDataAdapter = New SqlDataAdapter(Scmd)
    '    Dim dt As DataTable = New DataTable()
    '    Sdap.Fill(dt)
    '    Dim itm As ListItem = New ListItem()
    '    itm.Text = "- Language  -"
    '    itm.Value = "0"
    '    ddlLanguage.Items.Add(itm)

    '    For Each dr As DataRow In dt.Rows
    '        itm = New ListItem()
    '        itm.Text = dr("Descr").ToString()
    '        itm.Value = dr("LngID").ToString()
    '        ddlLanguage.Items.Add(itm)
    '    Next
    'End Sub
    'Protected Sub lnkLogout_Click(sender As Object, e As EventArgs) Handles lnkLogout.Click
    '    Response.Redirect("~/CommonFolder/Logout/frmLogout.aspx")
    'End Sub
End Class

