using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Xml;
using System.Text.RegularExpressions;
public partial class MasterForms_frmDownloadExcel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string[] notrowspanColumn = new string[0];
        string sFlg = Request.QueryString["flg"].ToString();//"1";//
        if (sFlg == "1")
        {
            string LoginId = Request.QueryString["LoginId"].ToString();// "01-Jul-2018";//
            string RSPExerciseid = Request.QueryString["RSPExerciseid"].ToString();// "01-Jul-2018";//
            fnRptDownloadCueSheet(RSPExerciseid, LoginId);
        }else if (sFlg == "2")
        {
            string CycleId = Request.QueryString["CycleId"].ToString();// "01-Jul-2018";//
            fnRptDownloadExperienceResponse(CycleId);
        }
    }

    public void fnRptDownloadCueSheet(string RSPExerciseid,string LoginId)
    {
        string[] SkipColumn = new string[0];
        int cntvalid = 0;
        string filename = "RatingCueSheet_" + DateTime.Now.ToString("yyyyMMdd");
        try
        {
            DataSet Ds = new DataSet();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAssessorGetRSPExerciseFullDetail_PopUp]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.Parameters.AddWithValue("@RSPExerciseId", RSPExerciseid);
            Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(Ds);
            using (XLWorkbook wb = new XLWorkbook())
            {
                cntvalid = 1;
                ////Start Chassiss
                int k = 1; int j = 0; int colFreeze = 2; int colLeft = 3;
                string strold = ""; int cntc = 0; int colst = 2; bool flgb = true;
                int resulsetcnt = 1;
                foreach (DataTable dt in Ds.Tables)//For SheetName
                {
                    string strSheetName = "Cue Sheet";
                    resulsetcnt++;
                    var ws = wb.Worksheets.Add(strSheetName);
                    k = 1; j = 0; colFreeze = 2; colLeft = 3;
                    strold = ""; cntc = 0; colst = 2; flgb = true; bool flgm = false;
                    //int rowstart = 0; // for data part insertion
                    int noofsplit = 1; //Convert.ToInt16(drowchasiss["NoOfSplit"]);
                    int noofcolfreeze = 0;// Convert.ToInt16(drowchasiss["Noofcolfreeze"]);
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        if (!SkipColumn.Contains(dt.Columns[c].ColumnName.ToString().Trim()))
                        {
                            string[] ColSpliter = dt.Columns[c].ColumnName.ToString().Split('^');
                            flgm = true;
                            for (var i = 0; i < ColSpliter.Length; i++)
                            {
                                string sVal = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                                ws.Cell(k + i, j + 1).Value = sVal.Split('^')[0];
                            }
                            for (var i = 0; i < noofsplit; i++)
                            {
                                string bgcolor = "#5151ff"; string forrecolor = "#ffffff";
                                ws.Cell(k + i, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml(bgcolor);
                                ws.Cell(k + i, j + 1).Style.Font.FontColor = XLColor.FromHtml(forrecolor);
                                ws.Cell(k + i, j + 1).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                                ws.Cell(k + i, j + 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                            }
                            j++;
                        }
                    }

                    for (var i = 0; i < noofsplit - 1; i++)
                    {
                        j = 0; colst = 1; k = 1; strold = "";
                        for (int c = 0; c < dt.Columns.Count; c++)
                        {
                            //if (strold != "")
                            //{
                            if (strold != dt.Columns[c].ColumnName.ToString().Split('^')[i])
                            {
                                flgb = true;
                                if (strold != "")
                                {
                                    ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j)).Merge();
                                }
                                cntc = 0;
                            }
                            //}
                            if (flgb == true)
                            {
                                colst = j + 1;
                            }
                            flgb = false;
                            strold = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                            cntc++;
                            if (c == dt.Columns.Count - 1)
                            {
                                ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j + 1)).Merge();
                                cntc = 0;
                            }

                            j++;
                        }
                    }


                    int rowst = 0;
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        strold = dt.Columns[c].ColumnName.ToString().Split('^')[0];
                        colst = 1; k = 1; flgb = false; rowst = 1;


                        for (var i = 0; i < noofsplit; i++)
                        {
                            //strold = "";                                                   
                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i, c + 1)).Merge();
                                flgb = false;
                                rowst++;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] == "")
                            {
                                flgb = true;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == false && i > 0)
                            {
                                rowst++;
                            }

                            if (i == noofsplit - 1 && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i + 1, c + 1)).Merge();
                            }
                        }
                    }
                    /**/
                   
                    var rangeWithData = ws.Cell(noofsplit + 1, 1).InsertData(dt.AsEnumerable());
                    ws.Columns().AdjustToContents();
                    //ws.Columns().AdjustToContents();//noofsplit + 1,  dt.Columns.Count

                    IXLCell cell3 = ws.Cell(1, 1);
                    IXLCell cell4 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);
                    IXLCell cell5 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);
                    ws.Range(ws.Cell(k, 2), cell5).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Left);
                    ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                    ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    ws.Column(1).Hide();
                   // ws.Range(ws.Cell(dt.Rows.Count + 1, 1), cell4).Style.Fill.BackgroundColor = XLColor.FromHtml("#d6d6d6");
                    //ws.Range(ws.Cell(dt.Rows.Count + 1, 1), cell4).Style.Font.FontColor = XLColor.FromHtml("#000000");
                    ws.SheetView.FreezeRows(noofsplit);
                    ws.SheetView.FreezeColumns(noofcolfreeze);

                   
                    //ws.Rows().AdjustToContents();
                    ws.Range(1, 1, 1, dt.Columns.Count).Style.Alignment.WrapText = true;
                }
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                //Response.ContentType = "application/vnd.ms-excel";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + filename + ".xlsx");
                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    wb.SaveAs(MyMemoryStream);
                    MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                    HttpContext.Current.Response.Flush();
                    HttpContext.Current.Response.End();
                }

            }
        }
        catch (Exception ex)
        {
            string sss = ex.Message;
        }
        finally
        {
        }
    }
    public void fnRptDownloadExperienceResponse(string CycleID)
    {
        string[] SkipColumn = new string[0];
        int cntvalid = 0;
        string filename = "ExperienceResponse_" + DateTime.Now.ToString("yyyyMMdd");
        try
        {
            DataSet Ds = new DataSet();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spDownloadRSPFeedbackExperience]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.Parameters.AddWithValue("@CycleID", CycleID);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(Ds);
            using (XLWorkbook wb = new XLWorkbook())
            {
                cntvalid = 1;
                ////Start Chassiss
                int k = 1; int j = 0; int colFreeze = 2; int colLeft = 3;
                string strold = ""; int cntc = 0; int colst = 2; bool flgb = true;
                int resulsetcnt = 1;
                foreach (DataTable dt in Ds.Tables)//For SheetName
                {
                    string strSheetName = "ExperienceResponses";
                    resulsetcnt++;
                    var ws = wb.Worksheets.Add(strSheetName);
                    k = 1; j = 0; colFreeze = 2; colLeft = 3;
                    strold = ""; cntc = 0; colst = 2; flgb = true; bool flgm = false;
                    //int rowstart = 0; // for data part insertion
                    int noofsplit = 1; //Convert.ToInt16(drowchasiss["NoOfSplit"]);
                    int noofcolfreeze = 0;// Convert.ToInt16(drowchasiss["Noofcolfreeze"]);
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        if (!SkipColumn.Contains(dt.Columns[c].ColumnName.ToString().Trim()))
                        {
                            string[] ColSpliter = dt.Columns[c].ColumnName.ToString().Split('^');
                            flgm = true;
                            for (var i = 0; i < ColSpliter.Length; i++)
                            {
                                string sVal = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                                ws.Cell(k + i, j + 1).Value = sVal.Split('^')[0];
                            }
                            for (var i = 0; i < noofsplit; i++)
                            {
                                string bgcolor = "#5151ff"; string forrecolor = "#ffffff";
                                ws.Cell(k + i, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml(bgcolor);
                                ws.Cell(k + i, j + 1).Style.Font.FontColor = XLColor.FromHtml(forrecolor);
                                ws.Cell(k + i, j + 1).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                                ws.Cell(k + i, j + 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                            }
                            j++;
                        }
                    }

                    for (var i = 0; i < noofsplit - 1; i++)
                    {
                        j = 0; colst = 1; k = 1; strold = "";
                        for (int c = 0; c < dt.Columns.Count; c++)
                        {
                            //if (strold != "")
                            //{
                            if (strold != dt.Columns[c].ColumnName.ToString().Split('^')[i])
                            {
                                flgb = true;
                                if (strold != "")
                                {
                                    ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j)).Merge();
                                }
                                cntc = 0;
                            }
                            //}
                            if (flgb == true)
                            {
                                colst = j + 1;
                            }
                            flgb = false;
                            strold = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                            cntc++;
                            if (c == dt.Columns.Count - 1)
                            {
                                ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j + 1)).Merge();
                                cntc = 0;
                            }

                            j++;
                        }
                    }


                    int rowst = 0;
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        strold = dt.Columns[c].ColumnName.ToString().Split('^')[0];
                        colst = 1; k = 1; flgb = false; rowst = 1;


                        for (var i = 0; i < noofsplit; i++)
                        {
                            //strold = "";                                                   
                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i, c + 1)).Merge();
                                flgb = false;
                                rowst++;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] == "")
                            {
                                flgb = true;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == false && i > 0)
                            {
                                rowst++;
                            }

                            if (i == noofsplit - 1 && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i + 1, c + 1)).Merge();
                            }
                        }
                    }
                    /**/

                    var rangeWithData = ws.Cell(noofsplit + 1, 1).InsertData(dt.AsEnumerable());
                    ws.Columns().AdjustToContents();
                    //ws.Columns().AdjustToContents();//noofsplit + 1,  dt.Columns.Count

                    IXLCell cell3 = ws.Cell(1, 1);
                    IXLCell cell4 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);
                    IXLCell cell5 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);
                    ws.Range(ws.Cell(k, 2), cell5).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Left);
                    ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                    ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    //ws.Column(1).Hide();
                    // ws.Range(ws.Cell(dt.Rows.Count + 1, 1), cell4).Style.Fill.BackgroundColor = XLColor.FromHtml("#d6d6d6");
                    //ws.Range(ws.Cell(dt.Rows.Count + 1, 1), cell4).Style.Font.FontColor = XLColor.FromHtml("#000000");
                    ws.SheetView.FreezeRows(noofsplit);
                    ws.SheetView.FreezeColumns(noofcolfreeze);


                    //ws.Rows().AdjustToContents();
                    ws.Range(1, 1, 1, dt.Columns.Count).Style.Alignment.WrapText = true;
                }
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                //Response.ContentType = "application/vnd.ms-excel";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + filename + ".xlsx");
                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    wb.SaveAs(MyMemoryStream);
                    MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                    HttpContext.Current.Response.Flush();
                    HttpContext.Current.Response.End();
                }

            }
        }
        catch (Exception ex)
        {
            string sss = ex.Message;
        }
        finally
        {
        }
    }

}