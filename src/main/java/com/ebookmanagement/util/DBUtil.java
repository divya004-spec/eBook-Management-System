package com.ebookmanagement.util;

import java.io.File;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Central place for all database access.
 *
 * Connection strategy (property "ebook.db.mode" = auto | network | embedded):
 *
 *  1. network  : Java DB / Derby server on localhost:1527, database "Divya",
 *                user root / password root (the settings used by the original project).
 *  2. embedded : if the network server is not running, the application silently
 *                falls back to an embedded Derby database stored in
 *                ~/EBookMgmtSys-db so the web site still works with zero setup.
 *
 * On the first successful connection the tables USERS, BOOK and EBOOKS are
 * created automatically (if missing) and filled with sample data.
 */
public final class DBUtil {

    private static final Logger LOG = Logger.getLogger(DBUtil.class.getName());

    public static final String DB_NAME = "Divya";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    private static final String CLIENT_DRIVER = "org.apache.derby.jdbc.ClientDriver";
    private static final String EMBEDDED_DRIVER = "org.apache.derby.jdbc.EmbeddedDriver";
    private static final String NETWORK_URL = "jdbc:derby://localhost:1527/" + DB_NAME + ";create=true";

    private static final Object LOCK = new Object();
    private static String mode;            // "network" or "embedded" (null = not decided yet)
    private static String embeddedUrl;
    private static String embeddedDir;
    private static boolean schemaReady;

    private DBUtil() {
    }

    // ------------------------------------------------------------------
    // Public API
    // ------------------------------------------------------------------

    /** Opens a connection (and makes sure the tables exist). Caller must close it. */
    public static Connection getConnection() throws SQLException {
        Connection con = openConnection();
        try {
            ensureSchema(con);
        } catch (SQLException e) {
            close(con);
            throw e;
        }
        return con;
    }

    /** Human readable description of the database currently in use. */
    public static String getModeDescription() {
        synchronized (LOCK) {
            if ("network".equals(mode)) {
                return "Java DB server (localhost:1527/" + DB_NAME + ")";
            }
            if ("embedded".equals(mode)) {
                return "Embedded Java DB (" + embeddedDir + ")";
            }
        }
        return "not connected yet";
    }

    public static void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public static void close(Statement st) {
        if (st != null) {
            try {
                st.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public static void close(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ignore) {
            }
        }
    }

    /** Called when the web application stops. */
    public static void shutdown() {
        String m;
        synchronized (LOCK) {
            m = mode;
        }
        if ("embedded".equals(m)) {
            try {
                DriverManager.getConnection("jdbc:derby:;shutdown=true");
            } catch (SQLException expected) {
                // Derby always reports a (successful) shutdown as an exception
            }
        }
        ClassLoader cl = DBUtil.class.getClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver d = drivers.nextElement();
            if (d.getClass().getClassLoader() == cl) {
                try {
                    DriverManager.deregisterDriver(d);
                } catch (SQLException ignore) {
                }
            }
        }
        synchronized (LOCK) {
            mode = null;
            schemaReady = false;
        }
    }

    // ------------------------------------------------------------------
    // Connection handling
    // ------------------------------------------------------------------

    private static Connection openConnection() throws SQLException {
        String current;
        synchronized (LOCK) {
            current = mode;
        }
        if (current != null) {
            return connect(current);
        }

        String preferred = System.getProperty("ebook.db.mode", "auto").trim().toLowerCase();
        SQLException networkError = null;

        if (!"embedded".equals(preferred)) {
            try {
                Connection c = connect("network");
                setMode("network");
                LOG.info("EBookMgmtSys: connected to Java DB network server on localhost:1527");
                return c;
            } catch (SQLException e) {
                if ("network".equals(preferred)) {
                    throw e;
                }
                networkError = e;
                LOG.log(Level.WARNING, "EBookMgmtSys: Java DB network server not reachable ({0}). "
                        + "Falling back to the embedded database.", e.getMessage());
            }
        }

        try {
            Connection c = connect("embedded");
            setMode("embedded");
            LOG.log(Level.INFO, "EBookMgmtSys: using embedded Java DB in {0}", embeddedDir);
            return c;
        } catch (SQLException e) {
            String msg = "Could not open the database. Network: "
                    + (networkError == null ? "skipped" : networkError.getMessage())
                    + " | Embedded: " + e.getMessage();
            throw new SQLException(msg, e);
        }
    }

