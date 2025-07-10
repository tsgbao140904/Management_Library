<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Member" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa thông tin thành viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Sửa thông tin thành viên</h2>
    <% Member member = (Member) request.getAttribute("member"); %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="${pageContext.request.contextPath}/admin/members" method="post" class="w-50 mx-auto position-relative">
        <input type="hidden" name="id" value="<%= member.getId() %>">
        <div class="mb-3">
            <label for="username" class="form-label">Tên đăng nhập</label>
            <input type="text" class="form-control" id="username" name="username" value="<%= member.getUsername() %>" required>
        </div>
        <div class="mb-3 position-relative">
            <label for="password" class="form-label">Mật khẩu</label>
            <input type="password" class="form-control" id="password" name="password" value="<%= member.getPassword() %>" required>
            <span class="password-toggle" onclick="togglePassword()">
                <i class="bi bi-eye" id="toggleIcon"></i>
            </span>
        </div>
        <div class="mb-3">
            <label for="fullName" class="form-label">Họ và tên</label>
            <input type="text" class="form-control" id="fullName" name="fullName" value="<%= member.getFullName() %>" required>
        </div>
        <div class="mb-3">
            <label for="role" class="form-label">Vai trò</label>
            <select class="form-control" id="role" name="role" required>
                <option value="ADMIN" <%= member.getRole().equals("ADMIN") ? "selected" : "" %>>ADMIN</option>
                <option value="MEMBER" <%= member.getRole().equals("MEMBER") ? "selected" : "" %>>MEMBER</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
        <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-secondary w-100 mt-2">Quay lại</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('toggleIcon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('bi-eye');
        toggleIcon.classList.add('bi-eye-slash');
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('bi-eye-slash');
        toggleIcon.classList.add('bi-eye');
    }
}
</script>
</body>
</html>