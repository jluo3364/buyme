<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/7/24
  Time: 4:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import ="java.sql.*" %>
<html>
<head>
    <%
        session.invalidate();
//        session.getAttribute("user"); //this will throw an error
        response.sendRedirect("login.jsp");
    %>
</head>
<body>
</body>
</html>
