<%@ WebHandler Language="C#" Class="FileUploadHandler" %>

using System;
using System.Web;
using System.IO;
using Ionic.Zip;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Text;
public class FileUploadHandler : IHttpHandler
{

    int mFileSize = 0;
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            if (context.Request.QueryString["flgfilefolderid"].ToString() == "3")
            {
                //for deleting existing File by file name
                string Serverpath = System.Configuration.ConfigurationManager.AppSettings["FileFolderpath"];
                string filename = context.Request.QueryString["filefolderid"].ToString();
                Serverpath = context.Server.MapPath(Serverpath) + "\\" + filename;

                if (File.Exists(Serverpath))
                {
                    File.Delete(Serverpath);
                    string msg = "1";
                    context.Response.Write(msg);
                }
                else
                {
                    string msg = "3";
                    context.Response.Write(msg);
                }
            }
            else if (context.Request.QueryString["flgfilefolderid"].ToString() == "2")
            {
                //for downloading existing File
                string filepath = System.Configuration.ConfigurationManager.AppSettings["FileFolderpath"];
                string file = context.Request.QueryString["filefolderid"].ToString();
                string Savepath = context.Server.MapPath("~/" + filepath);
                string fileExt = context.Request.QueryString["fileExt"].ToString();
                string FileName = context.Request.QueryString["FileName"].ToString() + "." + fileExt;
                if (File.Exists(Savepath + "\\" + file + "." + fileExt))
                {
                    context.Response.Clear();
                    context.Response.ContentType = "application/octet-stream";
                    context.Response.AddHeader("Content-Disposition", string.Format("attachment; filename=\"{0}\"", FileName));
                    context.Response.WriteFile(Savepath + "\\" + file + "." + fileExt);
                    context.Response.Flush();
                    context.Response.End();
                }
                else
                {
                    context.Response.Write("Sorry,File Not Found!!!");
                }
            }
            else if (context.Request.QueryString["flgfilefolderid"].ToString() == "5")
            {
                //for downloading existing File
                string filepath = System.Configuration.ConfigurationManager.AppSettings["FileFolderpath"];
                string Savepath = context.Server.MapPath("~/" + filepath);
                string FileName = context.Request.QueryString["FileName"].ToString();
                string OFileName = context.Request.QueryString["OFileName"].ToString();
                if (File.Exists(Savepath + "\\" + FileName))
                {
                    context.Response.Clear();
                    context.Response.ContentType = "application/octet-stream";
                    context.Response.AddHeader("Content-Disposition", string.Format("attachment; filename=\"{0}\"", OFileName));
                    context.Response.WriteFile(Savepath + "\\" + FileName);
                    context.Response.Flush();
                    context.Response.End();
                }
                else
                {
                    context.Response.Write("Sorry,File Not Found!!!");

                }
            }
            else if (context.Request.QueryString["flgfilefolderid"].ToString() == "6")
            {
                //for downloading existing File
                string filepath = System.Configuration.ConfigurationManager.AppSettings["FileFolderpath"];
                string Savepath = context.Server.MapPath("~/" + filepath);
                string EmployeeName = context.Request.QueryString["Employee"].ToString();
                string EmpId = context.Request.QueryString["EmpId"].ToString();
                string[] FileNames = HttpUtility.UrlDecode(context.Request.QueryString["fileName"].ToString()).Split(',');
                // string[] OFileNames = HttpUtility.UrlDecode(context.Request.QueryString["OFileName"].ToString()).Split(',');

                using (ZipFile zip = new ZipFile())
                {
                    zip.AlternateEncodingUsage = ZipOption.AsNecessary;
                    zip.AddDirectoryByName(EmployeeName);
                    string ResponseText = "";
                    foreach (string FileName in FileNames)
                    {
                        if (File.Exists(Savepath + FileName))
                        {
                            zip.AddFile(Savepath + FileName, EmployeeName);
                        }
                        else
                        {
                            ResponseText += " Sorry <b>" + FileName.Split('\\')[1] + "</b> Not Found!!! <br/>";
                        }
                    }
                    if (EmpId.Length > 0 && EmpId != "0")
                    {
                        string DodFile = GetMails(EmpId, EmployeeName);
                        zip.AddEntry(EmployeeName + "\\" + EmployeeName + "_InboxMail" + ".doc", "<html><head></head><body>" + DodFile + "</body></html>");
                    }
                    if (zip.Count < 2 && ResponseText.Length > 0)
                    {
                        context.Response.Write(ResponseText);
                        return;
                    }

                    context.Response.Clear();
                    context.Response.BufferOutput = false;
                    string zipName = String.Format(EmployeeName.Trim() + ".zip", DateTime.Now.ToString("yyyy-MMM-dd-HHmmss"));
                    context.Response.ContentType = "application/zip";
                    context.Response.AddHeader("content-disposition", "attachment; filename=" + zipName);
                    zip.Save(context.Response.OutputStream);
                    context.Response.End();
                }

            }
           
