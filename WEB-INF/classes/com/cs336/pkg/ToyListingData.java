package com.cs336.pkg;

import javax.sound.midi.SysexMessage;
import java.sql.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class ToyListingData {
    private Connection conn;
    private Timer timer;

    public ToyListingData(Connection conn) {
        this.conn = conn;
    }
    public List<ToyListing> getAllListings() throws SQLException {
        //does not extract category details for listings
        List<ToyListing> list = new ArrayList<ToyListing>();
        String sql = "select * from toy_listing";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ToyListing tl = extractToyListing(rs);
                    list.add(tl);
                }
            }
        }
        return list;
    }
    public List<ToyListing> getAllListingsFromUser(String user) throws SQLException {
        List<ToyListing> list = new ArrayList<ToyListing>();
        String sql = "select * from toy_listing where username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ToyListing tl = extractToyListing(rs);
                    list.add(tl);
                }
            }
        }
        return list;
    }

    public List<ToyListing> getAllListingsWithSearch(String search_query, String user) throws SQLException {
        //does not extract category details for listings
        List<ToyListing> list = new ArrayList<ToyListing>();
        String sql = "select * from toy_listing WHERE name LIKE ?";
        if(user!=null)
            sql+=" and username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + search_query + "%");
            if(user!=null)
                ps.setString(2, user);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ToyListing tl = extractToyListing(rs);
                    list.add(tl);
                }
            }
        }
        return list;
    }

    public ToyListing getToyListingDetails(int toyId, boolean getDetails) throws SQLException {
        String query = "SELECT * FROM toy_listing WHERE toy_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, toyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ToyListing tl = extractToyListing(rs);
                    if(getDetails) {
                        CategoryDetails cd = getCategoryDetails(tl.getCategory(), tl.getToyId());
                        tl.setCategoryDetails(cd);
                    }
                    return tl;
                }
            }
        }
        return null;
    }
    public void setConn(Connection conn) {
        this.conn = conn;
    }
    public CategoryDetails getCategoryDetails(String category, int toyId) throws SQLException {
        String query = "SELECT * FROM " + category + " WHERE toy_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, toyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractCategoryDetailsFromResultSet(category, rs);
                }
            }
        }
        return null;
    }

    public int insertListing(double initialPrice, String category, String name, int startAge, int endAge, double minPrice, LocalDateTime endDT, LocalDateTime startDT, double increment, String user) throws SQLException {
        // Create and execute the SQL INSERT statement
        String sql = "INSERT INTO toy_listing (initial_price,category, name, start_age, end_age, secret_min_price, closing_datetime, increment, start_datetime, username) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setDouble(1, initialPrice);
        pstmt.setString(2, category);
        pstmt.setString(3, name);
        pstmt.setInt(4, startAge);
        pstmt.setInt(5, endAge);
        pstmt.setDouble(6, minPrice);
        pstmt.setTimestamp(7, Timestamp.valueOf(endDT));
        pstmt.setDouble(8, increment);
        pstmt.setTimestamp(9, Timestamp.valueOf(startDT));
        pstmt.setString(10,user);

        pstmt.executeUpdate();

        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        if (generatedKeys.next()) {
            int toyId = Integer.parseInt(generatedKeys.getString(1));
            timer = new Timer();

            timer.schedule(new DetermineWinnerTask(toyId, conn),Timestamp.valueOf(endDT));
            return toyId;
        }

        // Close the resources
        pstmt.close();
        return -1;
    }


    public static ToyListing extractToyListing(ResultSet rs) throws SQLException {
        double initialPrice = rs.getDouble("initial_price");
        String category = rs.getString("category");
        String name = rs.getString("name");
        int startAge = rs.getInt("start_age");
        int endAge = rs.getInt("end_age");
        double secretMinPrice = rs.getDouble("secret_min_price");
        LocalDateTime closingDateTime = rs.getTimestamp("closing_datetime").toLocalDateTime();
        double increment = rs.getDouble("increment");
        int toyId = rs.getInt("toy_id");
        LocalDateTime startDateTime = rs.getTimestamp("start_datetime").toLocalDateTime();
        String username = rs.getString("username");

        return new ToyListing(initialPrice, category, name, startAge, endAge,
                secretMinPrice, closingDateTime, increment, toyId, startDateTime, username);
    }
    public boolean checkToyListings() throws SQLException{
        List<ToyListing> all = getAllListings();
        boolean change = false;
        for (ToyListing tl : all) {
            if(tl.getClosingDateTime().isBefore(LocalDateTime.now())){
                deactivateToyListing(tl.getToyId());
                change = true;
            }
        }
        return change;
    }

    public void deactivateToyListing(int toyId) throws SQLException {
        String query = "UPDATE toy_listing SET openStatus = 0 WHERE toy_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, toyId);
            pstmt.executeUpdate();

            BidData bd = new BidData(conn);

            SaleData sd = new SaleData(conn);
            Sale sale = sd.saleGivenId(toyId);

            if (sale == null) {
                Bid highestBidObj = bd.highestBidObj(toyId);
                if (highestBidObj != null) {
                    ToyListing tl = getToyListingDetails(toyId,false);
                    double minPrice = tl.getSecretMinPrice();
                    double highestBid = highestBidObj.getPrice();

                    if (highestBid >= minPrice) {
                        int bidId = highestBidObj.getBidId();
                        sd.insertSale(toyId, bidId);
                        bd.setBidStatus(bidId, "won");
                    }
                }
            }
            //mark all bids for this listing inactive if not won
            query = "UPDATE bid SET bid_status = 'inactive' WHERE toy_id = ? and bid_status != 'won'";
            PreparedStatement pstmt2 = conn.prepareStatement(query);
            pstmt2.setInt(1, toyId);
            pstmt2.executeUpdate();
            pstmt2.close();
        }
    }
    private CategoryDetails extractCategoryDetailsFromResultSet(String category, ResultSet rs) throws SQLException {
        // Extract category details from ResultSet and create CategoryDetails object
        CategoryDetails cd = new CategoryDetails();
        if (category.equals("action_figure")) {
            cd.addDetail("height",rs.getDouble("height"));
            cd.addDetail("canMove", rs.getBoolean("can_move"));
            cd.addDetail("characterName",rs.getString("character_name"));
            return cd;
        } else if (category.equals("board_game")) {
            int playerCount = rs.getInt("player_count");
            String brand = rs.getString("brand");
            boolean isCardsGame = rs.getBoolean("is_cards_game");
            cd.addDetail("playerCount",playerCount);
            cd.addDetail("brand",brand);
            cd.addDetail("isCardsGame",isCardsGame);

            return cd;
        } else if (category.equals("stuffed_animal")) {
            String color = rs.getString("color");
            String brand = rs.getString("brand");
            String animal = rs.getString("animal");
            cd.addDetail("color",color);
            cd.addDetail("brand",brand);
            cd.addDetail("animal",animal);
            return cd;
        }
        return null;
    }
    public class DetermineWinnerTask extends TimerTask {
        int toyId;
        private Connection conn;
        public DetermineWinnerTask(int toyId, Connection conn){
            this.toyId = toyId;
            this.conn = conn;
        }

        public int winningBid(Bid highestBidObj, double minPrice){
            double highestBid = highestBidObj.getPrice();
            int bidId = -1;
            if (highestBid < minPrice) {
                //no bids made on this item or not high enough price
                System.out.println("Highest bid found for " + toyId+" is lower than " + minPrice);
                //@TODO alert listing creator that there's no winner
            } else {
                //highest bid is winner, add this bid to sale table
                System.out.println("highest bid found for " + toyId+" is " + highestBid);
                bidId = highestBidObj.getBidId();
            }
            return bidId;
        }
        @Override
        public void run() {
            System.out.println("determining winner for " + toyId);
            try {
                if (conn == null || conn.isClosed()) {
                    System.out.println("Database connection is null or closed.");
                    conn = new ApplicationDB().getConnection();
                    setConn(conn);
                }
                deactivateToyListing(toyId);
                BidData bidData = new BidData(conn);

                Bid highestBidObj = bidData.highestBidObj(toyId);
                if (highestBidObj == null) {
                    System.out.println("No bid found for " + toyId);
                    //@TODO alert listing creator that there's no winner
                }
                else {
                    ToyListing tl = getToyListingDetails(toyId, false);
                    double minPrice = tl.getSecretMinPrice();
                    int bidId = winningBid(highestBidObj, minPrice);
                    if(bidId != -1) {
                        SaleData sd = new SaleData(conn);
                        sd.insertSale(toyId, bidId);
                        bidData.setBidStatus(bidId,"won");
                    }
                }
            } catch (SQLException e) {
                System.out.println("Error occurred while determining winner for toyId: " + toyId);
                e.printStackTrace();
            } finally {
                try {
                    if (conn != null && !conn.isClosed()) {
                        conn.close();
                    }
                } catch (SQLException ex) {
                    System.out.println("Error occurred while closing database connection.");
                    ex.printStackTrace();
                }
            }
        }
    }
}
