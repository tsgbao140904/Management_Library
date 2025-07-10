package com.library.model.decorator;

import com.library.model.Book;

public abstract class BookDecorator extends Book {
    protected Book decoratedBook;

    public BookDecorator(Book decoratedBook) {
        super(decoratedBook.getId(), decoratedBook.getTitle(), decoratedBook.getAuthor(), decoratedBook.getQuantity());
        this.decoratedBook = decoratedBook;
    }

    @Override
    public String getType() {
        return decoratedBook.getType();
    }
    @Override
    public int getId() {
        return decoratedBook.getId();
    }

    @Override
    public void setId(int id) {
        decoratedBook.setId(id);
    }

    @Override
    public String getTitle() {
        return decoratedBook.getTitle();
    }

    @Override
    public void setTitle(String title) {
        decoratedBook.setTitle(title);
    }

    @Override
    public String getAuthor() {
        return decoratedBook.getAuthor();
    }

    @Override
    public void setAuthor(String author) {
        decoratedBook.setAuthor(author);
    }
}