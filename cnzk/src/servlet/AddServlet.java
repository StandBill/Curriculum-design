package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.impl.UserDaoImpl;

public class AddServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String address = "http://127.0.0.1:8080/cnzk";
	//String address = "http://cnzk.applinzi.com";
	/**
	 * Constructor of the object.
	 */
	public AddServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.doPost(request, response);
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
		switch(status){
		case "add_semester":
			String id = request.getParameter("id").toString();
			String add_sem = request.getParameter("add_sem").toString();
			String pub = request.getParameter("public").toString();
			String major = request.getParameter("major").toString();
			String date1 = request.getParameter("date1").toString();
			String date2 = request.getParameter("date2").toString();
			//insert into semester
			sql = "insert into semester values(?,?)";
			String[] p1 = {id,add_sem};
			user.CRUD(sql, p1);
			//insert into status
			sql = "insert into status(sem_id,de_status,sc_status,start,end) values(?,?,?,?,?)";
			if(date1.equals("")||date2.equals("")){
				Object[] p2 = {id,pub,major,"1900-01-01","1900-01-01"};
				user.CRUD(sql, p2);
			}else{
				Object[] p2 = {id,pub,major,date1,date2};
				user.CRUD(sql, p2);
			}
			
			out.print("<script>top.window.location.href=\""+address+"/admin_html/setting_index.jsp\";</script>");
			break;
		case "ad_up_sem":
			String sem_id = request.getParameter("sem_id").toString();
			String edit_sem = translate(request.getParameter("add_sem").toString());
			String edit_pub = translate(request.getParameter("public").toString());
			String edit_major = translate(request.getParameter("major").toString());
			String edit_date1 = request.getParameter("date1").toString();
			String edit_date2 = request.getParameter("date2").toString();
			//update semester
			sql = "update semester set sem_name=? where sem_id=?";
			String[] edit_p1 = {edit_sem,sem_id};
			user.CRUD(sql, edit_p1);
			//update status
			sql = "update status set ma_status=?,pub_status=?,start=?,end=? where sem_id=?";
			if(edit_date1.equals("")||edit_date2.equals("")){
				Object[] p2 = {edit_pub,edit_major,"1900-01-01","1900-01-01",sem_id};
				user.CRUD(sql, p2);
			}else{
				Object[] p2 = {edit_pub,edit_major,edit_date1,edit_date2,sem_id};
				user.CRUD(sql, p2);
			}
			out.print("<script>top.window.location.href=\""+address+"/admin_html/setting_index.jsp\";</script>");
			break;
		case "ad_del_sem":
			String semid = request.getParameter("sem_id").toString();
			sql = "delete from semester where sem_id=?";
			String[] dels = {semid};
			user.CRUD(sql, dels);
			sql = "delete from status where sem_id=?";
			user.CRUD(sql, dels);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/setting_index.jsp\";</script>");
			break;
		case "ad_del_stu":
			String sid = request.getParameter("sid").toString();
			sql = "delete from student where s_id=?";
			String[] des = {sid};
			user.CRUD(sql, des);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/index.jsp\";</script>");
			break;
		case "ad_add_stu":
			String addsid = request.getParameter("id").toString();
			String sname = request.getParameter("stu_name").toString();
			String col = request.getParameter("col");
			String clname= request.getParameter("cl");
			String degress = request.getParameter("de");
			String grade = request.getParameter("grade");
			String sex = request.getParameter("sex");
			String date = request.getParameter("date");
			String clid = user.getName("select cl_id from class where name='"+clname+"'");
			sql = "insert into student(s_id,name,grade,sex,reg_date,cl_id) values(?,?,?,?,?,?)";
			String[] ins = {addsid,sname,grade,sex,date,clid.substring(0, clid.length()-1)};
			user.CRUD(sql, ins);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/index.jsp\";</script>");
			break;
		case "ad_up_stu":
			String upid = request.getParameter("s_id");
			String upname = translate(request.getParameter("stu_name").toString());
			String upcl = translate(request.getParameter("cl"));
			String upgrade = translate(request.getParameter("edit_grade"));
			String upsex = request.getParameter("sex");
			String update = request.getParameter("date");
			String upclid = user.getName("select cl_id from class where name='"+upcl+"'");
			sql = "update student set name=?,grade=?,sex=?,reg_date=?,cl_id=? where s_id=?";
			String[] ups = {upname,upgrade,upsex,update,upclid.substring(0, upclid.length()-1),upid};
			user.CRUD(sql, ups);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/index.jsp\";</script>");
			break;
		case "ad_add_tea":
			String tid = request.getParameter("id");
			String tname = request.getParameter("t_name");
			String tcol = request.getParameter("college");
			String tt = request.getParameter("title");
			String tsex = request.getParameter("sex");
			String tdate = request.getParameter("date");
			String tcolid = user.getName("select col_id from college where col_name='"+tcol+"'");
			String ttid = user.getName("select title_id from title where name='"+tt+"'");
			sql = "insert into teacher(t_id,name,col_id,title_id,sex,reg_date) values(?,?,?,?,?,?)";
			String[] intt = {tid,tname,tcolid.substring(0, tcolid.length()-1),ttid.substring(0, ttid.length()-1),tsex,tdate};
			user.CRUD(sql, intt);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/index.jsp\";</script>");
			break;
		case "ad_up_tea":
			String uptid = request.getParameter("t_id");
			String uptname = translate(request.getParameter("t_name"));
			String upcol = translate(request.getParameter("college"));
			String uptt = translate(request.getParameter("title"));
			String uptsex = request.getParameter("sex");
			String uptdate = request.getParameter("date");
			String upcolid = user.getName("select col_id from college where col_name='"+upcol+"'");
			String upttid = user.getName("select title_id from title where name='"+uptt+"'");
			sql = "update teacher set name=?,col_id=?,title_id=?,sex=?,reg_date=? where t_id=?";
			String []upt = {uptname,upcolid.substring(0, upcolid.length()-1),upttid.substring(0, upttid.length()-1),uptsex,uptdate,uptid};
			user.CRUD(sql, upt);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/index.jsp\";</script>");
			break;
		case "ad_del_tea":
			String deltid = request.getParameter("tid");
			sql = "delete from teacher where t_id=?";
			String[] delt = {deltid};
			user.CRUD(sql, delt);
			out.print("<script>top.window.location.href=\""+address+"/admin_html/index.jsp\";</script>");
			break;
		case "tea_add_course":
			String cid = request.getParameter("c_id");
			String cname = request.getParameter("c_name");
			String ctname = request.getParameter("add_ct");
			String de = request.getParameter("add_de");
			String sem = request.getParameter("add_sem");
			String wday = request.getParameter("weekday");
			String begin = request.getParameter("add_begin");
			String end = request.getParameter("add_end");
			String period = request.getParameter("period");
			String credit = request.getParameter("credit");
			String place = request.getParameter("add_place");
			String sec = request.getParameter("add_sec");
			String cnum = request.getParameter("c_numbers");
			String ctid = user.getName("select ct_id from course_type where ct_name='"+ctname+"'");
			//insert course
			sql = "insert into course values(?,?,?,?,?,?)";
			String[] isc = {cid,ctid.substring(0, ctid.length()-1),cname,cnum,period,credit};
			user.CRUD(sql, isc);
			//insert timetable
			String secid = user.getName("select sec_id from section where sec_name='"+sec+"'");
			sql = "insert into timetable values(?,?,?,?,?)";
			String[] istt = {cid,begin,end,wday,secid.substring(0, secid.length()-1)};
			user.CRUD(sql, istt);
			//insert sem_course
			String addsemid = user.getName("select sem_id from semester where sem_name='"+sem+"'");
			String did = user.getName("select d_id from degress where name='"+de+"'");
			sql = "insert into sem_course values(?,?,?,?,?,?,?,?)";
			Object[] iss = {cid,addsemid.substring(0, addsemid.length()-1),uid,cid,did.substring(0, did.length()-1),cid,cnum,0};
			user.CRUD(sql, iss);
			//insert timeclassroom
			sql = "insert into time_classroom values(?,?,?)";
			String clrid = user.getName("select clr_id from classroom where name='"+place+"'");
			String[] ittclr = {cid,cid,clrid.substring(0, clrid.length()-1)};
			user.CRUD(sql, ittclr);
			//insert courseclass
			sql = "insert into course_class values(?,?,?,?,?)";
			String[] iscc = {cid,begin,end,wday,secid.substring(0, secid.length()-1)};
			user.CRUD(sql, iscc);
			out.print("<script>top.window.location.href=\""+address+"/teacher_html/index.jsp\";</script>");
			break;
		case "tea_del_course":
			String delcid = request.getParameter("cid");
			String[] del={delcid};
			sql = "delete from course where c_id=?";
			user.CRUD(sql, del);
			
			sql = "delete from course_class where cc_id=?";
			user.CRUD(sql, del);
			
			sql = "delete from sem_course where sc_id=?";
			user.CRUD(sql, del);
			
			sql = "delete from timetable where time_id=?";
			user.CRUD(sql, del);
			
			sql = "delete from time_classroom where tc_id=?";
			user.CRUD(sql, del);
			out.print("<script>top.window.location.href=\""+address+"/teacher_html/index.jsp\";</script>");
			break;
		case "tea_up_course":
			String upcid = request.getParameter("c_id");
			String upcname = translate(request.getParameter("c_name"));
			String upct = translate(request.getParameter("add_ct"));
			String upde = translate(request.getParameter("add_de"));
			String upsem = translate(request.getParameter("add_sem"));
			String upwday = translate(request.getParameter("weekday"));
			String upbegin = request.getParameter("add_begin");
			String upend = request.getParameter("add_end");
			String upperiod = request.getParameter("period");
			String upcredit = request.getParameter("credit");
			String upplace = translate(request.getParameter("add_place"));
			String upsec = translate(request.getParameter("add_sec"));
			String upcnum = request.getParameter("c_numbers");
			String upctid = user.getName("select ct_id from course_type where ct_name='"+upct+"'");
			//update course
			sql = "update course set ct_id=?,c_name=?,c_numbers=?,period=?,credit=? where c_id=?";
			String[] upc = {upctid.substring(0, upctid.length()-1),upcname,upcnum,upperiod,upcredit,upcid};
			user.CRUD(sql, upc);
			//insert timetable
			String upsecid = user.getName("select sec_id from section where sec_name='"+upsec+"'");
			sql = "update timetable set week_begin=?,week_end=?,weekday=?,sec_id=? where time_id=?";
			String[] upttt = {upbegin,upend,upwday,upsecid.substring(0, upsecid.length()-1),upcid};
			user.CRUD(sql, upttt);
			//insert sem_course
			String upsemid = user.getName("select sem_id from semester where sem_name='"+upsem+"'");
			String updid = user.getName("select d_id from degress where name='"+upde+"'");
			sql = "update sem_course set sem_id=?,d_id=?,sum=? where sc_id=?";
			Object[] upsc = {upsemid.substring(0, upsemid.length()-1),updid.substring(0, updid.length()-1),upcnum,upcid};
			user.CRUD(sql, upsc);
			//insert timeclassroom
			sql = "update time_classroom set clr_id=? where tc_id=?";
			String upclrid = user.getName("select clr_id from classroom where name='"+upplace+"'");
			String[] upttclr = {upclrid.substring(0, upclrid.length()-1),upcid};
			user.CRUD(sql, upttclr);
			//insert courseclass
			sql = "update course_class set week_begin=?,week_end=?,weekday=?,sec_id=? where cc_id=?";
			String[] upscc = {upbegin,upend,upwday,upsecid.substring(0, upsecid.length()-1),upcid};
			user.CRUD(sql, upscc);
			
			out.print("<script>top.window.location.href=\""+address+"/teacher_html/index.jsp\";</script>");
			break;
		case "tea_up_psw":
			String psw = request.getParameter("psw");
			sql = "update teacher set t_psw=? where t_id=?";
			String[] ut = {psw,uid};
			user.CRUD(sql, ut);
			out.print("<script>top.window.location.href=\""+address+"/teacher_html/index.jsp\";</script>");
			break;
		case "stu_up_psw":
			String spsw = request.getParameter("psw");
			sql = "update student set s_psw=? where s_id=?";
			String[] us = {spsw,uid};
			user.CRUD(sql, us);
			out.print("<script>top.window.location.href=\""+address+"/student_html/index.jsp\";</script>");
			break;
		case "stu_sel_course":
			String selcid = request.getParameter("cid");
			String clrname = request.getParameter("clrname");
			
			
			String bs = user.getName("select chosen from sem_course where sc_id='"+selcid+"'");
			String sum = user.getName("select sum from sem_course where sc_id='"+selcid+"'");
			int sa = Integer.valueOf(sum.substring(0, sum.length()-1));
			int lt = Integer.valueOf(bs.substring(0, bs.length()-1));
			if(sa == lt){//人数选满
				out.print("<script>alert('超过人数限制，选择失败..');top.window.location.href=\""+address+"/student_html/index.jsp\";</script>");
			}else{
				String sclrid = user.getName("select clr_id from classroom where name='"+clrname+"'");
				sql = "insert into stu_tea_course values(?,?,?,?)";
				String[] istc = {selcid,selcid,selcid,uid};
				user.CRUD(sql, istc);
				
				sql = "insert into stu_course_class values(?,?,?)";
				String[] isccc = {selcid,selcid,uid};
				user.CRUD(sql, isccc);
				
				sql = "insert into stu_course_class_classroom values(?,?,?,?)";
				String[] isc2 = {selcid,selcid,sclrid.substring(0, sclrid.length()-1),uid};
				user.CRUD(sql, isc2);
				
				sql = "update sem_course set chosen=? where sc_id=?";
				Object[] ubs = {lt+1,selcid};
				user.CRUD(sql, ubs);
				out.print("<script>top.window.location.href=\""+address+"/student_html/index.jsp\";</script>");
			}
			break;
		case "stu_del_course":
			String delscid = request.getParameter("cid");
			String str = delscid.substring(1, delscid.length()-2);
			String[] ids = str.split("','");
			for(int i=0;i<ids.length;i++){
				sql = "delete from stu_course_class where scc_id=? and s_id=?";
				String deids[] = {ids[i],uid};
				user.CRUD(sql, deids);
				
				sql = "delete from stu_course_class_classroom where sccc_id=? and s_id=?";
				user.CRUD(sql, deids);
				
				sql = "delete from stu_tea_course where stc_id=? and s_id=?";
				user.CRUD(sql, deids);
				
				String ibg = user.getName("select chosen from sem_course where sc_id='"+ids[i]+"'");
				int iag = Integer.valueOf(ibg.substring(0, ibg.length()-1))-1;
				sql = "update sem_course set chosen=? where sc_id=?";
				Object[] uscs = {iag,ids[i]};
				user.CRUD(sql, uscs);
			}
			out.print("<script>top.window.location.href=\""+address+"/student_html/index.jsp\";</script>");
			break;
		}
		out.flush();
		out.close();
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
