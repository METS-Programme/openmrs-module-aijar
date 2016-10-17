package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
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
public class InvalidARTSummaryPage implements RuleDefn<Patient>  {
	
	private Log log = LogFactory.getLog(getClass());
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		
		ruleResults.addAll(patientsWithMoreThanOneSummaryARTPage());
		ruleResults.addAll(patientsWithEncountersAndNOSummaryPage());
		return ruleResults;
	}
	
	private List<RuleResult<Patient>> patientsWithMoreThanOneSummaryARTPage() {
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND e.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' GROUP BY e.patient.patientId HAVING COUNT(e.patient.patientId) > 1";
		
		Query query = getSessionFactory().openSession().createQuery(queryString);
		log.debug("Patients with encounters and no summary page query " + query.getQueryString());
		
		List<Patient> patientList = query.list();
		
		return patientToRuleResultTransformerForpatientsWithMoreThanOneSummaryPage(patientList, "More than one ART Summary Page");
	}
	
	private List<RuleResult<Patient>> patientsWithEncountersAndNOSummaryPage() {
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND ( e.encounterType.uuid = '8d5b2be0-c2cc-11de-8d13-0010c6dffd0f' OR e.encounterType.uuid = '6d88e370-f2ba-476b-bf1b-d8eaf3b1b67e') AND e.patient.patientId NOT IN (SELECT ee.patient.patientId FROM Encounter ee WHERE ee.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f') GROUP BY e.patient.patientId";
		
		Query query = getSessionFactory().openSession().createQuery(queryString);
		log.debug("Patients with encounters and no summary page query " + query.getQueryString());
		
		List<Patient> patientList = query.list();
		
		return patientToRuleResultTransformerForPatientWithNoSummaryPage(patientList, "Has encounters with No ART Summary Page");
	}
	
	private SessionFactory getSessionFactory() {
		return Context.getRegisteredComponent("sessionFactory", SessionFactory.class);
	}
	
	private List<RuleResult<Patient>> patientToRuleResultTransformerForpatientsWithMoreThanOneSummaryPage(List<Patient> patients, String notes) {
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patients) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes(notes);
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	private List<RuleResult<Patient>> patientToRuleResultTransformerForPatientWithNoSummaryPage(List<Patient> patients, String notes) {
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patients) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/clinicianfacing/patient.page?patientId=" + patient.getUuid());
			ruleResult.setNotes(notes);
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
}
