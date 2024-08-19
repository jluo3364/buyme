package com.cs336.pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class SaleData {
    private Connection conn;

    public SaleData(Connection conn) {
        this.conn = conn;
    }

    public void insertSale(int toy_id, int b_id) throws SQLException {
        String sql = "INSERT INTO sale ( date, toy_id, b_id) VALUES (NOW(), ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, toy_id);
            pstmt.setInt(2, b_id);
            pstmt.executeUpdate();
        }
    }

    public Sale saleGivenId(int toy_id) throws SQLException {
        String sql = "SELECT * FROM sale WHERE toy_id=?";
        Sale sale = null;
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, toy_id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next())
                sale = extractSale(rs);
        }
        return sale;
    }

    public Sale extractSale(ResultSet rs) throws SQLException {
        int id = rs.getInt("sale_id");
        int toy_id = rs.getInt("toy_id");
        int b_id = rs.getInt("b_id");
        LocalDateTime date = rs.getTimestamp("date").toLocalDateTime();
        return new Sale(id, date, toy_id, b_id);
    }
}

