package com.library.servlet;

import com.library.dao.MemberDAO;
import com.library.model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = MemberDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String contextPath = req.getContextPath();
        HttpSession session = req.getSession();

        try {
            Member member = memberDAO.getMemberByUsername(username);
            if (member != null && member.getPassword().equals(password)) {
                session.setAttribute("user", member);
                // Thêm thông báo thành công
                session.setAttribute("success", "Đăng nhập thành công!");
                // Xóa thông báo lỗi nếu có
                session.removeAttribute("error");
                if (member.getRole().equals("ADMIN")) {
                    resp.sendRedirect(contextPath + "/admin/books");
                } else {
                    resp.sendRedirect(contextPath + "/member/dashboard");
                }
            } else {
                session.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu.");
                resp.sendRedirect(contextPath + "/login");
            }
        } catch (SQLException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(contextPath + "/login");
        }
    }
}