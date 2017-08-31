package org.openmrs.module.aijar.dataintegrity;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifierType;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.module.dataintegrity.rule.RuleDefinition;

/**
 * Base class for RuleDefinitions
 */
public abstract class BasePatientRuleDefinition implements RuleDefinition<Patient> {
	
	
	protected Log log = LogFactory.getLog(getClass());
	
	/**
	 * Return the HIV Clinic number for the patient
	 * 
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
	 * 
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
	 * 
	 * @param patient
	 * @return
	 */
	public String getTbNumber(Patient patient, Encounter encounter, String identifierConceptUuid) { //To be done
		
		//Iterate through the possible TB identifiers and return the first occurrence of a TB identifier 
		ArrayList<String> tbIdentifierConceptUuids = new ArrayList<String>();
		if (identifierConceptUuid == null || identifierConceptUuid.length() == 0 ) {
			tbIdentifierConceptUuids.add(AijarConstants.UNIT_TB_NUMBER);
			tbIdentifierConceptUuids.add(AijarConstants.HSD_TB_NUMBER);
			tbIdentifierConceptUuids.add(AijarConstants.DISTRICT_TB_NUMBER);
		}
		else{
			tbIdentifierConceptUuids.add(identifierConceptUuid);
		}
		
		for (String tbIdentifierConceptUuid : tbIdentifierConceptUuids) {
			
			Concept tbIdentifierConcept = Context.getConceptService().getConceptByUuid(tbIdentifierConceptUuid);
			
			Set<Obs> patientObs = encounter.getObs();
			
			for (Obs obs : patientObs) {
				
				if (obs.getConcept().equals(tbIdentifierConcept)) {
					
					if (obs.getValueText() != null) {
						
						return obs.getValueText();
						
					}
					
				}
				
			}
			
		}
		
		String openmrsId = getOpenMrsId(patient);
		
		return openmrsId;
	}
	
	/**
	 * OpenMRS Id for the patient
	 * 
	 * @param patient
	 * @return
	 */
	public String getOpenMrsId(Patient patient) { //To be done
		
		PatientService patientService = Context.getPatientService();
		PatientIdentifierType pit = patientService.getPatientIdentifierTypeByUuid(PatientIdentifierTypes.OPENMRS_ID.uuid());

		return patient.getPatientIdentifier(pit) == null ? "" : patient.getPatientIdentifier(pit).toString();		
	}	
	
	/**
	 * A Session instance used by sub-classes
	 * 
	 * @return
	 */
	public Session getSession() {
		return Context.getRegisteredComponent("sessionFactory", SessionFactory.class).getCurrentSession();
	}
	
	/**
	 * A formatter for dates
	 * 
	 * @return
	 */
	public DateFormat getDateFormatter() {
		return Context.getDateFormat();
	}
}
