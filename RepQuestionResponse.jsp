<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/4/24
  Time: 2:37 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Responding to Question</title>
    <style>
        .center-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .response-form {
            width: 500px; /* Specific width can be set */
            text-align: center; /* Centers the text and other inline contents */
        }
        .response-form textarea {
            width: 100%; /* Makes the textarea take the full width of the form */
            height: 100px;
        }
        .back-button {
            display: block; /* Makes the link behave like a block */
            width: fit-content; /* Only as wide as necessary */
            margin: 20px auto; /* Centers the button horizontally */
        }
    </style>
</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String c_id = (String) session.getAttribute("employeeid");
    if (c_id == null) {
        response.sendRedirect("login.jsp");
    }
    String q_id = request.getParameter("q_id");

    PreparedStatement ps = null;
    ResultSet rs = null;

    String question_text_query = "SELECT question_text FROM question WHERE q_id=?";
    ps = con.prepareStatement(question_text_query);
    ps.setString(1, q_id);
    rs = ps.executeQuery();
    rs.next();
    String question_text = rs.getString("question_text");
%>
<div class="center-container">
    <h3 style="color: black;">Q: <%= question_text %></h3>
    <%
        ps = con.prepareStatement("SELECT c_id, answer_text FROM answer WHERE q_id=?");
        ps.setString(1, q_id);
        rs = ps.executeQuery();
        String c_responder = null;
        String answer_text = null;
        if (rs.next()) {
            c_responder = rs.getString("c_id");
            answer_text = rs.getString("answer_text");
        }

        if (c_responder == null) {
    %>
    <hr/>
    <h3>Respond to Question</h3>
    <form class="response-form" action="checkAnswer.jsp">
        <textarea name="answer_text"></textarea>
        <button style="margin-top: 20px;" type="submit">Resolve!</button>
        <input type="hidden" name="c_id" value="<%= c_id %>" />
        <input type="hidden" name="q_id" value="<%= q_id %>" />
    </form>
    <% } else { %>
    <h4>Resolved by Customer Rep <%= c_id %>:</h4>
    <p>A: <%= answer_text %></p>
    <% } %>
    <a class="back-button" href="CustomerRepMain.jsp">Back</a>

</div>
</body>
</html>