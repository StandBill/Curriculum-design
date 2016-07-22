package model;

import java.util.Date;

public class Student {
	private String id;
	private String psw;
	private String grade;
	private String sex;
	private Date date;
	private String clid;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPsw() {
		return psw;
	}
	public void setPsw(String psw) {
		this.psw = psw;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getClid() {
		return clid;
	}
	public void setClid(String clid) {
		this.clid = clid;
	}
}
