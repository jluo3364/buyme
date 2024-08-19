<%--
  Created by IntelliJ IDEA.
  User: andreakim
  Date: 4/21/24
  Time: 6:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html>
<head>
    <title>Customer Rep Main</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        tr:nth-child(odd) {
            background-color: #fffefe;
        }
        tr:nth-child(even) {
            background-color: #efefef;
        }
        tr:hover {
            background-color: #DCEDFF;
        }
        td {
            padding: 10px;
            border: 2px solid;
            text-align: left;
            max-width: 500px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .clickable-row {
            cursor: pointer;
        }
        form {
            border: 2px black solid;
            margin: 20px 0;
        }
        h2{
            margin-bottom: 0px;
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
%>
<h1>Hello <%= c_id %></h1>

<h2>Customer Questions</h2>
<%
    Statement st = con.createStatement();
    ResultSet resultset = st.executeQuery("SELECT q_id, question_text FROM question");
%>
<form action="RepQuestionResponse.jsp" id="questionForm" method="post">
    <table>
        <tr>
        </tr>
        <%
            if (!resultset.next()) {
        %>
        <tr>
            <td colspan="2">None</td>
        </tr>
        <%
        } else {
            resultset.beforeFirst();
            while (resultset.next()) {
        %>
        <tr class="clickable-row" onclick="submitForm('<%= resultset.getString(1) %>', 'questionForm')">
            <td><%= resultset.getString(2) %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
    <input type="hidden" name="q_id" id="questionInput">
</form>
<h2>Auctions and Bids</h2>
<%
    ResultSet bidquery = st.executeQuery("SELECT toy_id, name, category, initial_price FROM toy_listing");
%>
<form action="EditBidAuc.jsp" id="bidForm" method="post">
    <table>
        <tr>
            <th>Toy ID</th>
            <th>Name</th>
            <th>Category</th>
            <th>Initial Price</th>
        </tr>
        <%
            if (!bidquery.next()) {
        %>
        <tr>
            <td colspan="4">None</td>
        </tr>
        <%
        } else {
            bidquery.beforeFirst();
            while (bidquery.next()) {
        %>
        <tr class="clickable-row" onclick="submitForm('<%= bidquery.getString(1) %>', 'bidForm')">
            <td><%= bidquery.getString(1) %></td>
            <td><%= bidquery.getString(2) %></td>
            <td><%= bidquery.getString(3) %></td>
            <td><%= bidquery.getString(4) %></td>

        </tr>
        <%
                }
            }
        %>
    </table>
    <input type="hidden" name="toy_id" id="toyInput">
</form>
<h2>User Account Access</h2>
<%
    ResultSet accountsQuery = st.executeQuery("SELECT username FROM user");
%>
<form action="EditUserAccount.jsp" id="userForm" method="post">
    <table>
        <tr>
            <th>Username</th>
        </tr>
        <%
            if (!accountsQuery.next()) {
        %>
        <tr>
            <td>None</td>
        </tr>
        <%
        } else {
            accountsQuery.beforeFirst();
            while (accountsQuery.next()) {
        %>
        <tr class="clickable-row" onclick="submitForm('<%= accountsQuery.getString(1) %>', 'userForm')">
            <td><%= accountsQuery.getString(1) %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
    <input type="hidden" name="username" id="userInput">
</form>

<a class="back-button" href="logout.jsp">Logout</a>
<script>
    function submitForm(value, formId) {
        const form = document.getElementById(formId);
        const hiddenInput = form.querySelector('input[type=hidden]');
        hiddenInput.value = value;
        form.submit();
    }
</script>
</body>
</html>