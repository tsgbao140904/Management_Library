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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        memberDAO = MemberDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String contextPath = req.getContextPath();

        try {
            // Kiểm tra xem username đã tồn tại chưa
            Member existingMember = memberDAO.getMemberByUsername(username);
            if (existingMember != null) {
                req.setAttribute("error", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            // Tạo thành viên mới (mặc định là MEMBER)
            Member newMember = new Member(0, username, password, fullName, "MEMBER");
            memberDAO.addMember(newMember);

            // Đặt thông báo thành công vào session và redirect
            HttpSession session = req.getSession();
            session.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            resp.sendRedirect(contextPath + "/login");
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}