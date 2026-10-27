-- OPTIONAL: the application creates these tables (and sample data) automatically
-- the first time it connects. Use this script only if you want to create them by hand
-- in NetBeans (Services > Databases > jdbc:derby://localhost:1527/Divya > Execute Command).

CREATE TABLE USERS (
    USERNAME VARCHAR(50)  NOT NULL PRIMARY KEY,
    EMAIL    VARCHAR(100) NOT NULL UNIQUE,
    PASSWORD VARCHAR(255) NOT NULL
);

CREATE TABLE BOOK (
    ID             INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    TITLE          VARCHAR(255) NOT NULL,
    AUTHOR         VARCHAR(255) NOT NULL,
    GENRE          VARCHAR(100),
    CONTENT        CLOB,
    PUBLISHED_DATE DATE,
    COVER_IMG      VARCHAR(255),
    ISBN           VARCHAR(20)
);

CREATE TABLE EBOOKS (
    ID        INTEGER NOT NULL PRIMARY KEY,
    TITLE     VARCHAR(100) NOT NULL,
    AUTHOR    VARCHAR(100) NOT NULL,
    GENRE     VARCHAR(100) NOT NULL,
    C_PDF     VARCHAR(255),
    COVER_IMG VARCHAR(255)
);

INSERT INTO EBOOKS (ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG) VALUES
 (1, 'Atomic Habits', 'James Clear', 'Self-Help', 'Atomic Habits James Clear.pdf', 'Screenshot 2024-09-19 195650.png');
INSERT INTO EBOOKS (ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG) VALUES
 (2, 'Book of Wisdom', 'Advanced Society of Paranormal Studies', 'Philosophy', 'Book-Of-Wisdom.pdf', 'BookOfWisdom.jpg');
INSERT INTO EBOOKS (ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG) VALUES
 (3, 'Dark Clouds Over Salty Shores', 'E.J. Masters', 'Mystery', 'Dark-Clouds-Over-Salty-Shores.pdf', 'saltyshores.jpg');
INSERT INTO EBOOKS (ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG) VALUES
 (4, 'Smart Strategies: AI Tools for Sales and Marketing Excellence', 'Tadeusz Murawski', 'Business', 'Smart-Strategies-AI-Tools-for-Sales-and-Marketing-Excellence.pdf', 'samrtai.jpg');
INSERT INTO EBOOKS (ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG) VALUES
 (5, 'The Burden of A Man', 'Boygene Borice', 'Romance', 'The-Burden-of-A-Man.pdf', 'burdenofman.jpg');
-- Users are created through the Register page (passwords are stored hashed).
