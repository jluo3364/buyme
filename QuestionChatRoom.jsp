<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 5/4/24
  Time: 1:40 PM
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
    <title>Q&A</title>
    <link rel="stylesheet" type="text/css" href="styles.css">

</head>
<body>
<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    String q_id = request.getParameter("q_id");
    String employeeId = (String) session.getAttribute("employeeid");
    String userId = (String) session.getAttribute("user");
    PreparedStatement ps = null;
    ResultSet resultset = null;

    String question_text_query = "SELECT question_text FROM question WHERE q_id=(?)";
    ps = con.prepareStatement(question_text_query);
    ps.setString(1, q_id);
    resultset = ps.executeQuery();
    resultset.next();
    String question_text = resultset.getString(1);
%>
<h1>Q&A</h1>
<h3 style ="color: black;">Q: <%= question_text %></h3>
<%
    ps = con.prepareStatement(
            "SELECT c_id, answer_text FROM answer WHERE q_id=(?)"
    );
    ps.setString(1, q_id);
    String c_id = null;
    String answer_text = null;
    resultset = ps.executeQuery();
    if (resultset.next()) {
        c_id = resultset.getString(1);
        answer_text = resultset.getString(2);
    }

    if (c_id == null) {
%>
<hr/>
<h4 style="font-weight: normal;">This issue hasn't been addressed yet. Please wait.</h4>
<% } else { %>
<h4>Addressed by Customer Rep <%= c_id %>:</h4>
A: <%= answer_text %>
<% } %>

<%
    String url;
    if (userId != null) {
        // Redirect to a different page for employees
        url = "customerQuestion.jsp";
    } else {
        // Redirect to the home page for regular users
        url = "CustomerRepMain.jsp";
    }
%>
<a class="back-button" href="<%=url%>">Back</a>

</body>
</html>