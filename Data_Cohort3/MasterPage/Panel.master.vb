Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Partial Class Data_MasterPage_Panel
    Inherits System.Web.UI.MasterPage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        hdnMenuId.Value = Request.QueryString("MenuId")
        hdnAssmntType.Value = Session("AssessmentType")
        hdnFlagPageToOpen.Value = Session("flgPageToOpen")
        hdnLngID.Value = Session("SelectedLngID")
        Dim bandId = IIf(IsNothing(Session("BandID")), 0, Session("BandID"))
        If bandId <> 3 Then
            Response.Redirect("~/frmSessionExpire.aspx")
            Return
        End If
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
End Class

