package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public boolean save(Activity activity) {
        // 之后用flag代替抛异常
        boolean flag = true;
        int count = activityDao.save(activity);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {
        // 获取total
        Integer total = activityDao.getTotalByCondition(map);
        // 获取dataList
        List<Activity> activityList = activityDao.getActivityListByCondition(map);
        // 创建vo类，将total和dataList都封装到该vo类中
        PaginationVO<Activity> vo = new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(activityList);
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        // 查询出需要删除的备注的数量
        int count1 = activityRemarkDao.getCountByActivityIds(ids);
        // 删除备注，返回受到影响的条数（实际删除的数量）
        int count2 = activityRemarkDao.deleteByActivityIds(ids);
        if (count1 != count2){
            flag = false;
        }
        // 删除市场活动
        int count3 = activityDao.delete(ids);
        if (count3 < 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String,Object> getUserListAndActivity(String id) {
        // 取userList
        List<User> userList = userDao.getUserList();
        // 取activity
        Activity activity = activityDao.getById(id);
        // 将userList和activity打包到Map集合中
        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("activity",activity);
        // 返回Map集合
        return map;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag = true;
        int count = activityDao.update(activity);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemarkListByActivityId(String activityId) {
        List<ActivityRemark> activityRemarkList = activityRemarkDao.getRemarkListByActivityId(activityId);
        return activityRemarkList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityRemarkDao.deleteRemark(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
        boolean flag = true;
        int count = activityRemarkDao.saveRemark(activityRemark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {
        boolean flag = true;
        int count = activityRemarkDao.updateRemark(activityRemark);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        List<Activity> activityList = activityDao.getActivityListByClueId(clueId);
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByActivityNameAndNotByClueId(Map<String, String> map) {
        List<Activity> activityList = activityDao.getActivityListByActivityNameAndNotByClueId(map);
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByActivityName(String activityName) {
        List<Activity> activityList = activityDao.getActivityListByActivityName(activityName);
        return activityList;
    }
}
