package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    @Override
    public boolean save(Tran tran, String customerName) {
        /*
            添加交易业务：
            在做添加之前，参数里面就少了一项信息，就是客户的主键customerId
            （1）先处理和客户相关的需求，判断名为customerName的客户存不存在，在客户表中根据客户名称进行精确查询
                如果有这个客户，则取出这个客户的id封装到t对象中，
                如果没有这个客户，则新建一个客户，再取出这个客户的id封装到t对象中

            （2）经过以上的操作，t对象中的信息就全了，再执行添加交易的操作

            （3）添加交易完毕之后，需要创建一条交易历史
         */
        boolean flag = true;
        Customer customer = customerDao.getByName(customerName);
        if (customer == null){
            // 如果该客户名的客户不存在，新建一个客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(tran.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setDescription(tran.getDescription());

            // 添加客户
            int count1 = customerDao.save(customer);
            if (count1 != 1){
                flag = false;
            }
        }

        // 通过以上对客户的处理，无论是查询除已有的客户，还是之前没有，新建的客户，总之客户有了，可以使用客户的id了

        // 取出客户的id封装到t对象中
        tran.setCustomerId(customer.getId());
        // 添加交易
        int count2 = tranDao.save(tran);
        if (count2 != 1){
            flag = false;
        }

        TranHistory tranHistory = new TranHistory();

        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setTranId(tran.getId());
        // 添加交易历史
        int count3 = tranHistoryDao.save(tranHistory);
        if (count3 != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Tran detail(String id) {
        Tran tran = tranDao.detail(id);
        return tran;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> tranHistoryList = tranHistoryDao.getHistoryListByTranId(tranId);
        return tranHistoryList;
    }

    @Override
    public boolean changeStage(Tran tran) {
        boolean flag = true;

        // 改变交易阶段
        int count1 = tranDao.changeStage(tran);
        if (count1 != 1){
            flag = false;
        }

        // 交易阶段变化后，添加一条交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setTranId(tran.getId());

        // 添加交易历史
        int count2 = tranHistoryDao.save(tranHistory);
        if (count2 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        // 取得total
        int total = tranDao.getTotal();
        // 取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();
        // 取得nameList
        List<String> nameList = tranDao.getNames();
        // 将total、dataList和nameList打包到Map集合中
        Map<String,Object> map = new HashMap<>();
        map.put("total",total);
        map.put("dataList",dataList);
        map.put("nameList",nameList);
        // 返回Map集合
        return map;
    }
}
