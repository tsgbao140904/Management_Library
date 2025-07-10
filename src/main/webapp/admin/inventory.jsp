<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Book, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý kho sách</title>
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
    <h2>Quản lý kho sách</h2>
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="${pageContext.request.contextPath}/admin/inventory" method="post" class="row g-3 align-items-center mb-4">
        <div class="col-auto">
            <label for="bookId" class="col-form-label">Chọn sách:</label>
        </div>
        <div class="col-auto">
            <select class="form-select" name="bookId" id="bookId" required>
                <option value="">-- Chọn sách --</option>
                <% List<Book> books = (List<Book>) request.getAttribute("books");
                   if (books != null) {
                       for (Book book : books) { %>
                <option value="<%= book.getId() %>"><%= book.getTitle() %> - <%= book.getAuthor() %></option>
                <%   }
                   } %>
            </select>
        </div>
        <div class="col-auto">
            <input type="number" class="form-control" name="addQuantity" min="1" placeholder="Số lượng thêm" required>
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Thêm vào kho</button>
        </div>
    </form>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tiêu đề</th>
            <th>Tác giả</th>
            <th>Loại</th>
            <th>Số lượng tồn kho</th>
        </tr>
        </thead>
        <tbody>
        <% if (books != null && !books.isEmpty()) {
               for (Book book : books) { %>
        <tr>
            <td><%= book.getId() %></td>
            <td><%= book.getTitle() %></td>
            <td><%= book.getAuthor() %></td>
            <td><%= book.getType() %></td>
            <td>
                <%= book.getQuantity() %>
                <form action="${pageContext.request.contextPath}/admin/inventory" method="post" class="d-inline ms-2" style="width: 180px;">
                    <input type="hidden" name="action" value="decrease">
                    <input type="hidden" name="bookId" value="<%= book.getId() %>">
                    <input type="number" name="decreaseQuantity" min="1" max="<%= book.getQuantity() %>" placeholder="Số lượng" style="width: 70px; display: inline-block;" required>
                    <button type="submit" class="btn btn-sm btn-danger">Giảm kho</button>
                </form>
            </td>
        </tr>
        <%   }
           } else { %>
        <tr><td colspan="5" class="text-center">Chưa có sách nào.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 