    private static void setMode(String m) {
        synchronized (LOCK) {
            mode = m;
        }
    }

    private static Connection connect(String m) throws SQLException {
        try {
            if ("network".equals(m)) {
                Class.forName(CLIENT_DRIVER);
                return DriverManager.getConnection(NETWORK_URL, DB_USER, DB_PASSWORD);
            }
            Class.forName(EMBEDDED_DRIVER);
            return DriverManager.getConnection(embeddedUrl(), DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC driver not found: " + e.getMessage()
                    + " (check that derby.jar / derbyclient.jar are in WEB-INF/lib)", e);
        }
    }

    private static String embeddedUrl() {
        synchronized (LOCK) {
            if (embeddedUrl == null) {
                File base = new File(System.getProperty("user.home", "."), "EBookMgmtSys-db");
                if (!base.isDirectory() && !base.mkdirs()) {
                    base = new File(System.getProperty("java.io.tmpdir"), "EBookMgmtSys-db");
                    base.mkdirs();
                }
                if (System.getProperty("derby.stream.error.file") == null) {
                    System.setProperty("derby.stream.error.file", new File(base, "derby.log").getAbsolutePath());
                }
                embeddedDir = base.getAbsolutePath();
                embeddedUrl = "jdbc:derby:" + new File(base, DB_NAME).getAbsolutePath().replace('\\', '/')
                        + ";create=true";
            }
            return embeddedUrl;
        }
    }

    // ------------------------------------------------------------------
    // Schema creation + sample data
    // ------------------------------------------------------------------

    private static void ensureSchema(Connection con) throws SQLException {
        synchronized (LOCK) {
            if (schemaReady) {
                return;
            }
            Statement st = con.createStatement();
            try {
                boolean usersNew = createTable(st,
                        "CREATE TABLE USERS ("
                        + "USERNAME VARCHAR(50) NOT NULL PRIMARY KEY, "
                        + "EMAIL VARCHAR(100) NOT NULL UNIQUE, "
                        + "PASSWORD VARCHAR(255) NOT NULL)");
                boolean bookNew = createTable(st,
                        "CREATE TABLE BOOK ("
                        + "ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY, "
                        + "TITLE VARCHAR(255) NOT NULL, "
                        + "AUTHOR VARCHAR(255) NOT NULL, "
                        + "GENRE VARCHAR(100), "
                        + "CONTENT CLOB, "
                        + "PUBLISHED_DATE DATE, "
                        + "COVER_IMG VARCHAR(255), "
                        + "ISBN VARCHAR(20))");
                boolean ebooksNew = createTable(st,
                        "CREATE TABLE EBOOKS ("
                        + "ID INTEGER NOT NULL PRIMARY KEY, "
                        + "TITLE VARCHAR(100) NOT NULL, "
                        + "AUTHOR VARCHAR(100) NOT NULL, "
                        + "GENRE VARCHAR(100) NOT NULL, "
                        + "C_PDF VARCHAR(255), "
                        + "COVER_IMG VARCHAR(255))");

                if (!usersNew) {
                    // older databases may have a short PASSWORD column - widen it so hashes fit
                    try {
                        st.executeUpdate("ALTER TABLE USERS ALTER COLUMN PASSWORD SET DATA TYPE VARCHAR(255)");
                    } catch (SQLException ignore) {
                    }
                }
                if (usersNew) {
                    seedUsers(con);
                }
                if (ebooksNew) {
                    seedEbooks(con);
                }
                if (bookNew) {
                    seedBooks(con);
                }
            } finally {
                close(st);
            }
            schemaReady = true;
        }
    }

