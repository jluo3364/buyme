package com.cs336.pkg;

import java.time.LocalDateTime;

public class ToyListing {
    private double initialPrice;
    private String category;
    private String name;
    private int startAge;
    private int endAge;
    private double secretMinPrice;
    private LocalDateTime closingDateTime;
    private double increment;
    private int toyId;
    private LocalDateTime startDateTime;
    private String username;
    private CategoryDetails categoryDetails;
    private boolean openStatus;

    // Constructors
    public ToyListing() {
    }

    public ToyListing(double initialPrice, String category, String name, int startAge, int endAge,
                      double secretMinPrice, LocalDateTime closingDateTime, double increment,
                      int toyId, LocalDateTime startDateTime, String username) {
        this.initialPrice = initialPrice;
        this.category = category;
        this.name = name;
        this.startAge = startAge;
        this.endAge = endAge;
        this.secretMinPrice = secretMinPrice;
        this.closingDateTime = closingDateTime;
        this.increment = increment;
        this.toyId = toyId;
        this.startDateTime = startDateTime;
        this.username = username;
        openStatus= closingDateTime.isAfter(LocalDateTime.now());
    }

    // Getters and Setters (generated automatically or manually)
    public boolean getOpenStatus() {
        return openStatus;
    }
    public CategoryDetails getCategoryDetails() {
        return categoryDetails;
    }

    public void setCategoryDetails(CategoryDetails categoryDetails) {
        this.categoryDetails = categoryDetails;
    }

    public double getInitialPrice() {
        return initialPrice;
    }

    public void setInitialPrice(double initialPrice) {
        this.initialPrice = initialPrice;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public double getSecretMinPrice() {
        return secretMinPrice;
    }

    public void setSecretMinPrice(double secretMinPrice) {
        this.secretMinPrice = secretMinPrice;
    }

    public LocalDateTime getClosingDateTime() {
        return closingDateTime;
    }

    public void setClosingDateTime(LocalDateTime closingDateTime) {
        this.closingDateTime = closingDateTime;
    }

    public double getIncrement() {
        return increment;
    }

    public void setIncrement(double increment) {
        this.increment = increment;
    }

    public int getToyId() {
        return toyId;
    }

    public void setToyId(int toyId) {
        this.toyId = toyId;
    }

    public LocalDateTime getStartDateTime() {
        return startDateTime;
    }

    public void setStartDateTime(LocalDateTime startDateTime) {
        this.startDateTime = startDateTime;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // toString() method for debugging and logging
    @Override
    public String toString() {
        return "ToyListing{" +
                "initialPrice=" + initialPrice +
                ", category='" + category + '\'' +
                ", name='" + name + '\'' +
                ", startAge=" + startAge +
                ", endAge=" + endAge +
                ", secretMinPrice=" + secretMinPrice +
                ", closingDateTime=" + closingDateTime +
                ", increment=" + increment +
                ", toyId=" + toyId +
                ", startDateTime=" + startDateTime +
                ", username='" + username + '\'' +
                '}';
    }
}
