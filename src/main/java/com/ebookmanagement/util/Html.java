package com.ebookmanagement.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/** Small helpers used by the JSP pages. */
public final class Html {

    /** Image shown when a book has no cover. */
    public static final String DEFAULT_COVER = "images/bookcover.jpeg";

    private Html() {
    }

    /** Escapes text so it can be safely printed inside HTML (prevents XSS). */
    public static String esc(Object value) {
        if (value == null) {
            return "";
        }
        String s = String.valueOf(value);
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&':
                    sb.append("&amp;");
                    break;
                case '<':
                    sb.append("&lt;");
                    break;
                case '>':
                    sb.append("&gt;");
                    break;
                case '"':
                    sb.append("&quot;");
                    break;
                case '\'':
                    sb.append("&#39;");
                    break;
                default:
                    sb.append(c);
            }
        }
        return sb.toString();
    }

    /** Returns the value, or the given default when it is null / blank. */
    public static String nz(String value, String def) {
        return (value == null || value.trim().length() == 0) ? def : value;
    }

    /**
     * URL-encodes a relative path (each segment separately, "/" is kept) so file names with
     * spaces or brackets such as "OIP(2).jpg" or "Atomic Habits James Clear.pdf" work in href/src.
     */
    public static String url(String path) {
        if (path == null) {
            return "";
        }
        String[] parts = path.split("/", -1);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            if (i > 0) {
                sb.append('/');
            }
            try {
                sb.append(URLEncoder.encode(parts[i], "UTF-8").replace("+", "%20"));
            } catch (UnsupportedEncodingException e) {
                sb.append(parts[i]);
            }
        }
        return sb.toString();
    }

    /**
     * Builds the (already escaped) value for an img src attribute from the COVER_IMG column.
     * Accepts "file.jpg", "images/file.jpg" or a full http(s) URL; falls back to a default cover.
     */
    public static String cover(String coverImg) {
        String c = coverImg == null ? "" : coverImg.trim();
        if (c.length() == 0 || "null".equalsIgnoreCase(c)) {
            return esc(DEFAULT_COVER);
        }
        String lower = c.toLowerCase();
        if (lower.startsWith("http://") || lower.startsWith("https://")) {
            return esc(c);
        }
        c = c.replace('\\', '/');
        while (c.startsWith("/")) {
            c = c.substring(1);
        }
        if (c.toLowerCase().startsWith("images/")) {
            c = c.substring("images/".length());
        }
        if (c.indexOf("..") >= 0) {
            return esc(DEFAULT_COVER);
        }
        return esc("images/" + url(c));
    }

    /** Parses an int request parameter, returns -1 when missing / invalid. */
    public static int toId(String value) {
        if (value == null) {
            return -1;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}
