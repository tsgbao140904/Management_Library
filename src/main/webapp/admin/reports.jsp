<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.model.Loan, com.library.model.Book, com.library.model.Member, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo</title>
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
    <h2>Báo cáo thống kê</h2>
    <% List<Loan> loans = (List<Loan>) request.getAttribute("loans"); %>
    <% List<Book> books = (List<Book>) request.getAttribute("books"); %>
    <% List<Member> members = (List<Member>) request.getAttribute("members"); %>
    <% List<Loan> overdueLoans = (List<Loan>) request.getAttribute("overdueLoans"); %>
    <% long currentlyBorrowed = loans != null ? loans.stream().filter(loan -> loan.getReturnDate() == null).count() : 0; %>
    <div class="row">
        <div class="col-md-3">
            <div class="card text-white bg-primary mb-3">
                <div class="card-body">Tổng số sách: <%= books != null ? books.size() : 0 %></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-success mb-3">
                <div class="card-body">Tổng số thành viên: <%= members != null ? members.size() : 0 %></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-info mb-3">
                <div class="card-body">Tổng số sách đang mượn: <%= currentlyBorrowed %></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-warning mb-3">
                <div class="card-body">Tổng số sách quá hạn: <%= request.getAttribute("totalOverdueBooks") != null ? request.getAttribute("totalOverdueBooks") : 0 %></div>
            </div>
        </div>
    </div>

    <!-- Doanh thu tháng trước và tháng hiện tại -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="alert alert-info text-center fs-4 fw-bold" role="alert">
                Doanh thu tháng trước: <%= String.format("%,.0f", request.getAttribute("lastMonthRevenue") != null ? (Double)request.getAttribute("lastMonthRevenue") : 0.0) %> VNĐ
            </div>
        </div>
        <div class="col-md-6">
            <div class="alert alert-success text-center fs-4 fw-bold" role="alert">
                Doanh thu tháng này: <%= String.format("%,.0f", request.getAttribute("monthlyRevenue") != null ? (Double)request.getAttribute("monthlyRevenue") : 0.0) %> VNĐ
            </div>
        </div>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert" id="errorAlert">
        <%= request.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <h3>Sách đang được mượn (Số lượng: <%= currentlyBorrowed %>)</h3>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tiêu đề sách</th>
            <th>Tên thành viên</th>
            <th>Ngày mượn</th>
            <th>Ngày đến hạn</th>
            <th>Ngày trả</th>
        </tr>
        </thead>
        <tbody>
        <% if (loans != null && !loans.isEmpty()) { %>
        <% for (Loan loan : loans) { %>
        <% if (loan.getReturnDate() == null) { %>
        <tr>
            <td><%= loan.getId() %></td>
            <td><%
                String bookTitle = "";
                for (Book book : books) {
                    if (book.getId() == loan.getBookId()) {
                        bookTitle = book.getTitle();
                        break;
                    }
                }
            %><%= bookTitle %></td>
            <td><%
                String memberName = "";
                for (Member member : members) {
                    if (member.getId() == loan.getMemberId()) {
                        memberName = member.getFullName();
                        break;
                    }
                }
            %><%= memberName %></td>
            <td><%= loan.getBorrowDate() %></td>
            <td><%= loan.getDueDate() %></td>
            <td><%= loan.getReturnDate() != null ? loan.getReturnDate() : "Chưa trả" %></td>
        </tr>
        <% } %>
        <% } %>
        <% } else { %>
        <tr>
            <td colspan="6" class="text-center">Không có sách nào đang được mượn.</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <h3>Sách quá hạn (Số lượng: <%= overdueLoans != null ? overdueLoans.size() : 0 %>)</h3>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tiêu đề sách</th>
            <th>Tên thành viên</th>
            <th>Ngày mượn</th>
            <th>Ngày đến hạn</th>
        </tr>
        </thead>
        <tbody>
        <% if (overdueLoans != null && !overdueLoans.isEmpty()) { %>
        <% for (Loan loan : overdueLoans) { %>
        <tr>
            <td><%= loan.getId() %></td>
            <td><%
                String bookTitle = "";
                for (Book book : books) {
                    if (book.getId() == loan.getBookId()) {
                        bookTitle = book.getTitle();
                        break;
                    }
                }
            %><%= bookTitle %></td>
            <td><%
                String memberName = "";
                for (Member member : members) {
                    if (member.getId() == loan.getMemberId()) {
                        memberName = member.getFullName();
                        break;
                    }
                }
            %><%= memberName %></td>
            <td><%= loan.getBorrowDate() %></td>
            <td><%= loan.getDueDate() %></td>
        </tr>
        <% } %>
        <% } else { %>
        <tr>
            <td colspan="5" class="text-center">Không có sách nào quá hạn.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>