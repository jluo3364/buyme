<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<html>
<head>
    <title>Insert Custom Alert</title>
</head>
<body>
<%
    // Get parameters from the HTML form at createCustomAlert.jsp
    String alertName = request.getParameter("alertName");
    String category = request.getParameter("category");
    double maxPrice = Double.parseDouble(request.getParameter("maxPrice"));
    double minPrice = Double.parseDouble(request.getParameter("minPrice"));
    int startAge = Integer.parseInt(request.getParameter("startAge"));
    int endAge = Integer.parseInt(request.getParameter("endAge"));
    double height = request.getParameter("height") != null && !request.getParameter("height").isEmpty() ? Double.parseDouble(request.getParameter("height")) : 0;
    boolean canMove = request.getParameter("canMove") != null;
    String character = request.getParameter("character");
    String color = request.getParameter("color");
    String brand = request.getParameter("brand");
    String animal = request.getParameter("animal");
    int playerCount = (request.getParameter("playerCount") != null&& !request.getParameter("playerCount").isEmpty()) ? Integer.parseInt(request.getParameter("playerCount")) : 0;
    String gameBrand = request.getParameter("gameBrand");
    boolean isCardsGame = (request.getParameter("isCardsGame") != null && !request.getParameter("playerCount").isEmpty())? request.getParameter("isCardsGame").equals("on"):false;

    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        // Create and execute the SQL INSERT statement for custom_alerts table
        String sql = "INSERT INTO custom_alerts (alert_name, category, max_price, min_price, start_age, end_age, height, can_move, character_name, color, brand, animal, player_count, game_brand, is_cards_game, username) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, alertName);
        pstmt.setString(2, category);
        pstmt.setDouble(3, maxPrice);
        pstmt.setDouble(4, minPrice);
        pstmt.setInt(5, startAge);
        pstmt.setInt(6, endAge);
        pstmt.setDouble(7, height);
        pstmt.setBoolean(8, canMove);
        pstmt.setString(9, character);
        pstmt.setString(10, color);
        pstmt.setString(11, brand);
        pstmt.setString(12, animal);
        pstmt.setInt(13, playerCount);
        pstmt.setString(14, gameBrand);
        pstmt.setBoolean(15, isCardsGame);
        pstmt.setString(16, session.getAttribute("user").toString());

        pstmt.executeUpdate();

        // Close the resources
        pstmt.close();
        conn.close();

        out.println("<h2>Custom alert successfully created!</h2>");

        response.sendRedirect("myCustomAlerts.jsp");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</body>
</html>