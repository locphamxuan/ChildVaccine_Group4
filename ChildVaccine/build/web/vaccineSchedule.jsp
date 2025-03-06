<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Vaccination Schedule</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            /* Global styles */
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f2f5;
                color: #333;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }
            /* Hero Section */
            .hero-section {
                background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg?w=1380&t=st=1709825937~exp=1709826537~hmac=4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
                border-radius: 15px;
            }
            .hero-title {
                font-size: 3em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }
            .hero-subtitle {
                font-size: 1.2em;
                margin-bottom: 30px;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            }
            /* Table Styles */
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
            }
            table th, table td {
                padding: 12px;
                border: 1px solid #ddd;
                text-align: center;
            }
            table th {
                background-color: #0078D7;
                color: #fff;
            }
            .vaccine-name {
                text-align: left;
            }
            .vaccine-link {
                color: #0078D7;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease;
            }
            .vaccine-link:hover {
                text-decoration: underline;
            }
            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 999;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.4);
            }
            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 20px;
                border-radius: 8px;
                width: 50%;
                max-width: 600px;
                position: relative;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
                margin-top: -8px;
            }
            .close:hover {
                color: #000;
            }
            .modal-title {
                font-size: 1.4em;
                font-weight: 600;
                margin-bottom: 15px;
            }
            .modal-note {
                line-height: 1.5;
            }

            .back-button {
                display: inline-block;
                padding: 10px 20px;
                background-color: #1e88e5;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 20px;
                transition: background-color 0.3s ease;
            }
            .back-button:hover {
                background-color: #1565c0;
            }

        </style>
    </head>
    <body>
        <div class="container">
            <!-- Hero Section -->
            <div class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Vaccination Schedule</h1>
                    <p class="hero-subtitle">Lịch Tiêm Chủng Cho Trẻ</p>
                </div>
            </div>

            <a href="vaccinationSchedule.jsp" class="back-button">
                <i class="fas fa-arrow-left"></i> Back to Schedule
            </a>


            <c:if test="${not empty SCHEDULE_MONTHS and not empty SCHEDULE_MAP}">
                <table>
                    <thead>
                        <tr>
                            <th>Vaccine</th>
                                <c:forEach var="month" items="${SCHEDULE_MONTHS}">
                                <th>${month} tháng</th>
                                </c:forEach>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${SCHEDULE_MAP}">
                            <tr>
                                <td class="vaccine-name">
                                    <a href="javascript:void(0)"
                                       class="vaccine-link"
                                       data-name="${entry.key.vaccineName}"
                                       data-note="${VACCINE_NOTES[entry.key.vaccineID]}">
                                        <c:out value="${entry.key.vaccineName}" />
                                    </a>
                                </td>
                                <c:forEach var="month" items="${SCHEDULE_MONTHS}">
                                    <td>
                                        <c:set var="found" value="false" scope="page" />
                                        <c:forEach var="m" items="${entry.value}">
                                            <c:if test="${m == month}">
                                                <c:set var="found" value="true" scope="page" />
                                            </c:if>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${found}">
                                                X
                                            </c:when>
                                            <c:otherwise>
                                                &nbsp;
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty SCHEDULE_MONTHS or empty SCHEDULE_MAP}">
                <p style="text-align:center; color:red;">Không có dữ liệu để hiển thị.</p>
            </c:if>
        </div>

        <!-- Modal hiển thị ghi chú -->
        <div id="noteModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <div class="modal-title" id="modalVaccineName"></div>
                <div class="modal-note" id="modalNote"></div>
            </div>
        </div>

        <!-- JavaScript xử lý modal -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const modal = document.getElementById('noteModal');
                const closeBtn = modal.querySelector('.close');
                const modalVaccineName = document.getElementById('modalVaccineName');
                const modalNote = document.getElementById('modalNote');

                const vaccineLinks = document.querySelectorAll('.vaccine-link');
                vaccineLinks.forEach(link => {
                    link.addEventListener('click', event => {
                        event.preventDefault();
                        const vaccineName = link.dataset.name;
                        const note = link.dataset.note;
                        modalVaccineName.textContent = vaccineName;
                        modalNote.textContent = note;
                        modal.style.display = 'block';
                    });
                });
                closeBtn.addEventListener('click', () => {
                    modal.style.display = 'none';
                });
                window.addEventListener('click', event => {
                    if (event.target === modal) {
                        modal.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>
