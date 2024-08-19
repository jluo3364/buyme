package com.cs336.pkg;

import java.io.IOException;
import java.sql.*;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;


@WebServlet("/placeBid")
public class PlaceBidServlet extends HttpServlet {


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            int toyId = Integer.parseInt(request.getParameter("id"));
            double bidAmt = Double.parseDouble(request.getParameter("bidAmt"));
            System.out.println(request.getParameter("isAutoBid"));
            boolean isAutoBid = request.getParameter("isAutoBid")!=null && request.getParameter("isAutoBid").equals("on");
            double maxBid = -1;
            double autoBidIncrement = -1;
            if (isAutoBid) {
                maxBid = Double.parseDouble(request.getParameter("maxBid"));
                autoBidIncrement = Double.parseDouble(request.getParameter("autoBidIncrement"));
            }

            try {

                //Get the database connection
                ApplicationDB db = new ApplicationDB();
                Connection conn = db.getConnection();
                BidData bidData = new BidData(conn);
                //check cur highest bid and ensure not duplicate submission
                double lastHighest = bidData.highestBid(toyId);
                if(bidAmt>lastHighest) {

                    //insert new bid and get its id
                    Bid lastHighestBid = bidData.highestBidObj(toyId);
                    int bidId = bidData.insertBid(bidAmt, request.getSession().getAttribute("user").toString(), toyId, isAutoBid);

                    if(lastHighestBid!=null && !lastHighestBid.isAutoBid()) {
                        //@TODO alert last highest manual bid that they were out bid
                        bidData.setBidStatus(lastHighestBid.getBidId(),"outbid");
                    }
                    //see which autobids are tracking this toylisting
                    AutomaticBidData autobidDAO = new AutomaticBidData(conn);
                    List<AutomaticBid> autoBids;

                    double prevHighestBid = -1;
                    double highestBid = bidAmt;

                    while (highestBid > prevHighestBid) { //an autobidder placed a new bid
                        prevHighestBid = highestBid;
                        //see which autobids are still tracking the toy listing
                        autoBids = autobidDAO.getActiveAutomaticBidsByToyId(toyId);
                        highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);
                        System.out.println("new highest bid: " + highestBid + "prev bid: " + prevHighestBid);
                    }

                    // Insert current user's bid into autobid table if it's an autobid
                    if (isAutoBid) {
                        autobidDAO.insertAutomaticBid(autoBidIncrement, maxBid, bidId, toyId);
                        //run check with just added autobid in case price was raised by other autobids in while loop above
                        if (highestBid > bidAmt) {
                            autoBids = autobidDAO.getActiveAutomaticBidsByToyId(toyId);
                            prevHighestBid = highestBid;
                            highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);
                            while (highestBid > prevHighestBid) {
                                prevHighestBid = highestBid;
                                autoBids = autobidDAO.getActiveAutomaticBidsByToyId(toyId);
                                highestBid = autobidDAO.checkAutoBids(autoBids, prevHighestBid, toyId);
                            }
                        }
                    }
                    conn.close();

                    response.sendRedirect("/myBids.jsp");
                }
                else{
                    response.sendRedirect("listingDetails.jsp?id=" + toyId);
                }
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
            }
        } catch (Exception e) {
            // Handle exceptions
            System.out.println("Error: " + e.getMessage());
        }
//        response.sendRedirect("/myBids.jsp");
    }
}
