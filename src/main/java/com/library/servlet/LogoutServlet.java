package com.library.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String contextPath = req.getContextPath();

        // Mã hóa giá trị cookie
        String successMessage = URLEncoder.encode("Đăng xuất thành công!", StandardCharsets.UTF_8.toString());
        // Tạo cookie với giá trị đã mã hóa
        Cookie successCookie = new Cookie("success", successMessage);
        successCookie.setMaxAge(300); // Cookie tồn tại 300 giây
        successCookie.setPath(contextPath); // Áp dụng cho toàn bộ ứng dụng
        resp.addCookie(successCookie);

        // Hủy session
        req.getSession().invalidate();

        // Redirect về trang đăng nhập
        resp.sendRedirect(contextPath + "/login");
    }
}