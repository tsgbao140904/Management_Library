package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/inventory")
public class InventoryServlet extends HttpServlet {
    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = BookDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Book> books = bookDAO.getAllBooks();
            req.setAttribute("books", books);
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi lấy danh sách sách: " + e.getMessage());
        }
        req.getRequestDispatcher("/admin/inventory.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("decrease".equals(action)) {
            String bookIdStr = req.getParameter("bookId");
            String decreaseQuantityStr = req.getParameter("decreaseQuantity");
            try {
                int bookId = Integer.parseInt(bookIdStr);
                int decreaseQuantity = Integer.parseInt(decreaseQuantityStr);
                Book book = bookDAO.getBookById(bookId);
                if (book == null) {
                    req.setAttribute("error", "Không tìm thấy sách với ID " + bookId);
                } else if (decreaseQuantity < 1) {
                    req.setAttribute("error", "Số lượng giảm phải lớn hơn 0.");
                } else if (decreaseQuantity > book.getQuantity()) {
                    req.setAttribute("error", "Không thể giảm quá số lượng hiện có.");
                } else {
                    bookDAO.decreaseQuantity(bookId, decreaseQuantity);
                    req.setAttribute("success", "Đã giảm " + decreaseQuantity + " khỏi kho cho sách ID " + bookId);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi khi giảm kho: " + e.getMessage());
            }
            doGet(req, resp);
            return;
        }
        String bookIdStr = req.getParameter("bookId");
        String addQuantityStr = req.getParameter("addQuantity");
        try {
            int bookId = Integer.parseInt(bookIdStr);
            int addQuantity = Integer.parseInt(addQuantityStr);
            bookDAO.addQuantityToBook(bookId, addQuantity);
            req.setAttribute("success", "Đã thêm " + addQuantity + " vào kho cho sách ID " + bookId);
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi thêm vào kho: " + e.getMessage());
        }
        doGet(req, resp);
    }
} 