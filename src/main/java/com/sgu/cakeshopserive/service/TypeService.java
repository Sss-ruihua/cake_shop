package com.sgu.cakeshopserive.service;

import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.dao.TypeDao;
import com.sgu.cakeshopserive.model.Type;

import java.util.List;

/**
 * 分类业务逻辑服务类
 */
public class TypeService {

    private TypeDao typeDao = new TypeDao();

    /**
     * 获取所有分类
     * @return 分类列表结果
     */
    public Result<List<Type>> getAllTypes() {
        try {
            List<Type> types = typeDao.getAllTypes();
            return Result.success(types);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取分类列表失败：" + e.getMessage());
        }
    }

    /**
     * 根据ID获取分类
     * @param typeId 分类ID
     * @return 分类结果
     */
    public Result<Type> getTypeById(int typeId) {
        if (typeId <= 0) {
            return Result.error("分类ID无效");
        }

        try {
            Type type = typeDao.getTypeById(typeId);
            if (type == null) {
                return Result.error("分类不存在");
            }
            return Result.success(type);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取分类详情失败：" + e.getMessage());
        }
    }

    /**
     * 根据ID获取分类名称
     * @param typeId 分类ID
     * @return 分类名称结果
     */
    public Result<String> getTypeNameById(int typeId) {
        if (typeId <= 0) {
            return Result.error("分类ID无效");
        }

        try {
            String typeName = typeDao.getTypeNameById(typeId);
            if (typeName == null) {
                return Result.error("分类不存在");
            }
            return Result.success(typeName);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取分类名称失败：" + e.getMessage());
        }
    }
}