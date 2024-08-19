<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/4/24
  Time: 6:35 PM
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
  <title>Edit User Account</title>
  <style>
    button{
      background-color: darkred;
      border: 2px solid darkred;
    }

    button:hover{
      border: 2px solid darkred;
      color: darkred;
    }

  </style>
</head>
<body>
<%
  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();
  String rep_id = (String) session.getAttribute("employeeid");
  if (rep_id == null) {
    response.sendRedirect("login.jsp");
  }
  String username = request.getParameter("username");
  PreparedStatement ps = con.prepareStatement(
          "SELECT password FROM user WHERE username=(?)"
  );
  ps.setString(1, username);
  ResultSet rs = ps.executeQuery();
  rs.next();

%>
<h1>Edit <%=username%>'s Account</h1>
<div class="center-texts">
  <form action="updateUserAccount.jsp" method="POST">
    <p><strong>Current Username: </strong><%= username %></p>
    <p><strong>Current password: </strong><%= rs.getString(1) %><p>
    <hr/>
    <p>New Username: <input type="text" name="new_user" maxlength="30" /></p>
    <p>New Password: <input type="password" name="new_pw"  maxlength="30" /></p>

    <input type="submit" value="Update"/>

    <input type="hidden" name="del_user" value="<%= username %>"/>

  <button name="delete" style=" margin-top:40px; margin-bottom:40px; width:130px" type="submit" value="true">Delete Account</button>
    <br/>
    <br/>
  </form>


  <a class="back-button" href="CustomerRepMain.jsp">Back</a>

</div>
</body>
</html>