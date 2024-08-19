<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/12/24
  Time: 1:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Create Account</title>

</head>
<body>
<h1>Create Customer Account</h1>
<div class="center-texts">
<form action="insertAcc.jsp" id = "accInfo" method="POST" >
    Username: <input type="text" name="username" required/>  <br>
    Password: <input type="password" name="password" required/>  <br>
    <br>
    <input type="submit" value="Create Account"/>
</form> <br>
<a href="login.jsp">Cancel</a>

</div>
</body>
</html>