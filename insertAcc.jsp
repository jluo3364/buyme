<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/12/24
  Time: 1:57 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Error</title>
</head>
<body>
<%
        String userid = request.getParameter("username");
        String pwd = request.getParameter("password");
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

// Check if the username already exists
        String checkSql = "SELECT * FROM user WHERE username = ?";
        PreparedStatement checkStmt = con.prepareStatement(checkSql);
        checkStmt.setString(1, userid);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
                // Username already exists, handle the error

                out.println("This username already exists: "+ userid+"  <br><a href='createAccount.jsp'>create account</a><br><a href='login.jsp'>login</a>");
        } else {
                // Username does not exist, proceed with insertion
                String insertSql = "INSERT INTO user (username, password) VALUES (?,?)";
                PreparedStatement pstmt = con.prepareStatement(insertSql);
                pstmt.setString(1, userid);
                pstmt.setString(2, pwd);
                pstmt.executeUpdate();
                session.setAttribute("user", userid); // the username will be stored in the session
                response.sendRedirect("CustomerMain.jsp");

                pstmt.close();
        }

        rs.close();
        checkStmt.close();
        con.close();
%>
</body>
</html>