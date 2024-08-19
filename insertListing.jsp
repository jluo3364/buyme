<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/8/24
  Time: 1:56 PM
  insert the listing into toy_listing under the user
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Title</title>
</head>
<%
//Get parameters from the HTML form at createListing.jsp
  String name = request.getParameter("name");
  String category = request.getParameter("category");
  int startAge = Integer.parseInt(request.getParameter("start_age"));
  int endAge = Integer.parseInt(request.getParameter("end_age"));
  double price = Double.parseDouble(request.getParameter("price"));
  double increment = Double.parseDouble(request.getParameter("increment"));
  double minPrice = Double.parseDouble(request.getParameter("min_price"));
  String user = session.getAttribute("user").toString();
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
  // Parse the string to a LocalDateTime object
  LocalDateTime endDT = LocalDateTime.parse(request.getParameter("endDT"), formatter);
  LocalDateTime startDT = LocalDateTime.now();
  try {

    //Get the database connection
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    ToyListingData tld = new ToyListingData(conn);
    // Insert into the corresponding subcategory table
    int toyId = tld.insertListing(price, category, name, startAge, endAge, minPrice, endDT, startDT, increment, user);
    String sql;
    PreparedStatement pstmt;
    switch (category) {
      case "action_figure":
        sql = "INSERT INTO action_figure (toy_id, height, can_move, character_name) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, toyId);
        pstmt.setDouble(2, Double.parseDouble(request.getParameter("height")));
        pstmt.setBoolean(3, request.getParameter("can_move")!=null &&request.getParameter("can_move").equals("on"));
        pstmt.setString(4, request.getParameter("character"));
        break;
      case "stuffed_animal":
        sql = "INSERT INTO stuffed_animal (toy_id, color, brand, animal) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, toyId);
        pstmt.setString(2, request.getParameter("color"));
        pstmt.setString(3, request.getParameter("brand"));
        pstmt.setString(4, request.getParameter("animal"));
        break;
      case "board_game":
        sql = "INSERT INTO board_game (toy_id, player_count, brand, is_cards_game) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, toyId);
        pstmt.setInt(2, Integer.parseInt(request.getParameter("player_count")));
        pstmt.setString(3, request.getParameter("game_brand"));
        pstmt.setBoolean(4, request.getParameter("is_cards_game")!= null && request.getParameter("is_cards_game").equals("on"));
        break;
      default:
        throw new IllegalArgumentException("Invalid category: " + category);
    }

    // Execute the prepared statement
    pstmt.executeUpdate();
// Close the resources
pstmt.close();
conn.close();

response.sendRedirect("myListings.jsp");
} catch (Exception e) {
out.println("Error: " + e.getMessage());
}
%>
<body>
</body>
</html>