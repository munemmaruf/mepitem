﻿<%@ WebHandler Language="C#" Class="SubItemHandler" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Collections.Generic;

public class SubItemHandler : IHttpHandler {
    
   public void ProcessRequest(HttpContext context)
    {
        string term = context.Request["term"] ?? "";

        List<string> listSubItem = new List<string>();

        string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlCommand cmd = new SqlCommand("spGetSubItemTitle", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter()
            {
                ParameterName = "@term",
                Value = term
            });
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                listSubItem.Add(rdr["Title"].ToString());
            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        context.Response.Write(js.Serialize(listSubItem));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}