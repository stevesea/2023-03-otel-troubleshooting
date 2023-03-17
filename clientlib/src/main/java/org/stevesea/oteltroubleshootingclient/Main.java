
package org.stevesea.oteltroubleshootingclient;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;

public class Main {
    static Logger logger = Logger.getLogger("org.stevesea.oteltroubleshootingclient");

    public static void main(String[] args) {

        // Set up a simple configuration that logs on the console.
        BasicConfigurator.configure();

        myFunction();
    }


    public static void myFunction() {

        logger.info("log message from log4j1 client library");


    }
}
