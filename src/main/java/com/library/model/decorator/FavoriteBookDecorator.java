package com.library.model.decorator;

import com.library.dao.BookDAO;
import com.library.model.Book;

import java.sql.SQLException;

public class FavoriteBookDecorator extends BookDecorator {
    public FavoriteBookDecorator(Book decoratedBook) {
        super(decoratedBook);
    }

    @Override
    public String getTitle() {
        return decoratedBook.getTitle();
    }

    public String markAsFavorite() {
        try {
            BookDAO bookDAO = BookDAO.getInstance();
            bookDAO.markAsFavorite(decoratedBook.getId());
            return "Book '" + decoratedBook.getTitle() + "' has been marked as favorite.";
        } catch (SQLException e) {
            return "Error marking book as favorite: " + e.getMessage();
        }
    }
    public String unmarkAsFavorite() {
        try {
            BookDAO bookDAO = BookDAO.getInstance();
            bookDAO.unmarkAsFavorite(decoratedBook.getId());
            return "Book '" + decoratedBook.getTitle() + "' has been unmarked as favorite.";
        } catch (SQLException e) {
            return "Error unmarking book as favorite: " + e.getMessage();
        }
    }
}