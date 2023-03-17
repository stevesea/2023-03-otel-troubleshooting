package org.stevesea.oteltroubleshootingsvr;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.stevesea.oteltroubleshootingclient.Main;

@SpringBootApplication
public class OtelTroubleshootingSvrApplication {

	private static final Logger logger = LogManager.getLogger(OtelTroubleshootingSvrApplication.class);

	public static void main(String[] args) {

		logger.info("in Main");

		Main.myFunction();

		SpringApplication.run(OtelTroubleshootingSvrApplication.class, args);
	}

}
