package appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;
import static utils.DBUtils.getConnection;

public class AppointmentDAO {

    // Lấy tất cả cuộc hẹn
    public List<AppointmentDTO> getAllAppointments() throws Exception {
        List<AppointmentDTO> appointments = new ArrayList<>();
        String sql = "SELECT * FROM tblAppointments";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AppointmentDTO appointment = new AppointmentDTO(
                        rs.getInt("appointmentID"),
                        rs.getInt("childID"),
                        rs.getInt("centerID"),
                        rs.getDate("appointmentDate"),
                        rs.getString("serviceType"),
                        rs.getString("notificationStatus"),
                        rs.getString("status")
                );
                appointments.add(appointment);
            }
        }
        return appointments;
    }

    // Thêm cuộc hẹn mới
    public boolean addAppointment(AppointmentDTO appointment) {
        String sql = "INSERT INTO tblAppointments (childID, centerID, appointmentDate, serviceType, notificationStatus, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointment.getChildID());
            ps.setInt(2, appointment.getCenterID());
            ps.setDate(3, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            ps.setString(4, appointment.getServiceType());
            ps.setString(5, appointment.getNotificationStatus());
            ps.setString(6, appointment.getStatus());

            int rowsInserted = ps.executeUpdate();
            System.out.println("Rows inserted: " + rowsInserted); // Kiểm tra xem có bao nhiêu dòng được thêm
            return rowsInserted > 0;

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi chi tiết
        }
        return false;
    }

    // Cập nhật trạng thái thông báo
    public boolean updateNotificationStatus(int appointmentID, String status) throws Exception {
        String sql = "UPDATE tblAppointments SET notificationStatus = ? WHERE appointmentID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appointmentID);

            return ps.executeUpdate() > 0;
        }
    }

    // Tìm cuộc hẹn theo ID
    public AppointmentDTO findAppointmentById(int appointmentID) throws Exception {
        String sql = "SELECT * FROM tblAppointments WHERE appointmentID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AppointmentDTO(
                            rs.getInt("appointmentID"),
                            rs.getInt("childID"),
                            rs.getInt("centerID"),
                            rs.getDate("appointmentDate"),
                            rs.getString("serviceType"),
                            rs.getString("notificationStatus"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    public List<AppointmentDTO> getAppointmentHistory(int childID) throws Exception {
        List<AppointmentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblAppointments WHERE childID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, childID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AppointmentDTO(
                            rs.getInt("appointmentID"),
                            rs.getInt("childID"),
                            rs.getInt("centerID"),
                            rs.getDate("appointmentDate"),
                            rs.getString("serviceType"),
                            rs.getString("notificationStatus"),
                            rs.getString("status")
                    ));
                }
            }
        }
        return list;
    }

    public List<AppointmentDTO> getAppointmentsByChildID(int childID) throws Exception {
        List<AppointmentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblAppointments WHERE childID = ? ORDER BY appointmentDate DESC";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, childID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AppointmentDTO(
                            rs.getInt("appointmentID"),
                            rs.getInt("childID"),
                            rs.getInt("centerID"),
                            rs.getDate("appointmentDate"),
                            rs.getString("serviceType"),
                            rs.getString("notificationStatus"),
                            rs.getString("status")
                    ));
                }
            }
        }
        return list;
    }

    public boolean deleteAppointment(int appointmentID) throws Exception {
    String sql = "DELETE FROM tblAppointments WHERE appointmentID = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, appointmentID);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    }
}

   
    public List<AppointmentDTO> getAppointmentsByUserID(String userID) throws Exception {
    List<AppointmentDTO> list = new ArrayList<>();
    String sql = "SELECT a.appointmentID, a.childID, a.centerID, a.appointmentDate, " +
                 "a.serviceType, a.notificationStatus, a.status, " +
                 "c.childName, c.dateOfBirth, c.gender " +
                 "FROM tblAppointments a JOIN tblChildren c ON a.childID = c.childID " +
                 "WHERE c.userID = ? ORDER BY a.appointmentDate DESC";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, userID);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AppointmentDTO appointment = new AppointmentDTO();
                appointment.setAppointmentID(rs.getInt("appointmentID"));
                appointment.setChildID(rs.getInt("childID"));
                appointment.setCenterID(rs.getInt("centerID"));
                appointment.setAppointmentDate(rs.getDate("appointmentDate"));
                appointment.setServiceType(rs.getString("serviceType"));
                appointment.setNotificationStatus(rs.getString("notificationStatus"));
                appointment.setStatus(rs.getString("status"));
                // Các thông tin của trẻ
                appointment.setChildName(rs.getString("childName"));
                appointment.setDateOfBirth(rs.getDate("dateOfBirth"));
                appointment.setGender(rs.getString("gender"));
                list.add(appointment);
            }
        }
    }
    return list;
}

    /*
    public List<AppointmentDTO> getAppointmentsByUserID(String userID) throws Exception {
    List<AppointmentDTO> list = new ArrayList<>();
    String sql = "SELECT a.appointmentID, a.childID, a.centerID, a.appointmentDate, " +
                 "a.serviceType, a.notificationStatus, a.status, " +
                 "c.ChildName as childName, c.dateOfBirth as dateOfBirth, c.gender as gender " +
                 "FROM tblAppointments a " +
                 "JOIN tblChildren c ON a.childID = c.childID " +
                 "WHERE c.userID = ? ORDER BY a.appointmentDate DESC";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, userID);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AppointmentDTO appointment = new AppointmentDTO();
                appointment.setAppointmentID(rs.getInt("appointmentID"));
                appointment.setChildID(rs.getInt("childID"));
                appointment.setCenterID(rs.getInt("centerID"));
                appointment.setAppointmentDate(rs.getDate("appointmentDate"));
                appointment.setServiceType(rs.getString("serviceType"));
                appointment.setNotificationStatus(rs.getString("notificationStatus"));
                appointment.setStatus(rs.getString("status"));
                appointment.setChildName(rs.getString("childName")); // Lấy thông tin từ alias
                appointment.setDateOfBirth(rs.getDate("dateOfBirth"));
                appointment.setGender(rs.getString("gender"));
                list.add(appointment);
            }
        }
    }
    return list;
}
*/
    
public boolean deleteAppointmentsByChildID(int childID) throws Exception {
    String sql = "DELETE FROM tblAppointments WHERE childID = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, childID);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected >= 0;  // Hoặc kiểm tra cụ thể tùy vào logic của bạn
    }
}

public boolean updateAppointmentStatus(int appointmentID, String status) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE tblAppointments SET status = ? WHERE appointmentID = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, appointmentID);
        return ps.executeUpdate() > 0;
    }
}


}
