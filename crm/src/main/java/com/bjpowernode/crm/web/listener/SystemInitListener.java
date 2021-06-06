package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * 服务器初始化监听器
 */
public class SystemInitListener implements ServletContextListener {
    /*
        contextInitialized()方法能够监听上下文域对象application的创建，
        当服务器启动后，上下文域对象创建会立刻执行该方法
     */
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("服务器缓存处理数据字典开始！");
        // 通过参数sce能够取得被监听的对象
        ServletContext application = servletContextEvent.getServletContext();
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImpl());
        /*
            控制层应该从业务层取得所有装着相同字典类型的字典值的List集合，封装到一个Map集合中
            map.put("appellation",dicValueList1);
            map.put("clueState",dicValueList2);
            map.put("returnPriority",dicValueList3);
            ...
         */
        Map<String, List<DicValue>> map = dicService.getDicValueMap();
        // 将map解析为上下文域对象中的键值对
        Set<String> keySet = map.keySet();
        for (String key:keySet){
            application.setAttribute(key,map.get(key));
        }

        System.out.println("服务器缓存处理数据字典结束！");

        // 数据字典处理完毕之后，处理Stage2Possibility.properties属性配置文件

        /*
            处理Stage2Possibility.properties属性配置文件的步骤：
            解析该文件，将该文件中的键值对关系，解析为java中的键值对关系

            Map<String（stage阶段）,String（possibility可能性）> stagePossibilityMap = ......
            stagePossibilityMap.put("01资质审查",10);
            stagePossibilityMap.put("02需求分析",25);
            ......
            stagePossibilityMap.put("07成交",100);

            stagePossibilityMap保存值之后，放在服务器缓存中
            application.setAttribute("stagePossibilityMap",stagePossibilityMap);
         */

        // 解析Stage2Possibility.properties属性配置文件
        Map<String,String> stagePossibilityMap = new HashMap<>();
        ResourceBundle resourceBundle = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> enumeration = resourceBundle.getKeys();
        while (enumeration.hasMoreElements()){
            // 阶段
            String stage = enumeration.nextElement();
            // 可能性
            String possibility = resourceBundle.getString(stage);

            stagePossibilityMap.put(stage,possibility);
        }

        // 将spMap保存到服务器缓存中
        application.setAttribute("stagePossibilityMap",stagePossibilityMap);
        /*
            在遍历集合的时候，使用迭代器的效率是最高的，使用foreach最方便
            因此数据量不大时，建议使用foreach；数据量大时，建议使用迭代器
         */
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}
