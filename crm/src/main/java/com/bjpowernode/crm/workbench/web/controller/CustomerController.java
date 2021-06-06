package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.*;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入客户控制器！");
        // 获取url-pattern，判断执行哪个业务
        String path =  request.getServletPath();
        System.out.println(path);
        // 模板模式
        if ("/workbench/customer/getUserList.do".equals(path)){
            getUserList(request,response);
        } else if ("/workbench/customer/save.do".equals(path)){
            save(request,response);
        } else if ("/workbench/customer/pageList.do".equals(path)){
            pageList(request,response);
        } else if ("/workbench/customer/delete.do".equals(path)){
            delete(request,response);
        } else if ("/workbench/customer/getUserListAndCustomer.do".equals(path)){
            getUserListAndCustomer(request,response);
        } else if ("/workbench/customer/update.do".equals(path)){
            update(request,response);
        } else if ("/workbench/customer/detail.do".equals(path)){
            detail(request,response);
        } else if ("/workbench/customer/getRemarkListByCustomerId.do".equals(path)){
            getRemarkListByCustomerId(request,response);
        } else if ("/workbench/customer/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        } else if ("/workbench/customer/saveRemark.do".equals(path)){
            saveRemark(request,response);
        } else if ("/workbench/customer/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改客户备注！");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);
        activityRemark.setEditFlag(editFlag);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = activityService.updateRemark(activityRemark);

        Map<String,Object> map = new HashMap<>();
        map.put("activityRemark",activityRemark);
        map.put("isSuccess",isSuccess);

        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("创建客户备注！");
        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        String activityId = request.getParameter("activityId");

        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateTime(createTime);
        activityRemark.setCreateBy(createBy);
        activityRemark.setEditFlag(editFlag);
        activityRemark.setActivityId(activityId);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = activityService.saveRemark(activityRemark);

        Map<String,Object> map = new HashMap<>();
        map.put("activityRemark",activityRemark);
        map.put("isSuccess",isSuccess);

        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除客户备注！");
        String id = request.getParameter("id");
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = as.deleteRemark(id);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getRemarkListByCustomerId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据客户id查询客户备注列表！");
        String activityId = request.getParameter("activityId");
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> arList = as.getRemarkListByActivityId(activityId);
        PrintJson.printJsonObj(response,arList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到客户详细信息页！");
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer customer = customerService.detail(id);
        request.setAttribute("customer",customer);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改客户！");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String contactSummary = request.getParameter("contactSummary");
        String description = request.getParameter("description");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setContactSummary(contactSummary);
        customer.setDescription(description);
        customer.setNextContactTime(nextContactTime);
        customer.setAddress(address);
        customer.setCreateTime(editTime);
        customer.setCreateBy(editBy);

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isSuccess = customerService.update(customer);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getUserListAndCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户列表和根据客户id查询单条客户记录！");
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String,Object> map = customerService.getUserListAndCustomer(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除客户！");
        String[] ids = request.getParameterValues("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isSuccess = customerService.delete(ids);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询客户列表（分页查询+条件查询）！");
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");

        Integer pageNo = Integer.valueOf(pageNoStr);
        Integer pageSize = Integer.valueOf(pageSizeStr);

        Integer skipCount = (pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        PaginationVO<Customer> vo = cs.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("创建客户！");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String contactSummary = request.getParameter("contactSummary");
        String description = request.getParameter("description");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setContactSummary(contactSummary);
        customer.setDescription(description);
        customer.setNextContactTime(nextContactTime);
        customer.setAddress(address);
        customer.setCreateTime(createTime);
        customer.setCreateBy(createBy);

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isSuccess = customerService.save(customer);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户列表！");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();
        PrintJson.printJsonObj(response,userList);
    }
}

