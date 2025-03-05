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

public partial class M3_Rating_RatingStatus : System.Web.UI.Page
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
            hdnLoginId.Value = Session["LoginID"].ToString();
            fnBindAssessementList();
        }
        //frmGetStatus("1","1");
    }

    private void fnBindAssessementList()
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;

        Scmd.CommandText = "spGetCycleNameAgAssessor";
        Scmd.Parameters.AddWithValue("@LoginID", Session["LoginId"]);


        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dt = new DataTable();
        Sdap.Fill(dt);

        ListItem itm;//= new ListItem();
        //itm.Text = "All";
        //itm.Value = "0";
        //ddlCycle.Items.Add(itm);
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                itm = new ListItem();
                itm.Text = dr["CycleName"].ToString() + " (" + Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy") + ")";
                itm.Value = dr["CycleId"].ToString();
                ddlCycle.Items.Add(itm);
            }

        }
        else
        {
            itm = new ListItem();
            itm.Text = "No cycle mapped";
            itm.Value = "0";
            ddlCycle.Items.Add(itm);
        }

    }
    [System.Web.Services.WebMethod(enableSession: true)]
    public static string frmGetStatus(string loginId, string CycleId)
    {
        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spRatingAssessorGetExcerciseList]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@CycleId", CycleId);
        Scmd.Parameters.AddWithValue("@LoginId", loginId);
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);

       return createStoretbl(ds, 1, true);
    }


    [System.Web.Services.WebMethod()]
    public static object fnCheckComplition(string RSPExerciseid, string LoginId)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spRatingAssessorGetInCompleteExerciseList]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@RSPExerciseid", RSPExerciseid);
            //Scmd.Parameters.AddWithValue("@LoginId", LoginId);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter da = new SqlDataAdapter(Scmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            Scon.Dispose();
           string strResult = JsonConvert.SerializeObject(dt, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            return strResult;
        }
        catch (Exception ex)
        {
            return "1|"+ex.Message;
        }
    }

    private static string createStoretbl(DataSet ds, int headerlvl, bool IsHeader)
    {
        DataTable dt = ds.Tables[0];

        string[] SkipColumn = new string[8];
        SkipColumn[0] = "RspExerciseID";
        SkipColumn[1] = "ExerciseID";
        SkipColumn[2] = "Participant Name";
        SkipColumn[3] = "flgOverallStatus";
        SkipColumn[4] = "flgExerciseStatus";
        SkipColumn[5] = "BandID";
        SkipColumn[6] = "EmpNodeID";
        SkipColumn[7] = "RspId";




        if (ds.Tables[0].Rows.Count > 0)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<div id='dvtblbody'><table id='tbl_Status' class='table table-bordered table-sm bg-white'>");
            sb.Append("<thead >");
            string[] Collength = dt.Columns[2].ColumnName.ToString().Split('|')[0].Split('^');
            for (int k = 0; k < Collength.Length; k++)
            {
                sb.Append("<tr class='bg-blue text-white'>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()))
                    {
                        string[] ColSpliter = (dt.Columns[j].ColumnName.ToString().Split('|')[0].Trim()).Split('^');
                        if (ColSpliter[k] != "")
                        {
                            if (string.Join("", ColSpliter) == ColSpliter[k])
                            {
                                if (dt.Columns[j].ColumnName == "Participant Code")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>Participant Name</th>");
                                }
                                else if (dt.Columns[j].ColumnName == "Action")
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style='text-align:center'>Action</th>");
                                }
                                else
                                {
                                    sb.Append("<th rowspan='" + ColSpliter.Length + "' style=''>" + ColSpliter[k] + "</th>");
                                }
                                
                            }
                            else
                            {
                                string strrowspan = multilvlPopuptbl(dt, j, k);
                                sb.Append(strrowspan.Split('|')[0]);
                                j = j + Convert.ToInt32(strrowspan.Split('|')[1]) - 1;
                            }
                        }
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</thead>");
            sb.Append("<tbody>");
            string[] rowspanColumn = new string[1];
            rowspanColumn[0] = "Participant Code";
            foreach (DataRow Row in ds.Tables[0].Rows)
            {
               
                sb.Append("<tr RspExerciseID='" + Row["RspExerciseID"].ToString() + "' BandId='1'>");
                for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(ds.Tables[0].Columns[j].ColumnName.ToString()))
                    {
                        if (rowspanColumn.Contains(ds.Tables[0].Columns[j].ColumnName))
                        {
                            int Row_Span = 0;
                            DataRow drows = null;
                            Row_Span = dt.Select("[" + ds.Tables[0].Columns[j].ColumnName + "]='" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "'").Count();
                            drows = dt.Select("[" + ds.Tables[0].Columns[j].ColumnName + "]='" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "'")[0];
                            if (Row_Span > 1)
                            {
                                if (Row == drows)
                                {
                                    sb.Append(string.Format("<td rowspan='{0}' style='text-align:left'>{1}</td>", Row_Span, Row["Participant Name"]));
                                }
                            }
                            else
                            {
                                sb.Append(string.Format("<td  style='text-align:left;vertical-align:middle'>{1}</td>", Row_Span, Row["Participant Name"]));
                            }
                        }
                        else
                        {
                            if (ds.Tables[0].Columns[j].ColumnName == "Action")
                            {
                                if (Row["Action"].ToString() != "")
                                {
                                    sb.Append("<td style=''><a href='#' onclick='fnCaseStudy(1," + Row["RspExerciseID"].ToString() + ");'>" + Row["Action"].ToString() + "</a></td>");
                                }
                                else
                                {
                                    sb.Append("<td style='text-align:left;vertical-align:middle'>" + Row["Action"].ToString() + "</td>");
                                }
                            }
                            else
                            {
                                sb.Append("<td style='text-align:left;vertical-align:middle'>" + Row[ds.Tables[0].Columns[j].ColumnName].ToString() + "</td>");
                            }
                            
                        }
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table></div>");
            return sb.ToString();
        }
        else
        {
            return "<div style='padding : 10px 20px; color:red; font-weight:bold;'>No Record Found !</div>";
        }
    }
    private static string multilvlPopuptbl(DataTable dt, int col_ind, int row_ind)
    {
        int cntr = 1;
        string str = dt.Columns[col_ind].ColumnName.ToString().Split('|')[0].Split('^')[row_ind];
        for (int i = col_ind + 1; i < dt.Columns.Count; i++)
        {
            if (str == dt.Columns[i].ColumnName.ToString().Split('|')[0].Split('^')[row_ind])
            {
                cntr++;
            }
            else
            {
                break;
            }
        }
        return " <th colspan='" + cntr + "' style='color: #ffffff; background-color: #0080b9; border: 1px solid #dddddd;'> " + str + " </th>|" + cntr;
    }

    [System.Web.Services.WebMethod()]
    public static string SubmitWhenCompleteCBI(string RSPExerciseid)
    {
        using (SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"])))
        {
            using (SqlCommand Scmd = new SqlCommand())
            {
                Scmd.Connection = Scon;
                Scmd.CommandText = "[spUpdateCBIExerciseStatus]";
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.Parameters.AddWithValue("@RspExerciseID", RSPExerciseid);
                Scmd.Parameters.AddWithValue("@Status", 2);
                Scmd.Parameters.AddWithValue("@LoginId", HttpContext.Current.Session["LoginId"]);
                Scmd.CommandTimeout = 0;
                try
                {
                    Scon.Open();
                    Scmd.ExecuteNonQuery();
                    Scon.Close();
                    return "1^";
                }
                catch (Exception ex)
                {
                    return "2^" + ex.Message;
                }
            }
        }
    }
}