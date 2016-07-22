package database;

import java.sql.*;
import java.util.*;


//operate with database
public class DBOperator {
	Connection con;
	private PreparedStatement pstmt;
	ResultSet rs;
	static int pageNumber = 0;
	static int pageSum = 5;
	static String URL = "jdbc:mysql://localhost:3306/zhku_course?user=root&password=root";
	//static String URL="jdbc:mysql://w.rdc.sae.sina.com.cn:3307/app_cnzk?user=y2502own2x&password=50j2yj21i313542i30wm5k1hik0j3kxz4h2h5mjz";
	public DBOperator(){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			// 建立链接
			con = DriverManager.getConnection(URL);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	public void getCon(){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			// 建立链接
			con = DriverManager.getConnection(URL);
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}
	}
	public void close()
	{
		try
		{
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			if (con != null) con.close();
		} catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	public boolean isLogin(String sql,String[] param){
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			for (int i = 0; i < param.length; i++)
				pstmt.setString(i + 1, param[i]);
			rs = pstmt.executeQuery();
			while(rs.next()){
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}finally
		{
			this.close();
		}
		return false;
	}
	public String getLoginName(String sql,String[] param){
		String name = "";
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			for (int i = 0; i < param.length; i++)
				pstmt.setString(i + 1, param[i]);
			rs = pstmt.executeQuery();
			while(rs.next()){
				name = rs.getString("name");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}finally
		{
			this.close();
		}
		return name;
	}
	//统一的update create delete
	public boolean CRUD(String sql,Object[] param){
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			for (int i = 0; i < param.length; i++)
				pstmt.setObject(i + 1, param[i]);
			int temp= pstmt.executeUpdate();
			if(temp != 0){
				return true;
			}
		} catch (Exception e) {
			// TODO: handle exception
		}	finally
		{
			this.close();
		}
		return false;
	}

	//获取数据量
	public int getCounts(String sql,String[] param){
		int sum = 0;
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			for (int i = 0; i < param.length; i++)
				pstmt.setString(i + 1, param[i]);
			rs = pstmt.executeQuery();
			while(rs.next()){
				sum ++;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	finally
		{
			this.close();
		}
		return sum;
	}
	public ArrayList<HashMap<Integer,Object>> getList(String sql,String[] param){
		ArrayList<HashMap<Integer,Object>> al = new ArrayList<HashMap<Integer,Object>>();
		Map<Integer,Object> m = null;
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			for (int i = 0; i < param.length; i++)
				pstmt.setObject(i + 1, param[i]);
			rs = pstmt.executeQuery();
			int column = rs.getMetaData().getColumnCount();//获取总列数
			while(rs.next()){
				m = new HashMap<Integer, Object>();
				for(int i = 1;i <= column; i++){
					m.put(i, rs.getObject(i));
				}
				al.add((HashMap<Integer, Object>) m);
			}
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			this.close();
		}
		return al;
	}
	//获取指定数据
	public String getName(String sql){
		String result = "";
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				result += rs.getString(1)+",";
			}
		} catch (Exception e) {
			// TODO: handle exception
		}	finally
		{
			this.close();
		}
		return result;
	}
	//获取指定数据集合
	public ArrayList<String> getDataList(String sql){
		ArrayList<String> result = new ArrayList<String>();
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				result.add(rs.getString(1));
			}
		} catch (Exception e) {
			// TODO: handle exception
		}	finally
		{
			this.close();
		}
		return result;
	}
	public boolean isExist(String sql){
		try {
			this.getCon();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}finally
		{
			this.close();
		}
		return false;
	}
	
}
