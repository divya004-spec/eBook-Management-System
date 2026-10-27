# eBook-Management-System
A Java-based eBook Management System built with JSP, Servlets, Jakarta EE, Maven, and Apache Derby, featuring user authentication, an online PDF library, and personal book management.

## Features

- **User Authentication:** User registration, login, and logout.
- **E-Book Library:** Browse a collection of e-books with book details and cover images.
- **Online PDF Reader:** Read available e-books directly in the browser.
- **Book Downloads:** Download available PDF books.
- **Personal Library Management:** Add, write, read, and delete personal book entries.
- **Database Integration:** Store user and book information using Apache Derby.
- **Authentication Filter:** Restrict protected pages to authenticated users.

## Technology Stack

- **Language:** Java
- **Frontend:** HTML, CSS, JSP
- **Backend:** Jakarta Servlets, Jakarta EE
- **Database:** Apache Derby
- **ORM / Mapping Configuration:** Hibernate mapping XML files are included in the project.
- **Build Tool:** Apache Maven
- **IDE:** Apache NetBeans
- **Server:** Apache Tomcat 10.1+ or a compatible Jakarta EE server

## Project Structure

```text
EBook-Management-System/
├── database/
│   └── schema.sql
├── src/
│   └── main/
│       ├── java/
│       │   └── com/ebookmanagement/
│       │       ├── filter/
│       │       ├── listener/
│       │       ├── model/
│       │       ├── servlet/
│       │       └── util/
│       ├── resources/
│       └── webapp/
│           ├── images/
│           ├── WEB-INF/
│           ├── *.jsp
│           ├── *.html
│           └── *.css
├── pom.xml
└── README.md
```

## Prerequisites

- JDK 21 or a compatible newer JDK
- Apache NetBeans 31 or another Maven-compatible IDE
- Apache Tomcat 10.1+ or a compatible Jakarta EE server
- Internet access for downloading Maven dependencies on the first build

## How to Run

1. Clone or download this repository.
2. Open the project in Apache NetBeans.
3. Allow Maven to download the required dependencies.
4. Configure a compatible Jakarta web server.
5. Run the project from the IDE.
6. Open the application at:

   `http://localhost:8080/EBookMgmtSys/`

The application initializes its Apache Derby database and sample records on startup. The default database configuration supports embedded mode; network mode can be configured if required.

## Build the Project

Run the following command from the project directory:

```bash
mvn clean package
```

The generated WAR file is available at:

`target/EBookMgmtSys.war`

Deploy the WAR to a compatible Jakarta web server.

## Database

The project includes `database/schema.sql`, which defines the user and book tables and sample e-book records. The application also contains database initialization logic.

## Learning Outcomes

- Java web application development
- Servlet and JSP request handling
- User authentication and session-based access control
- Relational database integration with JDBC
- Maven-based project management
- Web application deployment using a Jakarta-compatible server

## Future Enhancements

- Book search, filtering, and category management
- Improved responsive UI and accessibility
- Pagination and reading progress tracking
- Automated testing and deployment

## Author

**Divya Basutkar**

Developed as a Java web application project for learning and demonstrating web development, database integration, and application security concepts.
