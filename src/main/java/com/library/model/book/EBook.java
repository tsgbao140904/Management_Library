package com.library.model.book;

import com.library.model.Book;

public class EBook extends Book {
    public EBook(int id, String title, String author, int quantity) {
        super(id, title, author, quantity);
    }

    @Override
    public String getType() {
        return "EBook";
    }
}