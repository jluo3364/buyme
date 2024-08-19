<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/4/24
  Time: 6:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.URLEncoder"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Updating User Account</title>
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String del_user = request.getParameter("del_user");
    String user = del_user;
    String new_user = request.getParameter("new_user");
    String new_pw = request.getParameter("new_pw");
    String deleteOperation = request.getParameter("delete");

    if (deleteOperation != null && deleteOperation.equals("true")) {
        PreparedStatement ps = con.prepareStatement(
                "DELETE FROM user WHERE username=(?)"
        );
        ps.setString(1, del_user);
        ps.executeUpdate();
        response.sendRedirect("CustomerRepMain.jsp");
    } else {
        if (new_pw != null && !new_pw.isBlank()) {
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE user SET password=(?) WHERE username=(?)"
            );
            ps.setString(1, new_pw);
            ps.setString(2, del_user);
            ps.executeUpdate();
        }

        if (new_user != null && !new_user.isBlank()) {
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE user SET username=(?) WHERE username=(?)"
            );
            ps.setString(1, new_user);
            ps.setString(2, del_user);
            user = new_user;
            ps.executeUpdate();
        }

        // Redirect to EditUserAccount.jsp with the updated username as a URL parameter
        String encodedUsername = URLEncoder.encode(user, "UTF-8");
        response.sendRedirect("EditUserAccount.jsp?username=" + encodedUsername);
    }
%>
</body>
</html>