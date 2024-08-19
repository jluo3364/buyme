package com.cs336.pkg;

public class AutomaticBid {
    private int abId;
    private double increment;
    private double secretMaxPrice;
    private int lastBidId;
    private int toyId;

    // Constructor
    public AutomaticBid(int abId, double increment, double secretMaxPrice, int lastBidId, int toyId) {
        this.abId = abId;
        this.increment = increment;
        this.secretMaxPrice = secretMaxPrice;
        this.lastBidId = lastBidId;
        this.toyId = toyId;
    }

    // Getters and Setters
    public int getAbId() {
        return abId;
    }

    public void setAbId(int abId) {
        this.abId = abId;
    }

    public double getIncrement() {
        return increment;
    }

    public void setIncrement(double increment) {
        this.increment = increment;
    }

    public double getSecretMaxPrice() {
        return secretMaxPrice;
    }

    public void setSecretMaxPrice(double secretMaxPrice) {
        this.secretMaxPrice = secretMaxPrice;
    }

    public int getLastBidId() {
        return lastBidId;
    }

    public void setLastBidId(int lastBidId) {
        this.lastBidId = lastBidId;
    }

    public int getToyId() {
        return toyId;
    }

    public void setToyId(int toyId) {
        this.toyId = toyId;
    }

    // toString method for debugging or logging
    @Override
    public String toString() {
        return "AutomaticBid{" +
                "abId=" + abId +
                ", increment=" + increment +
                ", secretMaxPrice=" + secretMaxPrice +
                ", lastBidId=" + lastBidId +
                ", toyId=" + toyId +
                '}';
    }
}
