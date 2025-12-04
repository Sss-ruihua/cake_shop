package com.sgu.cakeshopserive.service;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.dao.TypeDao;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.model.Type;
import com.sgu.cakeshopserive.model.PageResult;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * 商品业务逻辑服务类
 */
public class GoodsService {

    private GoodsDao goodsDao = new GoodsDao();
    private TypeDao typeDao = new TypeDao();

    /**
     * 获取首页推荐商品
     * @return 推荐商品结果
     */
    public Result<IndexRecommendations> getIndexRecommendations() {
        try {
            List<Goods> hotGoods = goodsDao.getHotGoods(6);
            List<Goods> newGoods = goodsDao.getNewGoods(6);
            List<Goods> bannerGoods = goodsDao.getBannerGoods(3);
            List<Type> types = typeDao.getAllTypes();

            // 创建类型映射
            Map<Integer, String> typeMap = new HashMap<>();
            for (Type type : types) {
                typeMap.put(type.getTypeId(), type.getTypeName());
            }

            IndexRecommendations recommendations = new IndexRecommendations();
            recommendations.setHotGoods(hotGoods);
            recommendations.setNewGoods(newGoods);
            recommendations.setBannerGoods(bannerGoods);
            recommendations.setTypes(types);
            recommendations.setTypeMap(typeMap);

            return Result.success(recommendations);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取推荐商品失败：" + e.getMessage());
        }
    }

    /**
     * 根据ID获取商品详情
     * @param goodsId 商品ID
     * @return 商品详情结果
     */
    public Result<Goods> getGoodsById(int goodsId) {
        if (goodsId <= 0) {
            return Result.error("商品ID无效", Constants.CODE_PARAM_ERROR);
        }

        try {
            Goods goods = goodsDao.getGoodsById(goodsId);
            if (goods == null) {
                return Result.error("商品不存在", Constants.CODE_GOODS_NOT_FOUND);
            }
            return Result.success(goods);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取商品详情失败：" + e.getMessage());
        }
    }

    /**
     * 根据分类获取商品列表
     * @param typeId 分类ID
     * @return 商品列表结果
     */
    public Result<List<Goods>> getGoodsByType(int typeId) {
        if (typeId <= 0) {
            return Result.error("分类ID无效", Constants.CODE_PARAM_ERROR);
        }

        try {
            Type type = typeDao.getTypeById(typeId);
            if (type == null) {
                return Result.error("分类不存在", Constants.CODE_TYPE_NOT_FOUND);
            }

            List<Goods> goodsList = goodsDao.getGoodsByTypeId(typeId);
            return Result.success(goodsList);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取分类商品失败：" + e.getMessage());
        }
    }

    /**
     * 搜索商品
     * @param keyword 搜索关键词
     * @return 搜索结果
     */
    public Result<List<Goods>> searchGoods(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Result.error("搜索关键词不能为空", Constants.CODE_PARAM_ERROR);
        }

        try {
            List<Goods> searchResults = goodsDao.searchGoods(keyword.trim());
            return Result.success(searchResults);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("搜索商品失败：" + e.getMessage());
        }
    }

    /**
     * 获取所有商品
     * @return 商品列表结果
     */
    public Result<List<Goods>> getAllGoods() {
        try {
            List<Goods> allGoods = goodsDao.getAllGoods();
            return Result.success(allGoods);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取商品列表失败：" + e.getMessage());
        }
    }

    // ========== 分页查询方法 ==========

    /**
     * 分页获取所有商品（用于懒加载）
     * @param currentPage 当前页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    public Result<PageResult<Goods>> getAllGoodsPaginated(int currentPage, int pageSize) {
        if (currentPage <= 0) currentPage = 1;
        if (pageSize <= 0) pageSize = 12; // 默认每页12个商品

        try {
            PageResult<Goods> pageResult = goodsDao.getAllGoodsPaginated(currentPage, pageSize);
            return Result.success(pageResult);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("分页获取商品失败：" + e.getMessage());
        }
    }

    /**
     * 分页根据分类获取商品（用于懒加载）
     * @param typeId 分类ID
     * @param currentPage 当前页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    public Result<PageResult<Goods>> getGoodsByTypePaginated(int typeId, int currentPage, int pageSize) {
        if (typeId <= 0) {
            return Result.error("分类ID无效", Constants.CODE_PARAM_ERROR);
        }
        if (currentPage <= 0) currentPage = 1;
        if (pageSize <= 0) pageSize = 12; // 默认每页12个商品

        try {
            // 验证分类是否存在
            Type type = typeDao.getTypeById(typeId);
            if (type == null) {
                return Result.error("分类不存在", Constants.CODE_TYPE_NOT_FOUND);
            }

            PageResult<Goods> pageResult = goodsDao.getGoodsByTypeIdPaginated(typeId, currentPage, pageSize);
            return Result.success(pageResult);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("分页获取分类商品失败：" + e.getMessage());
        }
    }

    /**
     * 分页搜索商品（用于懒加载）
     * @param keyword 搜索关键词
     * @param currentPage 当前页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    public Result<PageResult<Goods>> searchGoodsPaginated(String keyword, int currentPage, int pageSize) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Result.error("搜索关键词不能为空", Constants.CODE_PARAM_ERROR);
        }
        if (currentPage <= 0) currentPage = 1;
        if (pageSize <= 0) pageSize = 12; // 默认每页12个商品

        try {
            PageResult<Goods> pageResult = goodsDao.searchGoodsPaginated(keyword.trim(), currentPage, pageSize);
            return Result.success(pageResult);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("分页搜索商品失败：" + e.getMessage());
        }
    }

    /**
     * 首页推荐商品数据类
     */
    public static class IndexRecommendations {
        private List<Goods> hotGoods;
        private List<Goods> newGoods;
        private List<Goods> bannerGoods;
        private List<Type> types;
        private Map<Integer, String> typeMap;

        public IndexRecommendations() {}

        public List<Goods> getHotGoods() {
            return hotGoods;
        }

        public void setHotGoods(List<Goods> hotGoods) {
            this.hotGoods = hotGoods;
        }

        public List<Goods> getNewGoods() {
            return newGoods;
        }

        public void setNewGoods(List<Goods> newGoods) {
            this.newGoods = newGoods;
        }

        public List<Goods> getBannerGoods() {
            return bannerGoods;
        }

        public void setBannerGoods(List<Goods> bannerGoods) {
            this.bannerGoods = bannerGoods;
        }

        public List<Type> getTypes() {
            return types;
        }

        public void setTypes(List<Type> types) {
            this.types = types;
        }

        public Map<Integer, String> getTypeMap() {
            return typeMap;
        }

        public void setTypeMap(Map<Integer, String> typeMap) {
            this.typeMap = typeMap;
        }
    }
}