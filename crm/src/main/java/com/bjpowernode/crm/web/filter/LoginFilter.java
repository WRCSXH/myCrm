package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 拦截器：拦截未登录就访问网站内部资源的非法请求
 */
public class LoginFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        System.out.println("进入到拦截未登录的非法请求的拦截器！");

        // ServletRequest对象无法获取session域对象，需要强制类型转换成HttpServletRequest对象
        HttpServletRequest request = (HttpServletRequest) req;

        // ServletResponse对象无法发送重定向请求，需要强制类型转换成HttpServletResponse对象
        HttpServletResponse response = (HttpServletResponse) resp;

        // 获取具体资源文件的绝对路径，即url-pattern
        String path = request.getServletPath();

        System.out.println(path);

        if ("/login.jsp".equals(path)||"/settings/user/login.do".equals(path)){
            // 解决无限重定向的问题：自动放行与登录有关的资源文件
            chain.doFilter(request,response);
        } else {
            // getSession()方法无参，作用：有session就用，没有session就创建一个新的，防止了空指针异常，而且更准确地定位到了User对象
            HttpSession session = request.getSession();

            // 从session域对象中取出User对象

            // null强转成引用类型不会抛异常，强转成基本类型会抛异常，所以尽量使用包装类
            User user = (User) session.getAttribute("user");

            if (user != null){
                // user不为null，说明登录过
                // 直接放行
                chain.doFilter(request,response);
            } else {
                // user为null，说明没有登录过
                // 重定向到登录页进行登录

            /*
            关于重定向需要注意的两个问题：
                重定向的路径怎么写？
                    在以后实际项目开发中，不管是操作的是前端还是后端，一律使用绝对路径
                    关于请求转发和重定向的写法如下：
                        请求转发：
                            使用的是一种特殊的绝对路径，前面不需要写/项目名，
                            直接写具体的资源路径名即可，也被称为内部路径，如/login.jsp
                        重定向：
                            使用的是传统的绝对路径，前面必须写/项目名，
                            再接上具体的资源路径名，如/crm/login.jsp
                为什么使用重定向，使用请求转发不行吗？
                    请求转发之后，浏览器地址栏上的地址会停留在转发之前的旧地址，而不是变成转发之后的新地址，
                    因为请求转发本质上浏览器只发送了一次请求，对于用户来说，当前希望地址是当前页的地址，便于
                    进行刷新、前进、后退等操作，所以我们应该在为用户跳转到登录页的同时，将浏览器地址栏上的地址
                    变成当前登录页的地址。

                    综上所述：
                        选择重定向，因为重定向本质上浏览器发送了两次请求，浏览器第二次自动发送的请求就会更新
                        地址栏上的地址。
             */

                // getContextPath()方法返回：/项目名，写成动态的路径，避免项目迁移时大量地修改路径
                // 测试数据：http://127.0.0.1:8080/crm/workbench/index.jsp
                response.sendRedirect(request.getContextPath()+"/login.jsp");
                // request.getRequestDispatcher("/login.jsp").forward(request,response);
            }
        }
    }
}

