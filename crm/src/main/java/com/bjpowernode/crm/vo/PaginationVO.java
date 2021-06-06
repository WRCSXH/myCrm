package com.bjpowernode.crm.vo;

import java.util.List;

// 用于展示分页查询结果的vo类，通用
public class PaginationVO<T> {
    private int total;// 总记录条数
    private List<T> dataList;// 所有记录的集合

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
