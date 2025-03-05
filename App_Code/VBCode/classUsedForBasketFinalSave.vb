Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient


Public Class classUsedForBasketFinalSave
    Dim objAdo As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))
    Dim arrPara(0, 1) As String


    Sub SpUpdateElaspedTime(ByVal exerciseId As Integer)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = 0
        arrPara(0, 1) = "0"

        arrPara(1, 0) = 30
        arrPara(1, 1) = "0"

        arrPara(2, 0) = exerciseId
        arrPara(2, 1) = "0"

        Dim objCon As New SqlConnection
        Dim objCom As New SqlCommand
        objCom.CommandTimeout = 0
        objAdo.RunSP("SpUpdateElaspedTime", arrPara, 1, objCon, objCom)
        objAdo.CloseConnection(objCon, objCom)

    End Sub


    Sub SpTimeUpdateOnPause(ByVal hdnExerciseTotalTime As Integer, ByVal hdnRspExerciseMainID As Integer)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnExerciseTotalTime
        arrPara(0, 1) = "0"

        arrPara(1, 0) = 0
        arrPara(1, 1) = "0"

        arrPara(2, 1) = hdnRspExerciseMainID
        arrPara(2, 2) = "0"

        Dim objCon2 As New SqlConnection
        Dim objCom2 As New SqlCommand
        objCom2.CommandTimeout = 0
        objAdo.RunSP("SpTimeUpdateOnPause", arrPara, 1, objCon2, objCom2)
        objAdo.CloseConnection(objCon2, objCom2)

    End Sub

    Sub SpTimeUpdateOnPause1(ByVal hdnTimeElapsedMin As Integer, ByVal hdnTimeElapsedSec As Integer, ByVal hdnRspExerciseMainID As Integer)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnTimeElapsedMin
        arrPara(0, 1) = "0"

        arrPara(1, 0) = hdnTimeElapsedSec
        arrPara(1, 1) = "0"

        arrPara(2, 0) = hdnRspExerciseMainID
        arrPara(2, 1) = "0"

        Dim objCon3 As New SqlConnection
        Dim objCom3 As New SqlCommand
        objCom3.CommandTimeout = 0
        objAdo.RunSP("SpTimeUpdateOnPause", arrPara, 1, objCon3, objCom3)
        objAdo.CloseConnection(objCon3, objCom3)


    End Sub


    Sub SpRspExerciseSubmit(ByVal RSPID As Integer, ByVal ExerciseID As Integer)
        ReDim arrPara(1, 1)
        arrPara(0, 0) = RSPID
        arrPara(0, 1) = "0"

        arrPara(0, 1) = ExerciseID
        arrPara(1, 1) = "0"

        Dim objCon4 As New SqlConnection
        Dim objCom4 As New SqlCommand
        objCom4.CommandTimeout = 0
        objAdo.RunSP("spRSPExerciseSubmit", arrPara, 1, objCon4, objCom4)
        objAdo.CloseConnection(objCon4, objCom4)


    End Sub

    Sub spRspMultiMailUpdAnswers(ByVal hdnRspDetID_To As Integer, ByVal LoginId As Integer, ByVal txtTo As String)
        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnRspDetID_To
        arrPara(0, 1) = "0"

        arrPara(1, 0) = LoginId
        arrPara(1, 1) = "0"

        arrPara(2, 0) = txtTo.Replace("'", "''")
        arrPara(2, 1) = "1"

        Dim objCon5 As New SqlConnection
        Dim objCom5 As New SqlCommand
        objCom5.CommandTimeout = 0
        objAdo.RunSP("spRspMultiMailUpdAnswers", arrPara, 1, objCon5, objCom5)
        objAdo.CloseConnection(objCon5, objCom5)


    End Sub


    Sub spRspMultiMailUpdAnswers1(ByVal hdnRspDetID_CC As Integer, ByVal LoginId As Integer, ByVal txtCC As String)

        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnRspDetID_CC
        arrPara(0, 1) = "0"

        arrPara(1, 0) = LoginId
        arrPara(1, 1) = "0"

        arrPara(2, 0) = txtCC.Replace("'", "''")
        arrPara(2, 1) = "1"

        Dim objCon6 As New SqlConnection
        Dim objCom6 As New SqlCommand
        objCom6.CommandTimeout = 0
        objAdo.RunSP("spRspMultiMailUpdAnswers", arrPara, 1, objCon6, objCom6)
        objAdo.CloseConnection(objCon6, objCom6)


    End Sub

    Sub spRspMultiMailUpdAnswers2(ByVal hdnRspDetID_BCC As Integer, ByVal LoginId As Integer, ByVal txtBCC As String)

        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnRspDetID_BCC
        arrPara(0, 1) = "0"

        arrPara(1, 0) = LoginId
        arrPara(1, 1) = "0"

        arrPara(2, 0) = txtBCC.Replace("'", "''")
        arrPara(2, 1) = "1"


        Dim objCon7 As New SqlConnection
        Dim objCom7 As New SqlCommand
        objCom7.CommandTimeout = 0
        objAdo.RunSP("spRspMultiMailUpdAnswers", arrPara, 1, objCon7, objCom7)
        objAdo.CloseConnection(objCon7, objCom7)

    End Sub

    Sub spRspMultiMailUpdAnswers3(ByVal hdnRspDetID_Ans As Integer, ByVal LoginId As Integer, ByVal txtAnswer As String)

        ReDim arrPara(2, 1)
        arrPara(0, 0) = hdnRspDetID_Ans
        arrPara(0, 1) = "0"

        arrPara(1, 0) = LoginId
        arrPara(1, 1) = "0"

        arrPara(2, 0) = txtAnswer.Replace("'", "''")
        arrPara(2, 1) = "1"


        Dim objCon8 As New SqlConnection
        Dim objCom8 As New SqlCommand
        objCom8.CommandTimeout = 0
        objAdo.RunSP("spRspMultiMailUpdAnswers", arrPara, 1, objCon8, objCom8)
        objAdo.CloseConnection(objCon8, objCom8)

    End Sub



End Class
