package com.sgu.cakeshopserive.dao;

import com.sgu.cakeshopserive.model.Type;
import com.sgu.cakeshopserive.utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TypeDao {

    public List<Type> getAllTypes() {
        List<Type> types = new ArrayList<>();
        String sql = "SELECT type_id, type_name FROM type ORDER BY type_name";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Type type = new Type();
                type.setTypeId(rs.getInt("type_id"));
                type.setTypeName(rs.getString("type_name"));
                types.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return types;
    }

    public Type getTypeById(int typeId) {
        String sql = "SELECT type_id, type_name FROM type WHERE type_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, typeId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Type type = new Type();
                    type.setTypeId(rs.getInt("type_id"));
                    type.setTypeName(rs.getString("type_name"));
                    return type;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public String getTypeNameById(int typeId) {
        String sql = "SELECT type_name FROM type WHERE type_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, typeId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("type_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}