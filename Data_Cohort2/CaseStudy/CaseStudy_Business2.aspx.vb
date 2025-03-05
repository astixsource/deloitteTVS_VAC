Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports Newtonsoft.Json

Partial Class CaseStudy
    Inherits System.Web.UI.Page
    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Dim ExerciseID As Integer = 0
    Dim BandID As Integer = 0
    Dim ExerciseType As Integer = 0
    Public TimeAllotedSec As Integer = 0
    Dim arrPara(0, 1) As String
    Dim PGNmbr As Integer = 0
    Dim Direction As Integer = 0

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim ReferalUrl As String
        ReferalUrl = Convert.ToString(Request.UrlReferrer)
        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If

        'Dim panelLogout As Panel
        'panelLogout = DirectCast(Page.Master.FindControl("panelLogout"), Panel)
        'panelLogout.Visible = False

        hdnExerciseID.Value = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        BandID = 2 ' IIf(IsNothing(Request.QueryString("BandID")), 0, Request.QueryString("BandID"))
        ExerciseType = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        hdnBandID.Value = BandID
        hdnRspID.Value = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        hdnLoginID.Value = IIf(IsNothing(Session("LoginId")), 0, Convert.ToString(Session("LoginId")))
        ' hdnPageNmbr.Value = IIf(IsNothing(Request.QueryString("PGNmbr")), 0, Request.QueryString("PGNmbr"))


        hdnRSPExerciseID.Value = IIf(IsNothing(Request.QueryString("RspExerciseID")), 0, Request.QueryString("RspExerciseID"))

        If Not IsPostBack = True Then
            hdnIsProctoringEnabled.Value = IIf(IsNothing(Session("IsProctoringEnabled")), 0, Session("IsProctoringEnabled"))


            ReDim arrPara(3, 1)
            arrPara(0, 0) = hdnRspID.Value
            arrPara(0, 1) = "0"

            arrPara(1, 0) = hdnExerciseID.Value
            arrPara(1, 1) = "0"

            arrPara(2, 0) = hdnLoginID.Value
            arrPara(2, 1) = "0"

            arrPara(3, 0) = BandID
            arrPara(3, 1) = "0"

            Dim objCon As New SqlConnection
            Dim objcom As New SqlCommand
            objcom.CommandTimeout = 0
            Dim dr As SqlDataReader

            dr = objAdo.RunSP("[spRspExerciseManage]", arrPara, 0, objCon, objcom)

            'If (dr.HasRows) Then
            '   dvAlertDialog.InnerHtml = clsCheckRspCurrentProgress.GetStartedAssesments(dr)
            '  Page.ClientScript.RegisterStartupScript(Page.GetType(), "Dialog", "<script language='javascript'>ShowRunningAssesments();</script>")
            ' Return
            'End If
            'dr.NextResult()

            If dr.HasRows Then
                dr.Read()
                hdnExerciseStatus.Value = Convert.ToInt32(IIf(IsNothing(dr.Item("flgExerciseStatus")), 0, dr.Item("flgExerciseStatus")))
                hdnRSPExerciseID.Value = Convert.ToInt32(IIf(IsNothing(dr.Item("RSPExerciseID")), 0, dr.Item("RSPExerciseID")))
                hdnTimeElapsedMin.Value = 0 ' IIf(IsNothing(dr.Item("ElapsedTime(Min)")), 0, dr.Item("ElapsedTime(Min)"))
                hdnTimeElapsedSec.Value = 0 ' IIf(IsNothing(dr.Item("ElapsedTime(Sec)")), 0, dr.Item("ElapsedTime(Sec)"))
                hdnExerciseTotalTime.Value = 0 ' IIf(IsNothing(dr.Item("TotalTestTime")), 0, dr.Item("TotalTestTime"))
                Dim TotElapsedSeconds = 0 'CInt(hdnTimeElapsedMin.Value) * 60 + CInt(hdnTimeElapsedSec.Value)
                Dim PrepRemainingTime = IIf(IsNothing(dr.Item("PrepRemainingTime")), 0, dr.Item("PrepRemainingTime"))
                hdnCounter.Value = PrepRemainingTime ' CInt(hdnExerciseTotalTime.Value) * 60 - TotElapsedSeconds
                hdnMeetingDefaultTime.Value = CInt(hdnExerciseTotalTime.Value) * 60
                Dim TotalPageNumber = IIf(IsNothing(dr.Item("TotalPageNumber")), 0, dr.Item("TotalPageNumber"))
                hdnTotalQuestions.Value = TotalPageNumber
                Dim PNmbr As Integer = 0
                PNmbr = IIf(IsNothing(dr.Item("PGNmbr")), 0, dr.Item("PgNmbr"))
                If PNmbr = 0 Then
                    PNmbr = 1
                End If

                PNmbr = IIf(PNmbr >= Convert.ToInt32(TotalPageNumber), TotalPageNumber, PNmbr)
                If hdnExerciseStatus.Value = 2 Then
                    hdnPageNmbr.Value = 1
                Else
                    hdnPageNmbr.Value = PNmbr
                    ' Dim strReturn1 = fnUpdateActualStartEndTime(Convert.ToInt32(hdnRSPExerciseID.Value), 1, 1)
                End If

            End If

            objAdo.CloseConnection(objCon, objcom, dr)
            If (Convert.ToInt32(hdnExerciseTotalTime.Value) * 60) > (Convert.ToInt32(hdnTimeElapsedMin.Value) * 60 + Convert.ToInt32(hdnTimeElapsedSec.Value)) Then
                TimeAllotedSec = (Convert.ToInt32(hdnExerciseTotalTime.Value) * 60) - (Convert.ToInt32(hdnTimeElapsedMin.Value) * 60 + Convert.ToInt32(hdnTimeElapsedSec.Value))
                '  Timer2.Interval = (1000 * TimeAllotedSec)
                hdnTimeLeft.Value = Convert.ToString(TimeAllotedSec)
            End If

            Dim strReturnTable As String = fnGetStatement(hdnRSPExerciseID.Value, hdnExerciseID.Value, hdnPageNmbr.Value, hdnExerciseStatus.Value, hdnTotalQuestions.Value, BandID)

            dvMain.InnerHtml = strReturnTable.Split("@")(1)

        End If



    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetStatement(ByVal RspExcersiseID As Integer, ByVal ExerciseID As Integer, ByVal PGNmbr As Integer, ByVal ExerciseStatusId As Integer, ByVal TotalPageNumber As String, ByVal BandID As String) As String
        Dim strVal1 As Int16 = 0
        Dim strVal2 As Int16 = 0
        Dim strVal3 As Int16 = 0
        Dim strVal4 As Int16 = 0

        Dim strReturnVal As String = 1

        Dim strTable As New StringBuilder

        'Dim LoginId As Integer
        'LoginId = HttpContext.Current.Session("LoginId")
        'Dim BandID As Integer
        'BandID = HttpContext.Current.Session("BandID")

        Dim arrPara(3, 1) As String
        arrPara(0, 0) = RspExcersiseID
        arrPara(0, 1) = "0"

        arrPara(1, 0) = PGNmbr
        arrPara(1, 1) = "0"

        arrPara(2, 0) = ExerciseID
        arrPara(2, 1) = "0"

        arrPara(3, 0) = BandID
        arrPara(3, 1) = "0"

        Dim objCon As New SqlConnection
        Dim objcom As New SqlCommand
        objcom.CommandTimeout = 0
        Dim dr As SqlDataReader

        Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        '  Try

        dr = objAdo.RunSP("[spRSPGetExcersiseQstns]", arrPara, 0, objCon, objcom)
        strTable.Append("<div id='tblMain'>")
        Dim chkDr As Integer = 0
        Dim flgMainHdng As Integer = 0
        Dim flgSubHdng As Integer = 0
        Dim varSubHdng As String = ""
        While dr.Read

            If chkDr = 0 Then
                strTable.Append("<div class='alert alert-info'>Page No :  " & dr.Item("PgNmbr") & "/" & TotalPageNumber & "</div>")
                chkDr = 1
            End If
            If IsDBNull(dr.Item("VideoURL")) Then
                If flgMainHdng = 0 Then
                    strTable.Append("<p class='font-weight-bold'>" & dr.Item("MainHeading") & "</p>")
                    flgMainHdng = 1
                End If

                If varSubHdng <> dr.Item("SubHeading") Then
                    strTable.Append("<p>" & dr.Item("SubHeading") & "</p>")
                    varSubHdng = dr.Item("SubHeading")
                End If
            Else
                ' If (Not String.IsNullOrWhiteSpace(dr.Item("Qstn"))) Then
                If flgMainHdng = 0 Then
                    strTable.Append("<p class='font-weight-bold'>" & dr.Item("MainHeading") & "</p>")
                    ' strTable.Append("<video id='video' width='500' height='300'  controls controlsList='nodownload'><source src='" & dr.Item("VideoURL") & "' type='video/mp4'></video>")
                    flgMainHdng = 1
                End If

                ' End If

            End If

            strTable.Append("<div class='section-qus'>")
            strTable.Append("<div class='row Qst_Header'>")
            If dr.Item("SrlNmbr") <> 0 Then
                strTable.Append("<div class='col-1'><span class='Qst-no'>")
                strTable.Append(dr.Item("SrlNmbr"))
                strTable.Append("</span></div>")
            Else
                strTable.Append("<div class='col-1'><span class='Qst-no'>")
                strTable.Append("")
                strTable.Append("</span></div>")
            End If
            strTable.Append("<div class='col-11'><p>")
            strTable.Append(dr.Item("Qstn"))
            strTable.Append("</p></div>")
            strTable.Append("</div>")

            Dim strDisabled = ""
            If ExerciseStatusId = 2 Then
                strDisabled = "disabled='disabled'"
            End If

            If (dr.Item("TypeID") <> 4) Then
                strTable.Append("<div class='row m-0'><div class='col-md-11 offset-md-1'><div class='qusgroup_option' IsQues=1  QuesId=" & dr.Item("RspExcerciseQstnID") & "  rspDetId=" & dr.Item("RspDetID") & ">")
            Else
                strTable.Append("<div class='row m-0'><div class='col-md-11 offset-md-1'><div class='qusgroup_option'>")
            End If
            If (dr.Item("TypeID") = 4) Then
                strTable.Append("<textarea flg='1'  " & strDisabled & " id='txt_" & dr.Item("RspExcerciseQstnID") & "' QuesId='" & dr.Item("RspExcerciseQstnID") & "' RspDetId='" & dr.Item("RspDetID") & "' rows='7' placeholder='Write your response here' class='form-control' style='width:100%;border:1px solid #ccc;'>" + dr.Item("Answrval").ToString() + "</textarea>")
            Else
                strTable.Append(fnGetSubStatement(dr.Item("RspExcerciseQstnID"), Convert.ToString(dr.Item("Answrval")).Split("|")(0), dr.Item("RspDetID"), 4, dr.Item("TypeID"), dr.Item("MaxQstnSelected"), dr.Item("SrlNmbr"), strDisabled))
                'If (Convert.ToString(dr.Item("Answrval")) <> "") Then
                '    strTable.Append("<div class='mt-1 mb-1'><b>Rational : </b></div><div><textarea  " & strDisabled & " id='txt_" & dr.Item("RspExcerciseQstnID") & "' flg='2' QuesId='" & dr.Item("RspExcerciseQstnID") & "' RspDetId='" & dr.Item("RspDetID") & "' rows='4' placeholder='Write your response here' class='form-control' style='width:100%;border:1px solid #ccc;'>" + HttpUtility.UrlDecode(Convert.ToString(dr.Item("Answrval")).Split("|")(1)) + "</textarea></div>")
                'Else
                '    strTable.Append("<div class='mt-1 mb-1'><b>Rational : </b></div><div><textarea  " & strDisabled & " id='txt_" & dr.Item("RspExcerciseQstnID") & "' flg='2' QuesId='" & dr.Item("RspExcerciseQstnID") & "' RspDetId='" & dr.Item("RspDetID") & "' rows='4' placeholder='Write your response here' class='form-control' style='width:100%;border:1px solid #ccc;'></textarea></div>")
                'End If

            End If
            strTable.Append("</div></div></div>")

            strTable.Append("</div>")
            ' dvPageNumber.InnerHtml = "Page No : " & dr.Item("PgNmbr") & "/4"
        End While
        strTable.Append("</div>")
        dr.Close()
        strReturnVal = "1@" & strTable.ToString

        Return strReturnVal

    End Function

    Public Shared Function fnGetSubStatement(ByVal QstID As Integer, ByVal RsltVal As String, ByVal RspDetId As Integer, ByVal NoOfOptions As Integer, ByVal TypeID As Integer, ByVal MaxQstnSelected As Integer, ByVal SrlNmbr As String, ByVal strDisabled As String) As String
        Dim arrPara(1, 1) As String
        arrPara(0, 0) = QstID ' RspDetId '19
        arrPara(0, 1) = 0
        arrPara(1, 0) = RspDetId ' RspDetId '19
        arrPara(1, 1) = 0
        Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCon1 As SqlConnection = New SqlConnection
        Dim objCom1 As SqlCommand = New SqlCommand
        'Dim drdr1 As SqlDataReader
        objCom1.CommandTimeout = 0
        Dim ds As New DataSet
        Dim strInnerTable As New StringBuilder
        Dim QstnValue As String
        Dim Value As String = ""
        Dim ctr As Integer = 0
        ds = objAdo.RunSPDS("spGetSubStatement_WithSuffle", arrPara)
        Dim cntr As Integer = 0
        Dim flagCount As Integer = 0
        Dim arrStrAnswrVal As String() = RsltVal.Split("^")
        If ds.Tables(0).Rows.Count > 0 Then

            If TypeID = 3 Then  'for Checkbox
                Dim checked As String = ""
                strInnerTable.Append("<div id='tblChk' class=''>")
                For k As Integer = 0 To ds.Tables(0).Rows.Count - 1
                    QstnValue = ds.Tables(0).Rows(k)("RspExcerciseSubQstnID")
                    strInnerTable.Append("<div class='form-check'>")
                    If (RsltVal.Contains(QstnValue)) Then
                        checked = " checked "
                    Else
                        checked = ""
                    End If
                    If ((RsltVal <> "") And (RsltVal <> "0")) Then

                        strInnerTable.Append("<input type='checkbox' " & strDisabled & " class='form-check-input' SrlNmbr = " & SrlNmbr & " maxQstnSelected=" & MaxQstnSelected & " RspDetID = " & RspDetId & " value = '" & QstnValue & "'  " & checked & " id='chkAns" & RspDetId & "^" & (k + 1) & "'  name = '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label></div>")
                    Else
                        strInnerTable.Append("<input type='checkbox' " & strDisabled & " class='form-check-input' SrlNmbr = " & SrlNmbr & " maxQstnSelected=" & MaxQstnSelected & " RspDetID = " & RspDetId & " value = '" & QstnValue & "'  id='chkAns" & RspDetId & "^" & (k + 1) & "'  name = '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label></div>")
                    End If
                Next
                strInnerTable.Append("</div>")

            ElseIf TypeID = 1 Then  'for Radio
                flagCount = 0
                Dim countOfRowsForRank As Integer = ds.Tables(0).Rows.Count
                strInnerTable.Append("<div id='tblRdo' class=''>")
                For k As Integer = 0 To ds.Tables(0).Rows.Count - 1
                    QstnValue = ds.Tables(0).Rows(k)("RspExcerciseSubQstnID")
                    strInnerTable.Append("<div class='form-check'>")

                    If (RsltVal.Split("^")(0) <> "" And (CType(QstnValue, String)) = RsltVal.Split("^")(0)) Then
                        strInnerTable.Append("<input type='radio' " & strDisabled & " class='form-check-input' RspDetID = " & RspDetId & " value = " & QstnValue & " checked=true id='rdoAns" & k & "^" & (k + 1) & "'  name = '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label></div>")
                    Else
                        strInnerTable.Append("<input type='radio' " & strDisabled & " class='form-check-input' RspDetID = " & RspDetId & " value = " & QstnValue & "  id='rdoAns" & k & "^" & (k + 1) & "'  name = '" & RspDetId & "'>")
                        strInnerTable.Append("<label class='form-check-label'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</label></div>")
                    End If

                Next
                strInnerTable.Append("</div>")
            ElseIf TypeID = 2 Then  'for drop down

                strInnerTable.Append("<select id='ddl" & QstID & "'  " & strDisabled & " class='form-control'><option value='0'>- Select Rank- </option>")
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

            ElseIf TypeID = 4 Then  'for textbox
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
                        strInnerTable.Append("<input type='textbox' " & strDisabled & "  id='rdoAns" & k & "^" & (k + 1) & "' class='form-control' style='width:250px'>")
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("</tr>")
                    Else
                        strInnerTable.Append("<tr>")
                        strInnerTable.Append("<td style='width:40%'>")
                        strInnerTable.Append(ds.Tables(0).Rows(k)("Descr"))
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("<td>")
                        strInnerTable.Append("<input type='textbox'  " & strDisabled & "  id='rdoAns" & k & "^" & (k + 1) & "' class='form-control' style='width:250px'>")
                        strInnerTable.Append("</td>")
                        strInnerTable.Append("</tr>")

                    End If

                Next
                strInnerTable.Append("</table>")
            End If
        End If
        objAdo.CloseConnection(objCon1, objCom1)
        ' hdnRspIDStr.Value &= RspDetId & "^" & NoOfOptions & "^" & QstID & "^|"
        Return strInnerTable.ToString
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnStartMeetingTimer(ByVal RSPExerciseID As Integer, ByVal MeetingDefaultTIME As Integer) As String
        Dim strReturn As String = 1

        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spAssesmentCheckDiscussionStarted]", Objcon2)
        objCom2.Parameters.Add("@RspExerciseID", SqlDbType.Int).Value = RSPExerciseID
        objCom2.Parameters.Add("MeetingDefaultTIME", SqlDbType.Int).Value = MeetingDefaultTIME
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Dim da As New SqlDataAdapter(objCom2)
        Dim dt As New DataTable
        Try
            da.Fill(dt)
            strReturn = "0|" & dt.Rows(0)("flgReturnVal") & "|" & dt.Rows(0)("RemainingTimeMeeting") & "|" & dt.Rows(0)("flgMeetingStatusP") & "|" & dt.Rows(0)("flgMeetingStatusA") & "|" & dt.Rows(0)("PrepRemainingTime")
        Catch ex As Exception
            strReturn = "1|" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnUpdateTime(ByVal ExerciseID As Integer) As String
        Dim ObjclassUsedForExerciseSave As New classUsedForExerciseSave
        ObjclassUsedForExerciseSave.SpUpdateElaspedTime(ExerciseID)
        Return "0"
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function spUpdateResponsesForSJT(ByVal RSPExerciseID As Integer, Status As Integer, PGNmbr As Integer, objAnswer As Object, flgTimeOver As Integer) As String
        Dim strReturn As String = 1
        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")

        Dim tblAnswer As New DataTable()
        tblAnswer.TableName = "tblAnswers"
        Dim settings As New JsonSerializerSettings()
        settings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore
        Dim strTable As String = JsonConvert.SerializeObject(objAnswer, settings.ReferenceLoopHandling)

        tblAnswer = JsonConvert.DeserializeObject(Of DataTable)(strTable)

        If (tblAnswer.Rows.Count = 0) Then
            tblAnswer.Columns.Add("RspDetID", GetType(Int32))
            tblAnswer.Columns.Add("QstId", GetType(Int32))
            tblAnswer.Columns.Add("RspExerciseId", GetType(Int32))
            tblAnswer.Columns.Add("ActualAnswer", GetType(String))
        End If

        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spUpdateResponses]", Objcon2)
        objCom2.Parameters.Add("@RspExcersiseID", SqlDbType.Int).Value = RSPExerciseID
        objCom2.Parameters.Add("@LoginID", SqlDbType.Int).Value = LoginId
        objCom2.Parameters.Add("@Status", SqlDbType.Int).Value = Status
        objCom2.Parameters.Add("@flgTimeOver", SqlDbType.Int).Value = flgTimeOver
        objCom2.Parameters.Add("@PGNmbr", SqlDbType.Int).Value = PGNmbr
        objCom2.Parameters.AddWithValue("@RspActualAnswerDetail", tblAnswer)
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "1^"
            If Status = 2 Then
                Dim strReturn1 = fnUpdateActualStartEndTime(RSPExerciseID, 1, 2)
            End If
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
    Public Shared Function fnUpdateActualStartEndTime(ByVal RSPExerciseID As Integer, ByVal UserTypeID As Integer, ByVal flgAction As Integer) As String
        Dim strReturn As String = 1

        Dim LoginId As Integer
        LoginId = HttpContext.Current.Session("LoginId")
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spUpdateActualStartEndTime]", Objcon2)
        objCom2.Parameters.Add("@RspExerciseID", SqlDbType.Int).Value = RSPExerciseID
        objCom2.Parameters.Add("@UserTypeID", SqlDbType.Int).Value = UserTypeID
        objCom2.Parameters.Add("@flgAction", SqlDbType.Int).Value = flgAction


        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "0|"
        Catch ex As Exception
            strReturn = "1|" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn

    End Function
End Class

