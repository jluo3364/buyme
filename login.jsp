<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/7/24
  Time: 2:58 PM
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
    <title>Login Form</title>
</head>
<body>
<h1>Customer Login</h1>
<div class="center-texts">
    <form action="checkLoginDetails.jsp" method="POST">
        <p>Username: <input type="text" name="username" maxlength="30" /></p>
        <p>Password: <input type="password" name="password"  maxlength="30" /></p>

        <input type="submit" value="Log In"/>
    </form>

    <p><a href="createAccount.jsp">Create Account</a></p>

    <p><a href="AdminRepLogin.jsp">Employee Login Page</a></p>
</div>
</body>
</html>