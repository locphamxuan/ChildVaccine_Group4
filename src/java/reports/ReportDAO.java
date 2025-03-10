package reports;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import reports.ReportDTO;
import utils.DBUtils;

public class ReportDAO {

    public static List<ReportDTO> getAllReports() throws Exception {
        List<ReportDTO> reports = new ArrayList<>();
        String sql = "SELECT * FROM tblReports";

        try (Connection con = DBUtils.getConnection();
                PreparedStatement stm = con.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                reports.add(new ReportDTO(
                        rs.getInt("reportID"),
                        rs.getInt("centerID"),
                        rs.getDate("reportDate"),
                        rs.getInt("totalAppointments"),
                        rs.getBigDecimal("totalRevenue")
                ));
            }
        }
        return reports;
    }

    public static List<ReportDTO> getReportsByCenter(int centerID, String reportDate) throws Exception {
        List<ReportDTO> reports = new ArrayList<>();
        String sql = "SELECT * FROM tblReports WHERE centerID = ?";

        if (reportDate != null && !reportDate.isEmpty()) {
            sql += " AND reportDate = ?";
        }

        try (Connection con = DBUtils.getConnection();
                PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, centerID);
            if (reportDate != null && !reportDate.isEmpty()) {
                stm.setString(2, reportDate);
            }

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                reports.add(new ReportDTO(
                        rs.getInt("reportID"),
                        rs.getInt("centerID"),
                        rs.getDate("reportDate"),
                        rs.getInt("totalAppointments"),
                        rs.getBigDecimal("totalRevenue")
                ));
            }
        }
        return reports;
    }
    
    

    public static void updateReportAfterPayment(int centerID, BigDecimal amount) throws Exception {
        String sql = "UPDATE tblReports " +
                    "SET totalAppointments = totalAppointments + 1, " +
                    "totalRevenue = totalRevenue + ? " +
                    "WHERE centerID = ? AND reportDate = CAST(GETDATE() AS DATE)";

        String insertSql = "INSERT INTO tblReports (centerID, reportDate, totalAppointments, totalRevenue) " +
                          "VALUES (?, CAST(GETDATE() AS DATE), 1, ?)";

        try (Connection con = DBUtils.getConnection()) {
            // First try to update existing report
            PreparedStatement updateStm = con.prepareStatement(sql);
            updateStm.setBigDecimal(1, amount);
            updateStm.setInt(2, centerID);
            
            int rowsAffected = updateStm.executeUpdate();

            // If no existing report found, create new one
            if (rowsAffected == 0) {
                PreparedStatement insertStm = con.prepareStatement(insertSql);
                insertStm.setInt(1, centerID);
                insertStm.setBigDecimal(2, amount);
                insertStm.executeUpdate();
            }
        }
    }
    
    
  
}
