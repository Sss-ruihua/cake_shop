package com.sgu.cakeshopserive.dao;

import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.model.PageResult;
import com.sgu.cakeshopserive.utils.DBUtils;
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

    /**
     * 获取搜索建议
     * @param keyword 搜索关键词
     * @return 搜索建议列表
     */
    public List<String> getSearchSuggestions(String keyword) {
        List<String> suggestions = new ArrayList<>();

        // 查询匹配商品名称的建议
        String nameSql = "SELECT DISTINCT goods_name FROM goods " +
                        "WHERE goods_name LIKE ? " +
                        "ORDER BY " +
                        "CASE " +
                        "  WHEN goods_name LIKE ? THEN 1 " +
                        "  WHEN goods_name LIKE ? THEN 2 " +
                        "  ELSE 3 " +
                        "END, " +
                        "LENGTH(goods_name) ASC " +
                        "LIMIT 5";

        // 查询匹配商品描述的推荐词
        String descSql = "SELECT DISTINCT " +
                        "CASE " +
                        "  WHEN goods_name LIKE ? THEN goods_name " +
                        "  WHEN description LIKE ? THEN " +
                        "    CASE " +
                        "      WHEN LOCATE('蛋糕', description) > 0 AND LOCATE(keyword, description) > 0 THEN CONCAT(SUBSTRING(description, 1, LOCATE('蛋糕', description) + 2), '蛋糕') " +
                        "      WHEN LOCATE('鲜奶', description) > 0 AND LOCATE(keyword, description) > 0 THEN CONCAT(SUBSTRING(description, 1, LOCATE('鲜奶', description) + 2), '鲜奶') " +
                        "      WHEN LOCATE('巧克力', description) > 0 AND LOCATE(keyword, description) > 0 THEN CONCAT(SUBSTRING(description, 1, LOCATE('巧克力', description) + 3), '巧克力') " +
                        "      ELSE LEFT(description, 20) " +
                        "    END " +
                        "  ELSE NULL " +
                        "END as suggestion " +
                        "FROM goods " +
                        "WHERE goods_name LIKE ? OR description LIKE ? " +
                        "ORDER BY " +
                        "CASE " +
                        "  WHEN goods_name LIKE ? THEN 1 " +
                        "  ELSE 2 " +
                        "END, " +
                        "LENGTH(description) ASC " +
                        "LIMIT 8";

        try (Connection conn = DBUtils.getConnection()) {
            // 搜索商品名称建议
            try (PreparedStatement stmt = conn.prepareStatement(nameSql)) {
                String searchPattern = "%" + keyword + "%";
                String exactPattern = keyword + "%";
                String containPattern = "%" + keyword;

                stmt.setString(1, searchPattern);
                stmt.setString(2, exactPattern);
                stmt.setString(3, containPattern);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        String suggestion = rs.getString("goods_name");
                        if (suggestion != null && !suggestions.contains(suggestion)) {
                            suggestions.add(suggestion);
                        }
                    }
                }
            }

            // 添加一些默认的蛋糕相关建议
            if (suggestions.size() < 5) {
                String[] defaultSuggestions = {
                    "生日蛋糕", "巧克力蛋糕", "水果蛋糕", "芝士蛋糕",
                    "奶油蛋糕", "慕斯蛋糕", "婚礼蛋糕", "儿童蛋糕"
                };

                for (String suggestion : defaultSuggestions) {
                    if (suggestion.contains(keyword) && !suggestions.contains(suggestion)) {
                        suggestions.add(suggestion);
                        if (suggestions.size() >= 8) break;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return suggestions;
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

    // ========== 分页查询方法 ==========

    /**
     * 分页获取所有商品
     */
    public PageResult<Goods> getAllGoodsPaginated(int currentPage, int pageSize) {
        List<Goods> goodsList = new ArrayList<>();

        // 查询当前页数据
        String dataSql = "SELECT g.*, t.type_name FROM goods g " +
                        "LEFT JOIN type t ON g.type_id = t.type_id " +
                        "ORDER BY g.create_time DESC " +
                        "LIMIT ? OFFSET ?";

        // 查询总记录数
        String countSql = "SELECT COUNT(*) FROM goods";

        try (Connection conn = DBUtils.getConnection()) {
            // 查询数据
            try (PreparedStatement dataStmt = conn.prepareStatement(dataSql)) {
                dataStmt.setInt(1, pageSize);
                dataStmt.setInt(2, (currentPage - 1) * pageSize);

                try (ResultSet rs = dataStmt.executeQuery()) {
                    while (rs.next()) {
                        Goods goods = extractGoodsFromResultSet(rs);
                        goodsList.add(goods);
                    }
                }
            }

            // 查询总数
            int totalCount = 0;
            try (PreparedStatement countStmt = conn.prepareStatement(countSql);
                 ResultSet rs = countStmt.executeQuery()) {
                if (rs.next()) {
                    totalCount = rs.getInt(1);
                }
            }

            return new PageResult<>(goodsList, currentPage, pageSize, totalCount);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PageResult<>(goodsList, currentPage, pageSize, 0);
    }

    /**
     * 分页根据分类获取商品
     */
    public PageResult<Goods> getGoodsByTypeIdPaginated(int typeId, int currentPage, int pageSize) {
        List<Goods> goodsList = new ArrayList<>();

        // 查询当前页数据
        String dataSql = "SELECT g.*, t.type_name FROM goods g " +
                        "LEFT JOIN type t ON g.type_id = t.type_id " +
                        "WHERE g.type_id = ? " +
                        "ORDER BY g.create_time DESC " +
                        "LIMIT ? OFFSET ?";

        // 查询总记录数
        String countSql = "SELECT COUNT(*) FROM goods WHERE type_id = ?";

        try (Connection conn = DBUtils.getConnection()) {
            // 查询数据
            try (PreparedStatement dataStmt = conn.prepareStatement(dataSql)) {
                dataStmt.setInt(1, typeId);
                dataStmt.setInt(2, pageSize);
                dataStmt.setInt(3, (currentPage - 1) * pageSize);

                try (ResultSet rs = dataStmt.executeQuery()) {
                    while (rs.next()) {
                        Goods goods = extractGoodsFromResultSet(rs);
                        goodsList.add(goods);
                    }
                }
            }

            // 查询总数
            int totalCount = 0;
            try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                countStmt.setInt(1, typeId);
                try (ResultSet rs = countStmt.executeQuery()) {
                    if (rs.next()) {
                        totalCount = rs.getInt(1);
                    }
                }
            }

            return new PageResult<>(goodsList, currentPage, pageSize, totalCount);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PageResult<>(goodsList, currentPage, pageSize, 0);
    }

    /**
     * 分页搜索商品
     */
    public PageResult<Goods> searchGoodsPaginated(String keyword, int currentPage, int pageSize) {
        List<Goods> goodsList = new ArrayList<>();

        // 查询当前页数据
        String dataSql = "SELECT g.*, t.type_name FROM goods g " +
                        "LEFT JOIN type t ON g.type_id = t.type_id " +
                        "WHERE g.goods_name LIKE ? OR g.description LIKE ? " +
                        "ORDER BY g.create_time DESC " +
                        "LIMIT ? OFFSET ?";

        // 查询总记录数
        String countSql = "SELECT COUNT(*) FROM goods g " +
                         "WHERE g.goods_name LIKE ? OR g.description LIKE ?";

        try (Connection conn = DBUtils.getConnection()) {
            String searchPattern = "%" + keyword + "%";

            // 查询数据
            try (PreparedStatement dataStmt = conn.prepareStatement(dataSql)) {
                dataStmt.setString(1, searchPattern);
                dataStmt.setString(2, searchPattern);
                dataStmt.setInt(3, pageSize);
                dataStmt.setInt(4, (currentPage - 1) * pageSize);

                try (ResultSet rs = dataStmt.executeQuery()) {
                    while (rs.next()) {
                        Goods goods = extractGoodsFromResultSet(rs);
                        goodsList.add(goods);
                    }
                }
            }

            // 查询总数
            int totalCount = 0;
            try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                countStmt.setString(1, searchPattern);
                countStmt.setString(2, searchPattern);
                try (ResultSet rs = countStmt.executeQuery()) {
                    if (rs.next()) {
                        totalCount = rs.getInt(1);
                    }
                }
            }

            return new PageResult<>(goodsList, currentPage, pageSize, totalCount);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PageResult<>(goodsList, currentPage, pageSize, 0);
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