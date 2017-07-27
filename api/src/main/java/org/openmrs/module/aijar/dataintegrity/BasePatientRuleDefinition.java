package org.openmrs.module.aijar.dataintegrity;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.openmrs.Concept;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifierType;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.dataintegrity.rule.RuleDefinition;

/**
 * Base class for RuleDefinitions
 */
public abstract class BasePatientRuleDefinition implements RuleDefinition<Patient> {
	
	protected Log log = LogFactory.getLog(getClass());
	
	/**
	 * Return the HIV Clinic number for the patient
	 * @param patient
	 * @return
	 */
	public String getHIVClinicNumber(Patient patient) {
		PatientService patientService = Context.getPatientService();
		PatientIdentifierType pit = patientService.getPatientIdentifierTypeByUuid(PatientIdentifierTypes.HIV_CARE_NUMBER.uuid());
		 return patient.getPatientIdentifier(pit) == null ? "" : patient.getPatientIdentifier(pit).toString();
	}
	
	/**
	 * Exposed Infant number for the patient
	 * @param patient
	 * @return
	 */
	public String getExposedInfantNumber(Patient patient) {
		PatientService patientService = Context.getPatientService();
		PatientIdentifierType pit = patientService.getPatientIdentifierTypeByUuid(PatientIdentifierTypes.EXPOSED_INFANT_NUMBER.uuid());
		return patient.getPatientIdentifier(pit) == null ? "" : patient.getPatientIdentifier(pit).toString();
	}

	/**
	 * TB number for the patient
	 * @param patient
	 * @return
	 */
	public String getTbNumber(Patient patient) { //To be done
		Program tbProgram = Context.getProgramWorkflowService().getProgramByUuid(Programs.TB_PROGRAM.uuid());

		//Iterate through the possible TB identifiers and return the first occurrence of a TB identifier 
		String[] tbIdentifierConceptUuids = new String[]{ AijarConstants.UNIT_TB_NUMBER, AijarConstants.HSD_TB_NUMBER, AijarConstants.DISTRICT_TB_NUMBER };
		for (String tbIdentifierConceptUuid : tbIdentifierConceptUuids) {
			Concept concept = Context.getConceptService().getConcept(tbIdentifierConceptUuid);
			List<Obs> patientObs = Context.getObsService().getObservationsByPersonAndConcept(patient.getPerson(), concept);
			if (patientObs.size() > 0) {
				for (Obs obs : patientObs) {
					if (obs.getValueText() != null ) {
						PatientProgram pp = Context.getProgramWorkflowService().getPatientPrograms(patient, tbProgram, null, null, null, null, false).get(0);
						Date treatmentStartDate = obs.getEncounter().getEncounterDatetime();
						
						//Compare the TB treatment start date with the TB program enrollment date. 
						//If the TB treatment date falls on or after the program enrollment date, consider this a current identifier 
						if (treatmentStartDate.equals(pp.getDateEnrolled()) || treatmentStartDate.after(pp.getDateEnrolled())){
							return obs.getValueText();
						}
					}
				}				
			}			
		}
		
		return "".toString();			
	}

	
	/**
	 * A Session instance used by sub-classes
	 * @return
	 */
	public Session getSession() {
		return Context.getRegisteredComponent("sessionFactory", SessionFactory.class).getCurrentSession();
	}
	
	/**
	 * A formatter for dates
	 * @return
	 */
	public DateFormat getDateFormatter() {
		return Context.getDateFormat();
	}
}