    /** @return true if the table was created, false if it already existed */
    private static boolean createTable(Statement st, String ddl) throws SQLException {
        try {
            st.executeUpdate(ddl);
            return true;
        } catch (SQLException e) {
            if ("X0Y32".equals(e.getSQLState())) {   // table already exists
                return false;
            }
            throw e;
        }
    }

    private static void seedUsers(Connection con) throws SQLException {
        PreparedStatement ps = con.prepareStatement("INSERT INTO USERS (USERNAME, EMAIL, PASSWORD) VALUES (?,?,?)");
        try {
            ps.setString(1, "demo");
            ps.setString(2, "demo@example.com");
            ps.setString(3, PasswordUtil.hash("demo123"));
            ps.executeUpdate();
        } finally {
            close(ps);
        }
    }

    private static void seedEbooks(Connection con) throws SQLException {
        String[][] rows = {
            {"1", "Atomic Habits", "James Clear", "Self-Help",
                "Atomic Habits James Clear.pdf", "Screenshot 2024-09-19 195650.png"},
            {"2", "Book of Wisdom", "Advanced Society of Paranormal Studies", "Philosophy",
                "Book-Of-Wisdom.pdf", "BookOfWisdom.jpg"},
            {"3", "Dark Clouds Over Salty Shores", "E.J. Masters", "Mystery",
                "Dark-Clouds-Over-Salty-Shores.pdf", "saltyshores.jpg"},
            {"4", "Smart Strategies: AI Tools for Sales and Marketing Excellence", "Tadeusz Murawski", "Business",
                "Smart-Strategies-AI-Tools-for-Sales-and-Marketing-Excellence.pdf", "samrtai.jpg"},
            {"5", "The Burden of A Man", "Boygene Borice", "Romance",
                "The-Burden-of-A-Man.pdf", "burdenofman.jpg"}
        };
        PreparedStatement ps = con.prepareStatement(
                "INSERT INTO EBOOKS (ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG) VALUES (?,?,?,?,?,?)");
        try {
            for (String[] r : rows) {
                ps.setInt(1, Integer.parseInt(r[0]));
                ps.setString(2, r[1]);
                ps.setString(3, r[2]);
                ps.setString(4, r[3]);
                ps.setString(5, r[4]);
                ps.setString(6, r[5]);
                ps.executeUpdate();
            }
        } finally {
            close(ps);
        }
    }

    private static void seedBooks(Connection con) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
                "INSERT INTO BOOK (TITLE, AUTHOR, GENRE, CONTENT, PUBLISHED_DATE, COVER_IMG, ISBN) VALUES (?,?,?,?,?,?,?)");
        try {
            ps.setString(1, "Welcome to Your eBook Library");
            ps.setString(2, "EBook Management System");
            ps.setString(3, "Guide");
            ps.setString(4, "Welcome!\n\n"
                    + "This is a sample book stored in the BOOK table.\n\n"
                    + "  - Use 'Add Book' to create a new book.\n"
                    + "  - Use the Write icon in 'My Books' to type or edit the content of a book.\n"
                    + "  - Use the Read icon to read it here.\n"
                    + "  - Use the Delete icon to remove a book.\n\n"
                    + "Happy reading!");
            ps.setDate(5, java.sql.Date.valueOf("2024-09-01"));
            ps.setString(6, "bookcover.jpeg");
            ps.setString(7, "978-0000000001");
            ps.executeUpdate();

            ps.setString(1, "My First Story");
            ps.setString(2, "Demo User");
            ps.setString(3, "Fiction");
            ps.setNull(4, Types.CLOB);
            ps.setDate(5, java.sql.Date.valueOf("2024-09-15"));
            ps.setString(6, "OIP.jpg");
            ps.setNull(7, Types.VARCHAR);
            ps.executeUpdate();
        } finally {
            close(ps);
        }
    }
}
