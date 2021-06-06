package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);

    @Override
    public Map<String, List<DicValue>> getDicValueMap() {
        // 查询字典类型列表，封装到List集合中
        List<DicType> dicTypeList = dicTypeDao.getDicTypeList();

        // 创建封装所有字典值List集合的Map集合
        Map<String, List<DicValue>> map = new HashMap<>();

        // 遍历字典类型List集合
        for (DicType dicType:dicTypeList){

            // 通过字典类型type获取字典类型编码code
            String code = dicType.getCode();

            // 通过字典类型编码code查询对应的字典值List集合，DicType中的code即DicValue中的typeCode
            List<DicValue> dicValueList = dicValueDao.getDicValueList(code);

            // 将每一个code和对应的dvList以键值对的形式保存到Map集合中
            map.put(code+"List",dicValueList);
        }

        // 返回Map集合
        return map;
    }
}
