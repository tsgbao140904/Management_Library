package com.library.model.book;

import com.library.model.Book;

public class AcademicBookFactory implements BookFactory {
    @Override
    public Book createBook(int id, String title, String author) {
        return createBook(id, title, author, 1);
    }

    @Override
    public Book createBook(int id, String title, String author, int quantity) {
        return new PrintedBook(id, title, author, quantity);
    }

    private static class AcademicBook extends Book {
        public AcademicBook(int id, String title, String author, int quantity) {
            super(id, title, author, quantity);
        }

        @Override
        public String getType() {
            return "Academic";
        }
    }
}