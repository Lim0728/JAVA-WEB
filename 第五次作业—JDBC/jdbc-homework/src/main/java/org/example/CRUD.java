package org.example;

import java.sql.*;

public class CRUD {
    // 数据库连接信息
    String url = "jdbc:mysql://localhost:3306/student?serverTimezone=GMT&characterEncoding=UTF-8";
    String user = "root";
    String password = "20040728";

    // 插入教师信息的方法
    public void insert(){
        // SQL 插入语句
        String sql = """
                INSERT INTO teacher (`id`, `name`, `course`, `birthday`) VALUES 
                (1, '张伟', '数学', '1980-05-12')
                """;

        // 创建数据库连接
        try(Connection conn= DriverManager.getConnection(url,user,password)){
            conn.setAutoCommit(false); // 开始事务
            try(PreparedStatement ps=conn.prepareStatement(sql)){
                ps.executeUpdate(); // 执行插入操作
                conn.commit(); // 提交事务
            }catch (SQLException e){
                conn.rollback(); // 回滚事务
                e.printStackTrace();
            }finally {
                conn.setAutoCommit(true); // 恢复自动提交
            }
        } catch (SQLException e) {
            throw new RuntimeException(e); // 异常处理
        }
    }

    // 查询教师信息的方法
    public void find(){
        String sql="select id,name,course from teacher where id=?";

        // 创建数据库连接
        try(Connection conn = DriverManager.getConnection(url, user, password);
            PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setInt(1, 1); // 设置查询参数
            try(ResultSet rs=ps.executeQuery()){ // 执行查询
                while(rs.next()){ // 遍历结果集
                    // 输出教师信息
                    System.out.println("id:" + rs.getObject(1) + " name:" + rs.getObject(2) + " course:" + rs.getObject(3));
                }
            }catch (SQLException e){
                e.printStackTrace();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e); // 异常处理
        }
    }

    // 更新教师信息的方法
    public void update(){
        String sql="update teacher set course='地理' where id=?";
        try (Connection conn = DriverManager.getConnection(url, user, password);) {
            conn.setAutoCommit(false); // 开始事务
            try (PreparedStatement ps = conn.prepareStatement(sql);) {
                // 设置更新参数
                ps.setInt(1, 1);
                // 执行更新操作
                ps.executeUpdate();
                conn.commit(); // 提交事务
            } catch (SQLException e) {
                conn.rollback(); // 回滚事务
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 异常处理
        }
    }

    // 删除教师信息的方法
    public void delete() {
        String sql="delete from teacher where id=?";
        try(Connection conn =DriverManager.getConnection(url,user,password)){
            conn.setAutoCommit(false); // 开始事务
            try (PreparedStatement ps = conn.prepareStatement(sql);) {
                // 设置删除参数
                ps.setInt(1, 1);
                ps.executeUpdate(); // 执行删除操作
                conn.commit(); // 提交事务
            }catch (SQLException e){
                conn.rollback(); // 回滚事务
                e.printStackTrace();
            }finally {
                conn.setAutoCommit(true); // 恢复自动提交
            }
        }catch (SQLException e){
            e.printStackTrace(); // 异常处理
        }
    }
}
