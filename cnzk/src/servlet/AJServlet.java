package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dao.impl.UserDaoImpl;

public class AJServlet extends HttpServlet {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doPost(request, response);
	}


	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setCharacterEncoding("utf-8");
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String uid = (String) request.getSession().getAttribute("u_id");
		String status = request.getParameter("status").toString();
		UserDaoImpl user = new UserDaoImpl();
		String sql = null;
		String result = null;
		switch(status){
		case "semester":
			sql = "select sem_name from semester";
			result = user.getName(sql);
			break;
		case "college":
			sql = "select col_name from college";
			result = user.getName(sql);
			break;
		case "degress":
			String colname = request.getParameter("data").toString();
			if(colname.equals("")){
				sql = "select name from degress";
			}else{
				sql = "select d.name from college c,degress d where d.col_id=c.col_id and c.col_name='"+colname+"'";
			}
			result = user.getName(sql);
			break;
		case "class":
			String dname = request.getParameter("data").toString();
			if(dname.equals("")){
				sql = "select name from class";
			}else{
				sql = "SELECT c.name from degress d,class c WHERE d.d_id=c.d_id and d.name='"+dname+"'";
			}
			result = user.getName(sql);
			break;
		case "title":
			String tiname = request.getParameter("data").toString();
			if(tiname.equals("")){
				sql = "select name from title";
			}else{
				sql = "select name from title";
			}
			result = user.getName(sql);
			break;
		
		case "ex_course":
			String cid = request.getParameter("cid").toString();
			sql = "select * from course where c_id='"+cid+"'";
			if(user.isExist(sql)){
				result = "目标已存在,";
			}else{
				result = "ok,";
			}
			break;
		case "ex_clr":
			String begin = request.getParameter("begin").toString();
			String end = request.getParameter("end").toString();
			String weekday = request.getParameter("weekday").toString();
			String section = request.getParameter("section").toString();
			String clr = request.getParameter("clr").toString();
			String iscid = request.getParameter("cid").toString();
			String tmp = user.getName("select sem_id from semester order by sem_id desc limit 0,1");
			String semid = tmp.substring(0, tmp.length()-1);
			if(iscid.equals("")){
				sql = "SELECT * from section sec,timetable tt,time_classroom tclr,classroom clr,sem_course sc where sec.sec_id=tt.sec_id AND "+
						"tt.time_id=tclr.time_id AND clr.clr_id=tclr.clr_id AND ((tt.week_begin<="+end+" and tt.week_end<="+begin+") OR "+
						"("+begin+">=tt.week_begin and "+end+"<=tt.week_end) OR ("+begin+"<=tt.week_begin and "+end+" <=tt.week_end) or("+begin+">=tt.week_begin and "+end+">=tt.week_end)) "+ 
						"AND sec.sec_name='"+section+"' AND tt.weekday='"+weekday+"' AND clr.name='"+clr+"' and sc.time_id=tt.time_id and sc.time_id=tclr.time_id and sc.sem_id='"+semid+"'";
			}else{
				sql = "SELECT * from section sec,timetable tt,time_classroom tclr,classroom clr,sem_course sc where sec.sec_id=tt.sec_id AND "+
						"tt.time_id=tclr.time_id AND clr.clr_id=tclr.clr_id AND ((tt.week_begin<="+end+" and tt.week_end<="+begin+") OR "+
						"("+begin+">=tt.week_begin and "+end+"<=tt.week_end) OR ("+begin+"<=tt.week_begin and "+end+" <=tt.week_end) or("+begin+">=tt.week_begin and "+end+">=tt.week_end)) "+ 
						"AND sec.sec_name='"+section+"' AND tt.weekday='"+weekday+"' AND clr.name='"+clr+"' and tt.time_id!='"+iscid+"' and sc.time_id=tt.time_id and sc.time_id=tclr.time_id and sc.sem_id='"+semid+"'";
			}
			if(user.isExist(sql)){
				result = "教室节次已被占用...,";
			}else{
				result = "ok,";
			}
			break;
		case "is_selected":
			String begin1 = request.getParameter("begin").toString();
			String end1 = request.getParameter("end").toString();
			String weekday1 = request.getParameter("weekday").toString();
			String section1 = request.getParameter("section").toString();
			
			sql = "SELECT * from stu_course_class scc,course_class cc,section sec where scc.cc_id=cc.cc_id AND cc.sec_id=sec.sec_id "+
					"AND cc.weekday='"+weekday1+"' and sec.sec_name='"+section1+"' and ((cc.week_begin<="+end1+" and cc.week_end<="+begin1+") OR "+
					"("+begin1+">=cc.week_begin and "+end1+"<=cc.week_end) OR ("+begin1+"<=cc.week_begin and "+end1+"<=cc.week_end) or("+begin1+
					">=cc.week_begin and "+end1+">=cc.week_end)) and scc.s_id='"+uid+"'";
			if(user.isExist(sql)){
				result = "周节次冲突...,";
			}else{
				result = "ok,";
			}
			break;
		case "classroom":
			String clrname = request.getParameter("data").toString();
			if(clrname.equals("")){
				sql = "select name from classroom";
			}else{
			}
			result = user.getName(sql);
			break;
		case "section":
			String secname = request.getParameter("data").toString();
			if(secname.equals("")){
				sql = "select sec_name from section";
			}else{
			}
			result = user.getName(sql);
			break;
		case "course_type":
			String ctname = request.getParameter("data").toString();
			if(ctname.equals("")){
				sql = "select ct_name from course_type";
			}else{
			}
			result = user.getName(sql);
			break;	
		}
		out.print(result.substring(0, result.length()-1));
	}
	//设置编码格式为utf-8
	public String translate(String obj){
		String result = "";
		try {
			result = new String(obj.getBytes("iso-8859-1"),"utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
		
	}

}
