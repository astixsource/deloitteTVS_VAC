Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Partial Class frmBackground
    Inherits System.Web.UI.Page

    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))

    Dim ExerciseID As Integer = 0
    Dim BandID As Integer = 0
    Dim ExerciseType As Integer = 0
    Public TimeAllotedSec As Integer = 0
    Dim arrPara(0, 1) As String

    Dim ElapsedTimeMin As Integer = 0
    Dim ElapsedTimeSec As Integer = 0
    Dim TimeAlloted As Integer = 0
    Dim PGNmbr As Integer = 0
    Dim Direction As Integer = 0

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Server.Transfer("../Common/frmSessionExpire.aspx")
            Return
        End If


        hdnExerciseID.Value = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        BandID = IIf(IsNothing(Request.QueryString("BandID")), 0, Request.QueryString("BandID"))
        ExerciseType = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))

        PGNmbr = IIf(IsNothing(Request.QueryString("PGNmbr")), 0, Request.QueryString("PGNmbr"))
        hdnRspID.Value = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        hdnLoginID.Value = IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))


        If Not IsPostBack = True Then

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
            Dim strTable As New StringBuilder

            dr = objAdo.RunSP("[spRspExerciseManage]", arrPara, 0, objCon, objcom)

            If dr.HasRows Then
                dr.Read()

                hdnRSPExerciseID.Value = Convert.ToInt32(IIf(IsNothing(dr.Item("RSPExerciseID")), 0, dr.Item("RSPExerciseID")))
                Dim PrepStatus = Convert.ToInt32(IIf(IsNothing(dr.Item("PrepStatus")), 0, dr.Item("PrepStatus")))
                Dim MeetingStatus = Convert.ToInt32(IIf(IsNothing(dr.Item("MeetingStatus")), 0, dr.Item("MeetingStatus")))
                hdnPrepStatus.Value = PrepStatus
                hdnMeetingStatus.Value = MeetingStatus
                Dim MeetingRemainingTime = IIf(IsNothing(dr.Item("MeetingRemainingTime")), 0, dr.Item("MeetingRemainingTime"))
                hdnCounterRunTime.Value = MeetingRemainingTime
                hdnMeetingDefaultTime.Value = IIf(IsNothing(dr.Item("MeetingDefaultTime")), 0, dr.Item("MeetingDefaultTime"))
                If (MeetingStatus = 2) Then
                    hdnCounterRunTime.Value = 0
                Else
                    hdnCounterRunTime.Value = IIf(CInt(MeetingRemainingTime) < 0, 0, MeetingRemainingTime)
                End If

                Dim PrepRemainingTime = IIf(IsNothing(dr.Item("PrepRemainingTime")), 0, dr.Item("PrepRemainingTime"))
                If (PrepStatus = 2) Then
                    hdnCounter.Value = 0
                Else
                    hdnCounter.Value = IIf(CInt(PrepRemainingTime) < 0, 0, PrepRemainingTime)
                End If


                hdnGoToMeetingURL.Value = IIf(IsDBNull(dr.Item("MeetingLink")), "", dr.Item("MeetingLink"))

            End If
        End If
    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function fnSubmit(ByVal ExerciseID As Integer, ByVal RSPExerciseID As Integer) As String

        Dim strReturn = fnUpdateActualStartEndTime(RSPExerciseID, 1, 4)
        If strReturn = "0|" Then
            strReturn = "1^"
        Else
            strReturn = "2^"
        End If
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
            strReturn = "0|" & dt.Rows(0)("flgReturnVal") & "|" & dt.Rows(0)("RemainingTimeMeeting")
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
    Public Shared Function fnUpdateTime(ByVal RspExerciseID As Integer, ByVal TotalElapsedSec As Integer) As String
        Dim ObjclassUsedForExerciseSave As New classUsedForExerciseSave
        ObjclassUsedForExerciseSave.SpUpdateElaspedTime(RspExerciseID)
        Return "0"
    End Function
End Class
