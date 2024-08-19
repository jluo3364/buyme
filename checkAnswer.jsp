<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/2/24
  Time: 10:28 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.*"%>
<html>
<head>
    <title>Answer Question</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String answer_text = request.getParameter("answer_text");
        String q_id = request.getParameter("q_id");
        String c_id = request.getParameter("c_id");

        PreparedStatement ps = con.prepareStatement(
                "INSERT INTO answer (q_id, c_id, answer_text) VALUES(?, ?, ?)"
        );
        ps.setString(1, q_id);
        ps.setString(2, c_id);
        ps.setString(3, answer_text);
        ps.executeUpdate();

        String redirectURL = "QuestionChatRoom.jsp?q_id=" + q_id;
        response.sendRedirect(redirectURL);
    } catch (SQLException e) {
        e.printStackTrace();
    } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
    }
%>
</body>
</html>