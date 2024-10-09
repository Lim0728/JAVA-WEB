
package com.example.filterdemo;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")  //过滤器应用于所有 URL 路径
public class LoginFilter implements Filter {

    //排除不需要登录的路径列表
    private static final List<String> STATIC_PATHS = Arrays.asList(
            "/filter_demo/login", "/filter_demo/register", "/filter_demo/public"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        // 将请求转换为 HTTP 特定的对象，用于获取session进行查看
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        // 将响应转换为 HTTP 特定的对象，用于重定位
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 获取请求的 URI
        String requestURI = httpRequest.getRequestURI();

        //检查请求路径是否在排除列表
        boolean isExcludedPath = STATIC_PATHS.stream().anyMatch(path -> requestURI.startsWith(path));

        if(isExcludedPath) {
            chain.doFilter(request, response);
            return;
        }
        String username = (String) httpRequest.getSession().getAttribute("username");

        if(username == null) {
            httpResponse.sendRedirect("login.html");
        }else {
            chain.doFilter(request, response);
        }
    }

    @Override
    //初始化方法
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
        System.out.println("LoginFilter initialized.");
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}

