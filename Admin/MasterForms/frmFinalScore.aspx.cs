using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LogMeIn.GoToMeeting.Api;
using LogMeIn.GoToMeeting.Api.Model;
using LogMeIn.GoToMeeting.Api.Common;
using LogMeIn.GoToCoreLib.Api;
using System.Net.Mail;
using System.Net;
using ClosedXML.Excel;
using System.IO;

public partial class Admin_MasterForms_frmFinalScore : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            if (!IsPostBack)
            {
                Response.Cache.SetExpires(DateTime.UtcNow.AddDays(-1));
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetNoStore();

                hdnLogin.Value = Session["LoginId"].ToString();
                GetMaster();
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");
        }
    }


    private void GetMaster()
    {
        //SqlCommand Scmd = new SqlCommand();
        //Scmd.Connection = Scon;
        //Scmd.CommandText = "spGetAllEmployeeDetailsForMappingToCycle";
        //Scmd.CommandType = CommandType.StoredProcedure;
        //Scmd.CommandTimeout = 0;
        //Scmd.Parameters.AddWithValue("@TypeID", hdnFlg.Value);
        //SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        //DataSet Ds = new DataSet();
        //Sdap.Fill(Ds);
        //Scmd.Dispose();
        //Sdap.Dispose();

        //StringBuilder sb = new StringBuilder();
        //sb.Append("<option value='0'>-- Select --</option>");
        //for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        //{
        //    sb.Append("<option value='" + Ds.Tables[0].Rows[i]["EmpNodeID"] + "'>" + Ds.Tables[0].Rows[i]["FName"] + " ( " + Ds.Tables[0].Rows[i]["EmpCode"] + " )</option>");
        //}
        //hdnUserlst.Value = sb.ToString();

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAssessmentCycleDetail";
        Scmd.Parameters.AddWithValue("@CycleID", 0);
        Scmd.Parameters.AddWithValue("@Flag", 2);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dtBatch = new DataTable();
        Sdap.Fill(dtBatch);
        Scmd.Dispose();
        Sdap.Dispose();

        ddlBatch.Items.Add(new ListItem("-- Select --", "0"));
        foreach (DataRow dr in dtBatch.Rows)
        {
            ddlBatch.Items.Add(new ListItem(dr["CycleName"].ToString(), dr["CycleId"].ToString()));
        }
    }



    [System.Web.Services.WebMethod()]
    public static string fnGetEntries(string CycleId)
    {
        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetParticipantList";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        string[] SkipColumn = new string[1];
        SkipColumn[0] = "EmpNodeID";
        
        return CreateSchedulingTbl(Ds.Tables[0], SkipColumn, "tblScheduling", 2);
    }
    private static string CreateSchedulingTbl(DataTable dt, string[] SkipColumn, string tblname, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb_disabled = new StringBuilder();
        sb.Append("<div id='dvtblbody'><table id='" + tblname + "' class='table table-bordered bg-white table-sm clsTarget'>");
        sb.Append("<thead class='thead-light text-center'>");
        sb.Append("<tr>");
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
            {
                sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
            }
        }
        sb.Append("<th>Download</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr employeenodeid='"+ dt.Rows[i]["EmpNodeID"].ToString() + "'>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {                       
                     sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("<td><a href='#' onclick='fndownload(this);' style='color:blue' >Download</a></td>");
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table></div>");
        return sb.ToString();
    }
    private static string createRowMergeTbl(string[] SkipColumn, DataTable dt, string str, int RowMerge_Index)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i != 0)
                sb.Append("<tr>");
            else
                sb.Append("<td rowspan ='" + dt.Rows.Count + "' >" + str + "</td>");

            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (j <= RowMerge_Index)
                    {
                        DataTable temp_dt = dt.Select("[" + dt.Columns[j].ColumnName + "]='" + dt.Rows[i][j].ToString() + "'").CopyToDataTable();
                        if (temp_dt.Rows.Count > 1)
                        {
                            temp_dt.Columns.RemoveAt(j);
                            sb.Append(createRowMergeTbl(SkipColumn, temp_dt, dt.Rows[i][j].ToString(), RowMerge_Index - 1));
                            i = i + temp_dt.Rows.Count - 1;
                            break;
                        }
                        else
                        {
                            if (j > 7 && dt.Rows[i][j].ToString() == "")
                            {
                                sb.Append("<td class='cls-" + (j + 1).ToString() + " cls-bg-gray'>" + dt.Rows[i][j] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td class='cls-" + (j + 1).ToString() + "'>" + dt.Rows[i][j] + "</td>");
                            }
                        }

                    }
                    else
                    {
                        if (j > 7 && dt.Rows[i][j].ToString() == "")
                        {
                            sb.Append("<td class='cls-" + (j + 1).ToString() + " cls-bg-gray'>" + dt.Rows[i][j] + "</td>");
                        }
                        else
                        {
                            sb.Append("<td class='cls-" + (j + 1).ToString() + "'>" + dt.Rows[i][j] + "</td>");
                        }
                    }
                }
            }
            if (i != (dt.Rows.Count - 1))
            {
                sb.Append("</tr>");
            }
        }
        return sb.ToString();
    }


    protected void btndownload_click(object sender, EventArgs e)
    {
        string[] SkipColumn = new string[0];
        string filename = "";

        filename = "Score_" + hdnfilename.Value;//+"_"+ DateTime.Now.ToString("dd_MMM_yyyy_hhmmsstt");

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = null;
        SqlDataAdapter Sdap = null;

        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spDownloadFinalScore]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@EmpNodeId", hdnScore.Value.Split('^')[0]);
        Scmd.Parameters.AddWithValue("@CycleId", hdnScore.Value.Split('^')[1]);            

        Sdap = new SqlDataAdapter(Scmd);
        try
        {
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);

            using (XLWorkbook wb = new XLWorkbook())
            {
                ////Start Chassiss
                int k = 1; int j = 0; int colFreeze = 2; int colLeft = 3;
                string strold = ""; int cntc = 0; int colst = 2; bool flgb = true;

                int resulsetcnt = 1;
                foreach (DataRow drowchasiss in Ds.Tables[0].Rows)//For SheetName
                {
                    //string strSheetName = filename.Length > 31 ? filename.Substring(0, 28) + "..." : filename;
                    string strSheetName = drowchasiss["SheetName"].ToString().Length > 31 ? drowchasiss["SheetName"].ToString().Substring(0, 28) + "..." : drowchasiss["SheetName"].ToString();
                    DataTable dt = Ds.Tables[resulsetcnt];
                    resulsetcnt++;
                    var ws = wb.Worksheets.Add(strSheetName.Replace("/", "_"));
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
                                ws.Cell(k + i, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#728cd4");
                                ws.Cell(k + i, j + 1).Style.Font.FontColor = XLColor.FromHtml("#ffffff");
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

                    ws.Rows().AdjustToContents();
                    //var rangeWithData = ws.Cell(noofsplit + 1, 1).InsertData(dt.AsEnumerable());

                    //ws.Columns().AdjustToContents();//noofsplit + 1,  dt.Columns.Count

                    //-- Body ---
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        for (j = 0; j < dt.Columns.Count; j++)
                        {
                            ws.Cell(noofsplit + i + 1, j + 1).Value = dt.Rows[i][j].ToString().Split('^')[0];
                            ws.Cell(noofsplit + i + 1, j + 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                        }
                    }

                    if (strSheetName.ToLower() != "overall scoring")
                    {
                        //-------------------merge column in body-------------

                        //foreach (DataColumn col in dt.Columns)
                        //{
                        //    if (col.ColumnName.ToLower().IndexOf("score") != 1)
                        //    {
                        //        col.Ordinal
                        //    }
                        //}


                        /**/
                        int startindex = noofsplit + 1;
                        int endindex = 0;
                        bool isgroupstart = false;
                        string startval = "";

                        //string[] currColumn = { "0","1","2","3" };

                        string[] currColumn = { "0" };// dt.Rows[0][0].ToString().Split(',');
                        int currColumnIndex = 0;

                        for (j = 0; j < dt.Columns.Count; j++)
                        {

                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                if (currColumn.Length > 0 && j.ToString() == currColumn[currColumnIndex])
                                {
                                    if (isgroupstart == false && j.ToString() == currColumn[currColumnIndex] && dt.Rows[i][j].ToString().Trim() != "" && dt.Rows[i][j].ToString().ToLower().IndexOf("total") == -1)
                                    {
                                        startval = dt.Rows[i][j].ToString().Trim();
                                        isgroupstart = true;
                                        startindex = i + noofsplit + 1;
                                    }

                                    if (j.ToString() == currColumn[currColumnIndex])//&& dt.Rows[i][j].ToString() != "AA"
                                    {
                                        if (dt.Rows[i][j].ToString().Trim() != startval && isgroupstart == true)
                                        {
                                            endindex = i + noofsplit;
                                            if (startindex < endindex)
                                            {
                                                //ws.Rows(startindex, endindex).Group();
                                                ws.Range(ws.Cell(startindex, j + 1), ws.Cell(endindex, j + 1)).Merge();

                                                foreach (DataColumn col in dt.Columns)
                                                {
                                                    if (col.ColumnName.ToLower() == "behavior")
                                                    {
                                                        int indx = col.Ordinal;
                                                        if (dt.Rows[i - 1][indx].ToString() != "NA")
                                                        {
                                                            ws.Range(ws.Cell(startindex, indx + 1), ws.Cell(endindex, indx + 1)).Merge();
                                                        }

                                                    }
                                                }

                                                isgroupstart = false;

                                            }
                                            else if (startindex == endindex)
                                            {
                                                isgroupstart = false;
                                            }


                                            if (dt.Rows[i][j].ToString().ToLower().IndexOf("total") == -1 && i != dt.Rows.Count - 1 && dt.Rows[i][j].ToString().Trim() != startval)
                                            {
                                                startval = dt.Rows[i][j].ToString().Trim();
                                                startindex = i + noofsplit + 1;
                                                isgroupstart = true;
                                            }

                                        }

                                        //if (i == dt.Rows.Count - 1)
                                        //{
                                        //    isgroupstart = false;
                                        //    if (startindex < i + 2)
                                        //    {
                                        //        ws.Rows(startindex, i + 2).Group();
                                        //    }

                                        //}
                                    }

                                    if (j.ToString() == currColumn[currColumnIndex] && i == dt.Rows.Count - 1 && isgroupstart == true)
                                    {
                                        ws.Range(ws.Cell(startindex, j + 1), ws.Cell(i + 1 + noofsplit, j + 1)).Merge();
                                        isgroupstart = false;
                                        foreach (DataColumn col in dt.Columns)
                                        {
                                            //if (col.ColumnName.ToLower().IndexOf("behavior") != -1)
                                            if (col.ColumnName.ToLower() == "behavior")
                                            {
                                                int indx = col.Ordinal;
                                                if (dt.Rows[i][indx].ToString() != "NA")
                                                {
                                                    ws.Range(ws.Cell(startindex, indx + 1), ws.Cell(i + 1 + noofsplit, indx + 1)).Merge();
                                                }

                                            }
                                        }
                                        if (currColumnIndex < currColumn.Length - 1)
                                        {
                                            startindex = noofsplit + 1;
                                            isgroupstart = true;

                                            currColumnIndex++;
                                        }
                                    }
                                }

                            }
                        }

                    }

                    //------------------end merge column in body-----------

                    IXLCell cell3 = ws.Cell(1, 1);
                    IXLCell cell4 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);

                    //ws.Range(ws.Cell(k, 4), cell4).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                    ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                    ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    ws.SheetView.FreezeRows(noofsplit);
                    ws.SheetView.FreezeColumns(noofcolfreeze);
                    //}
                    ws.Columns().AdjustToContents();
                    ws.Rows().AdjustToContents();
                    ws.Range(1, 1, 1, dt.Columns.Count).Style.Alignment.WrapText = true;


                }
                //Export the Excel file.
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
            // string ProjectTitle = ConfigurationManager.AppSettings["Title"];
            //clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "FrmDownload Page", "Download Page", "Error in FrmDownload Page in " + ProjectTitle);
        }
        finally
        {
            Sdap.Dispose();
            Scmd.Dispose();
            Scon.Dispose();
        }
    }

}