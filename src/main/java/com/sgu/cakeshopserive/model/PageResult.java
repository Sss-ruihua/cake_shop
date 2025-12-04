package com.sgu.cakeshopserive.model;

import java.util.List;

/**
 * 分页结果封装类
 * 用于懒加载和分页查询
 */
public class PageResult<T> {
    private List<T> data;          // 当前页数据
    private int currentPage;       // 当前页码
    private int pageSize;         // 每页大小
    private int totalCount;       // 总记录数
    private int totalPages;       // 总页数
    private boolean hasMore;      // 是否还有更多数据
    private boolean isFirst;      // 是否第一页
    private boolean isLast;       // 是否最后一页

    public PageResult() {
    }

    public PageResult(List<T> data, int currentPage, int pageSize, int totalCount) {
        this.data = data;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
        this.hasMore = currentPage < totalPages;
        this.isFirst = currentPage == 1;
        this.isLast = currentPage >= totalPages;
    }

    // Getters and Setters
    public List<T> getData() {
        return data;
    }

    public void setData(List<T> data) {
        this.data = data;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
        this.hasMore = currentPage < totalPages;
        this.isFirst = currentPage == 1;
        this.isLast = currentPage >= totalPages;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public boolean isHasMore() {
        return hasMore;
    }

    public void setHasMore(boolean hasMore) {
        this.hasMore = hasMore;
    }

    public boolean isFirst() {
        return isFirst;
    }

    public void setFirst(boolean first) {
        isFirst = first;
    }

    public boolean isLast() {
        return isLast;
    }

    public void setLast(boolean last) {
        isLast = last;
    }
}