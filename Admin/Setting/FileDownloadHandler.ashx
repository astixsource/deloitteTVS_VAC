<%@ WebHandler Language="C#" Class="FileDownloadHandler" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;
using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using System.IO;

public class FileDownloadHandler : IHttpHandler, System.Web.SessionState.IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Session["LoginID"] == null || context.Session["LoginID"].ToString() == "")
        {
            context.Response.Write("Invalid Session!");
            return;
        }

        if (context.Request.QueryString["flg"] == "1")
        {
            string empId = context.Request.QueryString["EmpId"] == null ? "0" : context.Request.QueryString["EmpId"].ToString();
            string userCode = context.Request.QueryString["UserCode"] == null ? "0" : context.Request.QueryString["UserCode"].ToString();

            string result = DownloadSheet(empId, userCode);
            if (!string.IsNullOrWhiteSpace(result))
            {
                context.Response.Write(result);
            }
        }
        else
        {
            context.Response.Write("Invalid service call.");
        }
    }

    private string DownloadSheet(string empId, string userCode)
    {
        string result = "";
        try
        {
            DataSet Ds = new DataSet();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spGetUserResponsesDetail]";
            Scmd.Parameters.AddWithValue("@EmpNodeId", empId);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(Ds);

            if (Ds.Tables.Count == 0)
            {
                return "No data found!";
            }

            string[] SkipColumn = new string[1];
            SkipColumn[0] = "SheetName";
            using (XLWorkbook wb = new XLWorkbook())
            {
                for (int a = 0; a < Ds.Tables.Count; a++)
                {
                    string strSheetName = Ds.Tables[a].Rows[0]["SheetName"].ToString();
                    DataTable dt = Ds.Tables[a];

                    var ws = wb.Worksheets.Add(strSheetName.Replace("/", "_"));

                    string[] header_length = dt.Columns[1].ColumnName.ToString().Split('^');
                    int last_header_index = 0;
                    for (int i = 0; i < header_length.Length; i++)
                    {
                        for (int j = 0; j < dt.Columns.Count; j++)
                        {
                            if (Array.IndexOf(SkipColumn, dt.Columns[j].ColumnName.ToString()) == -1)
                            {
                                ws.Cell(i + 1, j + 1).Value = " " + dt.Columns[j].ColumnName.ToString().Split('^')[i];
                                ws.Cell(i + 1, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#8000ff");
                                ws.Cell(i + 1, j + 1).Style.Font.FontName = "Verdana";
                                ws.Cell(i + 1, j + 1).Style.Font.FontSize = 8;
                                ws.Cell(i + 1, j + 1).Style.Font.Bold = true;
                                ws.Cell(i + 1, j + 1).Style.Font.FontColor = XLColor.FromHtml("#ffffff");
                                ws.Cell(i + 1, j + 1).Style.NumberFormat.Format = "@";
                            }
                        }
                        //ws.Columns(i + 1, 1).Hide();
                        last_header_index = i + 1;
                    }

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        for (int j = 0; j < dt.Columns.Count; j++)
                        {
                            if (Array.IndexOf(SkipColumn, dt.Columns[j].ColumnName.ToString()) == -1)
                            {
                                ws.Cell(last_header_index + i + 1, j + 1).Value = dt.Rows[i][j].ToString();
                                ws.Cell(last_header_index + i + 1, j + 1).Style.Font.FontName = "Verdana";
                                ws.Cell(last_header_index + i + 1, j + 1).Style.Font.FontSize = 7.5;
                            }
                        }
                        //ws.Columns(last_header_index + i + 1, 1).Hide();
                    }

                    ws.Columns().AdjustToContents();
                    ws.Columns().Style.Alignment.WrapText = false;
                }

                string filename = "UserResponse_" + userCode + "_" + DateTime.Now.ToString("ddMMyyyyHHmmss");

                //Export the Excel file.
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
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
            result = ex.Message;
        }

        return result;
    }

    private void DownloadExcel(string reportName, string html, HttpContext context)
    {
        context.Response.Clear();
        context.Response.Charset = "";
        context.Response.ContentEncoding = System.Text.UTF8Encoding.UTF8;
        context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        context.Response.ContentType = "application/ms-excel.xls";
        string attachment = "attachment; filename=" + reportName + "_" + DateTime.Now.ToString("ddMMMyyyy_HHmmss") + ".xls";
        context.Response.AddHeader("content-disposition", attachment);
        context.Response.Write("<html><head></head><body>" + html + "</body></html>");
        context.Response.Flush();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}