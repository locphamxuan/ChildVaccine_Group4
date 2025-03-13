<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="child.ChildDTO" %>
<%@page import="child.ChildDAO" %>
<%@page import="customer.CustomerDTO" %>
<%@page import="java.util.List" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hồ Sơ Trẻ Em</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            body {
                background-color: #f0f2f5;
                color: #333;
                line-height: 1.6;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }
            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg?w=1380');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;
                margin-bottom: 40px;
                border-radius: 15px;
            }
            .hero-title {
                font-size: 2.5em;
                margin-bottom: 20px;
            }
            .children-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 30px;
            }
            .child-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }
            .child-card:hover {
                transform: translateY(-5px);
            }
            .child-avatar {
                width: 80px;
                height: 80px;
                background: #1e88e5;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
            }
            .child-avatar i {
                font-size: 40px;
                color: white;
            }
            .child-info {
                text-align: center;
            }
            .child-name {
                font-size: 1.5em;
                color: #1e88e5;
                margin-bottom: 15px;
                font-weight: 600;
            }
            .info-item {
                display: flex;
                align-items: center;
                margin: 10px 0;
                padding: 10px;
                background: #f8f9fa;
                border-radius: 8px;
            }
            .info-item i {
                margin-right: 10px;
                color: #1e88e5;
                width: 20px;
            }
            .add-child-button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 15px 30px;
                background: #4CAF50;
                color: white;
                border: none;
                border-radius: 25px;
                font-size: 1.1em;
                text-decoration: none;
                margin-top: 20px;
                transition: all 0.3s ease;
            }
            .add-child-button:hover {
                background: #45a049;
                transform: translateY(-2px);
            }
            .btn-edit,
            .btn-delete {
                margin-top: 10px;
                padding: 10px 20px;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.3s ease;
            }
            .btn-edit {
                background: #1e88e5;
            }
            .btn-edit:hover {
                background: #1565c0;
            }
            .btn-delete {
                background: #f44336;
            }
            .btn-delete:hover {
                background: #d32f2f;
            }
            .btn-back {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 12px 20px;
                background: #1e88e5;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 1em;
                cursor: pointer;
                transition: background 0.3s ease;
                text-decoration: none;
                margin-top: 20px;
            }
            .btn-back:hover {
                background: #1565c0;
            }
            .btn-vaccination-record {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 12px 20px;
                background: #1e88e5;
                color: white;
                border-radius: 5px;
                text-decoration: none;
                font-size: 1em;
                margin-top: 20px;
                transition: background 0.3s ease;
            }
            .btn-vaccination-record:hover {
                background: #1565c0;
            }
            /* Các style cho modal (Edit, Confirm) */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.4);
                padding-top: 60px;
            }
            .modal-content {
                background-color: #fefefe;
                margin: 5% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
                max-width: 500px;
                border-radius: 10px;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }
            .close:hover,
            .close:focus {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
            }
            .form-group input,
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            .btn-save {
                padding: 10px 20px;
                background: #4CAF50;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.3s ease;
            }
            .btn-save:hover {
                background: #45a049;
            }
            .confirm-modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.4);
                padding-top: 60px;
            }
            .confirm-modal-content {
                background-color: #fefefe;
                margin: 5% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
                max-width: 400px;
                border-radius: 10px;
                text-align: center;
            }
            .confirm-buttons {
                display: flex;
                justify-content: space-around;
                margin-top: 20px;
            }
            .confirm-buttons button {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.3s ease;
            }
            .btn-yes {
                background: #4CAF50;
                color: white;
            }
            .btn-yes:hover {
                background: #45a049;
            }
            .btn-no {
                background: #f44336;
                color: white;
            }
            .btn-no:hover {
                background: #d32f2f;
            }
            /* Style cho thông báo lỗi */
            .error-message {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
                display: block;
                transition: all 0.3s ease;
            }

            .form-control.error {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
            }

            .form-control.error:focus {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
            }

            /* Animation cho thông báo lỗi */
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                20%, 40%, 60%, 80% { transform: translateX(5px); }
            }

            .error-shake {
                animation: shake 0.8s ease;
            }
        </style>
    </head>
    <body>
        <%
            // Kiểm tra đăng nhập
            CustomerDTO loginUser = (CustomerDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            ChildDAO childDAO = new ChildDAO();
            List<ChildDTO> children = null;
            try {
                String userID = loginUser.getUserID();
                children = childDAO.getAllChildrenByUserID(userID);
            } catch(Exception e) {
                e.printStackTrace();
            }
        %>
        <div class="container">
            <div class="hero-section">
                <h1 class="hero-title">Hồ Sơ Trẻ Em</h1>
                <p>Quản lý thông tin trẻ em của bạn</p>
            </div>
            <div class="children-grid">
                <% if(children != null && !children.isEmpty()){
                        for(ChildDTO child : children){ %>
                    <div class="child-card">
                        <div class="child-avatar">
                            <i class="fas fa-child"></i>
                        </div>
                        <div class="child-info">
                            <div class="child-name">
                                <%= child.getChildName() %>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-birthday-cake"></i>
                                <span>Date of birth: <%= child.getDateOfBirth() %></span>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-venus-mars"></i>
                                <span>Gender: <%= child.getGender() %></span>
                            </div>
                            <button onclick="openEditModal(<%= child.getChildID() %>, '<%= child.getChildName() %>', '<%= child.getDateOfBirth() %>', '<%= child.getGender() %>')" class="btn-edit">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button onclick="openConfirmModal(<%= child.getChildID() %>)" class="btn-delete">
                                <i class="fas fa-trash-alt"></i> Delete
                            </button>
                            <!-- Thêm đường link xem Sổ Tiêm Chủng cho từng trẻ -->
                            <a href="vaccinationRecord.jsp?childID=<%= child.getChildID() %>" class="btn-vaccination-record">
                                <i class="fas fa-notes-medical"></i> Sổ Tiêm Chủng
                            </a>
                        </div>
                    </div>
                <% }
                   } else { %>
                    <div style="text-align: center; grid-column: 1 / -1;">
                        <div class="child-card">
                            <i class="fas fa-child" style="font-size: 48px; color: #ccc; margin-bottom: 20px;"></i>
                            <p>Chưa có thông tin trẻ em</p>
                            <a href="childRegistration.jsp" class="add-child-button">
                                <i class="fas fa-plus"></i>
                                Thêm thông tin trẻ em
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
            <a href="vaccinationSchedule.jsp" class="btn-back">
                <i class="fas fa-arrow-left"></i>
                Back Vaccine Schedule
            </a>
            
        </div>
        
        <!-- Modal Edit -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Edit Children Profile</h2>
                <form id="editForm" action="EditChildController" method="POST">
                    <input type="hidden" id="editChildID" name="childID">
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" id="editFullName" name="fullName" required>
                    </div>
                    <div class="form-group">
                        <label>Date of birth</label>
                        <input type="date" id="editDateOfBirth" name="dateOfBirth" required
                               max="<%= java.time.LocalDate.now() %>"
                               onchange="validateDate(this)">
                        <span id="editDateError" class="error-message"></span>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <select id="editGender" name="gender" required>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-save">Lưu thay đổi</button>
                </form>
            </div>
        </div>
        
        <!-- Modal Confirm Delete -->
        <div id="confirmModal" class="confirm-modal">
            <div class="confirm-modal-content">
                <h2>Bạn có chắc chắn muốn xóa thông tin trẻ em này?</h2>
                <div class="confirm-buttons">
                    <button id="btnYes" class="btn-yes">Có</button>
                    <button id="btnNo" class="btn-no">Không</button>
                </div>
            </div>
        </div>
        
        <script>
            function validateDate(input) {
                const selectedDate = new Date(input.value);
                const today = new Date();
                const errorElement = document.getElementById('editDateError');
                
                if (selectedDate > today) {
                    input.classList.add('error');
                    errorElement.textContent = "Ngày sinh không tồn tại!";
                    errorElement.classList.add('error-shake');
                    input.value = '';
                    
                    // Xóa class error-shake sau khi animation kết thúc
                    setTimeout(() => {
                        errorElement.classList.remove('error-shake');
                    }, 800);
                } else {
                    input.classList.remove('error');
                    errorElement.textContent = "";
                }
            }

            function openEditModal(childID, fullName, dateOfBirth, gender) {
                document.getElementById('editChildID').value = childID;
                document.getElementById('editFullName').value = fullName;
                document.getElementById('editDateOfBirth').value = dateOfBirth;
                document.getElementById('editGender').value = gender;
                document.getElementById('editModal').style.display = 'block';
            }
            document.querySelector('.close').onclick = function () {
                document.getElementById('editModal').style.display = 'none';
            }
            window.onclick = function (event) {
                if (event.target == document.getElementById('editModal')) {
                    document.getElementById('editModal').style.display = 'none';
                }
                if (event.target == document.getElementById('confirmModal')) {
                    document.getElementById('confirmModal').style.display = 'none';
                }
            }
            function openConfirmModal(childID) {
                document.getElementById('confirmModal').style.display = 'block';
                document.getElementById('btnYes').onclick = function () {
                    window.location.href = 'DeleteChildController?childID=' + childID;
                }
                document.getElementById('btnNo').onclick = function () {
                    document.getElementById('confirmModal').style.display = 'none';
                }
            }
        </script>
    </body>
</html>
