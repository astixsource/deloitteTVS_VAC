using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public partial class Admin_Setting_frmDownload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strReqData = Request.QueryString["strReqData"] == null ? "" : Request.QueryString["strReqData"].ToString();
        if (strReqData != "")
        {
            fnDownloadUserForEY(strReqData);
        }
    }
    private void fnDownloadUserForEY(string strReqData)
    {
            DataTable dt = new DataTable();
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            SqlTransaction transaction;
            Scon.Open();
            transaction = Scon.BeginTransaction();
            try
            {
                DataTable DtUsers = new DataTable();
                DtUsers.TableName = "DtUsers";
                DtUsers.Columns.Add("ID", typeof(int));
                DtUsers.Columns.Add("Val", typeof(string));
                for (int i=0;i< strReqData.Split('|').Length; i++)
                {
                    int BandID =int.Parse(strReqData.Split('|')[i].Split('^')[0]);
                    string Noofuser = strReqData.Split('|')[i].Split('^')[1];
                    DataRow drow = DtUsers.NewRow();
                    drow["ID"] = BandID;
                    drow["Val"] = Noofuser;
                    DtUsers.Rows.Add(drow);
                }
                
               
                Scmd.Connection = Scon;
                Scmd.Transaction = transaction;
                Scmd.CommandText = "[spDownloadAvailableUser]";
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.Parameters.AddWithValue("@NoOfUser", DtUsers);
                Scmd.Parameters.AddWithValue("@LoginId", HttpContext.Current.Session["LoginId"]);
                Scmd.CommandTimeout = 0;
                SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
                Sdap.Fill(dt);

                using (XLWorkbook wb = new XLWorkbook())
                {

                    int k = 1;
                    string strSheetName = "HDFCUserDump";

                    var ws = wb.Worksheets.Add(dt, strSheetName);

                    ws.Range(1, 1, 1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                    ws.Range(1, 1, 1, 3).Style.Fill.BackgroundColor = XLColor.FromHtml("#4f81bd");
                    ws.Range(1, 1, 1, 3).Style.Font.FontColor = XLColor.FromHtml("#ffffff");

                    ws.Columns().AdjustToContents();
                    ws.Rows().AdjustToContents();
                    IXLCell cell3 = ws.Cell(1, 1);
                    IXLCell cell4 = ws.Cell(dt.Rows.Count + 1, dt.Columns.Count);
                    ws.Range(ws.Cell(k, 4), cell4).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                    ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                    ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    ws.SheetView.FreezeRows(1);

                //Export the Excel file.
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                //Response.ContentType = "application/vnd.ms-excel";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + strSheetName+"_"+DateTime.Now.ToString("ddMMMyyyyhhmm") + ".xlsx");
                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    wb.SaveAs(MyMemoryStream);
                    MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                    HttpContext.Current.Response.Flush();
                    // HttpContext.Current.Response.End();
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                    Response.Close();
                }
            }
                    transaction.Commit();
            }
            catch (Exception ex)
            {
                transaction.Rollback();
            }
            finally
            {
                Scon.Close();
            }
        
        
    }
}