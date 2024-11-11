package com.ebookmanagement.model;
// Generated 20 Sep, 2024 8:19:39 PM by Hibernate Tools 4.3.1


import java.sql.Clob;
import java.util.Date;

/**
 * Book generated by hbm2java
 */
public class Book  implements java.io.Serializable {


     private int id;
     private String title;
     private String author;
     private String genre;
     private Clob content;
     private Date publishedDate;
     private String coverImg;
     private String isbn;

    public Book() {
    }

	
    public Book(int id, String title, String author) {
        this.id = id;
        this.title = title;
        this.author = author;
    }
    public Book(int id, String title, String author, String genre, Clob content, Date publishedDate, String coverImg, String isbn) {
       this.id = id;
       this.title = title;
       this.author = author;
       this.genre = genre;
       this.content = content;
       this.publishedDate = publishedDate;
       this.coverImg = coverImg;
       this.isbn = isbn;
    }
   
    public int getId() {
        return this.id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    public String getTitle() {
        return this.title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    public String getAuthor() {
        return this.author;
    }
    
    public void setAuthor(String author) {
        this.author = author;
    }
    public String getGenre() {
        return this.genre;
    }
    
    public void setGenre(String genre) {
        this.genre = genre;
    }
    public Clob getContent() {
        return this.content;
    }
    
    public void setContent(Clob content) {
        this.content = content;
    }
    public Date getPublishedDate() {
        return this.publishedDate;
    }
    
    public void setPublishedDate(Date publishedDate) {
        this.publishedDate = publishedDate;
    }
    public String getCoverImg() {
        return this.coverImg;
    }
    
    public void setCoverImg(String coverImg) {
        this.coverImg = coverImg;
    }
    public String getIsbn() {
        return this.isbn;
    }
    
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }




}

