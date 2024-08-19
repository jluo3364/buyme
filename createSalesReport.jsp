<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Sales Report</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String start = request.getParameter("date1");
    String end = request.getParameter("date2");
    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    SimpleDateFormat printer = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");

    Timestamp date1 = new Timestamp(fmt.parse(start).getTime());
    Timestamp date2 = new Timestamp(fmt.parse(end).getTime());
    try {
        // Total Earnings Report
        PreparedStatement totalEarningsPS = con.prepareStatement(
            "SELECT SUM(total_earnings) AS total_earnings FROM report WHERE date BETWEEN ? AND ?;"
        );
        totalEarningsPS.setTimestamp(1, date1);
        totalEarningsPS.setTimestamp(2, date2);
        ResultSet totalEarningsRS = totalEarningsPS.executeQuery();
        %>
        <h3> Total Earnings:</h3>
        <%

        if (totalEarningsRS.next()) {
        %>
        <p> From: <%= printer.format(date1) %> To: <%= printer.format(date2) %> </p>
        <p> $<%=totalEarningsRS.getDouble("total_earnings")%>
        </p>

        <%
        } else {
        %>
        <p style="color:red;"> No data available for Total Earnings Report </p>
        <%
        }

        // Earnings Per Item Report
        PreparedStatement earningsPerItemPS = con.prepareStatement(
            "SELECT " +
            "tl.category AS item_type," +
            "tl.name AS item," +
            "AVG(r.earnings_per) AS earnings_per_item " + // Added space before FROM
            "FROM report r " +
            "JOIN toy_listing tl ON r.best_selling = tl.name " +
            "WHERE r.date BETWEEN ? AND ? " +
            "GROUP BY tl.name, tl.category;"
        );
        earningsPerItemPS.setTimestamp(1, date1);
        earningsPerItemPS.setTimestamp(2, date2);
        ResultSet earningsPerItemRS = earningsPerItemPS.executeQuery();
        Map<String, Double> earningsPerItem = new HashMap<>();
        boolean hasEarningsPerItemData = false;

        while (earningsPerItemRS.next()) {
            String itemName = earningsPerItemRS.getString("item");
            Double earnings = earningsPerItemRS.getDouble("earnings_per_item");
            earningsPerItem.put(itemName, earnings);
            hasEarningsPerItemData = true; // Data is available
        }
        %>
                <h3> Earning Per Item</h3>
                <%

        if (!hasEarningsPerItemData) {
        %>
        <p style="color:red;"> No data available for Earnings Per Item Report
        </p>
        <%
        } else {
            for (Map.Entry<String, Double> entry : earningsPerItem.entrySet()) {
                String itemName = entry.getKey();
                Double earnings = entry.getValue();
        %>

        <p> Item: <%= itemName %>, Earnings Per Item: $<%= earnings %></p>
        <%
            }
        }

        // Earnings Per Item Type Report
        PreparedStatement earningsPerItemTypePS = con.prepareStatement(
            "SELECT " +
            "tl.name AS item, " +
            "SUM(r.total_earnings) AS total_earnings " +
            "FROM " +
            "report r " +
            "JOIN " +
            "toy_listing tl ON r.best_selling = tl.name " +
            "WHERE " +
            "r.date BETWEEN ? AND ? " +
            "GROUP BY " +
            "tl.name"
        );
        earningsPerItemTypePS.setTimestamp(1, date1);
        earningsPerItemTypePS.setTimestamp(2, date2);
        ResultSet earningsPerItemTypeRS = earningsPerItemTypePS.executeQuery();
        Map<String, Double> earningsPerItemType = new HashMap<>();
        boolean hasEarningsPerItemTypeData = false;

        while (earningsPerItemTypeRS.next()) {
            String itemName = earningsPerItemTypeRS.getString("item");
            Double earnings = earningsPerItemTypeRS.getDouble("total_earnings");
            earningsPerItemType.put(itemName, earnings);
            hasEarningsPerItemTypeData = true;
        }

        %>
           <h3> Earning Per Item Type</h3>
        <%

        if (!hasEarningsPerItemTypeData) {
        %>
        <p style="color:red;"> No data available for Earnings Per Item Type Report </p>
        <%
        } else {
            for (Map.Entry<String, Double> entry : earningsPerItemType.entrySet()) {
                String itemName = entry.getKey();
                Double earnings = entry.getValue();
        %>
        <p> Item: <%= itemName %>, Total Earnings Per Item: $<%= earnings
        %></p>
        <%
            }
        }

        // Earnings Per End-User Report
        // NEED DATA TO TEST
        PreparedStatement earningsPerEndUserPS = con.prepareStatement(
            "SELECT " +
            "u.username AS end_user, " +
            "SUM(r.total_earnings) AS total_earnings " +
            "FROM " +
            "report r " +
            "JOIN " +
            "admin a ON r.admin_id = a.id " +
            "JOIN " +
            "user u ON a.id = u.username " +
            "WHERE " +
            "r.date BETWEEN ? AND ? " +
            "GROUP BY " +
            "u.username"
        );
        earningsPerEndUserPS.setTimestamp(1, date1);
        earningsPerEndUserPS.setTimestamp(2, date2);
        ResultSet earningsPerEndUserRS = earningsPerEndUserPS.executeQuery();
        Map<String, Double> earningsPerEndUser = new HashMap<>();
        boolean hasEarningsPerEndUserData = false;

        while (earningsPerEndUserRS.next()) {
            String endUserName = earningsPerEndUserRS.getString("end_user");
            Double earnings = earningsPerEndUserRS.getDouble("total_earnings");
            earningsPerEndUser.put(endUserName, earnings);
            hasEarningsPerEndUserData = true;
        }

        %>
           <h3> Earning Per End-User</h3>
        <%

        if (!hasEarningsPerEndUserData) {
        %>
        <p style="color:red;"> No data available for Earnings Per End-User Report </p>
        <%
        } else {
            for (Map.Entry<String, Double> entry : earningsPerEndUser.entrySet()) {
                String endUserName = entry.getKey();
                Double earnings = entry.getValue();
        %>
        <p> End User: <%= endUserName %>, Total Earnings Per End User: $<%=
        earnings %></p>
        <%
            }
        }

        // Best-Selling Items Report
        PreparedStatement bestSellingItemsPS = con.prepareStatement(
            "SELECT " +
                "tl.name AS best_selling_item, " +
                "u.username AS end_user, " +
                "COUNT(*) AS total_sales " +
                "FROM " +
                "sale s " +
                "JOIN " +
                "toy_listing tl ON s.toy_id = tl.toy_id " +
                "JOIN " +
                "bid b ON s.b_id = b.b_id " +
                "JOIN " +
                "user u ON b.username = u.username " +
                "WHERE " +
                "s.date BETWEEN ? AND ? " +
                "GROUP BY " +
                "tl.name, u.username " +
                "ORDER BY " +
                "total_sales DESC"
        );
        bestSellingItemsPS.setTimestamp(1, date1);
        bestSellingItemsPS.setTimestamp(2, date2);
        ResultSet bestSellingItemsRS = bestSellingItemsPS.executeQuery();
        Map<String, Integer> bestSellingItems = new LinkedHashMap<>();
        boolean hasBestSellingItemsData = false;

        while (bestSellingItemsRS.next()) {
            String itemName = bestSellingItemsRS.getString("best_selling_item");
            Integer sales = bestSellingItemsRS.getInt("total_sales");
            bestSellingItems.put(itemName, sales);
            hasBestSellingItemsData = true;
        }
        %>
           <h3> Best Selling Items:</h3>
        <%

        if (!hasBestSellingItemsData) {
        %>
        <p style="color:red;"> No data available for Best-Selling Items Report </p>
        <%
        } else {
            for (Map.Entry<String, Integer> entry : bestSellingItems.entrySet()) {
                String itemName = entry.getKey();
                Integer sales = entry.getValue();
        %>
        <p> Best Selling Item: <%= itemName %>, Total Sales: <%= sales %></p>
        <%
            }
        }

        // Best Buyers Report
        PreparedStatement bestBuyersPS = con.prepareStatement(
            "SELECT " +
            "u.username AS buyer," +
            "COUNT(*) AS total_purchases " +
            "FROM " +
                "sale s " +
            "JOIN " +
                "bid b ON s.b_id = b.b_id " +
            "JOIN " +
                "user u ON b.username = u.username " +
            "WHERE " +
                "s.date BETWEEN ? AND ? " +
            "GROUP BY " +
                "u.username " +
            "ORDER BY " +
                "COUNT(*) DESC"
        );
        bestBuyersPS.setTimestamp(1, date1);
        bestBuyersPS.setTimestamp(2, date2);
        ResultSet bestBuyersRS = bestBuyersPS.executeQuery();
        Map<String, Integer> bestBuyers = new LinkedHashMap<>();
        boolean hasBestBuyersData = false;

        while (bestBuyersRS.next()) {
            String buyerName = bestBuyersRS.getString("buyer");
            Integer purchases = bestBuyersRS.getInt("total_purchases");
            bestBuyers.put(buyerName, purchases);
            hasBestBuyersData = true; // Data is available
        }
        %>
           <h3> Best Buyers</h3>
        <%

        if (!hasBestBuyersData) {
        %>
        <p style="color:red;"> No data available for Best Buyers Report </p>
        <%
        } else {
            for (Map.Entry<String, Integer> entry : bestBuyers.entrySet()) {
                String buyerName = entry.getKey();
                Integer purchases = entry.getValue();
        %>
        <p> Buyer: <%= buyerName %>, Total Purchases: <%= purchases %></p>
        <%
            }
        }
%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<a style="margin-top: 30px;" href="AdminMain.jsp">Admin Home</a>
</body>
</html>