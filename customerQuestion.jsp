<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/2/24
  Time: 7:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Customer Service</title>
  <link rel="stylesheet" type="text/css" href="styles.css">
  <style>
    .center {
      margin-left: auto;
      margin-right: auto;
    }
    table, th, td {
      border: 1px solid;
      border-collapse: collapse;
    }
    .form-container {
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    input[type="submit"] {
      margin-top: 10px;
      width: 50%;
    }


    td a:hover {
      color: #0a2559;
    }
  </style>
</head>
<body>
<%
  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();
  String username = (String) session.getAttribute("user");
  if (username == null) {
    response.sendRedirect("CustomerMain.jsp");
  }

  String keyword = request.getParameter("search");
  PreparedStatement ps = null;
  ResultSet resultset = null;

  // Determine if the revert search was triggered
  boolean revertSearch = "true".equals(request.getParameter("revertSearch"));

  if (keyword != null && !keyword.isBlank() && !revertSearch) {
    String sql = "SELECT q_id, question_text FROM question WHERE question_text LIKE ? AND username = ?";
    ps = con.prepareStatement(sql);
    ps.setString(1, "%" + keyword + "%");
    ps.setString(2, username);
  } else {
    String sql = "SELECT q_id, question_text FROM question WHERE username = ?";
    ps = con.prepareStatement(sql);
    ps.setString(1, username);
  }
  resultset = ps.executeQuery();
%>
<h1>Customer Service</h1>
<div style="display: flex; min-width: 150vh;">
  <div style="flex: 1; padding-right: 50px;  align-items: center; flex-direction: column;">
    <h3 style="text-align: center;" >Contact Us</h3>
    <form method="post" action="checkQuestion.jsp" class="form-container">
      <textarea id="question" name="c_question" rows="10" cols="50" placeholder="Type in your inquiry here."></textarea>
      <input type="submit" style="padding: 10px; margin-top: 25px;" value="Send"/>
    </form>
  </div>
  <div style="flex: 2; display: flex; flex-direction: column;">
    <h3 style="text-align: center;">Your Past Questions</h3>
    <form method="post" action="<%=request.getRequestURI()%>">
      <input type="text" style="width: 350px; " name="search" class="form-control" placeholder="Search Question">
      <button type="submit" style="" name="save" >Search</button>
      <button type="submit" style="" name="revertSearch" value="true">Revert Search</button>
    </form>
    <hr/>
    <table style="margin: 0px auto; width: 90%; border-collapse: collapse;">
      <%
        if (!resultset.next()) {
      %>
      <tr>
        <td colspan="2" style="text-align: center;">No questions found</td>
      </tr>
      <%
      } else {
        resultset.beforeFirst();
        while (resultset.next()) {
          String q_id = resultset.getString(1);
          String questionText = resultset.getString(2);
      %>
      <tr>
        <td><a style="" href="QuestionChatRoom.jsp?q_id=<%= q_id %>" style="display: block; width: 100%; height: 100%; color: inherit; text-decoration: none;"><%= questionText %></a></td>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>
</div>
<a class="back-button" href="CustomerMain.jsp">Back</a>
</body>
</html>