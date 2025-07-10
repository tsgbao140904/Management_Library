<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Member" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản lý Thư viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
<%
    // Lấy context path động
    String contextPath = request.getContextPath();
    // Kiểm tra session
    Member user = (Member) session.getAttribute("user");
    if (user != null) {
        // Nếu đã đăng nhập, chuyển hướng theo vai trò
        if (user.getRole().equals("ADMIN")) {
            response.sendRedirect(contextPath + "/admin/books");
        } else {
            response.sendRedirect(contextPath + "/member/dashboard");
        }
    } else {
        // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
        response.sendRedirect(contextPath + "/login");
    }
%>
</body>
</html>