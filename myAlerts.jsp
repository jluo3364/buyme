<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.DecimalStyle" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>General Alerts</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>Alerts</h1>
<%--    <h2>Bids that closed when you entered them:</h2>--%>
<%--    <ul>--%>
<%--        &lt;%&ndash; Display bids that closed when the user entered them &ndash;%&gt;--%>
<%--        <%--%>
            <%// Get current user's username
            String username = (String) session.getAttribute("user");

            // Create a connection to the database
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ToyListingData tld = new ToyListingData(conn);
            BidData bd = new BidData(conn);
                try {
                    tld.checkToyListings();
                    String sql = "select toy_id from bid where username = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();
                    List<Integer> toysBidOn = new ArrayList<>();
                    while (rs.next()) {
                        toysBidOn.add(rs.getInt("toy_id"));
                    }
                    for(int id: toysBidOn) {
                        bd.checkOutBids(id);
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            %>

<%--            try {--%>
<%--                String query = "SELECT * FROM bid WHERE username = ? AND time < (SELECT closing_datetime FROM toy_listing WHERE toy_id = bid.toy_id)";--%>
<%--                pstmt = conn.prepareStatement(query);--%>
<%--                pstmt.setString(1, username);--%>
<%--                rs = pstmt.executeQuery();--%>

<%--                while (rs.next()) {--%>
<%--                    // Display bid information--%>
<%--                    out.println("<li>Bid ID: " + rs.getInt("b_id") + ", Price: " + rs.getDouble("price") + "</li>");--%>

<%--                    // Insert into alert table--%>
<%--                    String alertMessage = "Bid ID " + rs.getInt("b_id") + " closed when you entered it.";--%>
<%--                    String sql = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";--%>
<%--                    pstmt = conn.prepareStatement(sql);--%>
<%--                    pstmt.setString(1, alertMessage);--%>
<%--                    pstmt.setDouble(2, 0.0);--%>
<%--                    pstmt.setString(3, "");--%>
<%--                    pstmt.setDouble(4, 0.0);--%>
<%--                    pstmt.setString(5, "");--%>
<%--                    pstmt.setString(6, username);--%>
<%--                    pstmt.executeUpdate();--%>
<%--                }--%>
<%--            } catch (SQLException e) {--%>
<%--                e.printStackTrace();--%>
<%--            } finally {--%>
<%--                // Close resources--%>
<%--                if (rs != null) rs.close();--%>
<%--                if (pstmt != null) pstmt.close();--%>
<%--                if (conn != null) conn.close();--%>
<%--            }--%>
<%--        %>--%>
<%--    </ul>--%>

    <h2>Active listings you were outbid on:</h2>
    <ul>
        <%-- Display bids when someone else bid higher than the user --%>
        <%
            username = (String) session.getAttribute("user");

            db = new ApplicationDB();
            conn = db.getConnection();
            pstmt = null;

            try {
                String query = "SELECT * FROM bid WHERE username = ? AND bid_status= 'outbid'";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    // Display bid information
                    Bid outbid = BidData.extractBidFromResultSet(rs);
                    ToyListing tl = tld.getToyListingDetails(outbid.getToyId(), false);
                    String msg = "<a href= listingDetails.jsp?id="+tl.getToyId()+">"+tl.getName()+"</a>";
                    out.println("<li>"+msg+"</li>");

                    // Insert into alert table
                    String alertMessage = "Another user bid higher than you on Bid ID " + rs.getInt("b_id");
                    String insertQuery = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, alertMessage);
                    insertStmt.setDouble(2, 0.0);
                    insertStmt.setString(3, "");
                    insertStmt.setDouble(4, 0.0);
                    insertStmt.setString(5, "");
                    insertStmt.setString(6, username);
                    insertStmt.executeUpdate();
                    insertStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </ul>
    <h2>Bids that didn't win:</h2>
    <ul>
        <%-- Display bids for listings that have ended --%>

        <%
            // Get current user's username
            username = (String) session.getAttribute("user");

            db = new ApplicationDB();
            conn = db.getConnection();
            pstmt = null; // Reset pstmt

            try {
                String query = "SELECT * FROM bid WHERE (bid_status = 'inactive')and username = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    // Display bid information
                    DecimalFormat df = new DecimalFormat("#.##");
                    Bid inactiveBid = BidData.extractBidFromResultSet(rs);
                    int toyId = inactiveBid.getToyId();
                    ToyListing tl =tld.getToyListingDetails(toyId, false);
                    String msg = "bid of $ "+inactiveBid.getPrice()+" for <a href= 'listingDetails.jsp?id="+tl.getToyId()+"'>"+tl.getName()+"</a>";
                    out.println("<li>" + msg + "</li>");

                    // Insert into alert table
                    String alertMessage = "Bid ID " + rs.getInt("b_id") + " has ended.";
                    String insertQuery = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, alertMessage);
                    insertStmt.setDouble(2, 0.0);
                    insertStmt.setString(3, "");
                    insertStmt.setDouble(4, 0.0);
                    insertStmt.setString(5, "");
                    insertStmt.setString(6, username);
                    insertStmt.executeUpdate();
                    insertStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </ul>

    <h2>Won Auctions:</h2>
    <ul>
        <%-- Display bids that the user won --%>
        <%
            username = (String) session.getAttribute("user");

            db = new ApplicationDB();
            conn = db.getConnection();
            pstmt = null;

            try {
                String query = "SELECT * FROM bid WHERE username = ? AND bid_status = 'won'";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    // Display bid information
                    Bid b = BidData.extractBidFromResultSet(rs);
                    int toyId = b.getToyId();
                    ToyListing tl = tld.getToyListingDetails(toyId, false);

                    String alertMessage = "Congratulations! You won the listing for <a href= 'listingDetails.jsp?id="+tl.getToyId()+"'>"+tl.getName()+"</a> with a bid of $"+b.getPrice();
                    out.println("<li>"+alertMessage+". </li>");
                    alertMessage = "Congratulations! You won Bid ID"+ b.getBidId();
                    // Insert into alert table
                    String insertQuery = "INSERT INTO alert (name, max_price, category, min_price, age_range, username) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, alertMessage);
                    insertStmt.setDouble(2, 0.0);
                    insertStmt.setString(3, "");
                    insertStmt.setDouble(4, 0.0);
                    insertStmt.setString(5, "");
                    insertStmt.setString(6, username);
                    insertStmt.executeUpdate();
                    insertStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </ul>

    <br>
    <p>
        <a href="CustomerMain.jsp">Home</a>
    </p>
</body>