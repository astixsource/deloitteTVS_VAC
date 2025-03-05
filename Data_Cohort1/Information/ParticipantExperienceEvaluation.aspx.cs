using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using Newtonsoft.Json;

public partial class Admin_MasterForms_ParticipantExperienceEvaluation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

if (Session["LoginId"] == null)
        {
            Response.Redirect("../../Login.aspx");
            return;
        }
        if (!IsPostBack)
        {
            hdnLoginId.Value =Session["LoginId"].ToString();
            hdnRspID.Value =  Request.QueryString["RspID"] == null ? "0" : Request.QueryString["RspID"].ToString();
        }
    }

    [System.Web.Services.WebMethod()]    
    public static string GetDetails(string rspid)
    {
        StringBuilder sb = new StringBuilder();
        DataSet Ds = new DataSet();

        try
        {
            string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
            using (SqlConnection Scon = new SqlConnection(strConn))
            {
                using (SqlCommand Scmd = new SqlCommand())
                {
                    Scmd.Connection = Scon;

                    Scmd.CommandText = "[spGetRSPFeedbackResponse]";
                    Scmd.Parameters.AddWithValue("@RspId", rspid);
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.CommandTimeout = 0;

                    using (SqlDataAdapter Sdap = new SqlDataAdapter(Scmd))
                    {

                        Sdap.Fill(Ds);

                        Ds.Dispose();
                    }
                }
            }

            string[] val = { "MainQtn" };
            DataView view = new DataView(Ds.Tables[0]);
            DataTable distinctValues = view.ToTable(true, val);

            foreach (DataRow dr in distinctValues.Rows)
            {
                sb.Append("");
                sb.Append("<div class='form-group'>");
                sb.Append("<label for='ac' class='col-form- label'><strong>" + dr["MainQtn"].ToString() + "</strong></label>");
                //if (dr["TypeId"].ToString() == "6")
                //{
                //    getslider();
                //}
                DataTable dt = Ds.Tables[0].Select("MainQtn='" + dr["MainQtn"].ToString()+"'").CopyToDataTable();
                sb.Append(getslider(dt));
                sb.Append("</div >"); // end of form-group

                //sb.Append("<table style='width:100%;padding-bottom: 5px;'><tr style='font-size:16px;background-color: #23AED8;color: white;font-weight:bold;text-align: left;padding: 2px 0px 2px 4px; display: block; cursor:pointer;' onclick='fnShowHide(this);' flg='1'><td style='width:20px;'><img src='../NewImages/icoAdd.gif'/></td><td colspan='9'>" + dr["ChannelName"].ToString() + "</td></tr></table>");

                //DataTable dt = ds.Tables[0].Select("ChannelID=" + dr["ChannelID"].ToString()).CopyToDataTable();
                //sb.Append("<div style='padding:10px 0 30px 0; display:none;'>");
                //sb.Append(createStoretbl(dt, 1, true, "tblCatalogue"));
                //sb.Append("</div>");
            }

            return sb.ToString();// + "|" + Ds.Tables[1].Rows[0][0].ToString();
        }
        catch (Exception ex)
        {
            string str = ex.Message.ToString();
            return "";
        }
    }


    private static string getslider(DataTable dt)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            DataSet Ds = new DataSet();

            /*
            string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
            using (SqlConnection Scon = new SqlConnection(strConn))
            {
                using (SqlCommand Scmd = new SqlCommand())
                {
                    Scmd.Connection = Scon;

                    Scmd.CommandText = "[spGetOrderReturnStepsBySingleProduct]";
                    //Scmd.Parameters.AddWithValue("@OrderReturnDetailId", OrderReturnDetailId);
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.CommandTimeout = 0;

                    using (SqlDataAdapter Sdap = new SqlDataAdapter(Scmd))
                    {

                        Sdap.Fill(Ds);

                        Ds.Dispose();
                    }
                }
            }

            */

            sb.Append("");

            foreach (DataRow dr in dt.Rows)
            {
                if (dr["TypeId"].ToString() == "6")
                {
                    sb.Append("<div class='row mb-2'>");
                    sb.Append("<div class='col-sm-4'>");
                    sb.Append("" + dr["LeftDescr"].ToString() + "");
                    sb.Append("</div>");
                    sb.Append("<div class='col-sm-4'>");
                    sb.Append("<input type='text' id='amount1' readonly style='border:0; color:#f6931f; font-weight:bold;' RspExerciseSubQtsnId='" + dr["RspExcerciseSubQstnID"].ToString()+ "' Responses='" + dr["Responses"].ToString() + "' Value='" + dr["Responses"].ToString() + "' CssClass='form-control'>");
                    sb.Append("<div class='max-slider'></div>");
                    sb.Append("</div>");
                    sb.Append("<div class='col-sm-4'>");
                    sb.Append("" + dr["RightSideDescr"].ToString() + "");
                    sb.Append("</div>");
                    sb.Append("</div>"); // end of row mb-1
                }
                if (dr["TypeId"].ToString() == "4")
                {
                    sb.Append("<div class='row mb-1'>");
                    sb.Append("<div class='col-sm-4'>");
                    sb.Append("" + dr["LeftDescr"].ToString() + "");
                    sb.Append("</div> ");
                    sb.Append("<div class='col-sm-8'>");
                    sb.Append("<input type='text' id='amount1'  RspExerciseSubQtsnId='" + dr["RspExcerciseSubQstnID"].ToString() + "' Responses='" + dr["Responses"].ToString() + "' Value='" + dr["Responses"].ToString() + "' class='form-control form-control-sm'>");
                    sb.Append("</div>");
                    sb.Append("</div>");
                }
            }

            //if (typeid == "4")
            //{
            //    foreach (DataRow dr in dt.Rows)
            //    {
                    
            //    }

            //}
            return sb.ToString();

        }
        catch (Exception ex)
        {

            throw ex;
        }
    }


    [System.Web.Services.WebMethod()]
    public static string fnSave(object udt_DataSaving, string LoginId,string RspID)
    {
        string strResponse = "";
        try
        {
            string strDataSaving = JsonConvert.SerializeObject(udt_DataSaving, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtDataSaving = JsonConvert.DeserializeObject<DataTable>(strDataSaving);
            dtDataSaving.TableName = "udt_RspFeedbackResponsesDetail";
            if (dtDataSaving.Rows[0][0].ToString() == "0")
            {
                dtDataSaving.Rows[0].Delete();
            }


            string strConn = Convert.ToString(HttpContext.Current.Application["DbConnectionString"]);
            using (SqlConnection Scon = new SqlConnection(strConn))
            {
                using (SqlCommand Scmd = new SqlCommand())
                {
                    Scmd.Connection = Scon;

                    Scmd.CommandText = "[spManageRSPFeedbackResponse]";
                    Scmd.Parameters.AddWithValue("@RspId", RspID);
                    Scmd.Parameters.AddWithValue("@udt_RspFeedbackResponsesDetail", dtDataSaving);
                    Scmd.Parameters.AddWithValue("@LoginId", LoginId);
                    Scmd.CommandType = CommandType.StoredProcedure;
                    Scmd.CommandTimeout = 0;
                    Scon.Open();
                    Scmd.ExecuteNonQuery();

                    strResponse = "0|";
                }
            }
        }
        catch (Exception ex)
        {
            strResponse = "1|" + ex.Message;
        }
        return strResponse;
    }


    }