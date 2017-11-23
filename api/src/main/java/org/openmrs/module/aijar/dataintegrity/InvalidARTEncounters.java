package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.openmrs.Patient;
import org.openmrs.Visit;
import org.openmrs.module.dataintegrity.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.springframework.stereotype.Component;

/**
 * Data integrity rules for the ART Summary page which are:
 * <ol>
 *  <li>Patients Without An ART Summary Page yet have Health Education and Encounters</li>
 *  <li>Patients With More Than One Summary Page</li>
 *  <li>Patients with ART summary page and no encounters</li>
 *  <li>Patients with more than one encounter on the same date</li>
 * </ol>
 */
@Component
public class InvalidARTEncounters extends BasePatientRuleDefinition {
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		
		ruleResults.addAll(patientsWithMoreThanOneSummaryARTPage());
		ruleResults.addAll(patientsWithEncountersAndNoSummaryPage());
		ruleResults.addAll(patientsWithSummaryPageAndNoEncounters());
		ruleResults.addAll(patientsWithMoreThanOneEncounterOnTheSameDate());
		return ruleResults;
	}
	
	/**
	 * Patients with more than one ART Summary Page
	 * @return
	 */
	private List<RuleResult<Patient>> patientsWithMoreThanOneSummaryARTPage() {
		log.info("Executing rule to find patients with more than one summary page");
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND e.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' GROUP BY e.patient.patientId HAVING COUNT(e.patient.patientId) > 1";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " patients with more than one summary page");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client #" + getHIVClinicNumber(patient) + " has more than one ART Summary Page");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients with ART Encounter and Health Education encounters but no ART summary page
	 * @return
	 */
	private List<RuleResult<Patient>> patientsWithEncountersAndNoSummaryPage() {
		log.info("Executing rule to find patients with encounters and no ART summary page");
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND ( e.encounterType.uuid = '8d5b2be0-c2cc-11de-8d13-0010c6dffd0f' OR e.encounterType.uuid = '6d88e370-f2ba-476b-bf1b-d8eaf3b1b67e') AND e.patient.patientId NOT IN (SELECT ee.patient.patientId FROM Encounter ee WHERE ee.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f') GROUP BY e.patient.patientId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " patients with encounters and no ART summary page");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client #" + getHIVClinicNumber(patient) + " has encounters but no ART Summary Page");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients with an ART Summary page but no ART Encounter or Health Education encounters
	 * @return
	 */
	private List<RuleResult<Patient>> patientsWithSummaryPageAndNoEncounters() {
		log.info("Executing rule to find patients with a summary page and no encounters");
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND ( e.encounterType.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' ) AND e.patient.patientId NOT IN (SELECT ee.patient.patientId FROM Encounter ee WHERE ee.encounterType.uuid = '8d5b2be0-c2cc-11de-8d13-0010c6dffd0f' OR e.encounterType.uuid = '6d88e370-f2ba-476b-bf1b-d8eaf3b1b67e') GROUP BY e.patient.patientId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " patients with an ART summary page and no encounters");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client #" + getHIVClinicNumber(patient) + " has an ART Summary page but no Encounter or Health Education");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients more than one ART encounter on the same day
	 * @return
	 */
	private List<RuleResult<Patient>> patientsWithMoreThanOneEncounterOnTheSameDate() {
		log.info("Executing rule to find patients with more than one encounters on a single date");
		String queryString = "SELECT visit FROM Encounter e GROUP BY e.encounterType.encounterTypeId, e.visit.visitId HAVING count(e.visit.visitId) > 1";
		
		Query query = getSession().createQuery(queryString);
		
		List<Visit> visitList = query.list();
		log.info("There are " + visitList.size() + " visits with more than one encounter page");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Visit visit : visitList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + visit.getPatient().getPatientId() + "&visitId=" + visit.getVisitId());
			ruleResult.setNotes("Client #" + getHIVClinicNumber(visit.getPatient()) + " has more than one encounter on " + getDateFormatter().format(visit.getStartDatetime()));
			ruleResult.setEntity(visit.getPatient());
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	@Override
	public DataIntegrityRule getRule() {
		DataIntegrityRule rule = new DataIntegrityRule();
		rule.setRuleCategory("patient");
		rule.setHandlerConfig("java");
		rule.setHandlerClassname(getClass().getName());
		rule.setRuleName("Invalid ART Encounter pages");
		rule.setUuid("c57c3b5a-9019-11e6-85aa-b75ca9392202");
		return rule;
	}
}
