package com.example.filterdemo;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.Map;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    // 获取注册时保存的用户信息
    private static Map<String, String> users = RegisterServlet.getUsers();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 从请求中获取用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 验证用户名和密码
        if (users.containsKey(username) && users.get(username).equals(password)) {
            // 如果验证成功，则创建会话并保存用户名
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect("./home.html"); // 登录成功后重定向到首页
        } else {
            response.sendRedirect("./login.html"); // 登录失败，重定向回登录页面
        }
    }
}

