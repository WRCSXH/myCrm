package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    Clue detail(String id);

    boolean unbind(String id);

    boolean bind(String clueId, String[] activityIds);

    boolean convert(String clueId, Tran tran, String createBy);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    boolean delete(String[] ids);
}
