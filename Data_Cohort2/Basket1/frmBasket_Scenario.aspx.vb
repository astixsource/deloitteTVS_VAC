Imports System.Data
Imports System.Data.SqlClient
Partial Class Set1_Basket_frmBasket_Instructions
    Inherits System.Web.UI.Page
    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Dim ExerciseID As Integer = 0
    Dim BandID As Integer = 0
    Dim ExerciseType As Integer = 0
    Public TimeAllotedSec As Integer = 0
    Dim arrPara(0, 1) As String
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../Login.aspx")
            Return
        End If
        BandID = IIf(IsNothing(Session("BandID")), 0, Session("BandID"))
        hdnExerciseID.Value = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        ExerciseType = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        hdnRspID.Value = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        hdnLoginID.Value = Session("LoginId")

        'If Not IsPostBack = True Then

        '    ReDim arrPara(3, 1)
        '    arrPara(0, 0) = hdnRspID.Value
        '    arrPara(0, 1) = "0"

        '    arrPara(1, 0) = hdnExerciseID.Value
        '    arrPara(1, 1) = "0"

        '    arrPara(2, 0) = hdnLoginID.Value
        '    arrPara(2, 1) = "0"

        '    arrPara(3, 0) = BandID
        '    arrPara(3, 1) = "0"

        '    Dim objCon As New SqlConnection
        '    Dim objcom As New SqlCommand
        '    objcom.CommandTimeout = 0
        '    Dim dr As SqlDataReader

        '    dr = objAdo.RunSP("[spRspExerciseManage]", arrPara, 0, objCon, objcom)

        '    If dr.HasRows Then
        '        dr.Read()
        '        hdnRSPExerciseID.Value = Convert.ToInt32(IIf(IsNothing(dr.Item("RSPExerciseID")), 0, dr.Item("RSPExerciseID")))
        '        Dim PrepStatus = Convert.ToInt32(IIf(IsNothing(dr.Item("PrepStatus")), 0, dr.Item("PrepStatus")))
        '        Dim MeetingStatus = Convert.ToInt32(IIf(IsNothing(dr.Item("MeetingStatus")), 0, dr.Item("MeetingStatus")))

        '        'If PrepStatus = 0 Then
        '        '    fnUpdateActualStartEndTime(hdnRSPExerciseID.Value, 1, 1)
        '        'End If
        '        Dim PrepRemainingTime = IIf(IsNothing(dr.Item("PrepRemainingTime")), 0, dr.Item("PrepRemainingTime"))

        '        If (PrepStatus = 2) Then
        '            hdnCounter.Value = 0
        '        Else
        '            hdnCounter.Value = IIf(CInt(PrepRemainingTime) < 0, 0, PrepRemainingTime)
        '        End If
        '    End If

        '    objAdo.CloseConnection(objCon, objcom, dr)

        'End If

    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim BasketExcersiseID As Integer = IIf(IsNothing(Request.QueryString("ExerciseID")), 0, Request.QueryString("ExerciseID"))
        Dim ExerciseType As Integer = IIf(IsNothing(Request.QueryString("ExerciseType")), 0, Request.QueryString("ExerciseType"))
        Dim TimeAlloted As Integer = IIf(IsNothing(Request.QueryString("TotalTime")), 0, Request.QueryString("TotalTime"))
        Dim RspID As Integer = IIf(IsNothing(Request.QueryString("RspID")), 0, Request.QueryString("RspID"))
        Dim intLoginID As Integer = Session("LoginId") ' IIf(IsNothing(Request.QueryString("intLoginID")), 0, Request.QueryString("intLoginID"))

        Response.Redirect("MailFormat.aspx?ExerciseID=" & BasketExcersiseID & "&TotalTime=" & TimeAlloted & "&RspID=" & RspID & "&BandID=2" & "&ExerciseType=" & ExerciseType & "&intLoginID=" & intLoginID)
    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function fnUpdateTime(ByVal ExerciseID As Integer) As String
        Dim ObjclassUsedForExerciseSave As New classUsedForExerciseSave
        ObjclassUsedForExerciseSave.SpUpdateElaspedTime(ExerciseID)
        Return "0"
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnUpdateActualStartEndTime(ByVal RSPExerciseID As Integer, ByVal UserTypeID As Integer, ByVal flgAction As Integer) As String
        Dim strReturn As String = ""
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

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("frmBasket_InstructionsMain.aspx?RspID=" & hdnRspID.Value & "&ExerciseID=" & hdnExerciseID.Value)
    End Sub
End Class
