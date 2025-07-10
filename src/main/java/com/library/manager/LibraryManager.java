package com.library.manager;

import com.library.model.Book;
import com.library.model.Member;
import com.library.model.Loan;
import java.util.ArrayList;
import java.util.List;

public class LibraryManager {
    private static LibraryManager instance;
    private List<Observer> observers = new ArrayList<>();
    private List<Book> books = new ArrayList<>();
    private List<Member> members = new ArrayList<>();
    private List<Loan> loans = new ArrayList<>();

    private LibraryManager() {}

    public static LibraryManager getInstance() {
        if (instance == null) {
            instance = new LibraryManager();
        }
        return instance;
    }

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void notifyObservers(String message) {
        for (Observer observer : observers) {
            observer.update(message);
        }
    }

    // Methods to manage books, members, loans
    public void addBook(Book book) {
        books.add(book);
        notifyObservers("Book added: " + book.getTitle());
    }

    public void addMember(Member member) {
        members.add(member);
        notifyObservers("Member added: " + member.getFullName());
    }

    public void addLoan(Loan loan) {
        loans.add(loan);
        notifyObservers("Loan added for member ID: " + loan.getMemberId());
    }

    // Getters
    public List<Book> getBooks() { return books; }
    public List<Member> getMembers() { return members; }
    public List<Loan> getLoans() { return loans; }
}