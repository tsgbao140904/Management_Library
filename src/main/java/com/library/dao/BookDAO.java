package com.library.dao;

import com.library.config.DatabaseConfig;
import com.library.model.Book;
import com.library.model.book.AcademicBookFactory;
import com.library.model.book.EntertainmentBookFactory;
import com.library.model.book.BookFactory;
import com.library.model.decorator.FavoriteBookDecorator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    private static BookDAO instance;
    private BookDAO() {}
    public static synchronized BookDAO getInstance() {
        if (instance == null) {
            instance = new BookDAO();
        }
        return instance;
    }

    public void addBook(Book book) throws SQLException {
        long startTime = System.currentTimeMillis();
        long startMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        String sql = "INSERT INTO books (title, author, type, quantity) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getType());
            stmt.setInt(4, book.getQuantity());
            stmt.executeUpdate();
        }
        long endTime = System.currentTimeMillis();
        long endMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        System.out.println("[PERF] addBook: Time = " + (endTime - startTime) + " ms, Memory = " + ((endMemory - startMemory) / 1024) + " KB");
    }

    public List<Book> getAllBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                books.add(book);
            }
        }
        return books;
    }

    public Book getBookById(int id) throws SQLException {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                return book;
            }
        }
        return null;
    }

    public void updateBook(Book book) throws SQLException {
        String sql = "UPDATE books SET title = ?, author = ?, type = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getType());
            stmt.setInt(4, book.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteBook(int id) throws SQLException {
        String deleteLoansSql = "DELETE FROM loans WHERE book_id = ?";
        String deleteBookSql = "DELETE FROM books WHERE id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement deleteLoansStmt = conn.prepareStatement(deleteLoansSql);
             PreparedStatement deleteBookStmt = conn.prepareStatement(deleteBookSql)) {
            conn.setAutoCommit(false);

            deleteLoansStmt.setInt(1, id);
            deleteLoansStmt.executeUpdate();

            deleteBookStmt.setInt(1, id);
            deleteBookStmt.executeUpdate();

            conn.commit();
        } catch (SQLException e) {
            throw new SQLException("Loi khi xoa sach: " + e.getMessage(), e);
        }
    }

    public void markAsFavorite(int id) throws SQLException {
        String sql = "UPDATE books SET is_favorite = TRUE WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public void unmarkAsFavorite(int id) throws SQLException {
        String sql = "UPDATE books SET is_favorite = FALSE WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Book> getAvailableBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.* FROM books b LEFT JOIN loans l ON b.id = l.book_id AND l.return_date IS NULL WHERE l.book_id IS NULL AND b.quantity > 0";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BookFactory factory = rs.getString("type").equals("Printed") ? new AcademicBookFactory() : new EntertainmentBookFactory();
                Book book = factory.createBook(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getInt("quantity")
                );
                if (rs.getBoolean("is_favorite")) {
                    book = new FavoriteBookDecorator(book);
                }
                books.add(book);
            }
        }
        return books;
    }

    public List<Book> searchBooks(String idStr, String title, String author, String type, String favoriteStr, String quantityStr, String quantityOp, String quantityTo) throws SQLException {
        long startTime = System.currentTimeMillis();
        long startMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM books WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (idStr != null && !idStr.isEmpty()) {
            sql.append(" AND id = ?");
            params.add(Integer.parseInt(idStr));
        }
        if (title != null && !title.isEmpty()) {
            sql.append(" AND title LIKE ?");
            params.add("%" + title + "%");
        }
        if (author != null && !author.isEmpty()) {
            sql.append(" AND author LIKE ?");
            params.add("%" + author + "%");
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ?");
            params.add(type);
        }
        if (favoriteStr != null && !favoriteStr.isEmpty()) {
            sql.append(" AND is_favorite = ?");
            params.add(Boolean.parseBoolean(favoriteStr));
        }
        if (quantityStr != null && !quantityStr.isEmpty()) {
            int q = Integer.parseInt(quantityStr);
            if (quantityOp == null || quantityOp.equals("le")) {
                sql.append(" AND quantity <= ?");
                params.add(q);
            } else if (quantityOp.equals("ge")) {
                sql.append(" AND quantity >= ?");
                params.add(q);
            } else if (quantityOp.equals("eq")) {
                sql.append(" AND quantity = ?");
                params.add(q);
            } else if (quantityOp.equals("range") && quantityTo != null && !quantityTo.isEmpty()) {
                int qTo = Integer.parseInt(quantityTo);
                sql.append(" AND quantity BETWEEN ? AND ?");
                params.add(q);
                params.add(qTo);
            }
        }

        try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                books.add(book);
            }
        }
        long endTime = System.currentTimeMillis();
        long endMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        System.out.println("[PERF] searchBooks: Time = " + (endTime - startTime) + " ms, Memory = " + ((endMemory - startMemory) / 1024) + " KB");
        return books;
    }

    public void addQuantityToBook(int bookId, int addQuantity) throws SQLException {
        String sql = "UPDATE books SET quantity = quantity + ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, addQuantity);
            stmt.setInt(2, bookId);
            stmt.executeUpdate();
        }
    }

    public void decreaseQuantity(int bookId, int amount) throws SQLException {
        String sql = "UPDATE books SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, amount);
            stmt.setInt(2, bookId);
            stmt.setInt(3, amount);
            stmt.executeUpdate();
        }
    }

    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String title = rs.getString("title");
        String author = rs.getString("author");
        String type = rs.getString("type");
        boolean isFavorite = rs.getBoolean("is_favorite");
        int quantity = rs.getInt("quantity");

        BookFactory factory = type.equals("Printed") ? new AcademicBookFactory() : new EntertainmentBookFactory();
        Book book = factory.createBook(id, title, author, quantity);
        if (isFavorite) {
            book = new FavoriteBookDecorator(book);
        }
        return book;
    }
}