package com.bjpowernode.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * 过滤中文乱码的过滤器
 */
public class EncodingFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        // 过滤请求体中请求方式是post时的中文乱码
        req.setCharacterEncoding("utf-8");
        // 过滤响应体中响应内容的中文乱码
        resp.setContentType("text/html;charset=utf-8");
        // 将请求放行
        chain.doFilter(req,resp);
    }
}
