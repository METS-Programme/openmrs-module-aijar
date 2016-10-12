package org.openmrs.module.aijar.activator;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.io.IOExceptionWithCause;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.dataintegrity.InvalidARTSummaryPage;
import org.openmrs.module.dataintegrity.DataintegrityService;
import org.openmrs.module.dataintegrity.db.DataintegrityRule;
import org.openmrs.module.reporting.report.manager.ReportManager;

/**
 * Initialize the Data Integrity rules
 */
public class DataIntegrityRuleInitializer implements Initializer {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Override
	public void started() {
		log.info("Initializing Data Integrity validation rules");
		DataintegrityService dis = Context.getRegisteredComponent("dataintegrityService", DataintegrityService.class);
		
		if (dis == null) {
			// the Dataintegrity service not available
			log.info("Dataintegrity service is not available");
			return;
		}
		Iterator i = Context.getRegisteredComponents(DataintegrityRule.class).iterator();
		if (i == null) {
			log.info("No data integrity rules registerd in Context");
			return;
		}
		
		while(i.hasNext()) {
			DataintegrityRule rule = (DataintegrityRule) i.next();
			dis.saveRule(rule);
			log.info("Saving rule " + rule.getRuleName() + " uuid: " + rule.getUuid());
		}
	}
	
	@Override
	public void stopped() {
		
	}
	
}
