<%@ WebHandler Language="C#" Class="FileUploaderHandler" %>

using System;
using System.IO;
using System.Web;

public class FileUploaderHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            string res = "";
            HttpFileCollection files = context.Request.Files;
            string filename = "";
            if (files.Count > 0)
            {
                string FileName = context.Request.Form["FileName"].ToString();
                string EmpCode = context.Request.Form["EmpCode"].ToString();
                if (context.Request.Form["flg"].ToString() == "1")
                {
                    filename = "CV_" + EmpCode + "_" + DateTime.Now.ToString("ddMMyyyyhhmmss") + Path.GetExtension(FileName);
                }
                else if (context.Request.Form["flg"].ToString() == "2")
                {
                    filename = "PH_" + EmpCode + "_" + DateTime.Now.ToString("ddMMyyyyhhmmss") + Path.GetExtension(FileName);
                }
                else
                {
                    if (context.Request.Form["UserType"].ToString() == "1")
                    {
                        filename = "OS_" + EmpCode + "_" + DateTime.Now.ToString("ddMMyyyyhhmmss") + Path.GetExtension(FileName);
                    }
                    else
                    {
                        filename = "VD_" + EmpCode + "_" + DateTime.Now.ToString("ddMMyyyyhhmmss") + Path.GetExtension(FileName);
                    }
                }

                HttpPostedFile file = files[0];
                string fname = context.Server.MapPath("~/Files/" + filename);
                file.SaveAs(fname);
            }
            else
            {
                res = "2^Files not Found !";
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write(filename);
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