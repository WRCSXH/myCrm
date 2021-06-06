package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器！");
        // 获取url-pattern，判断执行哪个业务
        String path =  request.getServletPath();
        System.out.println(path);
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }
    }

    private static void login(HttpServletRequest request,HttpServletResponse response){
        System.out.println("用户登录！");
        // 接收登录账号和密码
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        System.out.println(loginPwd);
        // 将密码明文转换成MD5的密文
        loginPwd = MD5Util.getMD5(loginPwd);
        System.out.println(loginPwd);
        // 接收浏览器端的ip地址
        String ip = request.getRemoteAddr();
        // 如果使用localhost发起请求，ip地址会变成0:0:0:0:0:0:0:1，所以要使用本机环回地址：127.0.0.1
        System.out.println(ip);
        // 创建service对象，未来业务层的开发统一使用代理类形态的service对象
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        try{
            // 返回一个User对象
            User user = userService.login(loginAct,loginPwd,ip);
            /*
                上一行没有抛出异常，将返回的User对象放入session域对象中，
                这样做的目的是当需求需要展示当前用户的详细信息时，可以从session域对象中取出
            */
            request.getSession().setAttribute("user",user);
            // 程序执行到此处，说明业务层没有向控制层抛出任何异常，表示登录成功
            // 此时后端只需要给前端返回登录成功的信息：{"isSuccess":true}
            PrintJson.printJsonFlag(response,true);
        } catch (Exception e) {
            e.printStackTrace();
            // 程序执行到此处，说明业务层为用户验证登录失败，向控制层抛出了异常，表示登录失败
            // 此时后端需要给前端返回登录失败和失败原因两条信息：{"isSuccess":false,"errorMsg":?}
            String errorMsg = e.getMessage();
            /*
                控制层需要为ajax请求提供多项信息时，可以有两种选择：
                    1、将多项信息封装成Map集合，再将Map集合解析为json串
                    2、创建一个vo类
                需根据不同的情况进行选择：
                    如果这些信息将来在别的需求中还会被大量使用，创建一个vo类，使用方便
                    如果这些信息只在这个需求中被使用一次，使用Map集合可以避免项目的臃肿
             */
            Map<String,Object> map = new HashMap<String, Object>();
            map.put("isSuccess",false);
            map.put("errorMsg",errorMsg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
