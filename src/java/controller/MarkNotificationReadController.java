package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import utils.DBUtils;

public class MarkNotificationReadController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String notificationID = request.getParameter("notificationID");

        try {
            Connection conn = DBUtils.getConnection();
            String sql = "UPDATE tblNotifications SET isRead = 1 WHERE notificationID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, notificationID);
            ps.executeUpdate();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("vaccinationSchedule.jsp");
    }
}
