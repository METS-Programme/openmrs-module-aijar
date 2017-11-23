package org.openmrs.module.aijar.activator;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.GlobalProperty;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.Module;
import org.openmrs.module.ModuleFactory;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.appframework.service.AppFrameworkService;
import org.openmrs.module.emrapi.EmrApiConstants;
import org.openmrs.scheduler.SchedulerService;
import org.openmrs.scheduler.TaskDefinition;
import org.openmrs.scheduler.tasks.AutoCloseVisitsTask;

/**
 * Custom application configurations
 */
public class AppConfigurationInitializer implements Initializer {
	
	protected Log log = LogFactory.getLog(getClass());
	
	@Override
	public void started() {
		log.info("Setting administrative configurations for " + AijarConstants.MODULE_ID);
		
		SchedulerService schedulerService = Context.getSchedulerService();

		try {
			// set the AutoClose visits tasks to start automatically
			TaskDefinition autoCloseVisitsTask = (TaskDefinition) schedulerService.getTaskByName("Auto Close Visits Task");
			autoCloseVisitsTask.setStartOnStartup(true);
			schedulerService.saveTaskDefinition(autoCloseVisitsTask);
			
			// check the Database Backup Task
			TaskDefinition backupDatabase = (TaskDefinition) schedulerService.getTaskByName("Database Backup Task");
			 if (backupDatabase != null) {
				 // only execute if the task exists
				 backupDatabase.setStartOnStartup(true);
				 SimpleDateFormat sdf = new SimpleDateFormat("yyyy MMM dd HH:mm:ss");
				 Calendar taskDefinitionCalendar = new GregorianCalendar(2016, 8, 28, 23, 59, 59);
				 Calendar ugandaEMRCalendar = new GregorianCalendar(2016, 8, 28, 15, 59, 59);
				 
				 // change the start date
				 if(sdf.format(taskDefinitionCalendar.getTime()).equals(sdf.format(backupDatabase.getStartTime()))) {
					 // set it to the new time for Uganda
					 backupDatabase.setStartTime(ugandaEMRCalendar.getTime());
					 log.info("UgandaEMR backup time set");
				 }
				 schedulerService.saveTaskDefinition(backupDatabase);
				 log.info("Database Backup Task set to start on Startup");
			 }
 		}
		catch (Exception e) {
			log.error("Failed to setup scheduled tasks ", e);
		}
		
	}
	
	@Override
	public void stopped() {
		
	}
}
