package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.dao.LoanDAO;
import com.library.dao.MemberDAO;
import com.library.model.Book;
import com.library.model.Loan;
import com.library.model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
    private LoanDAO loanDAO;
    private BookDAO bookDAO;
    private MemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = BookDAO.getInstance();
        memberDAO = MemberDAO.getInstance();
        loanDAO = LoanDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("user") == null || !"ADMIN".equals(((Member) session.getAttribute("user")).getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Loan> loans = loanDAO.getAllLoans();
            List<Book> books = bookDAO.getAllBooks();
            List<Member> members = memberDAO.getAllMembers();

            // Log để kiểm tra dữ liệu
            System.out.println("Số lượng loans (ReportServlet): " + loans.size());
            long currentlyBorrowed = loans.stream().filter(loan -> loan.getReturnDate() == null).count();
            System.out.println("Số lượng sách đang mượn (ReportServlet): " + currentlyBorrowed);

            List<Loan> overdueLoans = loans.stream()
                    .filter(loan -> 
                        (loan.getReturnDate() == null && loan.getDueDate().isBefore(java.time.LocalDate.now())) // Đang mượn và quá hạn
                        || (loan.getReturnDate() != null && loan.getReturnDate().isAfter(loan.getDueDate())) // Đã trả nhưng trả muộn
                    )
                    .collect(Collectors.toList());
            int totalOverdueBooks = overdueLoans.size();

            // --- Tính tổng doanh thu tháng hiện tại ---
            java.time.LocalDate now = java.time.LocalDate.now();
            int currentMonth = now.getMonthValue();
            int currentYear = now.getYear();
            double monthlyRevenue = loans.stream()
                .filter(loan -> loan.getReturnDate() != null
                        && loan.getReturnDate().getMonthValue() == currentMonth
                        && loan.getReturnDate().getYear() == currentYear)
                .mapToDouble(Loan::getOverdueFee)
                .sum();
            req.setAttribute("monthlyRevenue", monthlyRevenue);
            
            // --- Tính tổng doanh thu tháng trước ---
            java.time.LocalDate lastMonth = now.minusMonths(1);
            int lastMonthValue = lastMonth.getMonthValue();
            int lastMonthYear = lastMonth.getYear();
            double lastMonthRevenue = loans.stream()
                .filter(loan -> loan.getReturnDate() != null
                        && loan.getReturnDate().getMonthValue() == lastMonthValue
                        && loan.getReturnDate().getYear() == lastMonthYear)
                .mapToDouble(Loan::getOverdueFee)
                .sum();
            req.setAttribute("lastMonthRevenue", lastMonthRevenue);
            // --- End doanh thu ---

            req.setAttribute("loans", loans);
            req.setAttribute("overdueLoans", overdueLoans);
            req.setAttribute("totalOverdueBooks", totalOverdueBooks);
            req.setAttribute("books", books);
            req.setAttribute("members", members);
            req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi lấy dữ liệu báo cáo: " + e.getMessage());
            req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
        }
    }
}