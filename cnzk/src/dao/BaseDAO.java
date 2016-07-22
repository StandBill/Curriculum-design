package dao;
import java.util.ArrayList;

import database.DBOperator;

public class BaseDAO<T> implements DAO<T> {
	DBOperator db = new DBOperator();
	@Override
	public boolean CRUD(String sql, String[] param) {
		// TODO Auto-generated method stub
		return db.CRUD(sql, param);
	}

	@Override
	public String getLoginName(String sql, String[] param) {
		// TODO Auto-generated method stub
		return db.getLoginName(sql, param);
	}

	@Override
	public boolean isLogin(String sql, String[] param) {
		// TODO Auto-generated method stub
		return db.isLogin(sql, param);
	}

	@Override
	public String getName(String sql) {
		// TODO Auto-generated method stub
		return db.getName(sql);
	}

	@Override
	public ArrayList<String> getDataList(String sql) {
		// TODO Auto-generated method stub
		return db.getDataList(sql);
	}

	@Override
	public boolean isExist(String sql) {
		// TODO Auto-generated method stub
		return db.isExist(sql);
	}

}
