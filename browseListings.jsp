<%--
  Created by IntelliJ IDEA.
  User: jessicaluo
  Date: 4/14/24
  Time: 12:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.OffsetTime" %>
<%@ page import="java.time.ZoneOffset" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <title>Browse Listings</title>
    <script>
        window.onload = function() {
            // Get all table rows
            var rows = document.querySelectorAll('table tr[data-href]');
            // Add click event listener to each row
            rows.forEach(function(row) {
                row.addEventListener('click', function() {
                    let href = row.getAttribute('data-href');
                    window.location.href = href;
                });
            });


            document.querySelector("#search-btn").addEventListener('click', ()=>{
                let url = new URL(window.location.href);
                let searchInput = document.querySelector("#search-input").value;
                if (searchInput){
                    url.searchParams.set("search",  searchInput);
                }else{
                    url.searchParams.delete("search");

                }
                window.history.replaceState({}, '', url.toString());
                location.reload();

            });
            document.querySelector("#filter-btn").addEventListener('click', ()=>{
                let url = new URL(window.location.href);
                let priceMin = document.querySelector("#price-min").valueAsNumber;
                if (!isNaN(priceMin)) {
                    url.searchParams.set("priceMin", priceMin);
                }else{
                    url.searchParams.delete("priceMin");
                }

                let priceMax = document.querySelector("#price-max").valueAsNumber;
                if (!isNaN(priceMax)) {
                    url.searchParams.set("priceMax", priceMax);
                }else{
                    url.searchParams.delete("priceMax");
                }

                let ageMin = document.querySelector("#age-min").valueAsNumber;
                if (!isNaN(ageMin)) {
                    url.searchParams.set("ageMin", ageMin);
                }else{
                    url.searchParams.delete("ageMin");
                }

                let ageMax = document.querySelector("#age-max").valueAsNumber;
                if (!isNaN(ageMax)) {
                    url.searchParams.set("ageMax", ageMax);
                }else{
                    url.searchParams.delete("ageMax");
                }
                let category = document.querySelector("#category-select").value;
                if (category){
                    url.searchParams.set("category",  category);
                }else{
                    url.searchParams.delete("category");
                }
                let sort = document.querySelector("#sort-select").value;
                if (sort){
                    url.searchParams.set("sort",  sort);
                }else{
                    url.searchParams.delete("sort");
                }
                window.history.replaceState({}, '', url.toString());
                location.reload();

            });

            let div = document.querySelector(".filter-controls");
            if ([...new URL(window.location.href).searchParams.keys()].some(el => el === "priceMin" || el === "priceMax" || el === "ageMin" || el === "ageMax" || el === "category" || el == "sort")){
                div.style.display = "block"
            }else{
                div.style.display = "none"
            }
            document.querySelector("#filter-toggle").addEventListener('click', ()=>{
                div.style.display = div.style.display == "none" ? "block" : "none";
            });
        };


    </script>
</head>
<div class="search-controls">
    <div class="row search-row">
        <input  type="text" placeholder=" Search by product name" id= "search-input"/>
        <input type="submit" value="Search" id="search-btn"/>
        <input type="submit" value="Advanced Search" id="filter-toggle"/>
    </div>
    <div class="filter-controls" style="display: none">
        <div class="row filter-row">
            <p>Sort By</p>
            <div class="column">
                <div class="row">
                    <select name="category" id="sort-select" >
                        <option value="" selected >default</option>
                        <option value="price_desc">Current Price: High to Low</option>
                        <option value="price_asc">Current Price: Low to High </option>
                        <option value="time_desc">Start Time: Newest</option>
                        <option value="time_asc">Start Time: Oldest</option>

                    </select>
                </div>
            </div>
        </div>

        <div class="row filter-row">
            <p>Price Range</p>
            <div class="column">
                <div class="row">
                    <p>min</p>
                    <input id="price-min" class="filter-input"  type="number"  />
                    <p>max</p>
                    <input id="price-max" class="filter-input" type="number" />
                </div>
            </div>
        </div>

        <div class="row filter-row">
            <p>Age</p>
            <div class="column">
                <div class="row">
                    <p>min</p>
                    <input id="age-min" class="filter-input" type="number" />
                    <p>max</p>
                    <input id="age-max" class="filter-input" type="number"  />
                </div>
            </div>
        </div>


        <div class="row filter-row">
            <p>Category</p>
            <div class="column">
                <div class="row">
                    <select name="category" id="category-select" >
                        <option value="" selected >select a toy category</option>
                        <option value="action_figure">action figure</option>
                        <option value="stuffed_animal">stuffed animal</option>
                        <option value="board_game">board game</option>

                    </select>
                    <input type="submit" value="Apply filters" id="filter-btn"/>
                </div>
            </div>
        </div>
    </div>

</div>

