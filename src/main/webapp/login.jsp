<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie, java.net.URLDecoder, java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Đăng nhập</h2>
    <%
        String successMessage = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("success".equals(cookie.getName())) {
                    successMessage = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.toString());
                    cookie.setMaxAge(0);
                    cookie.setPath(request.getContextPath());
                    response.addCookie(cookie);
                    break;
                }
            }
        }
        if (successMessage != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
        <%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert" id="errorAlert">
        <%= request.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
    <% if (session.getAttribute("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
        <%= session.getAttribute("success") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("success"); %>
    <% } %>
    <% if (session.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert" id="errorAlert">
        <%= session.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("error"); %>
    <% } %>
    <form action="login" method="post" class="w-50 mx-auto">
        <div class="mb-3">
            <label for="username" class="form-label">Tên đăng nhập</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Mật khẩu</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
        <p class="mt-3 text-center">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a></p>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>