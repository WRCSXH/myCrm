package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入线索控制器！");
        // 获取url-pattern，判断执行哪个业务
        String path =  request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)){
             getUserList(request,response);
        } else if ("/workbench/clue/save.do".equals(path)) {
            save(request, response);
        } else if ("/workbench/clue/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/clue/getActivityListByClueId.do".equals(path)) {
            getActivityListByClueId(request, response);
        } else if ("/workbench/clue/unbind.do".equals(path)) {
            unbind(request, response);
        } else if ("/workbench/clue/getActivityListByActivityNameAndNotByClueId.do".equals(path)) {
            getActivityListByActivityNameAndNotByClueId(request, response);
        } else if ("/workbench/clue/bind.do".equals(path)) {
            bind(request, response);
        } else if ("/workbench/clue/getActivityListByActivityName.do".equals(path)) {
            getActivityListByActivityName(request, response);
        } else if ("/workbench/clue/convert.do".equals(path)) {
            convert(request, response);
        } else if ("/workbench/clue/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/clue/getUserListAndClue.do".equals(path)) {
            getUserListAndClue(request, response);
        } else if ("/workbench/clue/update.do".equals(path)) {
            update(request, response);
        } else if ("/workbench/clue/delete.do".equals(path)) {
            delete(request, response);
        } else if ("/workbench/clue/getRemarkListByClueId.do".equals(path)){
            getRemarkListByClueId(request,response);
        } else if ("/workbench/clue/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        } else if ("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        } else if ("/workbench/clue/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
    }

    private void getRemarkListByClueId(HttpServletRequest request, HttpServletResponse response) {
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除线索！");
        String[] ids = request.getParameterValues("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isSuccess = clueService.delete(ids);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改线索！");
            String id = request.getParameter("id");
            String fullname = request.getParameter("fullname");
            String appellation = request.getParameter("appellation");
            String owner = request.getParameter("owner");
            String company = request.getParameter("company");
            String job = request.getParameter("job");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String website = request.getParameter("website");
            String mphone = request.getParameter("mphone");
            String state = request.getParameter("state");
            String source = request.getParameter("source");
            String editTime = DateTimeUtil.getSysTime();
            String editBy = ((User)request.getSession().getAttribute("user")).getName();
            String description = request.getParameter("description");
            String contactSummary = request.getParameter("contactSummary");
            String nextContactTime = request.getParameter("nextContactTime");
            String address = request.getParameter("address");

            Clue clue = new Clue();
            clue.setId(id);
            clue.setFullname(fullname);
            clue.setAppellation(appellation);
            clue.setOwner(owner);
            clue.setCompany(company);
            clue.setJob(job);
            clue.setEmail(email);
            clue.setPhone(phone);
            clue.setWebsite(website);
            clue.setMphone(mphone);
            clue.setState(state);
            clue.setSource(source);
            clue.setEditTime(editTime);
            clue.setEditBy(editBy);
            clue.setDescription(description);
            clue.setContactSummary(contactSummary);
            clue.setNextContactTime(nextContactTime);
            clue.setAddress(address);

            ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
            boolean isSuccess = clueService.update(clue);
            PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户列表和根据线索id查询单条线索记录！");
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map = clueService.getUserListAndClue(id);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询线索列表（分页查询+条件查询）！");
            String pageNoStr = request.getParameter("pageNo");
            String pageSizeStr = request.getParameter("pageSize");
            String fullname = request.getParameter("fullname");
            String company = request.getParameter("company");
            String phone = request.getParameter("phone");
            String source = request.getParameter("source");
            String owner = request.getParameter("owner");
            String mphone = request.getParameter("mphone");
            String state = request.getParameter("state");

            Integer pageNo = Integer.valueOf(pageNoStr);
            Integer pageSize = Integer.valueOf(pageSizeStr);

            Integer skipCount = (pageNo-1)*pageSize;

            Map<String,Object> map = new HashMap<>();
            map.put("fullname",fullname);
            map.put("company",company);
            map.put("phone",phone);
            map.put("source",source);
            map.put("owner",owner);
            map.put("mphone",mphone);
            map.put("state",state);
            map.put("skipCount",skipCount);
            map.put("pageSize",pageSize);

            ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
            PaginationVO<Clue> vo = clueService.pageList(map);
            PrintJson.printJsonObj(response,vo);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("转换线索！");
        String clueId = request.getParameter("clueId");
        // 接收是否需要创建交易的标记
        String flag = request.getParameter("flag");
        Tran tran = null;
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        // 如果需要创建交易
        if ("a".equals(flag)){
            tran = new Tran();
            // 接收交易表单中的数据
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");

            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();

            // 将交易对象中能填写的属性先填写
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);

            tran.setId(id);
            tran.setCreateTime(createTime);
            tran.setCreateBy(createBy);
        }

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        /*
            关于需要向业务层提供的参数
            1、必须提供参数clueId，这样我们才能知道操作的是哪条线索
            2、必须提供参数交易对象t，因为转换线索的过程中可能需要添加一条交易记录（也有可能不需要添加，此时t == null）
            3、提供参数createBy是因为后面做添加操作时需要用到
         */
        boolean isSuccess = clueService.convert(clueId,tran,createBy);
        System.out.println(isSuccess);
        if (isSuccess){
            // 由于没有携带参数，所以建议使用动态路径发送重定向请求
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
    }

    private void getActivityListByActivityName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据市场活动名称模糊查询市场活动列表！");
        String aName = request.getParameter("activityName");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByActivityName(aName);
        PrintJson.printJsonObj(response,activityList);
    }

    private void bind(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("关联市场活动！");
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isSuccess = clueService.bind(clueId,activityIds);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getActivityListByActivityNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据市场活动名称模糊查询未关联指定线索的市场活动列表！");
        String activityName = request.getParameter("activityName");
        String clueId = request.getParameter("clueId");

        Map<String,String> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByActivityNameAndNotByClueId(map);
        PrintJson.printJsonObj(response,activityList);
    }

    private void unbind(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("解除线索和市场活动的关联！");
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isSuccess = clueService.unbind(id);
        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据线索id查询关联的市场活动列表！");
        String clueId = request.getParameter("clueId");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActivityListByClueId(clueId);
        PrintJson.printJsonObj(response,activityList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到线索详细信息页！");
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.detail(id);
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加线索！");
        String id = UUIDUtil.getUUID();
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isSuccess = clueService.save(clue);

        PrintJson.printJsonFlag(response,isSuccess);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户列表！");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }
}
