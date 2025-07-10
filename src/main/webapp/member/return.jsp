<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Loan, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trả sách</title>

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
    <h2>Trả sách</h2>
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
    <% Loan returnedLoan = (Loan) request.getAttribute("returnedLoan"); %>
    <% if (returnedLoan != null) { %>
    <div class="alert alert-info mt-4">
        <h5>Thông tin sách vừa trả</h5>
        <ul class="mb-1">
            <li><b>Tên sách:</b> <%= returnedLoan.getBook() != null && returnedLoan.getBook().getTitle() != null ? returnedLoan.getBook().getTitle() : "Không xác định" %></li>
            <li><b>Ngày mượn:</b> <%= returnedLoan.getBorrowDate() != null ? returnedLoan.getBorrowDate() : "Không xác định" %></li>
            <li><b>Hạn trả:</b> <%= returnedLoan.getDueDate() != null ? returnedLoan.getDueDate() : "Không xác định" %></li>
            <li><b>Ngày trả:</b> <%= returnedLoan.getReturnDate() != null ? returnedLoan.getReturnDate() : "Không xác định" %></li>
            <li><b>Phí mượn:</b> <span class="text-success fw-bold"><%= returnedLoan.getOverdueFee() - returnedLoan.getLateFee() %> VNĐ</span></li>
            <li><b>Phí quá hạn:</b> <span class="text-danger fw-bold"><%= returnedLoan.getLateFee() %> VNĐ</span></li>
            <li><b>Tổng phí thanh toán:</b> <span class="fw-bold text-primary"><%= returnedLoan.getOverdueFee() %> VNĐ</span></li>
            <li><b>Chiến lược phí:</b> <span class="text-info">
                <% if ("daily".equalsIgnoreCase(returnedLoan.getFeeStrategy())) { %>Theo ngày<% } else if ("quantity".equalsIgnoreCase(returnedLoan.getFeeStrategy())) { %>Theo số lượng<% } else { %><%= returnedLoan.getFeeStrategy() != null ? returnedLoan.getFeeStrategy() : "Không xác định" %><% } %>
            </span></li>
        </ul>
    </div>
    <% } %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên sách</th>
            <th>Ngày mượn</th>
            <th>Hạn trả</th>
            <th>Phí mượn</th>
            <th>Phí quá hạn</th>
            <th>Tổng phí thanh toán</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <% List<Loan> loans = (List<Loan>) request.getAttribute("loans"); %>
        <% boolean hasUnreturnedLoans = false; %>
        <% if (loans != null && !loans.isEmpty()) { %>
        <% for (Loan loan : loans) { %>
        <% if (loan.getReturnDate() == null) { %>
        <% hasUnreturnedLoans = true; %>
        <tr>
            <td><%= loan.getId() %></td>
            <td><%= loan.getBook() != null ? loan.getBook().getTitle() : "Không có tên" %></td>
            <td><%= loan.getBorrowDate() %></td>
            <td><%= loan.getDueDate() %></td>
            <td><%= loan.getOverdueFee() - loan.getLateFee() %> VNĐ</td>
            <td><%= loan.getLateFee() %> VNĐ</td>
            <td><%= loan.getOverdueFee() %> VNĐ</td>
            <td>
                <a href="${pageContext.request.contextPath}/member/return?action=return&id=<%= loan.getId() %>&feeType=<%= loan.getFeeStrategy() %>"
                   class="btn btn-sm btn-success">
                    Trả sách
                </a>
            </td>
        </tr>
        <% } %>
        <% } %>
        <% } %>
        <% if (!hasUnreturnedLoans) { %>
        <tr>
            <td colspan="8" class="text-center">Chưa có sách nào để trả.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>