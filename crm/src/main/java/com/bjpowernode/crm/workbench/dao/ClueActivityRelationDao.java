package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {

    int bind(ClueActivityRelation clueActivityRelation);

    int unbind(String id);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(String clueId);

    int deleteByClueIds(String[] clueIds);
}
