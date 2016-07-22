package dao.impl;
import java.util.ArrayList;
import java.util.HashMap;

import dao.*;
import dao.BaseDAO;
import database.DBOperator;
import model.Admin;

public class UserDaoImpl extends BaseDAO<Admin> implements UserDao {

	DBOperator db = new DBOperator();
	@Override
	public ArrayList<HashMap<Integer, Object>> getList(String sql, String[] param) {
		// TODO Auto-generated method stub
		return db.getList(sql, param);
	}

	@Override
	public boolean CRUD(String sql, Object[] param) {
		// TODO Auto-generated method stub
		return db.CRUD(sql, param);
	}

}
