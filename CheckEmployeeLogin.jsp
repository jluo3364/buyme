<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Check Employee Login</title>
</head>
<body>
<%
    String id = request.getParameter("username");
    String password = request.getParameter("password");
    boolean loginSuccess = false; // Flag to track login status

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String lookup = "SELECT id, password FROM admin WHERE id=? AND password=?";
        PreparedStatement ps = con.prepareStatement(lookup);
        ps.setString(1, id);
        ps.setString(2, password);

        ResultSet result = ps.executeQuery();

        if (result.next()) {
            session.setAttribute("employeeid", id);
            loginSuccess = true;
            response.sendRedirect("AdminMain.jsp?user=" + id);
        } else {
            lookup = "SELECT id, password FROM customer_representative WHERE id=? AND password=?";
            ps = con.prepareStatement(lookup);
            ps.setString(1, id);
            ps.setString(2, password);
            result = ps.executeQuery();

            if (result.next()) {
                session.setAttribute("employeeid", id);
                loginSuccess = true;
                response.sendRedirect("CustomerRepMain.jsp?c_id=" + id);
            }
        }

        if (!loginSuccess) {
            out.println("Incorrect username or password. <a href='AdminRepLogin.jsp'>Try again</a>");
        }

    } catch (Exception e) {
        out.println("Error during login process. Please contact system administrator.");
    }
%>
</body>
</html>