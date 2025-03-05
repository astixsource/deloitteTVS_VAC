Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Public Class classUsedForExerciseSave
    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Dim arrPara(0, 1) As String


    Sub SpUpdateElaspedTime(ByVal exerciseId As Integer)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = 0
        arrPara(0, 1) = "0"

        arrPara(1, 0) = 10
        arrPara(1, 1) = "0"

        arrPara(2, 0) = exerciseId
        arrPara(2, 1) = "0"
        Dim Objcon As New SqlConnection
        Dim objCom As New SqlCommand
        objCom.CommandTimeout = 0
        objAdo.RunSP("SpUpdateElaspedTime", arrPara, 1, Objcon, objCom)
        objAdo.CloseConnection(Objcon, objCom)
    End Sub
    Sub SpUpdateElaspedTime1(ByVal exerciseId As Integer)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = 0
        arrPara(0, 1) = "0"

        arrPara(1, 0) = 10
        arrPara(1, 1) = "0"

        arrPara(2, 0) = exerciseId
        arrPara(2, 1) = "0"
        Dim Objcon As New SqlConnection
        Dim objCom As New SqlCommand
        objCom.CommandTimeout = 0
        objAdo.RunSP("SpUpdateElaspedTime", arrPara, 1, Objcon, objCom)
        objAdo.CloseConnection(Objcon, objCom)
    End Sub

Sub fnUpdateTime(ByVal RspExerciseID As Integer, ByVal TotalElapsedSec As Integer)
        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[SpUpdateElaspedMinSecTime]", Objcon2)
        objCom2.Parameters.Add("@RspExcersiseID", SqlDbType.Int).Value = RspExerciseID
        objCom2.Parameters.Add("@TimeInMin", SqlDbType.Int).Value = Math.Floor((TotalElapsedSec) / 60)
        objCom2.Parameters.Add("@TimeInSec", SqlDbType.Int).Value = TotalElapsedSec - (Math.Floor((TotalElapsedSec) / 60) * 60)
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
        Catch ex As Exception
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
    End Sub

    Sub SpTimeUpdateOnPause(ByVal hdnTimeElapsedMin As Integer, ByVal hdnTimeElapsedSec As Integer, ByVal hdnRSPExerciseID As Integer)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnTimeElapsedMin
        arrPara(0, 1) = "0"

        arrPara(1, 0) = hdnTimeElapsedSec
        arrPara(1, 1) = "0"

        arrPara(2, 0) = hdnRSPExerciseID
        arrPara(2, 1) = "0"
        Dim Objcon As New SqlConnection
        Dim objCom As New SqlCommand
        objCom.CommandTimeout = 0
        objAdo.RunSP("SpTimeUpdateOnPause", arrPara, 1, Objcon, objCom)
        objAdo.CloseConnection(Objcon, objCom)
    End Sub
    Sub SpRspExerciseSubmit(ByVal RspID As Integer, ByVal ExerciseID As Integer)
        ReDim arrPara(1, 1)
        arrPara(0, 0) = RspID
        arrPara(0, 1) = "0"

        arrPara(1, 0) = ExerciseID
        arrPara(1, 1) = "0"

        Dim Objcon1 As New SqlConnection
        Dim objCom1 As New SqlCommand
        objCom1.CommandTimeout = 0
        objAdo.RunSP("spRSPExerciseSubmit", arrPara, 1, Objcon1, objCom1)
        objAdo.CloseConnection(Objcon1, objCom1)
    End Sub
    Sub spRspSimplecaseUPDAnswers(ByVal hdnRspExcersiseID As Integer, ByVal LoginId As Integer, ByVal text1 As String, ByVal Status As Integer)

        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("spRspSimplecaseUPDAnswers", Objcon2)
        objCom2.Parameters.Add("@RspExerciseID", SqlDbType.Int).Value = hdnRspExcersiseID
        objCom2.Parameters.Add("@LoginId", SqlDbType.Int).Value = LoginId

        objCom2.Parameters.Add("@Cmnt1", SqlDbType.NVarChar).Value = text1
        objCom2.Parameters.Add("@Status", SqlDbType.Int).Value = Status

        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Objcon2.Open()
        objCom2.ExecuteNonQuery()
        objCom2.Dispose()
        Objcon2.Close()
        Objcon2.Dispose()
    End Sub

    Sub spRspScenarioUPDAnswers(ByVal hdnRpsID As Integer, ByVal LoginId As Integer, ByVal text1 As String, ByVal Status As Integer)

        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spRspScenarioUpdAnswers]", Objcon2)
        objCom2.Parameters.Add("@RspExerciseID", SqlDbType.Int).Value = hdnRpsID
        objCom2.Parameters.Add("@LoginId", SqlDbType.Int).Value = LoginId
        objCom2.Parameters.Add("@Cmnt1", SqlDbType.NVarChar).Value = text1
        objCom2.Parameters.Add("@Status", SqlDbType.Int).Value = Status

        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Objcon2.Open()
        objCom2.ExecuteNonQuery()
        objCom2.Dispose()
        Objcon2.Close()
        Objcon2.Dispose()
    End Sub

    Sub spRspSaveResponseFileName(ByVal exerciseID As Integer, ByVal LoginId As Integer, ByVal FileName As String, ByVal Status As Integer)

        Dim Objcon2 As New SqlConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
        Dim objCom2 As New SqlCommand("[spRspSaveResponseFileName]", Objcon2)
        objCom2.Parameters.Add("@RspExerciseID", SqlDbType.Int).Value = exerciseID
        objCom2.Parameters.Add("@LoginId", SqlDbType.Int).Value = LoginId
        objCom2.Parameters.Add("@FileName", SqlDbType.NVarChar).Value = FileName
        objCom2.Parameters.Add("@Status", SqlDbType.Int).Value = Status

        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Objcon2.Open()
        objCom2.ExecuteNonQuery()
        objCom2.Dispose()
        Objcon2.Close()
        Objcon2.Dispose()
    End Sub



End Class
