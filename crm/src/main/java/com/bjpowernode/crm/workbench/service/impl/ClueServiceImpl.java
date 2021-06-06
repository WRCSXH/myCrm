package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    // 线索相关表
    ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);

    // 客户相关表
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    // 联系人相关表
    ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);

    // 交易相关表
    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    // 用户列表
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public boolean save(Clue clue) {
        boolean flag = true;
        int count = clueDao.save(clue);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Clue detail(String id) {
        Clue clue = clueDao.detail(id);
        return clue;
    }

    @Override
    public boolean unbind(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.unbind(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean bind(String clueId, String[] activityIds) {
        boolean flag = true;
        for (String activityId:activityIds){
            // 取得每一个activityId和clueId关联
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setClueId(clueId);
            clueActivityRelation.setActivityId(activityId);
            int count = clueActivityRelationDao.bind(clueActivityRelation);
            if (count != 1){
                flag = false;
            }
        }
        return flag;
    }

    @Override
    public boolean convert(String clueId, Tran tran, String createBy) {
        boolean flag = true;
        // (1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueDao.getById(clueId);
        // (2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        // 客户以公司的名义存储，只能有一个，需要判断客户表中存不存在
        String company = clue.getCompany();
        // 在客户表中根据公司名称查单条记录，返回客户对象，后面需要用到
        Customer customer = customerDao.getByName(company);
        if (customer == null){
            // 如果客户不存在，新建客户
            customer = new Customer();

            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(company);
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());

            // 添加客户
            int count1 = customerDao.save(customer);
            if (count1 != 1){
                flag = false;
            }
        }
        // 经过第二步的处理，我们已经拥有了客户的信息，今后在操作其它表时，如果需要用到客户id，可以使用cus.getId()

        // (3) 通过线索对象提取联系人信息，保存联系人
        // 一个客户（公司）可以有多个联系人（员工），不需要判断存不存在
        Contacts contacts = new Contacts();

        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());

        // 添加联系人
        int count2 = contactsDao.save(contacts);
        if (count2 != 1){
            flag = false;
        }

        // 经过第三步的处理，我们已经拥有了联系人的信息，今后在操作其它表时，如果需要用到联系人id，可以使用con.getId()

        // (4) 线索备注转换到客户备注以及联系人备注

        // 在线索备注表中，根据线索id查询对应的线索备注列表
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        // 遍历每一个线索备注对象，取出线索备注内容，分别转换到客户备注以及联系人备注
        for (ClueRemark clueRemark:clueRemarkList){
            // 创建客户备注对象
            CustomerRemark customerRemark = new CustomerRemark();

            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(DateTimeUtil.getSysTime());
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());

            // 添加客户备注
            int count3 = customerRemarkDao.save(customerRemark);
            if (count3 != 1){
                flag = false;
            }

            // 创建联系人备注对象
            ContactsRemark contactsRemark = new ContactsRemark();

            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contacts.getId());

            // 添加联系人备注
            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4 != 1){
                flag = false;
            }
        }

        // (5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系

        // 在线索和市场活动关系表中，根据线索id查询对应的线索和市场活动关系列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        // 遍历每一个线索和市场活动关系对象，取出市场活动id，转换到联系人和市场活动关系
        for (ClueActivityRelation clueActivityRelation:clueActivityRelationList){

            // 创建联系人和市场活动关系对象
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();

            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());

            // 添加联系人和市场活动关系
            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count5 != 1){
                flag = false;
            }
        }

        // (6) 如果有创建交易需求，创建一条交易
        if (tran != null){
            tran.setOwner(clue.getOwner());
            tran.setCustomerId(customer.getId());
            tran.setSource(clue.getSource());
            tran.setContactsId(contacts.getId());
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());
            tran.setNextContactTime(clue.getNextContactTime());

            // 添加交易
            int count6 = tranDao.save(tran);
            if (count6 != 1){
                flag = false;
            }

            // (7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();

            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(DateTimeUtil.getSysTime());
            tranHistory.setCreateBy(createBy);
            tranHistory.setTranId(tran.getId());

            // 添加交易历史
            int count7 = tranHistoryDao.save(tranHistory);
            if (count7 != 1){
                flag = false;
            }
        }

        // (8) 删除线索备注
        int count8 = clueRemarkDao.delete(clueId);
        if (count8 != 1 && count8 != 0){
            flag = false;
        }

        // (9) 删除线索和市场活动的关系
        int count9 = clueActivityRelationDao.delete(clueId);
        if (count9 != 1 && count9 != 0){
            flag = false;
        }

        // (10) 删除线索
        int count10 = clueDao.delete(clueId);
        if (count10 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        Integer total = clueDao.getTotalByCondition(map);
        List<Clue> clueList = clueDao.getClueListByCondition(map);
        PaginationVO<Clue> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(clueList);
        return vo;
    }

    @Override
    public Map<String, Object> getUserListAndClue(String id) {
        List<User> userList = userDao.getUserList();
        Clue clue = clueDao.getById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("clue",clue);
        return map;
    }

    @Override
    public boolean update(Clue clue) {
        boolean flag = true;
        int count = clueDao.update(clue);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        int count1 = clueRemarkDao.getCountByClueIds(ids);
        int count2 = clueRemarkDao.deleteByClueIds(ids);
        if (count1 != count2){
            flag = false;
        }
        int count3 = clueActivityRelationDao.deleteByClueIds(ids);
        if (count3 != 1){
            flag = false;
        }
        int count4 = clueDao.deleteByIds(ids);
        if (count4 != 1){
            flag = false;
        }
        return flag;
    }
}
