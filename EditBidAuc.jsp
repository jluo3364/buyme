<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/4/24
  Time: 6:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="styles.css">
  <title>Edit Bid/Auction</title>
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
    }
    tr:nth-child(odd) {
      background-color: #fffefe;
    }
    tr:nth-child(even) {
      background-color: #efefef;
    }

    td {
      padding: 10px;
      border: 2px solid;
      text-align: left;
      max-width: 500px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .tdbtn{
      width: 100%;
    }
    h2{
      margin-bottom: 0px;
    }
  </style>
</head>
<body>
<%
  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();
  String rep_id = (String) session.getAttribute("employeeid");
  if (rep_id == null) {
    response.sendRedirect("Login.jsp");
  }
  Statement st = con.createStatement();

  String tl_id = request.getParameter("toy_id");
  PreparedStatement ps = con.prepareStatement(
          "SELECT toy_id, username, name, category, initial_price, start_age, end_age,  start_datetime, closing_datetime FROM toy_listing WHERE toy_id =(?)"
  );
  ps.setString(1, tl_id);
  ResultSet bidquery = ps.executeQuery();
%>
<h1>Edit Auction <%=tl_id%></h1>
<div class="center-texts">

<form action="removeBidAuc.jsp" method="post">
  <table>
    <tr>
      <th>Toy ID</th>
      <th>Poster</th>
      <th>Listing Name</th>
      <th>Category</th>
      <th>Initial Price</th>
      <th>Start Age</th>
      <th>End Age</th>
      <th>Start Date</th>
      <th>End Date</th>
    </tr>
    <%
      if (!bidquery.next()) {
    %>
    <tr>
      <td>None</td>
    </tr>
    <%
    } else {
      bidquery.beforeFirst();
      while (bidquery.next()) {
    %>
    <tr class="clickable-row" >
      <td><%= bidquery.getString(1) %></td>
      <td><%= bidquery.getString(2) %></td>
      <td><%= bidquery.getString(3) %></td>
      <td><%= bidquery.getString(4) %></td>
      <td><%= bidquery.getString(5) %></td>
      <td><%= bidquery.getString(6) %></td>
      <td><%= bidquery.getString(7) %></td>
      <td><%= bidquery.getString(8) %></td>
      <td><%= bidquery.getString(9) %></td>
    </tr>
    <%
        }
      }
    %>
  </table>
  <input type="hidden" name="tl_id" value="<%=tl_id%>">
  <button name="deleteAuc" style=" margin-top:40px; margin-bottom:40px; width:130px" type="submit" value="true">Delete Auction</button>
</form>

  <%
    // Additional SQL query to fetch bids for the given toy_id
    PreparedStatement bidStatement = con.prepareStatement("SELECT b_id, time, price, username, is_auto_bid, bid_status FROM bid WHERE toy_id = ?");
    bidStatement.setString(1, tl_id);
    ResultSet bids = bidStatement.executeQuery();
  %>

  <h2>Bid Details for <%=tl_id%></h2>
  <form action="removeBidAuc.jsp" method="post">
    <table style="margin-bottom: 50px;">
      <tr>
        <th>Bid ID</th>
        <th>Start Time</th>
        <th>Price</th>
        <th>Username</th>
        <th>Is Auto Bid</th>
        <th>Status</th>
        <th>Action</th>

      </tr>
      <%
        while (bids.next()) {
      %>
      <tr class="clickable-row">
        <td><%= bids.getInt("b_id") %></td>
        <td><%= bids.getTimestamp("time") %></td>
        <td><%= bids.getDouble("price") %></td>
        <td><%= bids.getString("username") %></td>
        <td><%= bids.getBoolean("is_auto_bid") ? "Yes" : "No" %></td>
        <td><%= bids.getString("bid_status") %></td>
        <td>
          <button class="tdbtn" type="submit" name="deleteBid" value="<%= bids.getInt("b_id") %>">Delete</button>
        </td>
      </tr>
      <%
        }
        if (!bids.first()) {
      %>
      <tr>
        <td colspan="10">No bids found</td>
      </tr>
      <%
        }
      %>
    </table>
    <input type="hidden" name="tl_id" value="<%=tl_id%>">

  </form>

  <a class="back-button" href="CustomerRepMain.jsp">Back</a>

</div>
</body>
</html>