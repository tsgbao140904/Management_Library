<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Book, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Thư viện</a>
        <div class="navbar-nav">
            <a class="nav-link" href="${pageContext.request.contextPath}/member/dashboard">Bảng điều khiển</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/member/borrow">Mượn sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/member/return">Trả sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
    </div>
</nav>
<div class="container mt-5">
    <h2>Danh sách sách</h2>
    <% if (session.getAttribute("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
        <%= session.getAttribute("success") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("success"); %>
    <% } %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Tác giả</th>
            <th>Loại</th>
            <th>Yêu thích</th>
        </tr>
        </thead>
        <tbody>
        <% List<Book> books = (List<Book>) request.getAttribute("books"); %>
        <% if (books != null && !books.isEmpty()) { %>
        <% for (Book book : books) { %>
        <tr>
            <td><%= book.getId() %></td>
            <td><%= book.getTitle() %></td>
            <td><%= book.getAuthor() %></td>
            <td><%= book.getType() %></td>
            <td><%= book instanceof com.library.model.decorator.FavoriteBookDecorator ? "Có" : "Không" %></td>
        </tr>
        <% } %>
        <% } else { %>
        <tr>
            <td colspan="5" class="text-center">Chưa có sách nào.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>