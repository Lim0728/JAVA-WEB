package com.example.filterdemo;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    // 存储用户信息的 HashMap，键为用户名，值为密码
    private static Map<String, String> users = new HashMap<>(); // 存储用户信息

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 从请求中获取用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 检查用户名是否已存在
        if (users.containsKey(username)) {
            response.sendRedirect("./register.html"); // 用户名已存在，重定向回注册页面
        } else {
            // 存储用户信息
            users.put(username, password);
            response.sendRedirect("./login.html"); // 注册成功，重定向到登录页面
        }
    }
    // 提供一个静态方法以便其他类获取用户信息
    public static Map<String, String> getUsers() {
        return users;
    }
}
