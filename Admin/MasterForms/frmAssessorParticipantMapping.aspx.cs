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

public partial class frmAssessorParticipantMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //LinkButton lnkHome = (LinkButton)Page.Master.FindControl("lnkHome");
        //lnkHome.Visible = false;
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        else {
            if (!IsPostBack)
            {
                hdnLoginId.Value = Session["LoginID"].ToString();
                fnBindAssessementList();
            }
        }
    }

    private void fnBindAssessementList()
    {

        SqlConnection Scon = new SqlConnection(Convert.ToString(HttpContext.Current.Application["DbConnectionString"]));
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetAssessmentCycleDetail";
        Scmd.Parameters.AddWithValue("@CycleID", 0);
		 Scmd.Parameters.AddWithValue("@Flag", 0);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dt = new DataTable();
        Sdap.Fill(dt);

            ListItem itm = new ListItem();
            itm.Text = "--------";
            itm.Value = "0";
            ddlCycle.Items.Add(itm);
        foreach (DataRow dr in dt.Rows)
        {
            itm = new ListItem();
            itm.Text = dr["CycleName"].ToString() + " (" +Convert.ToDateTime(dr["CycleStartDate"]).ToString("dd MMM yy")+")";
            itm.Value = dr["CycleId"].ToString();
            ddlCycle.Items.Add(itm);
        }
    }
    

    //Get Scheme And Product Detail Bases on Store
    [System.Web.Services.WebMethod()]
    public static string fnGetAssessorParticipantForMappingList(int CycleId)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        DataSet Ds = null;
        DataSet Ds1 = null;
        string stresponse = "";
        try
        {
            string storedProcName = "spGetAssessorParticipantForMapping";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@CycleId", CycleId),
                };
            Ds = clsDbCommand.ExecuteQueryReturnDataSet(storedProcName, con, sp);


            DataRow dr = Ds.Tables[1].NewRow();
            dr["AssessorCycleMappingId"] = "0";
            dr["AssessorName"] = "---Select---";
            Ds.Tables[1].Rows.InsertAt(dr,0);

            StringBuilder str = new StringBuilder();
            StringBuilder str1 = new StringBuilder();

            if (Ds.Tables[0].Rows.Count > 0)
            {
                string[] SkipColumn = new string[5];
                SkipColumn[0] = "ParticipantId";
                SkipColumn[1] = "ParticipantCycleMappingId";
                SkipColumn[2] = "AssessorCycleMappingId";
                SkipColumn[3] = "flgStatus";
                SkipColumn[4] = "MeetingId";


                int isSubmitted = 0;// int.Parse(Ds.Tables[1].Rows[0]["isSubmitted"].ToString());
                str.Append("<div id='dvtblbody' class='mb-3'><table id='tbldbrlist' class='table table-bordered table-sm mb-0' isSubmitted=" + isSubmitted + "><thead><tr>");

                //string ss = "style='text-align:center'";

                str.Append("<th style='width:6%' >SrNo</th>");
                for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                {
                    if (SkipColumn.Contains(Ds.Tables[0].Columns[j].ColumnName))
                    {
                        continue;
                    }
                    //ss = "style='text-align:center'";
                    string sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                    //if (sColumnName == "Route Name")
                    //{
                    //    ss = "style='width:35%'";
                    //}
                    str.Append("<th>" + sColumnName + "</th>");
                }
                str.Append("<th style='width:30%'>Developer</th>");
                str.Append("<th style='width:8%'></th>");
                str.Append("</tr></thead><tbody>");

                //ss = "";
                for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
                {

                    string dropdownlist_at = "";

                    //dropdownlist_at += "<option value='0'>--Select---</option>";
                    for (var j = 0; j < Ds.Tables[1].Rows.Count; j++)
                    {
                   if (Ds.Tables[0].Rows[i]["AssessorCycleMappingId"].ToString() == Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString())
                        {
                            dropdownlist_at += "<option value='" + Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() + "' selected>" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "</option>";
                        }
                   else
                        {
                            dropdownlist_at += "<option value='" + Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() + "'>" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "</option>";
                        }                        
                    }
                    string ParticipantCycleMappingId = Ds.Tables[0].Rows[i]["ParticipantCycleMappingId"].ToString();
                    int flgMapped = Convert.ToInt32(Ds.Tables[0].Rows[i]["AssessorCycleMappingId"]);
                    int flgStatus = Convert.ToInt32(Ds.Tables[0].Rows[i]["flgStatus"]);
                    long flgMeeting = Convert.ToInt64(Ds.Tables[0].Rows[i]["MeetingId"]);
                    string strHightlightclass = "";
                    string strTitle = "";
                    if (flgStatus > 0)
                    {
                        strTitle = "Assessement has started";
                        strHightlightclass = "class='clsHighlightrowsAssessor'";
                    }
                    else if (flgMeeting > 0)
                    {
                        strTitle = "Meeting has been scheduled for BEI";
                        strHightlightclass = "class='clsHighlightrowsMeeting'";
                    }
                    else if (flgMapped > 0)
                    {
                        strTitle = "Assessement has not started";
                        strHightlightclass = "class='clsHighlightrows'";
                    }
                        str.Append("<tr " + strHightlightclass + " flgStatus='"+ flgStatus + "' flgMapped='" + flgMapped + "' flgMeeting='" + flgMeeting + "'  ParticipantCycleMappingId='" + Ds.Tables[0].Rows[i]["ParticipantCycleMappingId"].ToString() + "'>");
                    str.Append("<td style='text-align:center'>" + (i + 1) + "</td>");
                    for (int j = 0; j < Ds.Tables[0].Columns.Count; j++)
                    {
                        string sColumnName = Ds.Tables[0].Columns[j].ColumnName;
                        if (SkipColumn.Contains(sColumnName))
                        {
                            continue;
                        }
                        var sData = Ds.Tables[0].Rows[i][j];
                        
                        string flgSearchable = "Searchable='0'";
                        if (Ds.Tables[0].Columns[j].ColumnName == "EmpName" || Ds.Tables[0].Columns[j].ColumnName == "EmpCode")
                        {
                            flgSearchable = "Searchable='1'";
                        }
                        //ss += "'";
                        str.Append("<td " + flgSearchable + ">" + sData + "</td>");
                    }
                    string sdeletelnk = "";
                    if (flgMapped > 0 && flgStatus==0)
                    {
                        sdeletelnk = "<i class='fa fa-times' aria-hidden='true' title='Click to remove mapping' style='font-size:15px;cursor:pointer;' onclick=\"fnDeleteParticipantMapping(this,'" + ParticipantCycleMappingId + "')\"></i>";
                    }
                    str.Append("<td style='text-align:center'><select class='col-10' "+ (flgMapped > 0?"disabled":"") + " class='clsassessor' AssessorCycleMappingId='0'  > " + dropdownlist_at + "<select/></td>");
                    str.Append("<td style='text-align:center;vertical-align:middle'>"+ sdeletelnk + "</td>");
                    str.Append("</tr>");
                }
                str.Append("</tbody></table></div>");

                str1.Append("<table id='tbldbrlist1' class='table table-bordered table-sm' ><thead><tr>");

                //string ss1 = "style='text-align:center'";

                str1.Append("<th style='width:4%' >SrNo</th>");
                str1.Append("<th>Developer Name</th>");
                str1.Append("<th>Mapped Participant</th></tr></thead><tbody>");
                int cntcc = 0;
                for (var j = 0; j < Ds.Tables[1].Rows.Count; j++)
                {
                    if (Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() != "0")
                    {
                        str1.Append("<tr totcount='"+ Ds.Tables[1].Rows[j]["TotCount"].ToString() + "' AssessorCycleMappingId='" + Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() + "'>");
                        str1.Append("<td>" + (cntcc + 1) + "</td>");
                        str1.Append("<td>" + Ds.Tables[1].Rows[j]["AssessorName"].ToString() + "</td>");
                        str1.Append("<td><a href='###' style='text-decoration:unlderline;color:blue' onclick=\"fnShowDetail(this,'" + Ds.Tables[1].Rows[j]["AssessorCycleMappingId"].ToString() + "')\">" + Ds.Tables[1].Rows[j]["TotCount"].ToString() + "</a></td>");
                        str1.Append("</tr>");
                        cntcc++;
                    }
                }
                str1.Append("</tbody></table>");
            }
            else
            {
                str.Append("");
            }
            stresponse = str.ToString() + "|" + str1.ToString();
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


    [System.Web.Services.WebMethod()]
    public static string fnAssessorParticipantMappingDetails(int Pid)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        DataSet Ds = null;
        string stresponse = "";
        try
        {
            string storedProcName = "select * from vwMappedParticipantAndAssessor where AssessorCycleMappingId="+ Pid;
            SqlCommand Scmd = new SqlCommand(storedProcName);
            Scmd.Connection = con;
            Scmd.CommandText = storedProcName;
            Scmd.CommandType = CommandType.Text;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
             Ds = new DataSet();
            Sdap.Fill(Ds);
            StringBuilder str1 = new StringBuilder();
            if (Ds.Tables[0].Rows.Count > 0)
            {
                str1.Append("<table id='tbldbrlist11' class='table table-bordered table-sm'><thead><tr>");
                str1.Append("<th style='width:6%' >SrNo</th>");
                str1.Append("<th>Emp Code</th>");
                str1.Append("<th>Participant Name</th></tr></thead><tbody>");
                for (var j = 0; j < Ds.Tables[0].Rows.Count; j++)
                {
                    str1.Append("<tr>");
                    str1.Append("<td style='text-align:center;' >" + (j + 1) + "</td>");
                    str1.Append("<td style='text-align:left;' >" + Ds.Tables[0].Rows[j]["EmpCode"].ToString() + "</td>");
                    str1.Append("<td style='text-align:left;' >" + Ds.Tables[0].Rows[j]["ParticipantName"].ToString() + "</td>");
                    str1.Append("</tr>");
                }
                str1.Append("</tbody></table>");
            }
            else
            {
                str1.Append("No Data Found");
            }
            stresponse ="1|"+ str1.ToString();
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
    


    //Get Scheme And Product Detail Bases on Store
    [System.Web.Services.WebMethod()]
    public static string fnPopulateAssessorParticipantMapping(int LoginId, object MapTCUser)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        string stresponse = "";
        try
        {
            con.Open();
            string strobjAttendance = JsonConvert.SerializeObject(MapTCUser, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblMapTCUser = JsonConvert.DeserializeObject<DataTable>(strobjAttendance);
            tblMapTCUser.TableName = "tblParticipant";

            string storedProcName = "spPopulateAssessorParticipantMapping";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@tblParticipant", tblMapTCUser),                 
                   new SqlParameter("@LoginId", LoginId)
                };
            clsDbCommand.ExecuteQueryProcedure(storedProcName, con, sp);
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

    //Get Scheme And Product Detail Bases on Store
    [System.Web.Services.WebMethod()]
    public static string fnDeleteAssessorParticipantMapping(int ParticipantCycleMappingId)
    {
        SqlConnection con = null;
        con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        string stresponse = "";
        try
        {
            con.Open();
            string storedProcName = "spDeleteAssessorParticipantMapping";
            List<SqlParameter> sp = new List<SqlParameter>()
                    {
                   new SqlParameter("@ParticipantCycleMappingId", ParticipantCycleMappingId),
                };
            clsDbCommand.ExecuteQueryProcedure(storedProcName, con, sp);
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