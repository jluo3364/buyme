<%--
  Created by IntelliJ IDEA.
  User: adam
  Date: 4/7/24
  Time: 3:58 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    if ((session.getAttribute("user") == null)) {
%>
<div class="center-texts">
    You are not logged in <br>
    <a href="login.jsp">Please Login</a>
</div>
<%
} else {
%>
<div class="center-texts">
    <h1> Welcome, <%=session.getAttribute("user") %>!</h1>

    <p><a href="SetCustomAlert.jsp">Set Custom Bid Alerts</a></p>
    <p><a href="browseListings.jsp">Browse Listings</a></p>
    <p><a href='createListing.jsp'>Create a Listing</a> </p>
    <p><a href='myListings.jsp'>My Listings</a> </p>
    <p><a href="myBids.jsp">My Bids</a></p>
    <p><a href="myCustomAlerts.jsp">My Custom Alerts</a></p>
    <p><a href="myAlerts.jsp">My General Alerts</a></p>
    <p><a href="customerQuestion.jsp">My Questions</a></p>
    <a href='logout.jsp'>Log Out</a>
</div>
<%
    }
%>
</body>
</html>