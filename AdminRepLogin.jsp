<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:01 PM
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
    <title>Admin or Rep Login Page</title>
</head>
<body>
<h1>Employee Login</h1>
<div class="center-texts">
    <form action="CheckEmployeeLogin.jsp" method="POST">
        Employee ID: <input type="text" name="username"  maxlength="30"/> <br>
        Password: <input type="password" name="password"  maxlength="30"/> <br>
        <br>
        <input type="submit" value="Log In"/>
    </form>
    <br>
    <a href="login.jsp">Customer Login</a>
</div>
</body>
</html>