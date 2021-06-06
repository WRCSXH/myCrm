package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<String> getCustomerName(String name);

    boolean save(Customer customer);

    PaginationVO<Customer> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String,Object> getUserListAndCustomer(String id);

    boolean update(Customer customer);

    Customer detail(String id);

    List<ActivityRemark> getRemarkListByCustomerId(String customerId);

    boolean deleteRemark(String id);

    boolean saveRemark(CustomerRemark customerRemark);

    boolean updateRemark(CustomerRemark customerRemark);
}
