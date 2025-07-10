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
import java.util.List;

@WebServlet("/admin/members")
public class MemberServlet extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        memberDAO = MemberDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String contextPath = req.getContextPath();
        if (session == null || session.getAttribute("user") == null || !((Member) session.getAttribute("user")).getRole().equals("ADMIN")) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("edit".equals(action)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Member member = memberDAO.getMemberById(id);
                    if (member == null) {
                        req.setAttribute("error", "Không tìm thấy thành viên với ID: " + id);
                    } else {
                        req.setAttribute("member", member);
                    }
                    req.getRequestDispatcher("/admin/editmember.jsp").forward(req, resp);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID không hợp lệ.");
                    req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
                }
                return;
            } else if ("delete".equals(action)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    memberDAO.deleteMember(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/members?success=delete");
                    return;
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID không hợp lệ.");
                } catch (SQLException e) {
                    req.setAttribute("error", "Lỗi khi xóa thành viên: " + e.getMessage());
                }
            }

            String idParam = req.getParameter("id");
            String username = req.getParameter("username");
            String fullName = req.getParameter("fullName");
            String role = req.getParameter("role");

            Integer id = null;
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    id = Integer.parseInt(idParam.trim());
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID tìm kiếm không hợp lệ.");
                }
            }

            List<Member> members;

            if ((id != null) ||
                    (username != null && !username.trim().isEmpty()) ||
                    (fullName != null && !fullName.trim().isEmpty()) ||
                    (role != null && !role.trim().isEmpty())) {
                members = memberDAO.searchMembers(id, username, fullName, role);
            } else {
                members = memberDAO.getAllMembers();
            }

            req.setAttribute("members", members);
            req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String contextPath = req.getContextPath();

        if (session == null || session.getAttribute("user") == null ||
                !((Member) session.getAttribute("user")).getRole().equals("ADMIN")) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        String idParam = req.getParameter("id");

        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                // Cập nhật thành viên
                int id = Integer.parseInt(idParam);
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String fullName = req.getParameter("fullName");
                String role = req.getParameter("role");

                // Kiểm tra username khi cập nhật
                Member existingMember = memberDAO.getMemberById(id);
                if (!existingMember.getUsername().equals(username) && memberDAO.isUsernameExists(username)) {
                    req.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại. Vui lòng chọn tên khác.");
                    req.setAttribute("member", existingMember);
                    req.getRequestDispatcher("/admin/editmember.jsp").forward(req, resp);
                    return;
                }

                Member member = new Member(id, username, password, fullName, role);
                memberDAO.updateMember(member);
            } else {
                // Thêm thành viên mới
                String name = req.getParameter("name");
                String username = req.getParameter("username");
                String password = req.getParameter("password");

                if (name == null || name.trim().isEmpty()) {
                    req.setAttribute("error", "Họ và tên không được để trống.");
                    req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
                    return;
                }
                if (username == null || username.trim().isEmpty()) {
                    req.setAttribute("error", "Tên đăng nhập không được để trống.");
                    req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
                    return;
                }
                if (password == null || password.trim().isEmpty()) {
                    req.setAttribute("error", "Mật khẩu không được để trống.");
                    req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
                    return;
                }

                // Kiểm tra username khi thêm mới
                if (memberDAO.isUsernameExists(username)) {
                    req.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại. Vui lòng chọn tên khác.");
                    // Lấy lại danh sách thành viên để hiển thị
                    List<Member> members = memberDAO.getAllMembers();
                    req.setAttribute("members", members);
                    req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
                    return;
                }

                Member member = new Member(0, username.trim(), password.trim(), name.trim(), "MEMBER");
                memberDAO.addMember(member);

                req.setAttribute("success", "Thêm thành viên thành công!");
            }

            resp.sendRedirect(contextPath + "/admin/members");

        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi CSDL: " + e.getMessage());
            try {
                List<Member> members = memberDAO.getAllMembers();
                req.setAttribute("members", members);
                req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
            } catch (SQLException ex) {
                throw new ServletException("Lỗi CSDL", ex);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID không hợp lệ: " + e.getMessage());
            try {
                List<Member> members = memberDAO.getAllMembers();
                req.setAttribute("members", members);
                req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
            } catch (SQLException ex) {
                throw new ServletException("Lỗi CSDL", ex);
            }
        }
    }
}