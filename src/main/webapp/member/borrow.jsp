<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Book, com.library.model.decorator.FavoriteBookDecorator, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mượn sách</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Thư viện</a>
        <div class="navbar-nav">
            <a class="nav-link" href="${pageContext.request.contextPath}/member/dashboard">Bảng điều khiển</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/member/borrow">Mượn sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/member/return">Trả sách</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
    </div>
</nav>
<div class="container mt-5">
    <h2>Mượn sách</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= request.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= request.getAttribute("success") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
    <form action="${pageContext.request.contextPath}/member/borrow" method="post">
        <div class="mb-3">
            <label for="bookId" class="form-label">Chọn sách</label>
            <select name="bookId" id="bookId" class="form-select" required>
                <option value="">-- Chọn sách --</option>
                <% List<Book> books = (List<Book>) request.getAttribute("books"); %>
                <% if (books != null && !books.isEmpty()) { %>
                <% for (Book book : books) { %>
                <option value="<%= book.getId() %>">
                    <%= book.getTitle() %> (Tác giả: <%= book.getAuthor() %>)
                </option>
                <% } %>
                <% } else { %>
                <option value="">Không có sách nào</option>
                <% } %>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Mượn</button>
    </form>
    <h3 class="mt-4">Danh sách sách</h3>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Tác giả</th>
            <th>Loại</th>
            <th>Trạng thái</th>
        </tr>
        </thead>
        <tbody>
        <% if (books != null && !books.isEmpty()) { %>
        <% for (Book book : books) { %>
        <tr>
            <td><%= book.getId() %></td>
            <td><%= book.getTitle() %></td>
            <td><%= book.getAuthor() %></td>
            <td><%= book.getType() %></td>
            <td>
                <% if (book instanceof FavoriteBookDecorator) { %>
                <span class="badge bg-success">Yêu thích</span>
                <% } else { %>
                <span class="badge bg-secondary">Bình thường</span>
                <% } %>
            </td>
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
</body>
</html>