package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    int delete(String clueId);

    int getCountByClueIds(String[] clueIds);

    int deleteByClueIds(String[] clueIds);
}
