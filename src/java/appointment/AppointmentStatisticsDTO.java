package appointment;

import java.math.BigDecimal;
import java.util.Date;

public class AppointmentStatisticsDTO {
    private Date appointmentDate;
    private int injectionCount;
    private BigDecimal revenue;

    public AppointmentStatisticsDTO(Date appointmentDate, int injectionCount, BigDecimal revenue) {
        this.appointmentDate = appointmentDate;
        this.injectionCount = injectionCount;
        this.revenue = revenue;
    }

    // Getters và Setters
    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public int getInjectionCount() {
        return injectionCount;
    }

    public void setInjectionCount(int injectionCount) {
        this.injectionCount = injectionCount;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }
}