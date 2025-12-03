package com.sgu.cakeshopserive.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Goods {
    private int goodsId;
    private String goodsName;
    private String coverImage;
    private String detailImage;
    private BigDecimal price;
    private String description;
    private int stock;
    private Integer typeId;
    private Timestamp createTime;
    private Timestamp updateTime;

    // 关联的分类名称
    private String typeName;

    public Goods() {}

    public Goods(int goodsId, String goodsName, String coverImage, String detailImage,
                BigDecimal price, String description, int stock, Integer typeId) {
        this.goodsId = goodsId;
        this.goodsName = goodsName;
        this.coverImage = coverImage;
        this.detailImage = detailImage;
        this.price = price;
        this.description = description;
        this.stock = stock;
        this.typeId = typeId;
    }

    // Getters and Setters
    public int getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(int goodsId) {
        this.goodsId = goodsId;
    }

    public String getGoodsName() {
        return goodsName;
    }

    public void setGoodsName(String goodsName) {
        this.goodsName = goodsName;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public String getDetailImage() {
        return detailImage;
    }

    public void setDetailImage(String detailImage) {
        this.detailImage = detailImage;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    @Override
    public String toString() {
        return "Goods{" +
                "goodsId=" + goodsId +
                ", goodsName='" + goodsName + '\'' +
                ", coverImage='" + coverImage + '\'' +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", stock=" + stock +
                ", typeId=" + typeId +
                ", typeName='" + typeName + '\'' +
                '}';
    }
}