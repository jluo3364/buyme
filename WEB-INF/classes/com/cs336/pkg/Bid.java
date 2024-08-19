package com.cs336.pkg;

import java.text.DecimalFormat;
import java.time.LocalDateTime;

public class Bid {
    private int bidId;
    private LocalDateTime time;
    private double price;
    private String username;
    private int toyId;
    private boolean isAutoBid;
    private String status;

    // Constructors
    public Bid() {
    }

    public Bid(int bidId, LocalDateTime time, double price, String username, int toyId, boolean isAutoBid, String status) {
        this.bidId = bidId;
        this.time = time;
        this.price = price;
        this.username = username;
        this.toyId = toyId;
        this.isAutoBid = isAutoBid;
        this.status = status;
    }

    // Getters and Setters
    public String getStatus() {
        return status;
    }
    public boolean isAutoBid() {
        return isAutoBid;
    }
    public void setAutoBid(boolean autoBid) {
        isAutoBid = autoBid;
    }
    public int getBidId() {
        return bidId;
    }

    public void setBidId(int bidId) {
        this.bidId = bidId;
    }

    public LocalDateTime getTime() {
        return time;
    }

    public void setTime(LocalDateTime time) {
        this.time = time;
    }

    public double getPrice() {
        return price;
    }

    public String formattedPrice(){
        DecimalFormat df = new DecimalFormat("#.##");
        return df.format(price);
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getToyId() {
        return toyId;
    }

    public void setToyId(int toyId) {
        this.toyId = toyId;
    }

    // toString method
    @Override
    public String toString() {
        return "Bid{" +
                "bidId=" + bidId +
                ", time=" + time +
                ", price=" + price +
                ", username='" + username + '\'' +
                ", toyId=" + toyId +
                '}';
    }
}
