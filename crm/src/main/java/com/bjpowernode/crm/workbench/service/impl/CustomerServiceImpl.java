package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.CustomerRemarkDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.CustomerService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public List<String> getCustomerName(String name) {
        List<String> nameList = customerDao.getCustomerName(name);
        return nameList;
    }

    @Override
    public boolean save(Customer customer) {
        boolean flag = true;
        int count = customerDao.save(customer);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        Integer total = customerDao.getTotalByCondition(map);
        List<Customer> customerList = customerDao.getCustomerListByCondition(map);
        PaginationVO<Customer> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(customerList);
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        // 查询出需要删除的备注的数量
        int count1 = customerRemarkDao.getCountByCustomerIds(ids);
        // 删除备注，返回受到影响的条数（实际删除的数量）
        int count2 = customerRemarkDao.deleteByCustomerIds(ids);
        if (count1 != count2){
            flag = false;
        }
        // 删除市场活动
        int count3 = customerDao.delete(ids);
        if (count3 < 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndCustomer(String id) {
        List<User> userList = userDao.getUserList();
        Customer customer = customerDao.getById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("customer",customer);
        return map;
    }

    @Override
    public boolean update(Customer customer) {
        boolean flag = true;
        int count = customerDao.update(customer);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Customer detail(String id) {
        Customer customer = customerDao.detail(id);
        return customer;
    }

    @Override
    public List<ActivityRemark> getRemarkListByCustomerId(String customerId) {
        return null;
    }

    @Override
    public boolean deleteRemark(String id) {
        return false;
    }

    @Override
    public boolean saveRemark(CustomerRemark customerRemark) {
        return false;
    }

    @Override
    public boolean updateRemark(CustomerRemark customerRemark) {
        return false;
    }
}
