package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.*;
import dao.impl.UserDaoImpl;

public class LoginServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Constructor of the object.
	 */
	public LoginServlet() {
		super();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		
		String u_name = request.getParameter("u_name").toString().trim();
		String u_psw = request.getParameter("u_psw").toString().trim();
		String status = request.getParameter("status").toString();
		String sql = "";
		String[] param = {u_name,u_psw};
		String loginName = "";
		UserDaoImpl admin = new UserDaoImpl(); 
		switch(status){
			case "admin"://管理员身份
				sql = "select * from admin where ad_id=? and ad_psw=?";
				if(admin.isLogin(sql, param)){
					loginName = admin.getLoginName(sql, param);
					request.getSession().setAttribute("u_name", loginName);
					request.getSession().setAttribute("u_id", u_name);
					response.sendRedirect("admin_html/index.jsp");
				}else{
					request.getSession().setAttribute("error", "<label style=\"color:red;\">用户名或者密码错误..</label>");
					request.getSession().setMaxInactiveInterval(2000);
					response.sendRedirect("login_html/login.jsp");
				}
				break;
			case "teacher":
				sql = "select * from teacher where t_id=? and t_psw=?";
				if(admin.isLogin(sql, param)){
					loginName = admin.getLoginName(sql, param);
					request.getSession().setAttribute("u_name", loginName);
					request.getSession().setAttribute("u_id", u_name);
					response.sendRedirect("teacher_html/index.jsp");
				}else{
					request.getSession().setAttribute("error", "<label style=\"color:red;\">用户名或者密码错误..</label>");
					request.getSession().setMaxInactiveInterval(2000);
					response.sendRedirect("login_html/login.jsp");
				}
				break;
			case "student":
				sql = "select * from student where s_id=? and s_psw=?";
				if(admin.isLogin(sql, param)){
					loginName = admin.getLoginName(sql, param);
					request.getSession().setAttribute("u_name", loginName);
					request.getSession().setAttribute("u_id", u_name);
					response.sendRedirect("student_html/index.jsp");
				}else{
					request.getSession().setAttribute("error", "<label style=\"color:red;\">用户名或者密码错误..</label>");
					request.getSession().setMaxInactiveInterval(2000);
					response.sendRedirect("login_html/login.jsp");
				}
				break;
			default:response.sendRedirect("login_html/login.jsp");
		}
	}

}
