package dao;

import java.util.ArrayList;
import java.util.HashMap;

public interface UserDao {
	public ArrayList<HashMap<Integer,Object>> getList(String sql,String[] para);
	public boolean CRUD(String sql,Object []param);
}
