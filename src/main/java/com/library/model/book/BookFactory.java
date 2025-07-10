package com.library.model.book;

import com.library.model.Book;

public interface BookFactory {
    Book createBook(int id, String title, String author);
    Book createBook(int id, String title, String author, int quantity);
}