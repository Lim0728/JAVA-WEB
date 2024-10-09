package com.example.listenerdemo;

import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpServletRequest;

import java.text.SimpleDateFormat;
import java.util.Date;

@WebListener // 标记该类为Servlet请求监听器
public class MyServletRequestListener implements ServletRequestListener {

    // 记录请求开始的时间
    private long startTime;

    // 自定义日期格式，用于日志输出
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        // 获取当前请求对象，转为HTTP是为了使用里面的一些方法
        HttpServletRequest request = (HttpServletRequest)sre.getServletRequest();
        startTime = System.currentTimeMillis();  // 记录请求初始化时间
        String ipAddress = request.getRemoteAddr();  // 获取请求的IP地址
        String method = request.getMethod();  // 获取请求方法（GET, POST等）
        String requestURI = request.getRequestURI();  // 获取请求的URI
        String queryString = request.getQueryString();  // 获取请求的查询字符串
        String userAgent = request.getHeader("User-Agent");  // 获取用户代理信息

        // 输出初始化日志
        System.out.println(formatLog("Request received", method, requestURI, ipAddress, userAgent, queryString,null));
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        // 获取当前请求对象
        HttpServletRequest request = (HttpServletRequest)sre.getServletRequest();
        long endTime = System.currentTimeMillis();  // 记录请求结束时间
        long processingTime = endTime - startTime;  // 计算请求处理时间

        String ipAddress = request.getRemoteAddr();  // 获取请求的IP地址
        String method = request.getMethod();  // 获取请求方法
        String requestURI = request.getRequestURI();  // 获取请求的URI

        // 输出销毁日志
        System.out.println(formatLog("Request completed", method, requestURI, ipAddress, null, null, processingTime));
    }

    private String formatLog(String message, String method, String requestURI, String ipAddress, String userAgent, String queryString, Long processingTime) {
        // 构建日志信息
        //StringBuilder和String最显著区别：StringBuilder可以在不创建新对象的情况下修改内容
        StringBuilder logMessage = new StringBuilder();
        String Date_now = dateFormat.format(new Date());// 获取当前时间并格式化

        // 以下为把传入的信息构建为日志
        logMessage.append(Date_now).append(" ")
                .append("INFO [main] ").append("MyServletRequestListener: ")
                .append(message).append(": ")
                .append(method).append(" ").append(requestURI)
                .append(" - IP: ").append(ipAddress);

        if (userAgent != null) {
            logMessage.append(" - User-Agent: ").append(userAgent);
        }

        if (queryString != null) {
            logMessage.append(" - Query String: ").append(queryString);
        }

        if (processingTime != null) {
            logMessage.append(" - Processing time: ").append(processingTime).append(" ms");
        }
        // 返回构建的日志信息
        return logMessage.toString();
    }
}
