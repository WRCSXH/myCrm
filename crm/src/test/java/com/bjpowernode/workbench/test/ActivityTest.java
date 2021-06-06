package com.bjpowernode.workbench.test;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import org.junit.Assert;
import org.junit.Test;

// junit：单元测试，未来实际项目开发中代替main方法，支持多线程，同时测试多个方法
public class ActivityTest {

    @Test
    public void testSaveActivities(){
        for (int i = 0; i < 238; i++) {
            Activity activity = new Activity(UUIDUtil.getUUID(),
                    (i%2 == 0)?"06f5fc056eac41558a964f96daa7f27c":"40f6cdea0bd34aceb77492a1656d9fb3",
                    "市场活动"+i,
                    "2021-01-01",
                    "2021-02-02",
                    "1000",
                    "描述"+i,
                    DateTimeUtil.getSysTime(),
                    (i%2 == 0)?"李四":"张三",
                    null,
                    null);
            ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
            activityService.save(activity);
        }
    }

    // 注解式开发
    @Test
    public void testSave(){
        System.out.println("123!");
        Activity a = new Activity();
        a.setId(UUIDUtil.getUUID());
        a.setName("宣传发布会");
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = as.save(a);
        // 断言，能将实际的测试结果与预期结果进行比对，如果不符将打印错误报告
        Assert.assertEquals(flag,true);
    }

    @Test
    public void testUpdate(){
        // 出现异常将无法通过测试
        // String str = null;
        // str.length();
        System.out.println("456!");
    }
}
