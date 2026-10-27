# EBook Management System - Apache NetBeans 31 edition
Maven web application, Jakarta EE 10 (`jakarta.*`), Java 17+ (NetBeans 31 itself runs on JDK 21+).

## Run it
1. Install **JDK 21** (or newer) and Apache NetBeans 31, and a Jakarta EE server:
   **Apache Tomcat 10.1 / 11**, **GlassFish 7 / 8** or **Payara 6+**
   (NetBeans: *Services > Servers > Add Server*).
2. **File > Open Project...** and select this folder (`EBookMgmtSys`, it shows the Maven icon).
   The first open downloads the dependencies from Maven Central, so an internet connection is needed once.
3. Right-click the project > **Run**. When asked for a server, choose the one from step 1.
4. Open `http://localhost:8080/EBookMgmtSys/`.

**Login:** `demo` / `demo123`, or use *Register* to create an account.

## Database - nothing to install
On start-up the app creates database `Divya` and the tables `USERS`, `BOOK`, `EBOOKS` with sample data.
* If a Derby server is running on `localhost:1527` (user `root` / password `root`) it is used.
* Otherwise an **embedded Derby database** is created in `~/EBookMgmtSys-db` automatically.
(NetBeans 31 no longer bundles Java DB, so the embedded mode is the normal case.)
Force a mode with the JVM option `-Debook.db.mode=network` or `-Debook.db.mode=embedded`.
`database/schema.sql` holds the same tables if you want to create them manually.

## Build a WAR without the IDE
`mvn clean package` -> `target/EBookMgmtSys.war` (copy it into the server's `webapps`/`autodeploy` folder).

## Features
Landing page, register / login / logout, dashboard, PDF library with search + online reader + download,
"My Library" (add, write, read, delete books with text), all pages behind a login filter.

## Troubleshooting
* *Wrong server type* - the project needs a **Jakarta** (EE 10+) server. Tomcat 9 / GlassFish 5 / 6 use the old `javax` packages and will not work.
* *Port 8080 busy* - stop the other server or change the port in the server settings.
* *Derby server on JDK 17+* - start it with the `-noSecurityManager` option.
