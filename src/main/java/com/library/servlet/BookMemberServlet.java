package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.dao.MemberDAO;
import com.library.model.Book;
import com.library.model.Member;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/getAvailableBooks")
public class BookMemberServlet extends HttpServlet {
    private BookDAO bookDAO = BookDAO.getInstance();
    private MemberDAO memberDAO = MemberDAO.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        String action = req.getParameter("action");

        Gson gson = new Gson(); // Khai báo Gson

        if ("books".equals(action)) {
            try {
                List<Book> books = bookDAO.getAvailableBooks();
                out.print(gson.toJson(books)); // Sử dụng gson.toJson()
            } catch (SQLException e) {
                out.print("[]");
                e.printStackTrace();
            }
        } else if ("members".equals(action)) {
            try {
                List<Member> members = memberDAO.getAllMembers();
                out.print(gson.toJson(members)); // Sử dụng gson.toJson()
            } catch (SQLException e) {
                out.print("[]");
                e.printStackTrace();
            }
        }
        out.flush();
    }
}