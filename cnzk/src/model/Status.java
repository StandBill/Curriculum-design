package model;

import java.util.Date;

public class Status {
	private int id;
	private String semid;
	private String mastatus;
	private String pubstatus;
	private Date start;
	private Date end;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getSemid() {
		return semid;
	}
	public void setSemid(String semid) {
		this.semid = semid;
	}
	public String getMastatus() {
		return mastatus;
	}
	public void setMastatus(String mastatus) {
		this.mastatus = mastatus;
	}
	public String getPubstatus() {
		return pubstatus;
	}
	public void setPubstatus(String pubstatus) {
		this.pubstatus = pubstatus;
	}
	public Date getStart() {
		return start;
	}
	public void setStart(Date start) {
		this.start = start;
	}
	public Date getEnd() {
		return end;
	}
	public void setEnd(Date end) {
		this.end = end;
	}
}
