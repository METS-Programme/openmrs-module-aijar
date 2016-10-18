package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataintegrity.db.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.springframework.stereotype.Component;

/**
 * Data integrity rules for the ART Summary page which are:
 * <ol>
 *  <li>Patients Without An ART Summary Page yet have Health Education and Encounters</li>
 *  <li>Patients With More Than One Summary Page</li>
 * </ol>
 */
@Component
public class InvalidARTSummaryPage extends BasePatientRuleDefinition {
	
	private Log log = LogFactory.getLog(getClass());
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		
		ruleResults.addAll(patientsWithMoreThanOneSummaryARTPage());
		ruleResults.addAll(patientsWithEncountersAndNOSummaryPage());
		return ruleResults;
	}
	
	/**
	 * Patients with more than one ART Summary Page
	 * @return
	 */
	private List<RuleResult<Patient>> patientsWithMoreThanOneSummaryARTPage() {
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND e.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' GROUP BY e.patient.patientId HAVING COUNT(e.patient.patientId) > 1";
		
		Query query = getSessionFactory().openSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client# " + getHIVClinicNumber(patient) + ", more than one ART Summary Page");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients with ART Encounter and Health Education encounters but no ART summary page
	 * @return
	 */
	private List<RuleResult<Patient>> patientsWithEncountersAndNOSummaryPage() {
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND ( e.encounterType.uuid = '8d5b2be0-c2cc-11de-8d13-0010c6dffd0f' OR e.encounterType.uuid = '6d88e370-f2ba-476b-bf1b-d8eaf3b1b67e') AND e.patient.patientId NOT IN (SELECT ee.patient.patientId FROM Encounter ee WHERE ee.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f') GROUP BY e.patient.patientId";
		
		Query query = getSessionFactory().openSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client# " + getHIVClinicNumber(patient) + ", no ART Summary Page");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	private SessionFactory getSessionFactory() {
		return Context.getRegisteredComponent("sessionFactory", SessionFactory.class);
	}
	
	@Override
	public DataIntegrityRule getRule() {
		DataIntegrityRule rule = new DataIntegrityRule();
		rule.setRuleCategory("patient");
		rule.setHandlerConfig("java");
		rule.setHandlerClassname(getClass().getName());
		rule.setRuleName("Invalid ART Summary Pages");
		rule.setUuid("c57c3b5a-9019-11e6-85aa-b75ca9392202");
		return rule;
	}
}
