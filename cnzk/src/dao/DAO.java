package dao;

import java.util.ArrayList;

import database.DBOperator;

public interface DAO<T> {
	public boolean CRUD(String sql,String[] param);
	public boolean isLogin(String sql,String[] param);
	public String getLoginName(String sql, String[] param);
	public String getName(String sql);
	public ArrayList<String> getDataList(String sql);
	public boolean isExist(String sql);
}
