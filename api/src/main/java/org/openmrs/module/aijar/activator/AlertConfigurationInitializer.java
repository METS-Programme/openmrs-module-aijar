package org.openmrs.module.aijar.activator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.GlobalProperty;
import org.openmrs.api.AdministrationService;
import org.openmrs.module.aijar.api.AijarService;

import javax.naming.Context;

import static org.openmrs.module.aijar.AijarConstants.*;
import static org.openmrs.module.aijar.AijarConstants.GP_DHIS2_DEFAULT_ALERT_MESSAGE;
import static org.openmrs.module.aijar.AijarConstants.GP_DHIS2_VALUE;

public class AlertConfigurationInitializer implements Initializer {
    protected Log log = LogFactory.getLog(AlertConfigurationInitializer.class);

    @Override
    public void started() {


        // set alert if National Health Provider Identifier is not set
        createAlertWhenDefaultIsNotSet(GP_NHPI, GP_NHPI_VALUE, GP_NHPI_DEFAULT_ALERT_MESSAGE);
        // set alert if Health Center Name is not set
        createAlertWhenDefaultIsNotSet(GP_HEALTH_CENTER_NAME, GP_HEALTH_CENTER_NAME_VALUE, GP_HEALTH_CENTER_NAME_DEFAULT_ALERT_MESSAGE);
        // set alert if DHIS2 Organization UUID is not set
        createAlertWhenDefaultIsNotSet(GP_DHIS2, GP_DHIS2_VALUE, GP_DHIS2_DEFAULT_ALERT_MESSAGE);
    }

    @Override
    public void stopped() {

    }

    /**
     * @param globalPropertyName
     * @param globalPropertyDefault
     * @param messageAlert
     */
    private void createAlertWhenDefaultIsNotSet(String globalPropertyName, String globalPropertyDefault, String messageAlert) {
        AijarService aijarService = org.openmrs.api.context.Context.getService(AijarService.class);
        AdministrationService administrationService = org.openmrs.api.context.Context.getAdministrationService();
        GlobalProperty globalProperty = new GlobalProperty();
        globalProperty = administrationService.getGlobalPropertyObject(globalPropertyName);
        if (globalProperty.getPropertyValue() == null) {
            aijarService.setAlertForAllUsers(messageAlert);
            log.info("Creating alert " + messageAlert);
        } else {
            if (globalProperty.getPropertyValue().equalsIgnoreCase(globalPropertyDefault)) {
                aijarService.setAlertForAllUsers(messageAlert);
                log.info("Creating alert " + messageAlert);
            }
        }
    }
}
