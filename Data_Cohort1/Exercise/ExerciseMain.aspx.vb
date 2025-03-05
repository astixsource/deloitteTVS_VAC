Imports System.Data
Imports System.Data.SqlClient
Imports System.Net
Imports System.Security.Principal
Imports System.Web.Script.Serialization
Imports System.Text
Partial Class Set1_Main_frmExerciseMain_New
    Inherits System.Web.UI.Page
    Dim ExerciseID As Integer
    Dim TotalTime As Integer
    Dim ExerciseType As Integer
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load


        hdnLoginID.Value = IIf(IsNothing(Session("LoginId")), 0, Session("LoginId"))
        hdnCycleId.Value = IIf(IsNothing(Session("CycleId")), 0, Session("CycleId"))

        If hdnLoginID.Value = "" Then
            hdnLoginID.Value = 0
        End If
        If hdnCycleId.Value = "" Then
            hdnCycleId.Value = 0
        End If
        If hdnLoginID.Value = 0 Or hdnCycleId.Value = 0 Then
            Server.Transfer("../../frmSessionExpire.aspx")
            Return
        End If

        If Not IsPostBack Then
            hdnIsProctoringEnabled.Value = IIf(IsNothing(Session("IsProctoringEnabled")), 0, Session("IsProctoringEnabled"))

            fnCallspRspmain(hdnLoginID.Value)

        End If

    End Sub

    Sub fnCallspRspmain(ByVal LoginID As Integer)

        Dim strTable As New StringBuilder
        Dim strReturnVal As String = 1
        Dim srlNmCntr As Int16 = 1
        Dim strText As String = ""
        Dim objCon As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom As New SqlCommand("[spRspMain]", objCon)
        objCom.Parameters.Add("@LoginID", SqlDbType.Int).Value = hdnLoginID.Value
        objCom.Parameters.Add("@CycleID", SqlDbType.Int).Value = hdnCycleId.Value
        objCom.CommandType = CommandType.StoredProcedure
        Dim da As New SqlDataAdapter(objCom)
        Dim ds As New DataSet
        da.Fill(ds)


        If (ds.Tables(0).Rows(0).Item("flgFinalStatus") = 1) Then
            dvFinalmsg.InnerHtml = "Your assessment has been submitted successfully, you will soon receive the development plan."
            btnFinalSubmit.Enabled = True
            btnFinalSubmit.CssClass = "btns btn-submit"
        Else
            btnFinalSubmit.Enabled = False
            btnFinalSubmit.CssClass = "btns btn-cancel"
        End If

        If (ds.Tables(0).Rows(0).Item("FeedbackStatus") = 0 And ds.Tables(0).Rows(0).Item("flgFinalStatus") = 2) Then
            btnExperienceFeedback.Enabled = True
            btnExperienceFeedback.CssClass = "btns btn-submit"
        Else
            btnExperienceFeedback.Enabled = False
            btnExperienceFeedback.CssClass = "btns btn-cancel"
        End If

        If (ds.Tables(2).Rows.Count > 0) Then

            btnFeedbackSession.Text = "Flash Feedback Session at " + ds.Tables(2).Rows(0).Item("ExerciseStartTime")
            hdnFeedbackGoToMeetingURL.Value = ds.Tables(2).Rows(0).Item("AssesseMeetingLink")
        End If

        If ((ds.Tables(0).Rows(0).Item("FeedbackStatus") = 1 Or ds.Tables(0).Rows(0).Item("FeedbackStatus") = 3) And ds.Tables(0).Rows(0).Item("flgFinalStatus") = 2) Then
            btnFeedbackSession.Enabled = True
            btnFeedbackSession.CssClass = "btns btn-submit"
        Else
            btnFeedbackSession.Enabled = False
            btnFeedbackSession.CssClass = "btns btn-cancel"
        End If

        Dim classNameSts As String = ""
        Dim className As String = ""
        Dim bgImage As String = ""
        Dim ExerciseStatus As Integer = 0
        Dim btnText As String = ""
		     Dim SpanClass As String = ""

        Session("RspId") = ds.Tables(0).Rows(0).Item(0)
        hdnRspId.Value = ds.Tables(0).Rows(0).Item(0)
        hdnRspStatus.Value = ds.Tables(0).Rows(0).Item("flgFinalStatus")
        If ds.Tables(1).Rows.Count > 0 Then
            For Each row As DataRow In ds.Tables(1).Rows


                ExerciseStatus = row.Item("flgExerciseStatus")
                ExerciseID = row.Item("ExerciseID")
                TotalTime = row.Item("TotalTestTime")
                ExerciseType = row.Item("ExerciseType")

                If ExerciseStatus = 0 Then
                    className = "panel-box panel-box-default"
                    btnText = "Start"
                    '  SpanClass = "status_icon fa fa-ban"
                ElseIf ExerciseStatus = 1 Then
                    className = "panel-box panel-box-default"
                    btnText = "In Progress"
                    ' SpanClass = "status_icon fa fa-ban"
                Else



                    className = "panel-box panel-box-success"
                    btnText = "Completed"
                    ' SpanClass = "status_icon fa fa-check"
                End If
                btnText = IIf(ExerciseID = 12, "To Be Scheduled", btnText)


                If ExerciseID = 1 Or ExerciseID = 2 Or ExerciseID = 3 Then
                    bgImage = "../../Images/icoCaseStudy.png"
                ElseIf ExerciseID = 4 Or ExerciseID = 5 Or ExerciseID = 6 Then
                    bgImage = "../../Images/icoInbox.png"
                ElseIf ExerciseID = 7 Or ExerciseID = 8 Or ExerciseID = 9 Then
                    bgImage = "../../Images/icoTechnicalCase.png"
                ElseIf ExerciseID = 10 Or ExerciseID = 11 Then
                    bgImage = "../../Images/icoSJT.png"
                ElseIf ExerciseID = 12 Then
                    bgImage = "../../Images/icoCaseStudy.png"
                ElseIf ExerciseID = 13 Then
                    bgImage = "../../Images/icoTechnicalAssessment.png"
                Else
                    bgImage = "../../Images/icoManagerAssessment.png"
                End If

                strTable.Append("<div class='col-sm-3 col-md-3'>")
                strTable.Append("<div class='" & className & "'>")
                strTable.Append("<div class='panel-box-title'><img src ='" & bgImage & "' />")
                strTable.Append("<div class='panel-box-title-text'>")
                strTable.Append("<small>" & row.Item("Name") & "</small>")
                strTable.Append("</div>")
                strTable.Append("</div>")
                strTable.Append("<div class='panel-body pb-0'> <table class='table mb-0 clstblmain'><tbody>")
                strTable.Append("<tr>")
                strTable.Append("<td><b>Status</b> :</td>")
                strTable.Append("<td>")
                strTable.Append(row.Item("txtStatus"))
                strTable.Append("</td>")
                strTable.Append("</tr>")
                If ExerciseID <> 14 Then
                    strTable.Append("<tr>")
                    strTable.Append("<td><b>Total Time</b> :</td>")
                    strTable.Append("<td>")
                    strTable.Append(row.Item("TotalTestTime") & " Minutes")
                    strTable.Append("</td>")
                    strTable.Append("</tr>")
                Else
                    strTable.Append("<tr>")
                    strTable.Append("<td><b>Total Time</b> :</td>")
                    strTable.Append("<td>NA")
                    strTable.Append("</td>")
                    strTable.Append("</tr>")

                End If

                strTable.Append("</tbody></table></div>")
                strTable.Append("<div class='panel-footer'> ")
                If ExerciseID = 12 Then
                    strTable.Append(" <Input type='button' class='btn w-100' value='To Be Scheduled' id='btnTask_" & ExerciseID.ToString() & "'>")
                Else
                    If ExerciseStatus = 2 Then
                        strTable.Append(" <Input type='button' class='btn w-100' value='" & btnText & "' id='btnTask_" & ExerciseID.ToString() & "'>")
                    Else
                        strTable.Append("<input type='button' class='btn w-100' value='" & btnText & "' id='btnTask_" & ExerciseID.ToString() & "' onclick='fnOpenTest(" & hdnRspId.Value & "," & ExerciseID & "," & TotalTime & "," & ExerciseType & ", " & hdnLoginID.Value & ")'>")
                    End If
                End If



                ' strTable.Append("<input type='button' class='btn w-100' value='" & btnText & "' id='btnTask_" & ExerciseID.ToString() & "' onclick='fnOpenTest(" & hdnRspId.Value & "," & ExerciseID & "," & TotalTime & "," & ExerciseType & ", " & hdnLoginID.Value & ")'>")

                strTable.Append("</div></div></div>")
                'strTable.Append("</div>")
            Next
        Else
            strTable.Append("<div>")
            strTable.Append("No Record Found...")
            strTable.Append("</div>")
        End If

        dvExerciseName.InnerHtml = strTable.ToString
        ' strReturnVal = "1@" & HttpContext.Current.Server.HtmlDecode(strTable.ToString)

    End Sub


    <System.Web.Services.WebMethod(True)>
    Public Shared Function fnEnableExerciseAutomatically(ByVal RspID As Integer) As String
        Dim strReturn As String = "0^0"
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spGetExerciseWiseStartTimeForRSP]", Objcon2)
        objCom2.Parameters.Add("@RspID", SqlDbType.Int).Value = RspID
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Dim da As New SqlDataAdapter(objCom2)
        Try
            Dim dt As New DataTable
            da.Fill(dt)

            Dim resourceJSON = DataTableToJSONWithJavaScriptSerializer(dt)

            strReturn = "1^" + Convert.ToString(resourceJSON)

        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Dispose()
        End Try
        Return strReturn
    End Function

    Public Shared Function DataTableToJSONWithJavaScriptSerializer(ByVal table As DataTable) As String
        Dim jsSerializer As JavaScriptSerializer = New JavaScriptSerializer()
        Dim parentRow As List(Of Dictionary(Of String, Object)) = New List(Of Dictionary(Of String, Object))()
        Dim childRow As Dictionary(Of String, Object)

        For Each row As DataRow In table.Rows
            childRow = New Dictionary(Of String, Object)()

            For Each col As DataColumn In table.Columns
                childRow.Add(col.ColumnName, row(col))
            Next

            parentRow.Add(childRow)
        Next

        Return jsSerializer.Serialize(parentRow)
    End Function

    <System.Web.Services.WebMethod(True)>
    Public Shared Function SubmitFinalStatus() As String
        Dim strReturn As String = 1
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spGetStatusForExcercise]", Objcon2)
        objCom2.Parameters.Add("@RspID", SqlDbType.Int).Value = HttpContext.Current.Session("RspId")
        objCom2.Parameters.Add("@LoginId", SqlDbType.Int).Value = HttpContext.Current.Session("LoginId")
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()

            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter(objCom2)
            da.Fill(ds)

            Dim FinalStatus As Integer = ds.Tables(0).Rows(0).Item(0)
            If FinalStatus = 2 Then
                strReturn = "1^"
			else
                strReturn = "3^"
				'strReturn = "1^"
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

    Private Sub btnExperienceFeedback_Click(sender As Object, e As EventArgs) Handles btnExperienceFeedback.Click
        Response.Redirect("../Information/ParticipantExperienceEvaluation.aspx?RspID=" + hdnRspId.Value)
    End Sub



End Class
