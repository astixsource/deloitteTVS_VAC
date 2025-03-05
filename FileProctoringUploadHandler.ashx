<%@ WebHandler Language="C#" Class="FileProctoringUploadHandler" %>

using System;
using System.Web;
using System.IO;
using Ionic.Zip;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Text;
public class FileProctoringUploadHandler : IHttpHandler
{

    int mFileSize = 0;
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            if (context.Request.QueryString["flgfilefolderid"].ToString() == "1") //For Selfie snapshots functionality
            {
                string Serverpath = context.Request.Form["FolderName"].ToString();
                int RspID = int.Parse(context.Request.Form["RspID"].ToString());
                int RSPExerciseID = int.Parse(context.Request.Form["RSPExerciseID"].ToString());
                int LoginId = int.Parse(context.Request.Form["LoginId"].ToString());
                string pageLocation = context.Request.Form["PageLocation"].ToString();
                string Savepath = context.Server.MapPath("~/" + Serverpath);

                if (!Directory.Exists(Savepath))
                    Directory.CreateDirectory(Savepath);
                for (int i = 1; i < 4; i++)
                {
                    string imageData = context.Request.Form["ImageData" + i.ToString()].ToString();
                    DateTime picTime = DateTime.Now;
                    string picName = LoginId + "_" + RSPExerciseID + "_" + i.ToString() + "_" + picTime.ToString("ddMMyyyyHHmmss") + ".jpg";
                    using (FileStream fs = new FileStream(Savepath + "/" + picName, FileMode.Create))
                    {
                        using (BinaryWriter bw = new BinaryWriter(fs))
                        {
                            byte[] data = Convert.FromBase64String(imageData);
                            bw.Write(data);
                            bw.Close();
                        }
                    }

                    SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                    Scon.Open();
                    SqlCommand Scmd = new SqlCommand();
                    Scmd.Connection = Scon;
                    Scmd.CommandText = "[spManageUserpic]";
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.Parameters.AddWithValue("@EmpId", LoginId);
                    Scmd.Parameters.AddWithValue("@PicName", picName);
                    Scmd.Parameters.AddWithValue("@PicTakenTime", picTime);
                    Scmd.Parameters.AddWithValue("@PicTakenFrom", pageLocation);
                    Scmd.Parameters.AddWithValue("@RspExerciseId", RSPExerciseID);
                    Scmd.Parameters.AddWithValue("@ImgType", 2);
                    Scmd.CommandTimeout = 0;
                    Scmd.ExecuteNonQuery();
                    Scmd.Dispose();
                    Scon.Close();
                    Scon.Dispose();
                }

                //Set response message
                context.Response.Write("1|Success");
            }
            else if (context.Request.QueryString["flgfilefolderid"].ToString() == "2") //For snapshots functionality
            {
                string Serverpath = context.Request.Form["FolderName"].ToString();
                string imageData = context.Request.Form["ImageData"].ToString();
                int RspID = int.Parse(context.Request.Form["RspID"].ToString());
                int RSPExerciseID = int.Parse(context.Request.Form["RSPExerciseID"].ToString());
                int LoginId = int.Parse(context.Request.Form["LoginId"].ToString());
                string pageLocation = context.Request.Form["PageLocation"].ToString();

                string Savepath = context.Server.MapPath("~/" + Serverpath);

                if (!Directory.Exists(Savepath))
                    Directory.CreateDirectory(Savepath);
                DateTime picTime = DateTime.Now;
                string picName = LoginId + "_" + RSPExerciseID + "_" + picTime.ToString("ddMMyyyyHHmmss") + ".jpg";

                using (FileStream fs = new FileStream(Savepath + "/" + picName, FileMode.Create))
                {
                    using (BinaryWriter bw = new BinaryWriter(fs))
                    {
                        byte[] data = Convert.FromBase64String(imageData);
                        bw.Write(data);
                        bw.Close();
                    }
                }

                SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
                Scon.Open();
                SqlCommand Scmd = new SqlCommand();
                Scmd.Connection = Scon;
                Scmd.CommandText = "[spManageUserpic]";
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.Parameters.AddWithValue("@EmpId", LoginId);
                Scmd.Parameters.AddWithValue("@PicName", picName);
                Scmd.Parameters.AddWithValue("@PicTakenTime", picTime);
                Scmd.Parameters.AddWithValue("@PicTakenFrom", pageLocation);
                Scmd.Parameters.AddWithValue("@RspExerciseId", RSPExerciseID);
                Scmd.Parameters.AddWithValue("@ImgType", 1);

                Scmd.CommandTimeout = 0;
                Scmd.ExecuteNonQuery();
                Scmd.Dispose();
                Scon.Close();
                Scon.Dispose();

                //Set response message
                context.Response.Write("1|Success");
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




    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}