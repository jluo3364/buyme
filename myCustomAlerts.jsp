<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*, com.cs336.pkg.*, java.util.ArrayList, java.util.List" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Custom Alerts</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h1>My Custom Alerts</h1>
    <div class="scrollable-container">
        <h2 class="center-texts">Action Figure Alerts</h2>
        <table class="center-texts">
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();

                    String category = "action_figure"; // Change this to the desired category
                    String username = session.getAttribute("user").toString();
                    String headerStart = "<thead>\n" +
                            "<tr>\n" +
                            "<th>Alert Name</th>\n" +
                            "<th>Min Price</th>\n" +
                            "<th>Max Price</th>\n" +
                            "<th>Age Range</th>\n";
                    String headerEnd =  "<th>Status</th>\n" +
                            "<th>Matching Listing</th>\n" +
                            "</tr>\n" +
                            "</thead>\n" +
                            "<tbody>";
                    String AFheader = headerStart+"<th>Height</th>\n" +
                            "<th>Can Move</th>\n" +
                            "<th>Character Name</th>\n"+headerEnd;
                    String BGheader = headerStart+"<th>Players</th>\n" +
                            "<th>Game Brand</th>"+headerEnd;
                    String SAheader = headerStart+"<th>Color</th>\n"+"<th>Animal</th>\n" +
                            "<th>Brand</th>\n"+ headerEnd;
                    try{
                    List<CustomAlert> alerts = CustomAlert.getCustomAlerts(username, conn);
                    List<CustomAlert> afAlerts = CustomAlert.byCategory("action_figure", alerts);
                    out.println(generateCategoryAlertsHTML(AFheader,afAlerts,category,conn));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </tbody>
        </table>

        <h2 class="center-texts">Board Game Alerts</h2>
        <table class="center-texts">
                <%
                try {
                    category = "board_game";
                    List<CustomAlert> alerts = CustomAlert.getCustomAlerts(username, conn);
                    List<CustomAlert> bgAlerts = CustomAlert.byCategory(category, alerts);
                    out.println(generateCategoryAlertsHTML(BGheader,bgAlerts,category,conn));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            </tbody>
        </table>

        <h2 class="center-texts">Stuffed Animal Alerts</h2>
        <table class="center-texts">
            <%
                try {
                    category = "stuffed_animal"; // Change this to the desired category
                    List<CustomAlert> alerts = CustomAlert.getCustomAlerts(username, conn);
                    List<CustomAlert> saAlerts = CustomAlert.byCategory(category, alerts);

                    out.println(generateCategoryAlertsHTML(SAheader,saAlerts,category,conn));
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
            </tbody>
        </table>
    </div>
    <br>
    <a href="CustomerMain.jsp">Home</a>
 <%!

     public String buildBoardGameSQL(int player_count, String game_brand){
         String sql = buildSQL("board_game");
         if (player_count != -1) {
             sql += " AND sa.player_count = ?";
         }
         if (game_brand != null && !game_brand.isEmpty()) {
             sql += " AND sa.brand = ?";
         }
         return sql;
     }
public String buildSQL(String category){
    String sql= "SELECT ca.*, tl.toy_id FROM "+category+" sa INNER JOIN toy_listing tl ON sa.toy_id=tl.toy_id INNER JOIN custom_alerts ca using(category) WHERE category = ? and ca.username = ? and tl.openStatus=1";
    sql+=" AND tl.initial_price >= ?";
    sql+=" AND tl.initial_price <= ?";
    sql+=" AND tl.start_age >= ?";
    sql+=" AND tl.end_age <= ?";
    return sql;
}
public String buildActionFigureSQL(double height, boolean can_move, String character_name){
    String sql = buildSQL("action_figure");
    if (height != -1) {
        sql+= " AND sa.height = ?";
    }
    sql+= " AND sa.can_move = ?";

    if (character_name != null && !character_name.isEmpty()) {
        sql+= " AND sa.character_name = ?";
    }
    return sql;
}
     public String buildStuffedAnimalSQL(String color, String animal, String brand){
         String sql = buildSQL("stuffed_animal");
         if (color != null && !color.isEmpty()) {
             sql+= " AND sa.color = ?";
         }
         if (animal != null && !animal.isEmpty()) {
             sql+= " AND sa.animal = ?";
         }
         if (brand != null && !brand.isEmpty()) {
             sql += " AND sa.brand = ?";
         }

         return sql;
     }
public PreparedStatement setPstmt(Connection conn, String sql, CustomAlert a) throws SQLException {
    PreparedStatement ps = conn.prepareStatement(sql);
    int index = 1;
    ps.setString(index++, a.getCategory());
    ps.setString(index++, a.getUsername());
    if (a.getMinPrice() != -1) {
        ps.setDouble(index++, a.getMinPrice());
    }
    if (a.getMaxPrice() != -1) {
        ps.setDouble(index++, a.getMaxPrice());
    }
    if (a.getStartAge() != -1) {
        ps.setInt(index++, a.getStartAge());
    }
    if (a.getEndAge() != -1) {
        ps.setInt(index++, a.getEndAge());
    }
    if(a.getCategory().equals("board_game")){
    if (a.getPlayerCount() != 1) {
        ps.setInt(index++, a.getPlayerCount());
    }
    if (a.getGameBrand() != null && !a.getGameBrand().isEmpty()) {
        ps.setString(index++, a.getGameBrand());
    }}
    else if(a.getCategory().equals("stuffed_animal")){
    if (a.getColor() != null && !a.getColor().isEmpty()) {
        ps.setString(index++, a.getColor());
    }
    if (a.getAnimal() != null && !a.getAnimal().isEmpty()) {
        ps.setString(index++, a.getAnimal());
    }
    if (a.getBrand() != null && !a.getBrand().isEmpty()) {
        ps.setString(index++, a.getBrand());
    }}
    else if(a.getCategory().equals("action_figure")){
        if (a.getHeight()!=-1) {
            ps.setDouble(index++, a.getHeight());
        }
        ps.setBoolean(index++,(a.getCanMove()));
        if (a.getCharacterName() != null) {
            ps.setString(index++, a.getCharacterName());
        }
    }
    return ps;
}
     public String generateCategoryAlertsHTML(String header,List<CustomAlert> alerts, String category, Connection conn) {
         String htmlOutput = "";

         // Check if there are any alerts for the given category
         if (!alerts.isEmpty()) {
             // Generate table header
             htmlOutput += header;
             // Iterate through alerts and generate table rows
             for (CustomAlert a : alerts) {
                 htmlOutput += "<tr>\n";
                 htmlOutput += "<td>" + a.getAlertName() + "</td>\n";
                 htmlOutput += "<td>" + a.getMinPrice() + "</td>\n";
                 htmlOutput += "<td>" + a.getMaxPrice() + "</td>\n";
                 htmlOutput += "<td>" + a.getStartAge() + " - " + a.getEndAge() + "</td>\n";
                String sql="";
                 // Additional columns based on category
                 if (category.equals("action_figure")) {
                     htmlOutput += "<td>" + a.getHeight() + " inches</td>\n";
                     htmlOutput += "<td>" + (a.getCanMove() ? "Yes" : "No") + "</td>\n";
                     htmlOutput += "<td>" + a.getCharacterName() + "</td>\n";
                     sql = buildActionFigureSQL(a.getHeight(), a.getCanMove(), a.getCharacterName());
                 } else if (category.equals("board_game")) {
                     htmlOutput += "<td>" + a.getPlayerCount() + "</td>\n";
                     htmlOutput += "<td>" + a.getGameBrand() + "</td>\n";
                     sql= buildBoardGameSQL(a.getPlayerCount(), a.getGameBrand());
                 } else if (category.equals("stuffed_animal")) {
                     htmlOutput += "<td>" + a.getColor() + "</td>\n";
                     htmlOutput += "<td>" + a.getAnimal() + "</td>\n";
                     htmlOutput += "<td>" + a.getBrand() + "</td>\n";
                     sql = buildStuffedAnimalSQL(a.getColor(), a.getAnimal(), a.getBrand());
                 }

                 // Get matching listings and generate corresponding HTML
                 Set<Integer> matchingListings = getMatchingListings(a,conn,sql);
                 if (!matchingListings.isEmpty()) {
                     htmlOutput += "<td>Yes</td>\n";
                     htmlOutput += "<td>";
                     for (int toyId : matchingListings) {
                         htmlOutput += "<p><a href=\"listingDetails.jsp?id=" + toyId + "\">Check Listing</a></p>\n";
                     }
                     htmlOutput += "</td>\n";
                 } else {
                     htmlOutput += "<td>No matching active listings</td>\n";
                 }

                 htmlOutput += "</tr>\n";
             }
         } else {
             // No alerts for the given category
             htmlOutput += "<tr><td colspan=\"9\">No alerts found for " + category.replace('_',' ') + "</td></tr>";
         }

         return htmlOutput;
     }

     // Method to get matching listings for a given alert
     public Set<Integer> getMatchingListings(CustomAlert a, Connection conn, String sql) {
         Set<Integer> toyIds = new HashSet<>();
         try (PreparedStatement ps = setPstmt(conn, sql, a)) {
             try (ResultSet rs = ps.executeQuery()) {
                 while (rs.next()) {
                     toyIds.add(rs.getInt("toy_id"));
                 }
             }} catch (SQLException e) {
             throw new RuntimeException(e);
         }
         return toyIds;
     }
 %>
</body>
</html>