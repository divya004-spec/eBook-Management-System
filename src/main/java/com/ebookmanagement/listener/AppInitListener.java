package com.ebookmanagement.listener;

import com.ebookmanagement.util.DBUtil;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

/**
 * Connects to the database when the application starts so that the tables and the
 * sample data are created immediately. A failure here never stops the deployment -
 * the connection is simply retried on the first request.
 */
public class AppInitListener implements ServletContextListener {

    private static final Logger LOG = Logger.getLogger(AppInitListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Connection con = null;
        try {
            con = DBUtil.getConnection();
            LOG.log(Level.INFO, "EBookMgmtSys started. Database: {0}", DBUtil.getModeDescription());
        } catch (Exception e) {
            LOG.log(Level.WARNING, "EBookMgmtSys: database not available at start-up ({0}). "
                    + "It will be retried on the first request.", e.getMessage());
        } finally {
            DBUtil.close(con);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DBUtil.shutdown();
    }
}
