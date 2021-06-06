package com.bjpowernode.workbench.test;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.impl.CustomerServiceImpl;
import org.junit.Test;

public class CustomerTest {
    @Test
    public void testSaveCustomers(){
        for (int i = 0; i < 182; i++) {
            Customer customer = new Customer(UUIDUtil.getUUID(),
                    (i%2 == 0)?"06f5fc056eac41558a964f96daa7f27c":"40f6cdea0bd34aceb77492a1656d9fb3",
                    "名字"+i,
                    "www.名字"+i+".com",
                    "001-9435672"+i,
                    (i%2 == 0)?"李四":"张三",
                    DateTimeUtil.getSysTime(),
                    null,
                    null,
                    "联系纪要"+i,
                    "2021-01-15",
                    "描述"+i,
                    "详细地址"+i
                    );
            CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
            customerService.save(customer);
        }
    }
}
