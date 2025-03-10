/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;
import doctor.DoctorDTO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vaccine.VaccinationDAO;

/**
 *
 * @author Admin
 */

//DANH SACH LỊCH CUA BAC SI
@WebServlet(name = "UpdateVaccinationStatusController", urlPatterns = {"/UpdateVaccinationStatusController"})
public class UpdateVaccinationStatusController extends HttpServlet {
    private static final String ERROR = "doctor.jsp";
    private static final String SUCCESS = "doctor.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = ERROR;
        try {
            String scheduleID = request.getParameter("scheduleID");
            String status = request.getParameter("status");
            
            // Nếu cần kiểm tra thông tin bác sĩ đăng nhập, có thể giữ phần này
            HttpSession session = request.getSession();
            // Giả sử không dùng doctorID nữa
            if (session.getAttribute("DOCTOR_LOGIN") != null) {
                VaccinationDAO dao = new VaccinationDAO();
                boolean check = dao.updateScheduleStatus(scheduleID, status);
                
                if (check) {
                    url = SUCCESS;
                    request.setAttribute("SUCCESS", "Cập nhật trạng thái thành công!");
                } else {
                    request.setAttribute("ERROR", "Cập nhật trạng thái thất bại!");
                }
            }
        } catch (Exception e) {
            log("Error at UpdateVaccinationStatusController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
