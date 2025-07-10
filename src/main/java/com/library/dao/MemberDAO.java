package com.library.dao;

import com.library.config.DatabaseConfig;
import com.library.model.Member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
    private static MemberDAO instance;
    private MemberDAO() {}
    public static synchronized MemberDAO getInstance() {
        if (instance == null) {
            instance = new MemberDAO();
        }
        return instance;
    }

    public Member getMemberByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM members WHERE username = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Member(rs.getInt("id"), rs.getString("username"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role"));
            }
        }
        return null;
    }

    public Member getMemberById(int id) throws SQLException {
        String sql = "SELECT * FROM members WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Member(rs.getInt("id"), rs.getString("username"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role"));
            }
        }
        return null;
    }

    public void addMember(Member member) throws SQLException {
        String sql = "INSERT INTO members (username, password, full_name, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, member.getUsername());
            stmt.setString(2, member.getPassword());
            stmt.setString(3, member.getFullName());
            stmt.setString(4, member.getRole());
            stmt.executeUpdate();
        }
    }

    public void updateMember(Member member) throws SQLException {
        String sql = "UPDATE members SET username = ?, password = ?, full_name = ?, role = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, member.getUsername());
            stmt.setString(2, member.getPassword());
            stmt.setString(3, member.getFullName());
            stmt.setString(4, member.getRole());
            stmt.setInt(5, member.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteMember(int id) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false);

            String deleteLoansSql = "DELETE FROM loans WHERE member_id = ?";
            try (PreparedStatement deleteLoansStmt = conn.prepareStatement(deleteLoansSql)) {
                deleteLoansStmt.setInt(1, id);
                deleteLoansStmt.executeUpdate();
            }

            String deleteMemberSql = "DELETE FROM members WHERE id = ?";
            try (PreparedStatement deleteMemberStmt = conn.prepareStatement(deleteMemberSql)) {
                deleteMemberStmt.setInt(1, id);
                int rowsAffected = deleteMemberStmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Không tìm thấy thành viên với ID: " + id);
                }
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public List<Member> getAllMembers() throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                members.add(new Member(rs.getInt("id"), rs.getString("username"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role")));
            }
        }
        return members;
    }

    public List<Member> searchMembers(Integer id, String username, String fullName, String role) throws SQLException {
        List<Member> members = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM members WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (id != null) {
            sql.append(" AND id = ?");
            params.add(id);
        }
        if (username != null && !username.trim().isEmpty()) {
            sql.append(" AND username LIKE ?");
            params.add("%" + username.trim() + "%");
        }
        if (fullName != null && !fullName.trim().isEmpty()) {
            sql.append(" AND full_name LIKE ?");
            params.add("%" + fullName.trim() + "%");
        }
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND role = ?");
            params.add(role.trim().toUpperCase());
        }

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Member member = new Member(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role")
                );
                members.add(member);
            }
        }

        return members;
    }

    // Thêm phương thức kiểm tra username đã tồn tại hay chưa
    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM members WHERE username = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}