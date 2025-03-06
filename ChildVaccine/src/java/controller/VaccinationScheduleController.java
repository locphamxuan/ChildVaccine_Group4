package controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import vaccine.VaccineDAO;
import vaccine.VaccineDTO;


@WebServlet(name = "VaccinationScheduleController", urlPatterns = {"/VaccinationScheduleController"})
public class VaccinationScheduleController extends HttpServlet {

    // Danh sách các mốc tháng/tuổi hiển thị trên bảng
    private static final List<Integer> SCHEDULE_MONTHS = Arrays.asList(
        2, 3, 4, 6, 9, 12, 15, 18, 24, 36
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy danh sách vaccine từ DB (không bao gồm ghi chú)
            VaccineDAO dao = new VaccineDAO();
            List<VaccineDTO> vaccineList = dao.getAllVaccines();
            
            // 2. Tạo Map: VaccineDTO -> Set<Integer> dựa trên recommendedAge
            Map<VaccineDTO, Set<Integer>> scheduleMap = new HashMap<>();
            for (VaccineDTO vaccine : vaccineList) {
                String recommendedAge = vaccine.getRecommendedAge();
                Set<Integer> recommendedMonths = parseRecommendedAge(recommendedAge);
                scheduleMap.put(vaccine, recommendedMonths);
            }
            
            // 3. Lấy Map ghi chú từ bảng tblChildVaccineNotes (key: vaccineID, value: note)
            Map<Integer, String> vaccineNotes = dao.getVaccineNotes();
            
            // 4. Đặt các dữ liệu cần thiết lên request
            request.setAttribute("SCHEDULE_MONTHS", SCHEDULE_MONTHS);
            request.setAttribute("SCHEDULE_MAP", scheduleMap);
            request.setAttribute("VACCINE_NOTES", vaccineNotes);
            
            // Nếu cần, tạo thêm attribute theo vaccineID
            Map<Integer, Set<Integer>> scheduleVaccineMap = new HashMap<>();
            for (VaccineDTO vaccine : vaccineList) {
                String recommendedAge = vaccine.getRecommendedAge();
                Set<Integer> recommendedMonths = parseRecommendedAge(recommendedAge);
                scheduleVaccineMap.put(vaccine.getVaccineID(), recommendedMonths);
            }
            request.setAttribute("SCHEDULE_VACCINE_MAP", scheduleVaccineMap);
            
            // 5. Forward sang trang JSP hiển thị
            request.getRequestDispatcher("vaccineSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error at VaccinationScheduleController: " + e.toString());
            e.printStackTrace();
            request.setAttribute("ERROR", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Phương thức parseRecommendedAge(String)
     * Tìm các số trong chuỗi recommendedAge rồi xác định đó là "tháng" hay "tuổi".
     * Ví dụ: "2 thang tuoi" -> thêm 2, "1 tuoi" -> thêm 12.
     */
    private Set<Integer> parseRecommendedAge(String recommendedAge) {
        Set<Integer> months = new HashSet<>();
        if (recommendedAge == null) {
            return months;
        }
        String[] tokens = recommendedAge.split("\\s+");
        for (int i = 0; i < tokens.length; i++) {
            try {
                int number = Integer.parseInt(tokens[i]);
                if (i + 1 < tokens.length) {
                    String next = tokens[i + 1].toLowerCase();
                    if (next.contains("thang")) {
                        months.add(number);
                    } else if (next.contains("tuoi")) {
                        months.add(number * 12);
                    }
                }
            } catch (NumberFormatException e) {
                // Bỏ qua token không phải số
            }
        }
        return months;
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
