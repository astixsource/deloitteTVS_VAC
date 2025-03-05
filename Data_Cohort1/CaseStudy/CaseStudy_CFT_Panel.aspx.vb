
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports Newtonsoft.Json

Partial Class Data_Cohort1_CaseStudy_CaseStudy_CFT_Panel
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
        BandID = 1 ' IIf(IsNothing(Request.QueryString("BandID")), 0, Request.QueryString("BandID"))
        ExerciseType = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        hdnRspID.Value = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        hdnLoginID.Value = IIf(IsNothing(Session("LoginId")), 0, Convert.ToString(Session("LoginId")))
        ' hdnPageNmbr.Value = IIf(IsNothing(Request.QueryString("PGNmbr")), 0, Request.QueryString("PGNmbr"))

        If Not IsPostBack = True Then
            hdnRSPExerciseID.Value = IIf(IsNothing(Request.QueryString("RspExerciseID")), 0, Request.QueryString("RspExerciseID"))

            ' hdnIsProctoringEnabled.Value = IIf(IsNothing(Session("IsProctoringEnabled")), 0, Session("IsProctoringEnabled"))


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
                'If hdnExerciseStatus.Value = 2 Then
                '    hdnPageNmbr.Value = 1
                'Else
                '    hdnPageNmbr.Value = PNmbr
                '    ' Dim strReturn1 = fnUpdateActualStartEndTime(Convert.ToInt32(hdnRSPExerciseID.Value), 1, 1)
                'End If

            End If

            objAdo.CloseConnection(objCon, objcom, dr)

        End If



    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function spSubmitExercise(ByVal RSPExerciseID As Integer) As String
        Dim strReturn As String = 1

        Try

            strReturn = "1^"
            Dim strReturn1 = fnUpdateActualStartEndTime(RSPExerciseID, 1, 2)
        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
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
