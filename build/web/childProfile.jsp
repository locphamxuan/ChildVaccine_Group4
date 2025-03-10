<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="child.ChildDTO" %>
<%@page import="child.ChildDAO" %>
<%@page import="customer.CustomerDTO" %>
<%@page import="java.util.List" %>
<%@page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet"%>
<%@page import="utils.DBUtils"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Hồ Sơ Trẻ Em</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Global reset & font */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
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

        /* Navbar (top) */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #1e88e5;
            color: #fff;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .navbar .welcome-message {
            display: flex;
            align-items: center;
            font-size: 1.1em;
            font-weight: 500;
        }
        .navbar .welcome-message i {
            margin-right: 10px;
            font-size: 1.4em;
        }
        .nav-right {
            display: flex;
            align-items: center;
        }

        /* Logout Button */
        .logout-button {
            padding: 10px 20px;
            background: #f44336;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1em;
            transition: 0.3s ease;
            margin-left: 15px;
        }
        .logout-button:hover {
            background: #d32f2f;
        }

        /* Notification icon */
        .notification-icon {
            position: relative;
            font-size: 1.4em;
            cursor: pointer;
            margin-right: 10px;
            transition: color 0.3s ease;
        }
        .notification-icon:hover {
            color: #f5f5f5;
        }
        .notification-badge {
            position: absolute;
            top: -6px;
            right: -10px;
            background: red;
            color: #fff;
            font-size: 0.8em;
            padding: 3px 6px;
            border-radius: 50%;
            font-weight: bold;
        }

        /* Notification dropdown */
        .notification-dropdown {
            display: none;
            position: absolute;
            top: 60px;
            right: 20px;
            background: #fff;
            width: 320px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px;
            z-index: 999;
        }
        .notification-dropdown h4 {
            margin: 0 0 10px;
            padding-bottom: 5px;
            font-size: 1.1em;
            border-bottom: 1px solid #ddd;
        }
        .notification-dropdown ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .notification-dropdown li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding: 10px 0;
            transition: background 0.2s ease;
        }
        .notification-dropdown li:last-child {
            border-bottom: none;
        }
        .notification-dropdown li.unread {
            font-weight: 600;
            background: #fafafa;
        }
        .notification-content .message {
            margin: 0;
            font-size: 0.95em;
            color: #333;
        }
        .notification-content .timestamp {
            font-size: 0.85em;
            color: #777;
            margin-top: 4px;
        }
        .mark-read-button {
            background: none;
            border: none;
            color: green;
            cursor: pointer;
            font-size: 1.2em;
            transition: 0.3s;
        }
        .mark-read-button:hover {
            color: #388e3c;
        }
        .no-notifications {
            text-align: center;
            color: #999;
            font-size: 0.95em;
        }

        /* Hero section */
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), 
                        url('https://img.freepik.com/free-photo/doctor-vaccinating-patient-clinic_23-2148880385.jpg?w=1380');
            background-size: cover;
            background-position: center;
            padding: 80px 0;
            text-align: center;
            color: white;
            border-radius: 10px;
            margin-bottom: 40px;
        }
        .hero-title {
            font-size: 2.5em;
            margin-bottom: 15px;
            font-weight: 600;
        }

        /* Children grid */
        .children-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px,1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .child-card {
            background: #fff;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .child-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 12px rgba(0,0,0,0.15);
        }
        .child-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #1e88e5;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .child-avatar i {
            color: white;
            font-size: 40px;
        }
        .child-info {
            text-align: center;
        }
        .child-name {
            font-size: 1.3em;
            color: #1e88e5;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .info-item {
            display: flex;
            align-items: center;
            margin: 8px 0;
            font-size: 0.95em;
            color: #333;
            background: #f9f9f9;
            padding: 8px;
            border-radius: 5px;
        }
        .info-item i {
            color: #1e88e5;
            margin-right: 8px;
        }

        /* Buttons inside card */
        .btn-edit, .btn-delete {
            margin-top: 10px;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            margin-right: 5px;
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
        .btn-vaccination-record {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 18px;
            background: #1e88e5;
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.95em;
            transition: background 0.3s ease;
            margin-top: 10px;
        }
        .btn-vaccination-record:hover {
            background: #1565c0;
        }

        /* Add child button */
        .add-child-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 25px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 1em;
            text-decoration: none;
            margin-top: 20px;
            transition: all 0.3s ease;
        }
        .add-child-button:hover {
            background: #45a049;
            transform: translateY(-2px);
        }

        /* Back button */
        .btn-back {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            background: #1e88e5;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            text-decoration: none;
            transition: background 0.3s ease;
            margin-top: 30px;
        }
        .btn-back:hover {
            background: #1565c0;
        }

        /* Modal (edit, confirm) */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background: #fff;
            margin: 5% auto;
            padding: 20px;
            max-width: 500px;
            border-radius: 8px;
            position: relative;
        }
        .modal-content h2 {
            margin-bottom: 15px;
            font-size: 1.3em;
            color: #333;
        }
        .close {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
        }
        .close:hover {
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            margin-bottom: 5px;
            display: block;
            font-weight: 500;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ccc;
            border-radius: 5px;
            font-size: 0.95em;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #1e88e5;
            outline: none;
        }
        .btn-save {
            background: #4CAF50;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .btn-save:hover {
            background: #45a049;
        }

        /* Confirm modal */
        .confirm-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
        }
        .confirm-modal-content {
            background: #fff;
            margin: 10% auto;
            padding: 20px;
            max-width: 400px;
            border-radius: 8px;
            text-align: center;
            position: relative;
        }
        .confirm-modal-content h2 {
            margin-bottom: 20px;
            font-size: 1.2em;
        }
        .confirm-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .confirm-buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            transition: background 0.3s ease;
            cursor: pointer;
        }
        .btn-yes {
            background: #4CAF50;
            color: #fff;
        }
        .btn-yes:hover {
            background: #45a049;
        }
        .btn-no {
            background: #f44336;
            color: #fff;
        }
        .btn-no:hover {
            background: #d32f2f;
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

    // Lấy danh sách Child
    ChildDAO childDAO = new ChildDAO();
    List<ChildDTO> children = null;
    try {
        String userID = loginUser.getUserID();
        children = childDAO.getAllChildrenByUserID(userID);
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Lấy thông báo & số thông báo chưa đọc
    int unreadCount = 0;
    List<String[]> notifications = new ArrayList<>();
    if (loginUser != null) {
        String userID = loginUser.getUserID();
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "SELECT notificationID, notificationText, isRead, notificationDate "
                       + "FROM tblNotifications "
                       + "WHERE userID = ? "
                       + "ORDER BY notificationDate DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String[] notification = new String[4];
                notification[0] = rs.getString("notificationID");
                notification[1] = rs.getString("notificationText");
                notification[2] = rs.getString("isRead");
                notification[3] = rs.getString("notificationDate");

                if (rs.getInt("isRead") == 0) {
                    unreadCount++;
                }
                notifications.add(notification);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!-- Navbar -->
<div class="navbar">
    <div class="welcome-message">
        <i class="fas fa-user-shield"></i>
        Welcome, <%= loginUser.getFullName() %>
    </div>
    <div class="nav-right">
        <!-- Thông báo -->
        <div class="notification-icon" onclick="toggleNotificationDropdown()">
            <i class="fas fa-bell"></i>
            <% if (unreadCount > 0) { %>
                <span class="notification-badge"><%= unreadCount %></span>
            <% } %>
        </div>
        <!-- Form logout -->
        <form action="MainController" method="POST">
            <button type="submit" name="action" value="Logout" class="logout-button">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</div>

<!-- Dropdown cho thông báo -->
<div id="notificationDropdown" class="notification-dropdown">
    <h4>Thông báo</h4>
    <% if (notifications.isEmpty()) { %>
        <p class="no-notifications">Không có thông báo</p>
    <% } else { %>
    <ul>
        <% for (String[] notification : notifications) { %>
        <li class="<%= notification[2].equals("0") ? "unread" : "" %>"
            id="notification-<%= notification[0] %>">
            <div class="notification-content">
                <p class="message"><%= notification[1] %></p>
                <p class="timestamp"><i class="far fa-clock"></i> <%= notification[3] %></p>
            </div>
            <% if (notification[2].equals("0")) { %>
                <button class="mark-read-button" onclick="markAsRead('<%= notification[0] %>')">✔</button>
            <% } %>
        </li>
        <% } %>
    </ul>
    <% } %>
</div>

<!-- Phần hero-section (tuỳ ý có thể bỏ đi nếu không muốn) -->
<div class="hero-section">
    <h1 class="hero-title">Hồ Sơ Trẻ Em</h1>
    <p>Quản lý thông tin trẻ em của bạn</p>
</div>

<div class="container">
    <div class="children-grid">
        <% if (children != null && !children.isEmpty()) {
               for (ChildDTO child : children) { %>

        <div class="child-card">
            <div class="child-avatar">
                <i class="fas fa-child"></i>
            </div>
            <div class="child-info">
                <div class="child-name"><%= child.getChildName() %></div>
                <div class="info-item">
                    <i class="fas fa-birthday-cake"></i>
                    <span>Date of birth: <%= child.getDateOfBirth() %></span>
                </div>
                <div class="info-item">
                    <i class="fas fa-venus-mars"></i>
                    <span>Gender: <%= child.getGender() %></span>
                </div>
                <button onclick="openEditModal(<%= child.getChildID() %>, 
                                    '<%= child.getChildName() %>', 
                                    '<%= child.getDateOfBirth() %>',
                                    '<%= child.getGender() %>')"
                        class="btn-edit">
                    <i class="fas fa-edit"></i> Edit
                </button>
                <button onclick="openConfirmModal(<%= child.getChildID() %>)" class="btn-delete">
                    <i class="fas fa-trash-alt"></i> Delete
                </button>
                <!-- Link xem Sổ Tiêm Chủng -->
                <a href="vaccinationRecord.jsp?childID=<%= child.getChildID() %>" class="btn-vaccination-record">
                    <i class="fas fa-notes-medical"></i> Sổ Tiêm Chủng
                </a>
            </div>
        </div>

        <% } } else { %>
        <div style="text-align: center; grid-column: 1 / -1;">
            <div class="child-card">
                <i class="fas fa-child" style="font-size: 48px; color: #ccc; margin-bottom: 20px;"></i>
                <p>Chưa có thông tin trẻ em</p>
                <a href="childRegistration.jsp" class="add-child-button">
                    <i class="fas fa-plus"></i> Thêm thông tin trẻ em
                </a>
            </div>
        </div>
        <% } %>
    </div>

    <a href="vaccinationSchedule.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back Vaccine Schedule
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
                <input type="date" id="editDateOfBirth" name="dateOfBirth" required>
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
    // Mở form edit
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

    // Xác nhận xoá
    function openConfirmModal(childID) {
        document.getElementById('confirmModal').style.display = 'block';
        document.getElementById('btnYes').onclick = function () {
            window.location.href = 'DeleteChildController?childID=' + childID;
        }
        document.getElementById('btnNo').onclick = function () {
            document.getElementById('confirmModal').style.display = 'none';
        }
    }

    // Toggle dropdown
    function toggleNotificationDropdown() {
        var dropdown = document.getElementById("notificationDropdown");
        dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
    }

    // Click ngoài thì ẩn
    window.onclick = function(event) {
        if (!event.target.matches('.notification-icon, .notification-icon *')) {
            var dropdown = document.getElementById("notificationDropdown");
            if (dropdown && dropdown.style.display === "block") {
                dropdown.style.display = "none";
            }
        }
    }

    // Đánh dấu đã đọc
    function markAsRead(notificationID) {
        fetch('MarkNotificationReadController', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'notificationID=' + notificationID
        })
        .then(response => {
            if (response.ok) {
                // Xoá class unread
                let notifElem = document.getElementById('notification-' + notificationID);
                notifElem.classList.remove('unread');

                // Xoá nút "✔"
                let markBtn = notifElem.querySelector('.mark-read-button');
                if (markBtn) {
                    markBtn.remove();
                }

                // Cập nhật badge
                let badge = document.querySelector('.notification-badge');
                if (badge) {
                    let count = parseInt(badge.textContent);
                    if (count > 1) {
                        badge.textContent = count - 1;
                    } else {
                        badge.remove();
                    }
                }
            }
        })
        .catch(error => console.log('Error marking notification as read:', error));
    }
</script>

</body>
</html>
