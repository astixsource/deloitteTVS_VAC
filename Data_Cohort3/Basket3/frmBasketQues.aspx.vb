Imports System.Data
Imports System.Data.SqlClient
Partial Class Basket_frmBasketQues
    Inherits System.Web.UI.Page

    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Dim ExerciseID As Integer = 0
    Dim BandID As Integer = 1
    Dim ExerciseType As Integer = 0
    Public TimeAllotedSec As Integer = 0
    Dim arrPara(0, 1) As String
    Dim PGNmbr As Integer = 0
    Dim Direction As Integer = 0

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        hdnMultiMailQstnID.Value = IIf(IsNothing(Request.QueryString("MultiMailQstnID")), 0, Request.QueryString("MultiMailQstnID"))

        hdnExerciseID.Value = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        hdnRSPExerciseID.Value = IIf(IsNothing(Request.QueryString("RSPExerciseID")), 0, Request.QueryString("RSPExerciseID"))
        hdnRspMailInstanceID.Value = IIf(IsNothing(Request.QueryString("RspMailInstanceID")), 0, Request.QueryString("RspMailInstanceID"))

        If Not IsPostBack = True Then
            dvMain.InnerHtml = fnGetStatement(hdnMultiMailQstnID.Value, hdnExerciseID.Value, BandID, hdnRSPExerciseID.Value)
        End If
    End Sub

    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetStatement(ByVal MultiMailQstnID As Integer, ByVal ExerciseID As Integer, ByVal BandID As Integer, ByVal RSPExerciseID As Integer) As String
        Dim strVal1 As Int16 = 0
        Dim strVal2 As Int16 = 0
        Dim strVal3 As Int16 = 0
        Dim strVal4 As Int16 = 0

        Dim strReturnVal As String = "1"

        Dim strTable As New StringBuilder

        'Dim arrPara(1, 1) As String
        'arrPara(0, 0) = "1" ' MultiMailQstnID
        'arrPara(0, 1) = "0"

        'arrPara(1, 0) = "2" ' ExerciseID
        'arrPara(1, 1) = "0"
        Dim strConn As String = Convert.ToString(HttpContext.Current.Application("DbConnectionString"))
        Dim objCon As New SqlConnection(strConn)
        Dim objcom As New SqlCommand("spgetmultimailqstns", objCon)
        objcom.Parameters.AddWithValue("@MultiMailQstnID", MultiMailQstnID)
        objcom.Parameters.AddWithValue("@ExcerciseID", ExerciseID)
        objcom.Parameters.AddWithValue("@BandID", 2)
        objcom.Parameters.AddWithValue("@RSPExerciseID", RSPExerciseID)
        objcom.CommandType = CommandType.StoredProcedure
        objcom.CommandTimeout = 0
        Dim dr As SqlDataReader

        Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Try
            objCon.Open()
            dr = objcom.ExecuteReader
            strTable.Append("<div id='tblMain' class='section-qus clearfix pb-2 mb-3' MultiMailQuesId='" & MultiMailQstnID & "' ExerciseId='" & ExerciseID & "' BandId='" & BandID & "'>")
            Dim cnt As Int32 = 1
            While dr.Read
                strTable.Append("<div class='row m-0' style='font-weight:bold;padding:5px;font-size:1rem'>")

                strTable.Append("<div class='col-2 col-md-1'>")
                strTable.Append("</div>")
                strTable.Append("<div class='col-10 col-md-11 text-center'>")
                strTable.Append(dr.Item("Qstn"))
                strTable.Append("</div>")

                strTable.Append("</div>")

                strTable.Append("<div class='col-11 offset-1' IsQues='1' QuesId='" & dr.Item("RspExcerciseQstnID") & "'>")
                strTable.Append("<div class='qusgroup_option'>")
                strTable.Append(fnGetSubStatement(dr.Item("RspExcerciseQstnID"), 0, 0, 4, dr.Item("TypeID"), dr.Item("AnswrVal")))
                strTable.Append("</div>")
                strTable.Append("</div>")

                cnt = cnt + 1
            End While
            strTable.Append("</div>")
            strTable.Append("<div class='text-center'><input type='button' id='btnBackbtn' value='Back' class='btns btn-submit' onclick='fngoback()'/><input type='button' id='btnSubmit' value='Save & Close' class='btns btn-submit' onclick='fnCloseQuestion()'/></div>")
            strReturnVal = strTable.ToString()

            dr.Close()
        Catch ex As Exception
            strReturnVal = ex.Message
        Finally
            objcom.Dispose()
            objCon.Dispose()
        End Try

        Return strReturnVal

    End Function

    Public Shared Function fnGetSubStatement(ByVal QstID As Integer, ByVal RsltVal As String, ByVal RspDetId As Integer, ByVal NoOfOptions As Integer, ByVal TypeID As Integer, ByVal selectedAnswerVal As Integer) As String

        Dim ds As New DataSet
        Dim strInnerTable As New StringBuilder
        Dim QstnValue As String
        Dim Value As String = ""
        Dim ctr As Integer = 0


        Dim strConn As String = Convert.ToString(HttpContext.Current.Application("DbConnectionString"))
        Dim objCon As New SqlConnection(strConn)
        Dim objcom As New SqlCommand("spGetSubStatement", objCon)
        objcom.Parameters.AddWithValue("@QsntID", QstID)
        objcom.CommandType = CommandType.StoredProcedure
        objcom.CommandTimeout = 0
        Dim da As SqlDataAdapter
        da = New SqlDataAdapter(objcom)
        da.Fill(ds)
        Dim cntr As Integer = 0

        Dim options(10) As String
        options(0) = "A"
        options(1) = "B"
        options(2) = "C"
        options(3) = "D"
        options(4) = "E"
        options(5) = "F"
        options(6) = "G"

        If ds.Tables(0).Rows.Count > 0 Then
            Dim checked As String = ""
            If TypeID = 3 Then  'for Checkbox
                strInnerTable.Append("<div id='tblChk' class='form-group clearfix'>")
                For k As Integer = 0 To ds.Tables(0).Rows.Count - 1
                    QstnValue = ds.Tables(0).Rows(k)("RspExcerciseSubQstnID")
                    Value = QstnValue

                    strInnerTable.Append("<div class='d-flex'>")
                    If (QstnValue = selectedAnswerVal) Then
                        checked = " checked "
                    Else
                        checked = ""
                    End If

                    strInnerTable.Append("<div class='pr-3 font-weight-bold text-primary'>" & options(k) & "</div>")
                    If (RsltVal <> "" And (CType(QstnValue, String)) = RsltVal) Then
                        strInnerTable.Append("<div class='form-check'>")
                        strInnerTable.Append("<input type='checkbox' class='form-check-input' " + checked + " value = '" & Value & "' checked=true id='chkAns" & RspDetId & "^" & (k + 1) & "' name = '" & QstID & "'>") '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label>")
                        strInnerTable.Append("</div>")
                    Else
                        strInnerTable.Append("<div class='form-check'>")
                        strInnerTable.Append("<input type='checkbox' class='form-check-input' " + checked + " value = '" & Value & "'  id='chkAns" & RspDetId & "^" & (k + 1) & "'  name = '" & QstID & "'>") '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label>")
                        strInnerTable.Append("</div>")
                    End If
                    strInnerTable.Append("</div>")
                Next
                strInnerTable.Append("</div>")

            ElseIf TypeID = 1 Then  'for Radio
                Dim countOfRowsForRank As Integer = ds.Tables(0).Rows.Count
                strInnerTable.Append("<div id='tblRdo' class='form-group clearfix'>")
                For k As Integer = 0 To ds.Tables(0).Rows.Count - 1
                    QstnValue = ds.Tables(0).Rows(k)("RspExcerciseSubQstnID")
                    Value = QstnValue

                    strInnerTable.Append("<div class='d-flex'>")
                    If (QstnValue = selectedAnswerVal) Then
                        checked = " checked "
                    Else
                        checked = ""
                    End If

                    If (RsltVal <> "" And (CType(QstnValue, String)) = RsltVal) Then
                        strInnerTable.Append("<div class='pr-3 font-weight-bold text-primary'>" & options(k) & "</div>")
                        strInnerTable.Append("<div class='form-check'>")
                        strInnerTable.Append("<input type='radio' class='form-check-input' " + checked + " value = " & Value & " checked=true id='rdoAns" & k & "^" & (k + 1) & "'  name = '" & QstID & "'>") 'name = '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label>")
                        strInnerTable.Append("</div>")
                    Else
                        strInnerTable.Append("<div class='pr-3 font-weight-bold text-primary'>" & options(k) & "</div>")
                        strInnerTable.Append("<div class='form-check'>")
                        strInnerTable.Append("<input type='radio' class='form-check-input' " + checked + " value = " & Value & "  id='rdoAns" & k & "^" & (k + 1) & "'  name = '" & QstID & "'>") 'name = '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label>")
                        strInnerTable.Append("</div>")
                    End If
                    strInnerTable.Append("</div>")
                Next
                strInnerTable.Append("</div>")
            ElseIf TypeID = 2 Then  'for drop down

                strInnerTable.Append("<select id='ddl" & QstID & "' class='form-control'><option value='0'>- Select Rank- </option>")
                Dim countOfRowsForRank As Integer = ds.Tables(0).Rows.Count
                For k As Integer = 0 To ds.Tables(0).Rows.Count - 1
                    QstnValue = ds.Tables(0).Rows(k)("RspExcerciseSubQstnID")
                    Value = RspDetId & "^" & QstnValue
                    If (RsltVal <> "" And (CType(QstnValue, String)) = RsltVal) Then
                        strInnerTable.Append("<option value='" & ds.Tables(0).Rows(k)("Descr") & "' qtnval='" & Value & "' selected > " & ds.Tables(0).Rows(k)("Descr") & "</option>")
                    Else
                        strInnerTable.Append("<option value='" & ds.Tables(0).Rows(k)("Descr") & "' qtnval='" & Value & "'>" & ds.Tables(0).Rows(k)("Descr") & "</option>")
                    End If
                Next
                strInnerTable.Append("</select>")

            ElseIf TypeID = 4 Then  'for Radio
                Dim countOfRowsForRank As Integer = ds.Tables(0).Rows.Count
                strInnerTable.Append("<table id='tblTextbox' style='width:100%'>")
                For k As Integer = 0 To ds.Tables(0).Rows.Count - 1
                    QstnValue = ds.Tables(0).Rows(k)("RspExcerciseSubQstnID") '& "^" & ds.Tables(0).Rows(k)("flgQstnShow") & "^" & QstID
                    Value = RspDetId & "^" & QstnValue

                    If (RsltVal <> "" And (CType(QstnValue, String)) = RsltVal) Then
                        strInnerTable.Append("<tr>")
                        strInnerTable.Append("<td style='width:40%'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("<td>")
                        strInnerTable.Append("<input type='textbox'  id='rdoAns" & k & "^" & (k + 1) & "' class='form-control' style='width:250px'>")
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("</tr>")
                    Else
                        strInnerTable.Append("<tr>")
                        strInnerTable.Append("<td style='width:40%'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("<td>")
                        strInnerTable.Append("<input type='textbox'   id='rdoAns" & k & "^" & (k + 1) & "' class='form-control' style='width:250px'>")
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("</tr>")

                    End If

                Next
                strInnerTable.Append("</table>")
            End If
        End If
        objcom.Dispose()
        ds.Dispose()
        objCon.Dispose()
        Return strInnerTable.ToString
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function spUpdateResponsesForSituationAnalysis2(ByVal RSPExerciseID As Integer, strResult As String, Status As Integer, PGNmbr As Integer) As String
        Dim strReturn As String = 1
        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spUpdateResponsesAnalysis]", Objcon2)
        objCom2.Parameters.Add("@RspExcersiseID", SqlDbType.Int).Value = RSPExerciseID
        objCom2.Parameters.Add("@RespStr", SqlDbType.NVarChar).Value = strResult
        objCom2.Parameters.Add("@LoginID", SqlDbType.Int).Value = LoginId
        objCom2.Parameters.Add("@Status", SqlDbType.Int).Value = Status
        objCom2.Parameters.Add("@PGNmbr", SqlDbType.Int).Value = PGNmbr
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "1^"
        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function spUpdateAnswer(ByVal multiMailQuestionId As Integer, ByVal rspExerciseId As Integer, ByVal resultString As String, ByVal rspMailInstanceId As String, ByVal flgPriorty As Integer) As String
        Dim strReturn As String = 1
        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spUpdateResponsesForBasketMCQ]", Objcon2)
        objCom2.Parameters.Add("@MultiMailQstnID", SqlDbType.Int).Value = multiMailQuestionId
        objCom2.Parameters.Add("@RspExcersiseID", SqlDbType.Int).Value = rspExerciseId
        objCom2.Parameters.Add("@RespStr", SqlDbType.VarChar).Value = resultString
        objCom2.Parameters.Add("@LoginID", SqlDbType.Int).Value = LoginId
        objCom2.Parameters.Add("@flgMailResponseType", SqlDbType.Int).Value = 2
        objCom2.Parameters.Add("@RspMailInstanceID", SqlDbType.Int).Value = rspMailInstanceId
        objCom2.Parameters.Add("@flgPriorty", SqlDbType.Int).Value = flgPriorty
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "1^"
        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function
End Class

