package com.bjpowernode.workbench.test;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.workbench.service.impl.ClueServiceImpl;
import org.junit.Test;

public class ClueTest {
    @Test
    public void testSaveClues(){
        for (int i = 0; i < 139; i++) {
            ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
            Clue clue = new Clue(UUIDUtil.getUUID(),
                    "姓名"+i,
                    "先生",
                    (i%2 == 0)?"06f5fc056eac41558a964f96daa7f27c":"40f6cdea0bd34aceb77492a1656d9fb3",
                    "公司"+i,
                    "职位"+i,
                    "姓名"+i+"@qq.com",
                    "010-74632153"+i,
                    "www."+"公司"+i+".com",
                    "1817463215"+i,
                    "试图联系",
                    "广告",
                    (i%2 == 0)?"李四":"张三",
                    DateTimeUtil.getSysTime(),
                    null,
                    null,
                    "描述"+i,
                    "联系纪要"+i,
                    "2021-01-27",
                    "详细地址"+i);
            clueService.save(clue);
        }
    }
}
