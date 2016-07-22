package model;

public class Timetable {
	private String timeid;
	private int begin;
	private int end;
	private String day;
	private String secid;
	public String getTimeid() {
		return timeid;
	}
	public void setTimeid(String timeid) {
		this.timeid = timeid;
	}
	public int getBegin() {
		return begin;
	}
	public void setBegin(int begin) {
		this.begin = begin;
	}
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getSecid() {
		return secid;
	}
	public void setSecid(String secid) {
		this.secid = secid;
	}
	
}
