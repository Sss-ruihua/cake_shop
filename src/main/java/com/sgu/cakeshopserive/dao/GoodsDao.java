package com.sgu.cakeshopserive.dao;

import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.utils.DBUtils;
import java.sql.Connection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GoodsDao {

    public List<Goods> getAllGoods() {
        List<Goods> goodsList = new ArrayList<>();
        String sql = "SELECT g.*, t.type_name FROM goods g " +
                    "LEFT JOIN type t ON g.type_id = t.type_id " +
                    "ORDER BY g.create_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Goods goods = extractGoodsFromResultSet(rs);
                goodsList.add(goods);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return goodsList;
    }

    public List<Goods> getGoodsByTypeId(int typeId) {
        List<Goods> goodsList = new ArrayList<>();
        String sql = "SELECT g.*, t.type_name FROM goods g " +
                    "LEFT JOIN type t ON g.type_id = t.type_id " +
                    "WHERE g.type_id = ? " +
                    "ORDER BY g.create_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, typeId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Goods goods = extractGoodsFromResultSet(rs);
                    goodsList.add(goods);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return goodsList;
    }

    public List<Goods> getRecommendedGoods(String recommendType, int limit) {
        List<Goods> goodsList = new ArrayList<>();
        String sql = "SELECT g.*, t.type_name FROM goods g " +
                    "LEFT JOIN type t ON g.type_id = t.type_id " +
                    "INNER JOIN recommend r ON g.goods_id = r.goods_id " +
                    "WHERE r.recommend_type = ? " +
                    "ORDER BY r.sort_order ASC, r.create_time DESC " +
                    "LIMIT ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, recommendType);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Goods goods = extractGoodsFromResultSet(rs);
                    goodsList.add(goods);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return goodsList;
    }

    public Goods getGoodsById(int goodsId) {
        String sql = "SELECT g.*, t.type_name FROM goods g " +
                    "LEFT JOIN type t ON g.type_id = t.type_id " +
                    "WHERE g.goods_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, goodsId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractGoodsFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Goods> searchGoods(String keyword) {
        List<Goods> goodsList = new ArrayList<>();
        String sql = "SELECT g.*, t.type_name FROM goods g " +
                    "LEFT JOIN type t ON g.type_id = t.type_id " +
                    "WHERE g.goods_name LIKE ? OR g.description LIKE ? " +
                    "ORDER BY g.create_time DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Goods goods = extractGoodsFromResultSet(rs);
                    goodsList.add(goods);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return goodsList;
    }

    public List<Goods> getHotGoods(int limit) {
        return getRecommendedGoods("hot", limit);
    }

    public List<Goods> getNewGoods(int limit) {
        return getRecommendedGoods("new", limit);
    }

    public List<Goods> getBannerGoods(int limit) {
        return getRecommendedGoods("banner", limit);
    }

    public boolean updateStock(int goodsId, int quantity) {
        String sql = "UPDATE goods SET stock = stock - ? WHERE goods_id = ? AND stock >= ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, goodsId);
            stmt.setInt(3, quantity);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Goods extractGoodsFromResultSet(ResultSet rs) throws SQLException {
        Goods goods = new Goods();
        goods.setGoodsId(rs.getInt("goods_id"));
        goods.setGoodsName(rs.getString("goods_name"));
        goods.setCoverImage(rs.getString("cover_image"));
        goods.setDetailImage(rs.getString("detail_image"));
        goods.setPrice(rs.getBigDecimal("price"));
        goods.setDescription(rs.getString("description"));
        goods.setStock(rs.getInt("stock"));
        goods.setTypeId(rs.getInt("type_id"));
        goods.setCreateTime(rs.getTimestamp("create_time"));
        goods.setUpdateTime(rs.getTimestamp("update_time"));
        goods.setTypeName(rs.getString("type_name"));

        return goods;
    }
}