            else
            {
                //for uploading new File
                string Serverpath = context.Request.Form["FolderName"].ToString();
                var postedFile = context.Request.Files[0];
                // Get Server Folder to upload file
                //string strDate = context.Request.QueryString["flName"].ToString();
                string Savepath = context.Server.MapPath("~/" + Serverpath);
                string file = Path.GetFileName(postedFile.FileName);
                string fileWithoutExt = Path.GetFileNameWithoutExtension(postedFile.FileName);
                string fileExt = Path.GetExtension(postedFile.FileName);
                if (!Directory.Exists(Savepath))
                    Directory.CreateDirectory(Savepath);

                decimal filesize = Math.Round(((decimal)postedFile.ContentLength / (decimal)1024), 2);

                int RspID = int.Parse(context.Request.Form["RspID"].ToString());
                int RSPExerciseID = int.Parse(context.Request.Form["RSPExerciseID"].ToString());
                int LoginId = int.Parse(context.Request.Form["LoginId"].ToString());

                fileWithoutExt = fileWithoutExt + "_" + RSPExerciseID + fileExt;
                string fileDirectory = Savepath + "\\" + fileWithoutExt;
                postedFile.SaveAs(fileDirectory);
                classUsedForExerciseSave ObjclassUsedForExerciseSave = new classUsedForExerciseSave();
                int Status = 2;

                ObjclassUsedForExerciseSave.spRspSaveResponseFileName(RSPExerciseID, LoginId, file, Status);




                //Set response message

                context.Response.Write("1|Success");
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("3|Error: " + ex.Message);
        }
    }

    public static string GetMails(string EmpId, string EmpName)
    {
        SqlConnection Scon = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spRptGetResponseAgExercise]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.Parameters.AddWithValue("@EmpNodeId", EmpId);
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet ds = new DataSet();
        Sdap.Fill(ds);

        string[] SkipColumn = new string[1];
        SkipColumn[0] = "EmpNodeId";

        StringBuilder sb = new StringBuilder();
        if (ds.Tables[0].Rows.Count > 0)
        {
            sb = new StringBuilder();

            sb.Append("<table style='margin: 0 auto; width:90%; font-weight: bold;font-family: Calibri, Gadget, sans-serif;'><tr><td style='color: blue; padding:0 0 10px 10px; font-size: 17px;'>Name</td><td>:</td><td style='font-size: 16px;'>" + EmpName + "</td></tr></table>");

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                sb.Append("<br/><br/><span style='font-size:15px; font-weight:bold; color: Orange; text-decoration:underline; font-family: Calibri, Gadget, sans-serif;'> Mail - " + (i + 1).ToString() + " : " + ds.Tables[0].Rows[i]["MailSubject"].ToString() + "</span><br/>");
                sb.Append("<table style='margin: 0 auto; width:90%; font-family: Calibri, Gadget, sans-serif; border:3px solid lightblue;padding:0;'>");
                if (ds.Tables[0].Rows[i]["Priority"].ToString() != "")
                {
                    sb.Append("<tr><td style='padding:5px 0 0 0; font-weight:bold; width:20%; font-size:13px;'>Priority</td><td>:</td><td style='font-size:13px;  '>" + ds.Tables[0].Rows[i]["Priority"].ToString() + "(" + ds.Tables[0].Rows[i]["PriorityText"].ToString() + ")</td></tr>");
                }
                if (ds.Tables[0].Rows[i]["Action"].ToString() != "")
                {
                    sb.Append("<tr><td style='padding:5px 0 0 0; font-weight:bold; width:20%; font-size:13px;'>Action</td><td>:</td><td style='font-size:13px;'>" + ds.Tables[0].Rows[i]["Action"].ToString() + "(" + ds.Tables[0].Rows[i]["ActionText"].ToString() + ")</td></tr>");
                }
                sb.Append("<tr><td colspan='3' style='padding:5px; background-color:gray; font-weight:bold; color:#ffffff;'>Content</td></tr>");
                sb.Append("<tr><td colspan='3' style='padding:10px;'>" + WebUtility.HtmlDecode(ds.Tables[0].Rows[i]["MailText"].ToString()) + "</td></tr>");
                sb.Append("</table>");
            }
            //WebUtility.HtmlDecode(ds.Tables[0].Rows[i]["MailText"].ToString())
            //sb.Append("</td></tr></table>");
            sb.Append("<table style='margin: 0 auto; width:90%; padding-top:5px;'>");
            sb.Append("<tr><td colspan='3' style='padding:20px 5px 5px 5px; font-size:15px; font-weight:bold; color: Orange; text-decoration:underline; border-bottom:3px solid lightblue;'>Feedback Form</td></tr>");
            for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
            {
                sb.Append("<tr style='border:3px solid lightblue;'><td style='padding:4px; font-weight:bold; width:50%;'>" + ds.Tables[1].Rows[i]["Qstn"].ToString() + "</td><td>:</td><td style='padding:4px; border:1px solid gray;'>" + ds.Tables[1].Rows[i]["Answ"].ToString() + "</td></tr>");
            }
            sb.Append("</table>");
        }
        else
        {
        }

        return sb.ToString();
    }




    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}