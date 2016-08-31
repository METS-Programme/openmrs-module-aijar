package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataintegrity.rule.RuleDefn;
import org.openmrs.module.dataintegrity.rule.RuleResult;

/**
 * Data integrity rules for the ART Summary page which are:
 * <ol>
 *  <li>Patients Without An ART Summary Page yet have Health Education and Encounters</li>
 *  <li>Patients With More Than One Summary Page</li>
 * </ol>
 */
public class InvalidARTSummaryPage implements RuleDefn<Patient> {
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		
		ruleResults.addAll(patientsWithMoreThanOneSummaryPage());
		return ruleResults;
	}
	
	private List<RuleResult<Patient>> patientsWithMoreThanOneSummaryPage() {
		String queryString = "select patient from encounter e INNER JOIN encounter_type et ON e.encounter_type = et"
				+ ".encounter_type_id where e.voided = false and et.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' GROUP BY "
				+ "e.patient_id HAVING COUNT(e.patient_id) > 1 ";
		
		Query query = getSessionFactory().getCurrentSession().createQuery(queryString.toString());
		
		List<Patient> patientList = query.list();
		
		return patientToRuleResultTransformer(patientList, "Patient with more than one ART Summary Page");
		
	}
	
	private SessionFactory getSessionFactory() {
		return Context.getRegisteredComponent("sessionFactory", SessionFactory.class);
	}
	
	private List<RuleResult<Patient>> patientToRuleResultTransformer(List<Patient> patients, String notes) {
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patients) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("");
			ruleResult.setNotes(notes);
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
}
