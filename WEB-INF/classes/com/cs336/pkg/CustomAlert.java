package com.cs336.pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class CustomAlert {
    private int alertId;
    private String alertName;
    private String category;
    private double maxPrice;
    private double minPrice;
    private int startAge;
    private int endAge;
    private double height;
    private Boolean canMove;
    private String characterName;
    private String color;
    private String brand;
    private String animal;
    private Integer playerCount;
    private String gameBrand;
    private Boolean isCardsGame;
    private String username;
    private boolean customAlertStatus;

    // Constructors, getters, and setters
    // Constructor
    public CustomAlert() {
    }

    // Getters and Setters
    public int getAlertId() {
        return alertId;
    }

    public void setAlertId(int alertId) {
        this.alertId = alertId;
    }

    public String getAlertName() {
        return alertName;
    }

    public void setAlertName(String alertName) {
        this.alertName = alertName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }

    public int getStartAge() {
        return startAge;
    }

    public void setStartAge(int startAge) {
        this.startAge = startAge;
    }

    public int getEndAge() {
        return endAge;
    }

    public void setEndAge(int endAge) {
        this.endAge = endAge;
    }

    public double getHeight() {
        return height;
    }

    public void setHeight(double height) {
        this.height = height;
    }

    public Boolean getCanMove() {
        return canMove;
    }

    public void setCanMove(Boolean canMove) {
        this.canMove = canMove;
    }

    public String getCharacterName() {
        return characterName;
    }

    public void setCharacterName(String characterName) {
        this.characterName = characterName;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getAnimal() {
        return animal;
    }

    public void setAnimal(String animal) {
        this.animal = animal;
    }

    public Integer getPlayerCount() {
        return playerCount;
    }

    public void setPlayerCount(Integer playerCount) {
        this.playerCount = playerCount;
    }

    public String getGameBrand() {
        return gameBrand;
    }

    public void setGameBrand(String gameBrand) {
        this.gameBrand = gameBrand;
    }

    public Boolean getIsCardsGame() {
        return isCardsGame;
    }

    public void setIsCardsGame(Boolean isCardsGame) {
        this.isCardsGame = isCardsGame;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public boolean isCustomAlertStatus() {
        return customAlertStatus;
    }

    public void setCustomAlertStatus(boolean customAlertStatus) {
        this.customAlertStatus = customAlertStatus;
    }
    public static List<CustomAlert> byCategory(String category, List<CustomAlert> customAlertList) {
        Stream<CustomAlert> stream = customAlertList.stream();
        stream = stream.filter(customAlert -> customAlert.getCategory().equals(category));
        return stream.toList();
    }
    public static List<CustomAlert> getCustomAlerts(String username , Connection conn) throws SQLException{
        String sql = "select * from custom_alerts where username=?";
        List<CustomAlert> list = new ArrayList<>();
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            list = fromResultSet(rs);
        }
        return list;
    }

    public static List<CustomAlert> fromResultSet(ResultSet rs) throws SQLException {
        List<CustomAlert> customAlerts = new ArrayList<>();

        while (rs.next()) {
            CustomAlert customAlert = new CustomAlert();
            customAlert.setAlertId(rs.getInt("alert_id"));
            customAlert.setAlertName(rs.getString("alert_name"));
            customAlert.setCategory(rs.getString("category"));
            customAlert.setMaxPrice(rs.getDouble("max_price"));
            customAlert.setMinPrice(rs.getDouble("min_price"));
            customAlert.setStartAge(rs.getInt("start_age"));
            customAlert.setEndAge(rs.getInt("end_age"));
            customAlert.setHeight(rs.getDouble("height"));
            customAlert.setCanMove(rs.getBoolean("can_move"));
            customAlert.setCharacterName(rs.getString("character_name"));
            customAlert.setColor(rs.getString("color"));
            customAlert.setBrand(rs.getString("brand"));
            customAlert.setAnimal(rs.getString("animal"));
            customAlert.setPlayerCount(rs.getInt("player_count"));
            customAlert.setGameBrand(rs.getString("game_brand"));
            customAlert.setIsCardsGame(rs.getBoolean("is_cards_game"));
            customAlert.setUsername(rs.getString("username"));
            customAlert.setCustomAlertStatus(rs.getBoolean("custom_alert_status"));

            customAlerts.add(customAlert);
        }

        return customAlerts;
    }
}
