package org.example;

import java.sql.*;

public class ScrollableResultSet {
    String url = "jdbc:mysql://localhost:3306/student?serverTimezone=GMT&characterEncoding=UTF-8";
    String user = "root";
    String password = "20040728";

    public void moveToNext() {
        String sql = "SELECT * FROM teacher WHERE id < ?";
        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement ps = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ) {
            // 设置参数
            ps.setInt(1, 20);
            // 执行查询
            try (ResultSet rs = ps.executeQuery()) {
                // 移动到倒数第二行
                rs.absolute(-2);
                System.out.println("id:"+rs.getInt("id") + " name:" + rs.getString("name"));
            }catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}