Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Partial Class Admin_MasterForms_frmManageEmployeeDetails
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'Dim strReturnTable As String = fnGetEmployeeDetails(1, "", 1)
            'dvMain.InnerHtml = strReturnTable.Split("~")(1)
            Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
            Dim ScmdGrade As SqlCommand = New SqlCommand()
            ScmdGrade.Connection = Scon
            ScmdGrade.CommandText = "spGetGradeMstr"
            ScmdGrade.CommandType = CommandType.StoredProcedure
            ScmdGrade.CommandTimeout = 0
            Dim SdapGrade As SqlDataAdapter = New SqlDataAdapter(ScmdGrade)
            Dim DsGrade As DataSet = New DataSet()
            SdapGrade.Fill(DsGrade)

            ddlGrade.Items.Add(New ListItem("-- Select --", "0"))
            For i = 0 To DsGrade.Tables(0).Rows.Count - 1
                ddlGrade.Items.Add(New ListItem(DsGrade.Tables(0).Rows(i)("Grade"), DsGrade.Tables(0).Rows(i)("GradeId")))
            Next




            Dim ScmdBandType As SqlCommand = New SqlCommand()
            ScmdBandType.Connection = Scon
            ScmdBandType.CommandText = "spGetBand"
            ScmdBandType.CommandType = CommandType.StoredProcedure
            ScmdBandType.CommandTimeout = 0
            Dim SdapBandType As SqlDataAdapter = New SqlDataAdapter(ScmdBandType)
            Dim DsBandType As DataSet = New DataSet()
            SdapBandType.Fill(DsBandType)

            'ddlBandType.Items.Add(New ListItem("-- Select --", "0"))
            For i = 0 To DsBandType.Tables(0).Rows.Count - 1
                ddlBandType.Items.Add(New ListItem(DsBandType.Tables(0).Rows(i)("Descr"), DsBandType.Tables(0).Rows(i)("BandID")))
            Next
            'GetMaster()
        End If
    End Sub
    Public Sub GetMaster()
        Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim Scmd As SqlCommand = New SqlCommand()
        Scmd.Connection = Scon
        Scmd.CommandText = "spGetDemographicMaster"
        Scmd.CommandType = CommandType.StoredProcedure
        Scmd.CommandTimeout = 0
        Dim Sdap As SqlDataAdapter = New SqlDataAdapter(Scmd)
        Dim Ds As DataSet = New DataSet()
        Sdap.Fill(Ds)

        Dim str As New StringBuilder
        Dim dttemp As New DataTable

        dttemp = Ds.Tables(1).Select("NodeType=2").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value = str.ToString()

        dttemp.Clear()
        str.Clear()
        dttemp = Ds.Tables(1).Select("NodeType=4").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value += "|" & str.ToString()

        dttemp.Clear()
        str.Clear()
        dttemp = Ds.Tables(1).Select("NodeType=5").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value += "|" & str.ToString()

        dttemp.Clear()
        str.Clear()
        dttemp = Ds.Tables(1).Select("NodeType=6").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value += "|" & str.ToString()

        dttemp.Clear()
        str.Clear()
        dttemp = Ds.Tables(1).Select("NodeType=9").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value += "|" & str.ToString()

        dttemp.Clear()
        str.Clear()
        dttemp = Ds.Tables(1).Select("NodeType=10").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value += "|" & str.ToString()

        dttemp.Clear()
        str.Clear()
        dttemp = Ds.Tables(1).Select("NodeType=11").CopyToDataTable()
        str.Append("<option value='0'>-- Select --</option>")
        For i As Integer = 0 To dttemp.Rows.Count - 1
            str.Append("<option value='" & dttemp.Rows(i)("NodeId") & "'>" & dttemp.Rows(i)("Descr") & "</option>")
        Next
        hdnMaster.Value += "|" & str.ToString()
    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetEmployeeDetails(ByVal flagChkddlUsers As Integer, ByVal SerachTxt As String, ByVal TypeID As Integer) As String
        Dim strTable As New StringBuilder
        Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim Scmd As SqlCommand = New SqlCommand()
        Scmd.Connection = Scon
        Scmd.CommandText = "spGetAllEmployeeDetails_New"
        Scmd.CommandType = CommandType.StoredProcedure
        Scmd.Parameters.AddWithValue("@flagChkParticipant", flagChkddlUsers)
        Scmd.Parameters.AddWithValue("@SearchText", SerachTxt)
        Scmd.Parameters.AddWithValue("@TypeID", TypeID)
        Scmd.CommandTimeout = 0
        Dim Sdap As SqlDataAdapter = New SqlDataAdapter(Scmd)
        Dim Ds As DataSet = New DataSet()
        Sdap.Fill(Ds)

        Dim strReturn As String = ""
        Dim SkipColumn As String() = New String(8) {}
        SkipColumn(0) = "EmpNodeID"
        SkipColumn(1) = "TypeID"
        SkipColumn(2) = "Photo"
        SkipColumn(3) = "CV"
        SkipColumn(4) = "Org Structure"
        SkipColumn(5) = "Video"
        SkipColumn(6) = "GradeID"
        SkipColumn(7) = "BandID"

        Dim dt As DataTable = Ds.Tables(0)

        Try
            If dt.Rows.Count > 0 Then
                strTable.Append("1~")
                strTable.Append("<table class='table table-bordered table-sm text-center'>")
                strTable.Append("<thead><tr>")
                For j As Integer = 0 To dt.Columns.Count - 1
                    If Not SkipColumn.Contains(dt.Columns(j).ColumnName.ToString()) Then
                        strTable.Append("<th>" & dt.Columns(j).ColumnName.ToString() & "</th>")
                    End If
                Next
                strTable.Append("<th style='width:10%'>Action</th>")
                strTable.Append("</tr></thead><tbody>")
                For i As Integer = 0 To dt.Rows.Count - 1
                    strTable.Append("<tr>")
                    For j As Integer = 0 To dt.Columns.Count - 1
                        If Not SkipColumn.Contains(dt.Columns(j).ColumnName.ToString()) Then
                            'If dt.Columns(j).ColumnName.ToString() = "CV" Then
                            '    If Convert.ToInt16(dt.Rows(i)("TypeID")) < 3 Then
                            '        If dt.Rows(i)("CV") = "" Then
                            '            strTable.Append("<td style='width: 60px;'><span class='text-warning fa fa-file-text'></span></td>")
                            '        Else
                            '            strTable.Append("<td style='width: 60px;'><span class='text-success fa fa-file-text pointer' file='" & dt.Rows(i)("CV") & "' onclick='fnShowPDF(this, 1);'></span></td>")
                            '        End If
                            '    Else
                            '        strTable.Append("<td style='background:#A4ABAE; width: 60px;'></td>")
                            '    End If
                            'ElseIf dt.Columns(j).ColumnName.ToString() = "Photo" Then
                            '    If Convert.ToInt16(dt.Rows(i)("TypeID")) < 3 Then
                            '        If dt.Rows(i)("Photo") = "" Then
                            '            strTable.Append("<td style='width: 60px;'><span class='text-warning fa fa-camera'></span></td>")
                            '        Else
                            '            strTable.Append("<td style='width: 60px;'><span class='text-success fa fa-camera pointer' file='" & dt.Rows(i)("Photo") & "' onclick='fnShowImg(this);'></span></td>")
                            '        End If
                            '    Else
                            '        strTable.Append("<td style='background:#A4ABAE; width: 60px;'></td>")
                            '    End If
                            'ElseIf dt.Columns(j).ColumnName.ToString() = "Video" Then
                            '    If dt.Rows(i)("TypeID") = 2 Then
                            '        If dt.Rows(i)("Video") = "" Then
                            '            strTable.Append("<td style='width: 60px;'><span class='text-warning fa fa-video-camera'></span></td>")
                            '        Else
                            '            strTable.Append("<td style='width: 60px;'><span class='text-success fa fa-video-camera pointer' file='" & dt.Rows(i)("Video") & "' onclick='fnShowVideo(this);'></span></td>")
                            '        End If
                            '    Else
                            '        strTable.Append("<td style='background:#A4ABAE; width: 60px;'></td>")
                            '    End If
                            'ElseIf dt.Columns(j).ColumnName.ToString() = "Org Structure" Then
                            '    If dt.Rows(i)("TypeID") = 1 Then
                            '        If dt.Rows(i)("Org Structure") = "" Then
                            '            strTable.Append("<td style='width: 60px;'><span class='text-warning fa fa-file-text'></span></td>")
                            '        Else
                            '            strTable.Append("<td style='width: 60px;'><span class='text-success fa fa-file-text pointer' file='" & dt.Rows(i)("Org Structure") & "' onclick='fnShowPDF(this, 3);'></span></td>")
                            '        End If
                            '    Else
                            '        strTable.Append("<td style='background:#A4ABAE; width: 60px;'></td>")
                            '    End If
                            'Else
                            '    strTable.Append("<td class='cls-" & j & "'>" + dt.Rows(i)(j).ToString() & "</td>")
                            'End If
                            strTable.Append("<td class='cls-" & j & "'>" + dt.Rows(i)(j).ToString() & "</td>")
                        End If
                    Next
                    'If dt.Rows(i)("TypeID") = 1 Then
                    '    strTable.Append("<td><span class='text-primary fa fa-pencil pointer' onclick=fnEditEmployeeDetails('" & dt.Rows(i)("EmpNodeID") & "','" & Replace(dt.Rows(i)("User Name"), " ", "-") & "','" & Replace(dt.Rows(i)("EMail ID"), " ", "-") & "','" & Replace(dt.Rows(i)("User Code"), " ", "-") & "'," & dt.Rows(i)("TypeID") & ",'" & Replace(dt.Rows(i)("CV"), " ", "-") & "','" & Replace(dt.Rows(i)("Photo"), " ", "-") & "','" & Replace(dt.Rows(i)("Org Structure"), " ", "-") & "')></span><span class='text-default ml-3 fa fa-user-circle-o pointer' onclick=fnEditDemographicDetails('" & dt.Rows(i)("EmpNodeID") & "')></span><span class='text-danger ml-3 fa fa-trash pointer' onclick=fndelete_row('" & dt.Rows(i)("EmpNodeID") & "')></span></td>")
                    'ElseIf dt.Rows(i)("TypeID") = 2 Then
                    '    strTable.Append("<td><span class='text-primary fa fa-pencil pointer' onclick=fnEditEmployeeDetails('" & dt.Rows(i)("EmpNodeID") & "','" & Replace(dt.Rows(i)("User Name"), " ", "-") & "','" & Replace(dt.Rows(i)("EMail ID"), " ", "-") & "','" & Replace(dt.Rows(i)("User Code"), " ", "-") & "'," & dt.Rows(i)("TypeID") & ",'" & Replace(dt.Rows(i)("CV"), " ", "-") & "','" & Replace(dt.Rows(i)("Photo"), " ", "-") & "','" & Replace(dt.Rows(i)("Video"), " ", "-") & "')></span><span class='text-danger ml-3 fa fa-trash pointer' onclick=fndelete_row('" & dt.Rows(i)("EmpNodeID") & "')></span></td>")
                    'Else
                    '    strTable.Append("<td><span class='text-primary fa fa-pencil pointer' onclick=fnEditEmployeeDetails('" & dt.Rows(i)("EmpNodeID") & "','" & Replace(dt.Rows(i)("User Name"), " ", "-") & "','" & Replace(dt.Rows(i)("EMail ID"), " ", "-") & "','" & Replace(dt.Rows(i)("User Code"), " ", "-") & "'," & dt.Rows(i)("TypeID") & ",'','','')></span><span class='text-danger ml-3 fa fa-trash pointer' onclick=fndelete_row('" & dt.Rows(i)("EmpNodeID") & "')></span></td>")
                    'End If
                    'If dt.Rows(i)("TypeID") = 1 Then
                    '    strTable.Append("<td><span class='text-primary fa fa-pencil pointer' onclick=fnEditEmployeeDetails('" & dt.Rows(i)("EmpNodeID") & "','" & Replace(dt.Rows(i)("User Name"), " ", "-") & "','" & Replace(dt.Rows(i)("EMail ID"), " ", "-") & "','" & Replace(dt.Rows(i)("User Code"), " ", "-") & "'," & dt.Rows(i)("TypeID") & ",'','','')></span><span class='text-default ml-3 fa fa-user-circle-o pointer' onclick=fnEditDemographicDetails('" & dt.Rows(i)("EmpNodeID") & "')></span><span class='text-danger ml-3 fa fa-trash pointer' onclick=fndelete_row('" & dt.Rows(i)("EmpNodeID") & "')></span></td>")
                    '    strTable.Append("</tr>")
                    'Else
                    strTable.Append("<td><span class='text-primary fa fa-pencil pointer' onclick=fnEditEmployeeDetails('" & dt.Rows(i)("EmpNodeID") & "','" & Replace(dt.Rows(i)("User Name"), " ", "-") & "','" & Replace(dt.Rows(i)("EMail ID"), " ", "-") & "','" & Replace(dt.Rows(i)("User Code"), " ", "-") & "'," & dt.Rows(i)("TypeID") & "," & dt.Rows(i)("GradeId") & "," & dt.Rows(i)("BandId") & ",'','','')></span><span class='text-danger ml-3 fa fa-trash pointer' onclick=fndelete_row('" & dt.Rows(i)("EmpNodeID") & "')></span></td>")
                    strTable.Append("</tr>")
                    'End If
                Next
                strTable.Append("</tbody></table>")
            Else
                strTable.Append("2~")
                strTable.Append("<table class='table table-bordered table-sm text-center'><tbody>")
                strTable.Append("<tr>")
                strTable.Append("<td class='text-left'>No Record Found... Please click on the ''Add New Employee'' Button to add the new employee.</td>")
                strTable.Append("</tr>")
                strTable.Append("</tbody></table>")
            End If
            strReturn = HttpContext.Current.Server.HtmlDecode(strTable.ToString)
        Catch ex As Exception
            strReturn = "3~" & ex.Message
        End Try
        Return strReturn
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnManageEmployeeDetails(ByVal EmpID As Integer, FName As String, EmpCode As String, EmailID As String, SecondaryEmailID As String, ByVal UserType As Integer, ByVal GradeId As Integer, ByVal BandType As Integer, ByVal SetName As Integer, Uploader1 As String, Uploader2 As String, Uploader3 As String) As String
        Dim strReturn As String = 1

        Dim LoginId As Integer

        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spManageEmployeeDetails]", Objcon2)
        objCom2.Parameters.Add("@EmpId", SqlDbType.Int).Value = EmpID
        objCom2.Parameters.Add("@FName", SqlDbType.NVarChar).Value = FName
        objCom2.Parameters.Add("@EmailID", SqlDbType.NVarChar).Value = EmailID
        objCom2.Parameters.Add("@SecondaryEmailID", SqlDbType.NVarChar).Value = SecondaryEmailID
        objCom2.Parameters.Add("@Empcode", SqlDbType.NVarChar).Value = EmpCode
        objCom2.Parameters.Add("@UserType", SqlDbType.Int).Value = UserType
        objCom2.Parameters.Add("@SetNameID", SqlDbType.Int).Value = 0
        objCom2.Parameters.Add("@GradeId", SqlDbType.Int).Value = GradeId
        objCom2.Parameters.Add("@BandId", SqlDbType.Int).Value = BandType
        objCom2.Parameters.Add("@CVDocName", SqlDbType.NVarChar).Value = Uploader1
        objCom2.Parameters.Add("@PhototDocName", SqlDbType.NVarChar).Value = Uploader2
        If UserType = 1 Then
            objCom2.Parameters.Add("@OrgStructureDocName", SqlDbType.NVarChar).Value = Uploader3
        Else
            objCom2.Parameters.Add("@VideoFileName", SqlDbType.NVarChar).Value = Uploader3
        End If
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Dim dr As SqlDataReader
        Dim ReturnFlgVal As Integer
        ' Try
        Objcon2.Open()
        dr = objCom2.ExecuteReader
        dr.Read()

        ReturnFlgVal = dr.Item("FlgVal")
        strReturn = "1@" & ReturnFlgVal
        ' Catch ex As Exception
        ' strReturn = "2@" & ex.Message
        '  Finally
        objCom2.Dispose()
        Objcon2.Close()
        Objcon2.Dispose()
        ' End Try
        Return strReturn

    End Function


    <System.Web.Services.WebMethod()>
    Public Shared Function fnCheckMappedUsersAgCycle(ByVal EmpNodeID As Integer) As String
        Dim strReturn As String = 1
        ' Sub spRspBusinessCaseUPDAnswers(ByVal RspExerciseID As Integer, ByVal LoginId As Integer, ByVal selValues As String, ByVal statusValue As Integer)
        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spCheckUsersAssmntStatus]", Objcon2)
        objCom2.Parameters.Add("@EmpNodeID", SqlDbType.Int).Value = EmpNodeID


        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Dim dr As SqlDataReader
        Dim ReturnFlag As Integer
        Try
            Objcon2.Open()
            dr = objCom2.ExecuteReader
            dr.Read()

            ReturnFlag = dr.Item("chkFlag")
            strReturn = "1@" & ReturnFlag
        Catch ex As Exception
            strReturn = "2@" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnDeleteUser(ByVal EmpNodeID As Integer) As String
        Dim strReturn As String = 1

        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spDeleteUser]", Objcon2)
        objCom2.Parameters.Add("@EmpNodeID", SqlDbType.Int).Value = EmpNodeID

        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "1@"
        Catch ex As Exception
            strReturn = "2@" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnEditDemographicDetails(ByVal EmpNodeID As String) As String
        Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim Scmd As SqlCommand = New SqlCommand()
        Scmd.Connection = Scon
        Scmd.CommandText = "[spGetDemographicDetailsForUser]"
        Scmd.CommandType = CommandType.StoredProcedure
        Scmd.CommandTimeout = 0
        Scmd.Parameters.AddWithValue("@EmpNodeID", EmpNodeID)
        Dim Sdap As SqlDataAdapter = New SqlDataAdapter(Scmd)
        Dim Ds As DataSet = New DataSet()
        Dim str As String
        Try
            Sdap.Fill(Ds)
            str = "1^"
            For i As Integer = 0 To Ds.Tables(0).Columns.Count - 1
                str &= Ds.Tables(0).Rows(0)(i).ToString() & "|"
            Next
        Catch ex As Exception
            str = "2^"
        Finally
            Scmd.Dispose()
            Sdap.Dispose()
            Scon.Close()
        End Try

        Return str.ToString()
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnSaveDemographicDetails(ByVal EmpNodeID As String, ByVal DOB As String, ByVal GenderId As String, ByVal JobTitle As String, ByVal JobFunctionId As String, ByVal OfficeOrSiteId As String, ByVal ICId As String, ByVal BUDescr As String, ByVal DateOfJoining As String, ByVal OverallExperienceId As String, ByVal EducationDetailsId As String, ByVal PerformanceCategoryId As String, ByVal CurrentRoleExperienceInMonths As String, ByVal Location As String) As String
        Dim Scon As SqlConnection = New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim Scmd As SqlCommand = New SqlCommand()
        Scmd.Connection = Scon
        Scmd.CommandText = "[spSaveDemographicDetailsForUser]"
        Scmd.CommandType = CommandType.StoredProcedure
        Scmd.CommandTimeout = 0
        Scmd.Parameters.AddWithValue("@EmpNodeId", EmpNodeID)
        Scmd.Parameters.AddWithValue("@DOB", DOB)
        Scmd.Parameters.AddWithValue("@GenderId", GenderId)
        Scmd.Parameters.AddWithValue("@JobTitle", JobTitle)
        Scmd.Parameters.AddWithValue("@JobFunctionId", JobFunctionId)
        Scmd.Parameters.AddWithValue("@OfficeOrSiteId", OfficeOrSiteId)
        Scmd.Parameters.AddWithValue("@ICId", ICId)
        Scmd.Parameters.AddWithValue("@BUDescr", BUDescr)
        Scmd.Parameters.AddWithValue("@DateOfJoining", DateOfJoining)
        Scmd.Parameters.AddWithValue("@OverallExperienceId", OverallExperienceId)
        Scmd.Parameters.AddWithValue("@EducationDetailsId", EducationDetailsId)
        Scmd.Parameters.AddWithValue("@PerformanceCategoryId", PerformanceCategoryId)
        Scmd.Parameters.AddWithValue("@CurrentRoleExperienceInMonths", CurrentRoleExperienceInMonths)
        Scmd.Parameters.AddWithValue("@Location", Location)
        Dim Sdap As SqlDataAdapter = New SqlDataAdapter(Scmd)
        Dim Ds As DataSet = New DataSet()
        Dim str As String
        Try
            Sdap.Fill(Ds)
            str = "1"
        Catch ex As Exception
            str = "2"
        Finally
            Scmd.Dispose()
            Sdap.Dispose()
            Scon.Close()
        End Try
        Return str
    End Function
End Class
