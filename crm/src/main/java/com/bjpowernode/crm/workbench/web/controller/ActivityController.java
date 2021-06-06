package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.*;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入市场活动控制器！");
        // 获取url-pattern，判断执行哪个业务
        String path =  request.getServletPath();
        System.out.println(path);
        // 虽然只需要用到用户姓名，但是为了以后方便拓展业务，选择查询所有User对象
        // 因为是从市场活动模块发起的请求，所以控制层选择ActivityController
        // 模板模式
        if ("/workbench/activity/getUserList.do".equals(path)){
             getUserList(request,response);
        } else if ("/workbench/activity/save.do".equals(path)){
            save(request,response);
        } else if ("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        } else if ("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        } else if ("/workbench/activity/getUserListAndActivity.do".equals(path)){
            getUserListAndActivity(request,response);
        } else if ("/workbench/activity/update.do".equals(path)){
            update(request,response);
        } else if ("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        } else if ("/workbench/activity/getRemarkListByActivityId.do".equals(path)){
            getRemarkListByActivityId(request,response);
        } else if ("/workbench/activity/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        } else if ("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        } else if ("/workbench/activity/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改市场活动备注！");
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
        System.out.println("创建市场活动备注！");
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
        System.out.println("删除市场活动备注！");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getRemarkListByActivityId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据市场活动id查询市场活动备注列表！");
        String activityId = request.getParameter("activityId");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> activityRemarkList = activityService.getRemarkListByActivityId(activityId);
        PrintJson.printJsonObj(response,activityRemarkList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到市场活动详细信息页！");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.detail(id);
        request.setAttribute("activity",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改市场活动！");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        // 修改时间：系统当前时间
        String editTime = DateTimeUtil.getSysTime();
        // 修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        // 不需要创建时间和创建人这两项

        // 创建Activity对象保存参数
        Activity activity  = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = activityService.update(activity);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户列表和根据市场活动id查询单条市场活动记录！");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
            总结：
                controller层调用service层的方法，返回值应该是什么？
                    你得想想前端需要什么，就得从service层取什么
                    前端需要的是：
                        List<User> uList，Activity a
                    以上两项信息，复用率不高，我们选择使用Map集合打包这两项信息即可
         */
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除市场活动！");
        String[] ids = request.getParameterValues("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = activityService.delete(ids);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询市场活动列表（分页查询+条件查询）！");
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        // 页数
        Integer pageNo = Integer.valueOf(pageNoStr);
        // 每一页的记录条数
        Integer pageSize = Integer.valueOf(pageSizeStr);
        // 跳过的记录条数
        Integer skipCount = (pageNo-1)*pageSize;

        // 使用Map集合保存参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
            前端需要 市场活动列表 和 查询的记录总条数 这两条数据，但是这两条数据无法封装到一个Activity对象中
            业务层获取到这两条数据后，应该以Map集合的形式返回，还是以vo类的形式返回？

            答案是以vo类的形式返回，因为在以后的模块中也需要处理分页查询，创建一个专门的vo类，操作起来更为方便
         */
        PaginationVO<Activity> vo = activityService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("创建市场活动！");
        // 获取参数
        // 市场活动id由UUID生成
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        // 创建时间：系统当前时间
        String createTime = DateTimeUtil.getSysTime();
        // 创建人：当前登录用户
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        // 不需要修改时间和修改人这两项

        // 创建Activity对象保存参数
        Activity activity  = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isSuccess = activityService.save(activity);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户列表！");
        // 但是查询的业务实际上是用户模块的，所以业务层选择UserService
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
        }
    }
