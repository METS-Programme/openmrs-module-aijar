package org.openmrs.module.aijar.tasks;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Context;
import org.openmrs.scheduler.tasks.AbstractTask;

import static org.openmrs.module.aijar.AijarConstants.UIC_GENERATOR_QUERY;

public class GenerateUniqueIdentifierCodeTask extends AbstractTask {
    private Log log = LogFactory.getLog(this.getClass());
    @Override
    public void execute() {
        log.info("method executing started");
        generateUICForPatientsWithout();
    }

    /*
    * This method generates Unique identification Code
    * for all patients that do not have that id
    * It is generated based on the person demographics
    * submitted during patient registration
    * This has been designed to run as an automatic task
    * that run once a day for any patient that may not have the UIC already existing */
    public void generateUICForPatientsWithout() {

        try {
            Context.getAdministrationService().executeSQL(UIC_GENERATOR_QUERY, false);

            log.info("UIC task executed successfully");
        }
        catch (Exception e) {
            log.error("Error updating UIC identifier for patients # " + e.getMessage(), e);
        }
    }

}

