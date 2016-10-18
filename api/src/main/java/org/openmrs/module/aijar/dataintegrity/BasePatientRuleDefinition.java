package org.openmrs.module.aijar.dataintegrity;

import org.openmrs.Patient;
import org.openmrs.PatientIdentifierType;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.module.dataintegrity.db.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleDefinition;
import org.openmrs.module.dataintegrity.rule.BaseRuleDefinition;

/**
 * Base class for RuleDefinitions
 */
public abstract class BasePatientRuleDefinition implements RuleDefinition<Patient>, BaseRuleDefinition {
	
	/**
	 * Return the HIV Clinic number for the patient
	 * @param patient
	 * @return
	 */
	public String getHIVClinicNumber(Patient patient) {
		PatientService patientService = Context.getPatientService();
		PatientIdentifierType pit = patientService.getPatientIdentifierTypeByUuid(PatientIdentifierTypes.HIV_CARE_NUMBER.uuid());
		 return patient.getPatientIdentifier(pit).toString();
	}
}
