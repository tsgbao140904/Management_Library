<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Member, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý thành viên</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Thư viện</a>
        <div class="navbar-nav">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/books">Sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/members">Thành viên</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/loans">Mượn sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/inventory">Kho sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Báo cáo</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
    </div>
</nav>
<div class="container mt-5">
    <h2>Quản lý thành viên</h2>
    <form action="${pageContext.request.contextPath}/admin/members" method="get" class="d-flex align-items-center gap-2 mb-4">
        <input type="text" class="form-control" name="id" placeholder="ID" style="width: 80px;">
        <input type="text" class="form-control" name="username" placeholder="Tên đăng nhập" style="width: 180px;">
        <input type="text" class="form-control" name="fullName" placeholder="Họ và tên" style="width: 200px;">

        <select class="form-control" name="role" style="width: 150px;">
            <option value="">-- Vai trò --</option>
            <option value="ADMIN">ADMIN</option>
            <option value="MEMBER">MEMBER</option>
        </select>

        <button type="submit" class="btn btn-success">Tìm kiếm</button>
    </form>

    <form action="${pageContext.request.contextPath}/admin/members" method="post" class="mb-4">
        <div class="row">
            <div class="col">
                <input type="text" class="form-control" name="name" placeholder="Họ và tên" required>
            </div>
            <div class="col">
                <input type="text" class="form-control" name="username" placeholder="Tên đăng nhập" required>
            </div>
            <div class="col">
                <input type="password" class="form-control" name="password" placeholder="Mật khẩu" required>
            </div>
            <div class="col">
                <button type="submit" class="btn btn-primary">Thêm thành viên</button>
            </div>
        </div>
    </form>
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">
        <%= request.getAttribute("success") %>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên đăng nhập</th>
            <th>Họ và tên</th>
            <th>Vai trò</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Member> members = (List<Member>) request.getAttribute("members");
            if (members == null || members.isEmpty()) {
        %>
        <tr>
            <td colspan="5" class="text-center">Không có thành viên nào.</td>
        </tr>
        <%
        } else {
            for (Member member : members) {
        %>
        <tr>
            <td><%= member.getId() %></td>
            <td><%= member.getUsername() %></td>
            <td><%= member.getFullName() %></td>
            <td><%= member.getRole() %></td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/members?action=edit&id=<%= member.getId() %>" class="btn btn-sm btn-warning">Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/members?action=delete&id=<%= member.getId() %>" class="btn btn-sm btn-danger"
                   onclick="return confirm('Bạn có chắc muốn xoá thành viên này?');">Xoá</a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>