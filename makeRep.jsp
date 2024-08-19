<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:43 PM
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
    <meta charset="ISO-8859-1">
    <title>Making Customer Rep</title>
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement stmt = con.createStatement();
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String insert = "INSERT INTO customer_representative VALUES(?, ?)";
    PreparedStatement ps = con.prepareStatement(insert);
    ps.setString(1, id);
    ps.setString(2, password);
    try {
        ps.executeUpdate();

        insert = "INSERT INTO create_admin VALUES(0, ?)";
        ps = con.prepareStatement(insert);
        ps.setString(1, id);
        ps.executeUpdate();

        session.setAttribute("CreateRet", "Rep Successfully created!");
        session.setAttribute("CreateRetCode", "0");
        response.sendRedirect("AdminMain.jsp");
    } catch (SQLException e) {
        String code = e.getSQLState();
        if (code.equals("23000")) {
            session.setAttribute("CreateRet", "A rep already exists with this ID.");
            session.setAttribute("CreateRetCode", "1");
            response.sendRedirect("AdminMain.jsp");
        } else {
            session.setAttribute("CreateRet", "Error creating Rep. Please try again.");
            session.setAttribute("CreateRetCode", "1");
            response.sendRedirect("AdminMain.jsp");
        }
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</body>
</html>