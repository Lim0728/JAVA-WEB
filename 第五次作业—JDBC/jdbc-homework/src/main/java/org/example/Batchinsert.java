package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Batchinsert {
    // 数据库连接信息
    String url = "jdbc:mysql://localhost:3306/student?serverTimezone=GMT&characterEncoding=UTF-8";
    String user = "root";
    String password = "20040728";

    // 批量插入教师信息的方法
    public void batch() {
        // SQL 插入语句
        String sql = "insert into teacher(`id`, `name`, `course`, `birthday`) values(?,?,?,?)";

        // 创建数据库连接
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            conn.setAutoCommit(false); // 开始事务，手动管理提交
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                // 循环插入500条数据
                for (int i = 1; i <= 500; i++) {
                    // 设置插入的每一列的值
                    ps.setInt(1, i);
                    ps.setString(2, "name" + i);
                    ps.setString(3, "course" + i);
                    ps.setDate(4, new java.sql.Date(System.currentTimeMillis())); // 设置生日为当前时间
                    ps.addBatch(); // 将当前插入语句添加到批处理

                    // 每100条执行一次批处理
                    if (i % 100 == 0) {
                        ps.executeBatch(); // 执行批处理
                        ps.clearBatch(); // 清空批处理，准备下一批
                    }
                }
                ps.executeBatch(); // 执行剩余的批处理
                conn.commit();
                System.out.println("批处理已完成"); // 输出完成信息
            } catch (SQLException e) {
                conn.rollback(); // 出现异常时回滚事务
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