<%

    // Create a connection to the database
    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();
    BidData bidData = new BidData(conn);
    ToyListingData tld = new ToyListingData(conn);
    String search_query = request.getParameter("search");
    String age_min = request.getParameter("ageMin");
    String age_max = request.getParameter("ageMax");

    String price_min = request.getParameter("priceMin");
    String price_max = request.getParameter("priceMax");

    String categoryParam = request.getParameter("category");
    String sort = request.getParameter("sort");

    String userParam = request.getParameter("id");
    List<String> params = new ArrayList<>();
    // true if it's a string, false if int. dumb data modeling, but who cares
    List<Boolean> types = new ArrayList<>();

    try {
        List<ToyListing> toys = new ArrayList<ToyListing>();
        String sql = "select * from toy_listing as tl WHERE 1 = 1";
        if(search_query != null){
            sql += " AND name LIKE ?";
            params.add( "%" + search_query + "%");
            types.add(true);
        }

        if(age_min != null){
            sql += " AND ? <= start_age ";
            params.add(age_min);
            types.add(false);

        }
        if(age_max != null){
            sql += " AND ? >= end_age ";
            params.add(age_max);
            types.add(false);
        }

        if(price_min != null){
            sql += " AND (SELECT price FROM bid WHERE toy_id = tl.toy_id ORDER BY price DESC LIMIT 1 ) > ?";
            params.add(price_min);
            types.add(false);

        }
        if(price_max != null){
            sql += " AND (SELECT price FROM bid WHERE toy_id = tl.toy_id ORDER BY price DESC LIMIT 1 ) < ?";
            params.add(price_max);
            types.add(false);

        }
        if(categoryParam != null){
            sql += " AND category = ?";
            params.add(categoryParam);
            types.add(true);

        }
        if(userParam!= null){
            sql += " AND user = ?";
            params.add(userParam);
            types.add(true);
        }
        if (sort != null){
            if ("price_desc".equals(sort)){
                sql += " ORDER BY (SELECT price FROM bid WHERE toy_id = tl.toy_id ORDER BY price DESC LIMIT 1 ) DESC";
            } else if ("price_asc".equals(sort)){
                sql += " ORDER BY (SELECT price FROM bid WHERE toy_id = tl.toy_id ORDER BY price DESC LIMIT 1 ) ASC";
            } else if ("time_asc".equals(sort)){
                sql += " ORDER BY start_datetime ASC";
            } else if ("time_desc".equals(sort)){
                sql += " ORDER BY start_datetime DESC";
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                if (types.get(i)){
                    ps.setString(i+1, params.get(i));
                }else{
                    ps.setInt(i+1, Integer.parseInt(params.get(i)));
                }
            }
//            System.out.println(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ToyListing tl = ToyListingData.extractToyListing(rs);
                    toys.add(tl);
                }

            }
        }

        if(toys== null || toys.isEmpty()){
            out.println("There are no listings.");
        }
        else {
            // Display the data in a table
            out.println("<table>");
            out.println("<tr><th>Category</th><th>Name</th><th>Age Range</th><th>Current Price</th><th>Increment</th><th>Start Time</th><th>Closing Time</th><th>status</th></tr>");
            for(ToyListing toy : toys) {
                String category = toy.getCategory();
                int id = toy.getToyId();
                double curPrice = bidData.highestBid(id);
                DecimalFormat df = new DecimalFormat("#.##");
                //no bids placed on it yet
                if(curPrice ==-1){
                    curPrice = toy.getInitialPrice();
                }
                String url = "listingDetails.jsp?id=" + id;
                out.println("<tr data-href=\"" + url + "\" class =\"listing-tr\">");
                category = category.replace("_", " ");
                out.println("<td>" + category + "</td>");
                out.println("<td>" + toy.getName() + "</td>");
                out.println("<td>" + toy.getStartAge() +" - "+ toy.getEndAge()+"</td>");
                out.println("<td>" + df.format(curPrice) + "</td>");
                out.println("<td>" + toy.getIncrement() + "</td>");

                LocalDateTime startTime = toy.getStartDateTime();
                // Define the format with AM/PM and without seconds
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a");
                // Format the datetime using the formatter
                String startDT = startTime.format(formatter);
                out.println("<td>" + startDT + "</td>");
                LocalDateTime endTime = toy.getClosingDateTime();
                String endDT = endTime.format(formatter);
                out.println("<td>" + endDT + "</td>");

                if (LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) > startTime.toEpochSecond(ZoneOffset.UTC) &&
                        LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) < endTime.toEpochSecond(ZoneOffset.UTC)){
                    out.println("<td>auction in progress</td>");
                }else if (LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) < startTime.toEpochSecond(ZoneOffset.UTC)){
                    out.println("<td>auction starting soon</td>");
                }
                else{
                    tld.deactivateToyListing(id);
                    out.println("<td>auction done</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
        }
        // Close resources
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle any exceptions
    } finally {
        // Ensure resources are closed even in case of exceptions
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
<p>
    <a href="CustomerMain.jsp">Home</a>
</p>
</body>
</html>