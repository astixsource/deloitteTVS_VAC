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

public partial class frmBEISchedulingList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginId"] != null && Session["LoginId"].ToString() != "")
        {
            hdnRoleId.Value = Session["RoleId"].ToString();
            hdnLogin.Value = Session["LoginId"].ToString();

            if (hdnRoleId.Value == "1")
            {
                fnBindAssessementList(0, 2, hdnRoleId.Value);
            }
            else
            {
                fnBindAssessementList(0, 1, hdnRoleId.Value);
            }
        }
        else
        {
            Response.Redirect("../../Login.aspx");

        }
    }

    private void fnBindAssessementList(int CycleID, int Flag, string RoleId)
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        if (RoleId == "1")
        {
            Scmd.CommandText = "spGetAssessmentCycleDetail";
            Scmd.Parameters.AddWithValue("@CycleID", CycleID);
            Scmd.Parameters.AddWithValue("@Flag", Flag);
        }
        else
        {
            Scmd.CommandText = "spGetCycleNameAgAssessor";
            Scmd.Parameters.AddWithValue("@LoginID", hdnLogin.Value);

        }

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
				 if (Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy") == DateTime.Now.ToString("dd MMM yy"))
                {
                    itm.Selected = true;
                }
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


    //Get Scheme And Product Detail Bases on Store
    [System.Web.Services.WebMethod()]
    public static string fnGetBEIScheduleList(int CycleID)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        DataSet Ds = null;
        string stresponse = "";
        try
        {
            string storedProcName = "spGetBEIScheduledList";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@CycleId", CycleID),
                };
            Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);

            StringBuilder str = new StringBuilder();
            if (Ds.Tables[0].Rows.Count > 0)
            {
                string[] SkipColumn = new string[1];
                SkipColumn[0] = "CycleStartDate";
                str.Append("<div id='dvtblbody' class='mb-3'><table id='tbldbrlist' class='table table-bordered table-sm mb-0'><thead><tr>");
                str.Append("<th style='width:6%' >SrNo</th>");
                for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                {
                    if (SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName))
                    {
                        continue;
                    }
                    string sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                    str.Append("<th>" + sColumnName + "</th>");
                }
                str.Append("</tr></thead><tbody>");

                for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
                {
                    str.Append("<tr>");
                    str.Append("<td style='text-align:center'>" + (i + 1) + "</td>");
                    for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                    {
                        string sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                        if (SkipColumn.Contains(sColumnName))
                        {
                            continue;
                        }
                        var sData = Ds.Tables[0].Rows[i][j];

                        string flgSearchable = "Searchable='1'";
                        str.Append("<td " + flgSearchable + ">" + sData + "</td>");
                    }
                    str.Append("</tr>");
                }
                str.Append("</tbody></table></div>");
            }
            else
            {
                str.Append("");
            }
            stresponse = str.ToString();
        }
        catch (Exception ex)
        {
            stresponse = "2|" + ex.Message;
        }
        finally
        {
            con.Dispose();
        }

        return stresponse;
    }
}