package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;
import com.library.model.book.AcademicBookFactory;
import com.library.model.book.EntertainmentBookFactory;
import com.library.model.book.BookFactory;
import com.library.model.decorator.FavoriteBookDecorator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet({"/admin/books", "/admin/toggle-favorite"})
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = BookDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String contextPath = req.getContextPath();

        if (session == null || session.getAttribute("user") == null ||
                !((com.library.model.Member) session.getAttribute("user")).getRole().equals("ADMIN")) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Book book = bookDAO.getBookById(id);
                if (book == null) {
                    req.setAttribute("error", "Không tìm thấy sách với ID: " + id);
                    List<Book> books = bookDAO.getAllBooks();
                    req.setAttribute("books", books);
                    req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("book", book);
                req.getRequestDispatcher("/admin/editbook.jsp").forward(req, resp);
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                bookDAO.deleteBook(id);
                session.setAttribute("success", "Xóa sách thành công!");
                resp.sendRedirect(contextPath + "/admin/books");
                return;

            } else if ("favorite".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                bookDAO.markAsFavorite(id);
                session.setAttribute("success", "Đã đánh dấu sách là yêu thích!");
                resp.sendRedirect(contextPath + "/admin/books");
                return;
            }

            String searchId = req.getParameter("id");
            Integer id = null;
            if (searchId != null && !searchId.trim().isEmpty()) {
                try {
                    id = Integer.parseInt(searchId);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID phải là số nguyên hợp lệ.");
                    List<Book> books = bookDAO.getAllBooks();
                    req.setAttribute("books", books);
                    req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
                    return;
                }
            }

            String title = req.getParameter("title");
            String author = req.getParameter("author");
            String type = req.getParameter("type");
            String favorite = req.getParameter("favorite");
            String quantity = req.getParameter("quantity");
            String quantityOp = req.getParameter("quantityOp");
            String quantityTo = req.getParameter("quantityTo");

            List<Book> books;

            if ((searchId != null && !searchId.isEmpty()) ||
                    (title != null && !title.isEmpty()) ||
                    (author != null && !author.isEmpty()) ||
                    (type != null && !type.isEmpty()) ||
                    (favorite != null && !favorite.isEmpty()) ||
                    (quantity != null && !quantity.isEmpty())) {
                books = bookDAO.searchBooks(searchId, title, author, type, favorite, quantity, quantityOp, quantityTo);
            } else {
                books = bookDAO.getAllBooks();
            }

            req.setAttribute("books", books);
            req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);

        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            try {
                List<Book> books = bookDAO.getAllBooks();
                req.setAttribute("books", books);
                req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
            } catch (SQLException ex) {
                throw new ServletException("Database error", ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String contextPath = req.getContextPath();
        if (session == null || session.getAttribute("user") == null || !((com.library.model.Member) session.getAttribute("user")).getRole().equals("ADMIN")) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        String path = req.getServletPath();
        try {
            if ("/admin/books".equals(path)) {
                String action = req.getParameter("action");
                if ("update".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String title = req.getParameter("title");
                    String author = req.getParameter("author");
                    String type = req.getParameter("type");

                    BookFactory factory = type.equals("Printed") ? new AcademicBookFactory() : new EntertainmentBookFactory();
                    Book book = factory.createBook(id, title, author);
                    bookDAO.updateBook(book);
                    session.setAttribute("success", "Cập nhật sách thành công!");
                    resp.sendRedirect(contextPath + "/admin/books");
                    return;
                }

                String title = req.getParameter("title");
                String author = req.getParameter("author");
                String type = req.getParameter("type");
                String quantityStr = req.getParameter("quantity");
                int quantity = 1;
                if (quantityStr != null && !quantityStr.isEmpty()) {
                    try {
                        quantity = Integer.parseInt(quantityStr);
                    } catch (NumberFormatException e) {
                        quantity = 1;
                    }
                }
                BookFactory factory = type.equals("Printed") ? new AcademicBookFactory() : new EntertainmentBookFactory();
                Book book = factory.createBook(0, title, author, quantity);
                bookDAO.addBook(book);
                session.setAttribute("success", "Thêm sách thành công!");
                resp.sendRedirect(contextPath + "/admin/books");
            } else if ("/admin/toggle-favorite".equals(path)) {
                String bookId = req.getParameter("bookId");
                if (bookId != null) {
                    int bookIdInt = Integer.parseInt(bookId);
                    Book book = bookDAO.getBookById(bookIdInt);
                    if (book != null) {
                        if (book instanceof FavoriteBookDecorator) {
                            bookDAO.unmarkAsFavorite(bookIdInt);
                            session.setAttribute("success", "Đã hủy yêu thích sách!");
                        } else {
                            bookDAO.markAsFavorite(bookIdInt);
                            session.setAttribute("success", "Đã đánh dấu sách là yêu thích!");
                        }
                    } else {
                        req.setAttribute("error", "Sách không tồn tại.");
                    }
                    List<Book> books = bookDAO.getAllBooks();
                    req.setAttribute("books", books);
                    req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
                }
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            List<Book> books;
            try {
                books = bookDAO.getAllBooks();
            } catch (SQLException ex) {
                throw new ServletException("Database error", ex);
            }
            req.setAttribute("books", books);
            req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
        }
    }
}