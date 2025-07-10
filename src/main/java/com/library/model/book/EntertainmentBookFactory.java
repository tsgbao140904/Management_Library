package com.library.model.book;

import com.library.model.Book;

public class EntertainmentBookFactory implements BookFactory {
    @Override
    public Book createBook(int id, String title, String author) {
        return createBook(id, title, author, 1);
    }

    @Override
    public Book createBook(int id, String title, String author, int quantity) {
        return new EBook(id, title, author, quantity);
    }

    private static class EntertainmentBook extends Book {
        public EntertainmentBook(int id, String title, String author, int quantity) {
            super(id, title, author, quantity);
        }

        @Override
        public String getType() {
            return "Entertainment";
        }
    }
}