<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/8/24
  Time: 12:39 PM
  User enters details to create a new listing.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Create Listing</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
        function showAdditionalFields() {
            var category = document.getElementsByName("category")[0].value;
            var actionFigureFields = document.getElementById("actionFigureFields");
            var stuffedAnimalFields = document.getElementById("stuffedAnimalFields");
            var boardGameFields = document.getElementById("boardGameFields");

            // Hide all additional fields
            actionFigureFields.style.display = "none";
            stuffedAnimalFields.style.display = "none";
            boardGameFields.style.display = "none";

            // Show fields based on selected category
            if (category === "action_figure") {
                actionFigureFields.style.display = "block";
            } else if (category === "stuffed_animal") {
                stuffedAnimalFields.style.display = "block";
            } else if (category === "board_game") {
                boardGameFields.style.display = "block";
            }

            // Show the additional fields container
            document.getElementById("additionalFields").style.display = "block";
        }
    </script>

</head>
<body>
<form action="insertListing.jsp" id="listingForm" method="POST" onsubmit="return validateForm()">
    Name: <input type="text" name="name"/>  <br>
    Category: <select name="category" onchange="showAdditionalFields()">
    <option value="" disabled selected hidden>select a toy category</option>
    <option value="action_figure">action figure</option>
    <option value="stuffed_animal">stuffed animal</option>
    <option value="board_game">board game</option>
</select><br>
    <div id="additionalFields" style="display: none;">
        <br>
        <!-- Action Figure Fields -->
        <div id="actionFigureFields" style="display: none;">
            Action Figure Details <br><br>
            Height: <input type="number" name="height"/> <br>
            Can Move: <input type="checkbox" name="can_move"/> <br>
            Character: <input type="text" name="character"/> <br>
        </div>

        <!-- Stuffed Animal Fields -->
        <div id="stuffedAnimalFields" style="display: none;">
            Stuffed Animal Details <br><br>
            Color: <input type="text" name="color"/> <br>
            Brand: <input type="text" name="brand"/> <br>
            Animal: <input type="text" name="animal"/> <br>
        </div>

        <!-- Board Game Fields -->
        <div id="boardGameFields" style="display: none;">
            Board Game Details <br><br>
            Player Count: <input type="number" name="player_count"/> <br>
            Brand: <input type="text" name="game_brand"/> <br>
            Is Cards Game: <input type="checkbox" name="is_cards_game"/> <br>
        </div>
        <br>
    </div>

    Age Range: <input type="number" name="start_age"/> - <input type='number' name="end_age"/> <br>
    Initial Price: <input type="number" name="price" step="0.01" /> <br>

    Minimum Bid Increment: <input type="number" name="increment" step="0.01"/>  <br>
    Minimum Sale Price: <input type="number" name="min_price" step="0.01"/>  <br>
    <% LocalDateTime now = LocalDateTime.now().plusHours(1);
        String minDateTime = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));%>
    Closing Date and Time: <input type="datetime-local" name="endDT" /><%--min="<%= minDateTime "%>--%>  <br>
    <input type="submit" value="Submit"/>
</form>
<a href="CustomerMain.jsp">Cancel</a>
<script>
    function validateForm() {
        var form = document.getElementById("listingForm");
        var inputs = form.getElementsByTagName("input");
        var dropdown = form.querySelector("select[name='category']");
        var visibleInputs = Array.from(inputs).filter(input => input.offsetParent !== null); // Filter out hidden inputs
        for (var i = 0; i < visibleInputs.length; i++) {
            if (visibleInputs[i].value.trim() === "") {
                alert("Please fill in all fields: "+visibleInputs[i].name+" is missing.");
                return false; // Prevent form submission
            }
        }
        var price = parseFloat(document.getElementsByName("price")[0].value);
        var start_age = parseInt(document.getElementsByName("start_age")[0].value);
        var end_age = parseInt(document.getElementsByName('end_age')[0].value);
        var min_price = parseFloat(document.getElementsByName('min_price')[0].value);
        var increment = parseFloat(document.getElementsByName('increment')[0].value);
        if (price < 0 || start_age < 0 || end_age < 0 || min_price < 0 || increment < 0) {
            alert("Please enter non-negative values for price, age, and price increment.");
            return false; // Prevent form submission
        }
        if (start_age > end_age) {
            alert("Start age must be less than or equal to end age.");
            return false; // Prevent form submission
        }
        if (!dropdown.value) {
            alert("Please select a category.");
            return false; // Prevent form submission
        }
        var category = dropdown.value;
        if (category === "action_figure") {
            var heightStr = document.getElementsByName("height")[0].value;
            var character = document.getElementsByName("character")[0].value
            if (character.trim() === "" || heightStr === "") {
                alert("Please fill in the height and character fields for the action figure details.");
                return false; // Prevent form submission
            }
            var height = parseFloat(heightStr);
            if (isNaN(height) || height < 0) {
                alert("Please enter a non-negative value for height.");
                return false; // Prevent form submission
            }
        } else if (category === "stuffed_animal") {
            var color = document.getElementsByName("color")[0].value;
            var brand = document.getElementsByName("brand")[0].value;
            var animal = document.getElementsByName("animal")[0].value;
            if (color.trim() === "" || brand.trim() === "" || animal.trim() === "") {
                alert("Please fill in all fields for stuffed animal details.");
                return false; // Prevent form submission
            }
        } else if (category === "board_game") {
            var brand = document.getElementsByName('game_brand')[0].value;
            var player_countStr = (document.getElementsByName("player_count")[0].value);
            if (brand.trim() === "") {
                alert("Please fill in the board game brand.");
                return false; // Prevent form submission
            }
            var player_count = parseInt(player_countStr);
            if (isNaN(player_count) || player_count < 0) {
                alert("Please enter a non-negative integer for player count.");
                return false; // Prevent form submission
            }
        }
        return true; // Allow form submission
    }
</script>
</body>
</html>