package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    int getCountByCustomerIds(String[] customerIds);

    int deleteByCustomerIds(String[] customerIds);
}
