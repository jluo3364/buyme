<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/2/24
  Time: 8:50 PM
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
  <meta charset="ISO-8859-1">
  <title>Verify Question</title>
</head>
<body>
<%
  try {

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String username = (String) session.getAttribute("user");
    if (username == null) {
      response.sendRedirect("login.jsp");
      return;
    }

    String question = request.getParameter("c_question");
    String q_id = question+username;


    String insert = "INSERT INTO question(question_text, q_id, username) VALUES(?, ?, ?)";
    PreparedStatement ps = con.prepareStatement(insert);
    ps.setString(1, question);
    ps.setString(2, q_id);
    ps.setString(3, username);

    ps.executeUpdate();

    session.setAttribute("askQuestionRet", "Question posted!");
    response.sendRedirect("customerQuestion.jsp");

  } catch (SQLException e) {
    String code = e.getSQLState();
    session.setAttribute("msg", code.equals("23000") ? "Duplicate question detected!" : "Database error occurred.");
    response.sendRedirect("customerQuestion.jsp");

  } catch (Exception e) {
    session.setAttribute("msg", "An unknown error occurred.");
    response.sendRedirect("AskQuestion.jsp");
  }
%>
</body>
</html>