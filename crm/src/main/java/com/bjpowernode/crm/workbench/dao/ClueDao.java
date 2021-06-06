package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {

    int save(Clue clue);

    Clue detail(String id);

    Clue getById(String id);

    int delete(String id);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    int update(Clue clue);

    int deleteByIds(String[] ids);
}
