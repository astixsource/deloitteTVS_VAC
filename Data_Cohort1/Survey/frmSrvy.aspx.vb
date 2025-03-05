Imports System.Data.SqlClient
Partial Class frmSrvy
    Inherits System.Web.UI.Page
    Dim arrPara(0, 1) As String
    Dim RspId As Integer
    Dim PgNmbr As Integer
    Dim Direction As Integer
    Dim intColorCount As Integer

    Dim drdr As SqlDataReader
    Dim objCon As SqlConnection
    Dim objCom As SqlCommand
    Dim objADO As New clsConnection.clsConnection(Convert.ToString(HttpContext.Current.Application("DbConnectionString")))

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load


        If Not IsPostBack Then
            RspId = Session("RspId")
            'RspId = 7
            PgNmbr = 1
            Direction = 0
            subPopulateQuestions(RspId, PgNmbr, Direction)
            intColorCount = 0
        End If
    End Sub
    Private Sub subPopulateQuestions(ByVal RspId As Integer, ByVal PgNmbr As Integer, ByVal Direction As Integer)

        Dim iCount As Integer = 0   '' For Saving Purpose

        Dim iCountQnsNmbr As Integer = 0  ' ' For Displaying the Question Number

        Dim intQnsType As Integer = 0

        Dim strOldQnsText As String = ""

        ReDim arrPara(2, 1)
        arrPara(0, 0) = RspId
        arrPara(0, 1) = 0
        arrPara(1, 0) = PgNmbr
        arrPara(1, 1) = 0
        arrPara(2, 0) = Direction
        arrPara(2, 1) = 0

        objCon = New SqlConnection
        objCom = New SqlCommand
        drdr = objADO.RunSP("spRspGetFeedbackQst", arrPara, 0, objCon, objCom)

        'drdr = objCommon.RunSP("spRspGetQst", arrPara, 0)

        Dim strTable As String = "<table class='table table-bordered' id='tblsvry'>"
        Dim oldGrpName As String = ""
        While (drdr.Read)
            Dim str As String

            If (IsDBNull(drdr.Item("QstnPartTxt"))) Then

                If (intQnsType <> drdr.Item("QstTypeId")) Then
                    strTable &= "<td width='3%' style='text-align:center;border:none;border-bottom:1px solid #ddd !important;'>&nbsp;"
                    strTable &= "</td>"
                    strTable &= "<td width='2%' style='border:none;border-bottom:1px solid #ddd !important;'>&nbsp;"
                    strTable &= "</td>"
                    If (iCount = 0) Then
                        strTable &= "<td width='55%'>&nbsp;"
                        strTable &= "</td>"
                        If Convert.ToInt16(drdr.Item("QstTypeId")) = 2 Then
                            'tdHead1.Attributes.Add("style", "Display:none")
                            strTable &= "</td>"
                        Else
                            'tdHead1.Attributes.Add("style", "Display:block;vertical-align:middle;")
                            strTable &= "<td width='40%'>"
                            strTable &= "</td>"
                        End If

                        strTable &= "<tr>"
                    Else
                        strTable &= "<td width='55%' style='border:none;border-bottom:1px solid #ddd !important;'>&nbsp;"
                        strTable &= "</td>"
                        strTable &= "<td width='40%' style='background: #2488C4; color:#FFF;'>" & fnCreateRadioButtonHeader(drdr.Item("QstTypeId"), drdr.Item("RspDetID"), iCount)
                        strTable &= "</td>"
                        strTable &= "<tr>"
                    End If

                End If

                strTable &= "<td width='3%' style='text-align:center;'><input type='hidden' id=hdnRspDetId" & iCount & " value=" & drdr.Item("RspDetID") & ">" & drdr.Item("Ordr")
                strTable &= "</td>"
                strTable &= "<td width='2%' id=td" & iCount & ">&nbsp;"
                strTable &= "</td>"
                strTable &= "<td width='55%'>" & drdr.Item("QstnHdrTxt")
                strTable &= "</td>"
                strTable &= "<td width='40%'>" & fnCreateRadioButton(drdr.Item("QstTypeId"), drdr.Item("RspDetID"), iCount, drdr.Item("RsltVal"), drdr.Item("NoOfOptions"))
                strTable &= "</td>"
                strTable &= "</tr>"
                strTable &= "<tr>"


                iCountQnsNmbr += 1

            ElseIf (Trim(drdr.Item("QstnHdrTxt")) <> Trim(strOldQnsText)) Then

                If (intQnsType <> drdr.Item("QstTypeId")) Then

                    strTable &= "<td  width='3%' style='text-align:center;'>&nbsp;"
                    strTable &= "</td>"
                    strTable &= "<td width='2%'>&nbsp;"
                    strTable &= "</td>"

                    If (iCount = 0) Then
                        strTable &= "<td width='55%'>&nbsp;"
                        strTable &= "</td>"
                        If Convert.ToInt16(drdr.Item("QstTypeId")) = 2 Then
                            'tdHead1.Attributes.Add("style", "Display:none")

                            strTable &= "<td width='55%'>&nbsp;"
                            strTable &= "</td>"
                        Else
                            ' tdHead1.Attributes.Add("style", "Display:block")
                            strTable &= "<td width='40%'>&nbsp;"
                            strTable &= "</td>"
                        End If
                        strTable &= "<tr>"
                    Else
                        strTable &= "<td  width='55%'>&nbsp;"
                        strTable &= "</td>"
                        strTable &= "<td  width='40%'>"
                        strTable &= "</td>"
                        strTable &= "<tr>"
                    End If
                End If

                strTable &= "<td  width='3%' style='text-align:center;'>" & drdr.Item("Ordr")
                strTable &= "</td>"
                strTable &= "<td width='2%'>&nbsp;"
                strTable &= "</td>"

                strTable &= "<td  width='55%'>" & drdr.Item("QstnHdrTxt")
                strTable &= "</td>"
                strTable &= "<td  width='40%'> &nbsp;"
                strTable &= "</td>"
                strTable &= "</tr>"

                strTable &= "<tr>"
                strTable &= "<td  width='3%' style='text-align:center;'><input type='hidden' id=hdnRspDetId" & iCount & " value=" & drdr.Item("RspDetID") & ">&nbsp;"
                strTable &= "</td>"
                strTable &= "<td width='2%'  id=td" & iCount & ">&nbsp;"
                strTable &= "</td>"

                strTable &= "<td  width='55%'><li>" & drdr.Item("QstnPartTxt")
                strTable &= "</td>"
                strTable &= "<td  width='40%'>" & fnCreateRadioButton(drdr.Item("QstTypeId"), drdr.Item("RspDetID"), iCount, drdr.Item("RsltVal"), drdr.Item("NoOfOptions"))
                strTable &= "</td>"
                strTable &= "</tr>"
                strTable &= "<tr>"

                iCountQnsNmbr += 1


            ElseIf (Trim(drdr.Item("QstnHdrTxt")) = Trim(strOldQnsText)) Then

                strTable &= "<td  width='3%' style='text-align:center;'><input type='hidden' id=hdnRspDetId" & iCount & " value=" & drdr.Item("RspDetID") & ">&nbsp;"
                strTable &= "</td>"
                strTable &= "<td width='2%' id=td" & iCount & ">&nbsp;"
                strTable &= "</td>"

                strTable &= "<td  width='55%'><li>" & drdr.Item("QstnPartTxt")
                strTable &= "</td>"
                strTable &= "<td  width='40%'>" & fnCreateRadioButton(drdr.Item("QstTypeId"), drdr.Item("RspDetID"), iCount, drdr.Item("RsltVal"), drdr.Item("NoOfOptions"))
                strTable &= "</td>"
                strTable &= "</tr>"
                strTable &= "<tr>"

            End If
            strTable &= "</tr>"

            strOldQnsText = drdr.Item("QstnHdrTxt")

            iCount += 1

            intQnsType = drdr.Item("QstTypeID")

            hdnPageNmbr.Value = drdr.Item("PgNmbr")

        End While

        drdr.NextResult()
        If drdr.HasRows Then
            drdr.Read()
            If drdr.Item("Cmnt") <> "" Then
                txtCmnt.Value = drdr.Item("Cmnt")
            Else
                txtCmnt.Value = ""
            End If
        Else
            txtCmnt.Value = ""
        End If

        hdnNoOfQuestions.Value = iCount

        '' **********************************************************************************
        Dim indx As Integer
        Dim strColor As String = ""
        strColor = "<table border='0' cellspacing='0' cellpadding=0 width='100%'><tr>"
        For indx = 0 To iCount - 1
            If (indx < intColorCount) Then
                strColor &= "<td id=tdColor" & indx & " bgColor='#008000'>&nbsp;&nbsp;</td>"
            Else
                strColor &= "<td id=tdColor" & indx & " bgColor='#FF0000'>&nbsp;&nbsp;</td>"
            End If
        Next
        strColor &= "</tr></table>"
        hdnColorCounter.Value = intColorCount - 1
        '  dvColor.InnerHtml = strColor

        '' **********************************************************************************

        strTable &= "</table>"

        dvSurvey.InnerHtml = strTable

        If (Trim(hdnPreviousSelected.Value) <> "") Then
            hdnPreviousSelected.Value = hdnPreviousSelected.Value.Substring(1)
        End If
        objADO.CloseConnection(objCon, objCom, drdr)
    End Sub

    Private Function fnCreateRadioButton(ByVal QstTypeId As Integer, ByVal RspDetId As Integer, ByVal iCount As Integer, ByVal RsltVal As Integer, ByVal NoOfOptions As Integer) As String
        Dim strTable As String = ""
        Select Case QstTypeId
            Case 1
                strTable = "<table  width='100%' border='0' cellspacing='0' cellpadding='0' class='border-0'><tr>" & fnCreateRadioBtnDetail(RspDetId, NoOfOptions, iCount, RsltVal) & "</tr></table>"
            Case 2
                strTable = "<table  width='100%' border='0' cellspacing='0' cellpadding='0' class='border-0'><tr>" & fnCreateRadioBtnDetail(RspDetId, NoOfOptions, iCount, RsltVal) & "</tr></table>"
            Case 3
                strTable = "<table  width='100%' border='0' cellspacing='0' cellpadding='0' class='border-0'><tr>" & fnCreateRadioBtnDetail(RspDetId, NoOfOptions, iCount, RsltVal) & "</tr></table>"
        End Select
        Return strTable
    End Function

    Private Function fnCreateRadioBtnDetail(ByVal RspDetId As Integer, ByVal NoOfOptions As Integer, ByVal iCount As Integer, ByVal RsltVal As Integer) As String
        Dim strRet As String = ""
        Dim indx As Integer = 0
        For indx = 0 To NoOfOptions - 1
            If indx = NoOfOptions - 1 Then
                If ((indx + 1) = RsltVal) Then
                    strRet &= "<td align='center' width='20%'><input type='radio' id='rdoAns" & RspDetId & "^" & (indx + 1) & "'  name=" & RspDetId & " checked  onclick=fnUpDateArray(" & iCount & ",'" & RspDetId & "^" & (indx + 1) & "')></td>"
                    hdnPreviousSelected.Value &= "@" & iCount & "|" & RspDetId & "^" & (indx + 1)
                    intColorCount += 1
                Else
                    strRet &= "<td align='center'><input type='radio' id='rdoAns" & RspDetId & "^" & (indx + 1) & "'  name=" & RspDetId & " onclick=fnUpDateArray(" & iCount & ",'" & RspDetId & "^" & (indx + 1) & "')></td>"
                End If
            Else
                If ((indx + 1) = RsltVal) Then
                    strRet &= "<td align='center'><input type='radio' id='rdoAns" & RspDetId & "^" & (indx + 1) & "'  name=" & RspDetId & " checked  onclick=fnUpDateArray(" & iCount & ",'" & RspDetId & "^" & (indx + 1) & "')></td>"
                    hdnPreviousSelected.Value &= "@" & iCount & "|" & RspDetId & "^" & (indx + 1)
                    intColorCount += 1
                Else
                    strRet &= "<td align='center'><input type='radio' id='rdoAns" & RspDetId & "^" & (indx + 1) & "'  name=" & RspDetId & " onclick=fnUpDateArray(" & iCount & ",'" & RspDetId & "^" & (indx + 1) & "')></td>"
                End If
            End If
        Next
        Return strRet
    End Function

    Private Function fnCreateRadioButtonHeader(ByVal QstTypeId As Integer, ByVal RspDetId As Integer, ByVal iCount As Integer) As String
        Dim strTable As String = ""
        Select Case QstTypeId
            Case 1
                strTable = "<table  width='100%'><tr><td width='15%' align='center'>Strongly Agree</td><td width='14%' align='center'>Agree</td><td width='14%' align='center'>Neutral</td><td width='14%' align='center'>Diagree</td><td width='14%' align='center'>Strongly Diagree</td></tr></table>"
            Case 2
                strTable = "<table  width='100%'><tr><td width='33%' align='center'>Yes, more positive</td><td width='33%' align='center'>Yes, more negative</td><td width='33%' align='center'>No</td></tr></table>"
            Case 3
                strTable = "<table  width='100%'><tr><td width='33%' align='center'>Just Right</td><td width='33%' align='center'>Too Late</td><td width='33%' align='center'>Too Early</td></tr></table>"
        End Select
        Return strTable
    End Function

    Private Sub btnSaveASP_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveASP.Click
        ReDim arrPara(3, 1)

        arrPara(0, 0) = Session("RspId")
        arrPara(0, 1) = 0

        arrPara(1, 0) = 1
        arrPara(1, 1) = 0

        arrPara(2, 0) = hdnResult.Value
        arrPara(2, 1) = 1

        arrPara(3, 0) = Replace(txtCmnt.Value, "'", "`")
        arrPara(3, 1) = 1


        objCon = New SqlConnection
        objCom = New SqlCommand
        objADO.RunSP("[spRSPUpdateFeedbackResponses]", arrPara, 1, objCon, objCom)
        objADO.CloseConnection(objCon, objCom)

        Response.Redirect("../Exercise/ExerciseMain.aspx")

    End Sub
End Class
