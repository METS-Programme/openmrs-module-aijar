package org.openmrs.module.aijar.tasks;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.scheduler.tasks.AbstractTask;

import static org.openmrs.module.aijar.AijarConstants.UIC_GENERATOR_QUERY;

public class GenerateUniqueIdentifierCodeTask extends AbstractTask {
    private Log log = LogFactory.getLog(this.getClass());
    private AijarService aijarService  = Context.getService(AijarService.class);;

    @Override
    public void execute() {
        log.info("method executing started");
     aijarService.generateUICForPatientsWithout();
    }

}

