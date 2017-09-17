package org.openmrs.module.aijar.activator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.AdministrationService;
import org.openmrs.module.aijar.api.AijarService;

import javax.naming.Context;

import static org.openmrs.module.aijar.AijarConstants.*;
import static org.openmrs.module.aijar.AijarConstants.GP_DHIS2_DEFAULT_ALERT_MESSAGE;
import static org.openmrs.module.aijar.AijarConstants.GP_DHIS2_VALUE;

public class AlertConfigurationInitializer implements Initializer{
    protected Log log = LogFactory.getLog(AlertConfigurationInitializer.class);
    @Override
    public void started() {
        AdministrationService administrationService= org.openmrs.api.context.Context.getAdministrationService();
        AijarService aijarService= org.openmrs.api.context.Context.getService(AijarService.class);
        // set alert if National Health Provider Identifier is not set
        if (administrationService.getGlobalProperty(GP_NHPI).equalsIgnoreCase(GP_NHPI_VALUE)) {
            aijarService.setAlertForAllUsers(GP_NHPI_DEFAULT_ALERT_MESSAGE);
            log.info("Creating alert "+GP_NHPI_DEFAULT_ALERT_MESSAGE);
        }

        // set alert if Health Center Name is not set
        if (administrationService.getGlobalProperty(GP_HEALTH_CENTER_NAME).equalsIgnoreCase(GP_HEALTH_CENTER_NAME_VALUE)) {
            aijarService.setAlertForAllUsers(GP_HEALTH_CENTER_NAME_DEFAULT_ALERT_MESSAGE);
            log.info("Creating alert "+GP_HEALTH_CENTER_NAME_DEFAULT_ALERT_MESSAGE);
        }
        // set alert if DHIS2 Organization UUID is not set
        if (administrationService.getGlobalProperty(GP_DHIS2).equalsIgnoreCase(GP_DHIS2_VALUE)) {
            aijarService.setAlertForAllUsers(GP_DHIS2_DEFAULT_ALERT_MESSAGE);
            log.info("Creating alert "+GP_DHIS2_DEFAULT_ALERT_MESSAGE);
        }
    }

    @Override
    public void stopped() {

    }
}
