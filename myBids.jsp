<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 5/2/24
  Time: 1:33 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>My Bids</title>
    <script>
        window.onload = function() {
            // Get all table rows
            var rows = document.querySelectorAll('table tr[data-href]');
            // Add click event listener to each row
            rows.forEach(function(row) {
                row.addEventListener('click', function() {
                    // Get the value of the data-href attribute
                    var href = row.getAttribute('data-href');
                    // Navigate to the specified URL
                    window.location.href = href;
                });
            });
        };
    </script>
</head>
<body>
<%
        String username = request.getParameter("id");
        boolean isSessionUser = false;
        if(username == null || username.equals(session.getAttribute("user"))) {
            isSessionUser = true;
            username = session.getAttribute("user").toString();
        }
        // Create a connection to the database
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        BidData bidData = new BidData(conn);
        ToyListingData tlData = new ToyListingData(conn);
    try {
        tlData.checkToyListings();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    List<Bid> bids = bidData.getBidsByUser(username);
        if(bids==null || bids.isEmpty()){
            out.println("You have no bids.");
        }
        else {
            for(Bid bid : bids) {
                try {
                    bidData.checkOutBids(bid.getToyId());
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        %>
<table>
<tr><th>Bid Time</th><th>Listing Name</th><th>Bid Price</th><th>Status</th>
    <%if(isSessionUser){%>
    <th>Is Auto Bid</th><th>Max Auto Bid</th> <th>Auto Bid Increment</th>
        <%}
    %></tr>
    <%
            for (Bid b : bids) {
                int id = b.getToyId();
                ToyListing toyListing = tlData.getToyListingDetails(id, true);
                String category = toyListing.getCategory();
                String name = toyListing.getName();
                String status = b.getStatus();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a");
                String bidTime = b.getTime().format(formatter);
                String url = "listingDetails.jsp?id=" + id + "&category=" + category;
                out.println("<tr data-href=\"" + url + "\" class = \"listing-tr\">");
                out.println("<td>" + bidTime + "</td>");
                out.println("<td>" + name + "</td>");
                out.println("<td>$ " + b.formattedPrice() + "</td>");
                out.println("<td>" + status + "</td>");
                if(isSessionUser) {
                    out.println("<td>" + b.isAutoBid() + "</td>");
                    String maxBid = "n/a";
                    String bidInc = "n/a";

                    if(b.isAutoBid()){
                        AutomaticBidData abd = new AutomaticBidData(conn);
                        AutomaticBid ab = abd.getAutomaticBid(b.getBidId());
                        if(ab!=null) {
                            maxBid = "$ "+String.valueOf(ab.getSecretMaxPrice());
                            bidInc = "$ "+String.valueOf(ab.getIncrement());
                        }
                    }
                    out.println("<td>" + maxBid + "</td>");
                    out.println("<td>" + bidInc + "</td>");
                }
                out.println("</tr>");
            }
        }
    %>
</table>
<p><a href="CustomerMain.jsp">Home</a></p>
</body>
</html>