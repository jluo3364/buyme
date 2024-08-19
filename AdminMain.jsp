<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <meta charset="ISO-8859-1">
    <title>Admin Homepage</title>
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement st = con.createStatement();
    String admin_id = (String) session.getAttribute("employeeid");
    if (admin_id == null) {
        response.sendRedirect("login.jsp");
    }
    ResultSet resultset = st.executeQuery("SELECT id, password FROM customer_representative");
%>
<h1>Admin Home</h1>
<div style="display: flex; min-width: 150vh; padding:0 200px;">
    <div style="flex: 2; padding-right: 50px;">
        <h3 style="text-align: center; ">Current Customer Reps</h3>
        <table style="width: 90%; border-collapse: collapse;">
            <tr>
                <th>Rep ID</th>
                <th>Password</th>
            </tr>
            <%
                if (!resultset.next()) {
            %>
            <tr>
                <td colspan="2" style="text-align: center;">None</td>
            </tr>
            <%
            } else {
                resultset.beforeFirst();
                while (resultset.next()) { %>
            <tr>
                <td><%= resultset.getString(1) %></td>
                <td><%= resultset.getString(2) %></td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>
    <div style="flex: 1; display: flex; flex-direction: column;">
        <div>
            <h3 style="text-align: center; margin-bottom:0px;">Add Customer Rep</h3>
            <form method="post" action="makeRep.jsp">
                <table style="width: 100%;">
                    <tr>
                        <td>Rep ID: <input type="text" name="id" value="" maxlength="30" required/></td>
                    </tr>
                    <tr>
                        <td>Rep Password: <input type="text" name="password" value="" maxlength="30" required/></td>
                    </tr>
                    <tr>
                        <td><input type="submit" value="Add" style="width: 100px;"/></td>
                    </tr>
                    <% if (request.getParameter("CreateRet") != null) { %>
                    <tr>
                        <td><p style="text-align: center;
                                color: <%= request.getParameter("CreateRetCode").equals("0") ? "blue" : "red" %>;">
                            <%= request.getParameter("CreateRet") %>
                        </p></td>
                    </tr>
                    <% } %>
                </table>
            </form>
        </div>
        <div>
            <h3 class="center-texts" style="margin-bottom:0px;">Sales Reports</h3>
            <form action="createSalesReport.jsp">
                <table style="width: 100%;">
                    <tr>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                    <tr>
                        <td ><input type="datetime-local" required name="date1"></td>
                        <td><input type="datetime-local" required name="date2"></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;"><input type="submit" value="Create" style="width: 100px;"/></td>
                    </tr>
                </table>
                <p class="center-texts">Generates various sales reports based on the
                                           specified date range. These reports will provide
                                           insights into various aspects of sales performance,
                                           including total earnings, earnings per item, earnings
                                           per item type, earnings per end-user, and best-selling
                                           items and end-users. </p>
            </form>
        </div>
    </div>
</div>
<a class="back-button" href="logout.jsp">Logout</a>
</body>
</html>