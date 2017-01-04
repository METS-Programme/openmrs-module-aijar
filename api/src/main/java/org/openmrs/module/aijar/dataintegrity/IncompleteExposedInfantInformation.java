package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.openmrs.Patient;
import org.openmrs.module.dataintegrity.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.springframework.stereotype.Component;

/**
 * Incomplete information for Exposed Infants
 *
 * <ol>
 *     <li>EID with Encounters and no summary page</li>
 *     <li>EID with summary page and no encounters</li>
 * <li>No final outcome at 2 years of age</li>
 * <li>TODO: Missing PCR tests after enrollment</li>
 * </ol>
 *
 * */
@Component
public class IncompleteExposedInfantInformation extends BasePatientRuleDefinition {
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		
		ruleResults.addAll(exposedInfantsWithEncountersAndNOSummaryPage());
		ruleResults.addAll(exposedInfantsWithSummaryPageNoEncounters());
		ruleResults.addAll(exposedInfantsOlderThan18MonthsWithNoFinalOutcome());
		return ruleResults;
	}
	
	/**
	 * Exposed infants with Encounters but no summary page
	 * @return
	 */
	private List<RuleResult<Patient>> exposedInfantsWithEncountersAndNOSummaryPage() {
		log.info("Executing rule to find exposed infants with encounters but no summary page");
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND ( e.encounterType.uuid = '4345dacb-909d-429c-99aa-045f2db77e2b') AND e.patient.patientId NOT IN (SELECT ee.patient.patientId FROM Encounter ee WHERE ee.encounterType.uuid = '9fcfcc91-ad60-4d84-9710-11cc25258719') GROUP BY e.patient.patientId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " exposed infants with encounters and no Summary page");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Exposed Infant # " + getExposedInfantNumber(patient) + " has no Summary Page");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Exposed infants with Summary page but no encounters
	 * @return
	 */
	private List<RuleResult<Patient>> exposedInfantsWithSummaryPageNoEncounters() {
		log.info("Executing rule to find exposed infants a summary page and no encounters");
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND ( e.encounterType.uuid = '9fcfcc91-ad60-4d84-9710-11cc25258719') AND e.patient.patientId NOT IN (SELECT ee.patient.patientId FROM Encounter ee WHERE ee.encounterType.uuid =  '4345dacb-909d-429c-99aa-045f2db77e2b') GROUP BY e.patient.patientId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " exposed infants with a summary page and no encounters");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Exposed Infant # " + getExposedInfantNumber(patient) + " has no Encounters");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Exposed infants older than 2 years with Summary page but no final outcome
	 * @return
	 */
	private List<RuleResult<Patient>> exposedInfantsOlderThan18MonthsWithNoFinalOutcome() {
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND e.encounterType.uuid = '9fcfcc91-ad60-4d84-9710-11cc25258719' AND e.patient.age >= 2 AND e.patient.patientId NOT IN (SELECT o.patient.patientId FROM Obs o WHERE o.voided = false AND o.concept.conceptId = 99428))";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?formUuid=860c5f2f-cf3c-4c3f-b0c4-9958b6a5a938&patientId=" + patient.getUuid());
			ruleResult.setNotes("Exposed Infant # " + getExposedInfantNumber(patient) + " is over 18 months with no final outcome");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Exposed infants missing 1st DNA PCR after 6 weeks of enrollment
	 * @return
	 */
	private List<RuleResult<Patient>> exposedInfantsWithoutFirstDNAPCRWhenEnrolledBefore6Weeks() {
		String queryString = "SELECT patient FROM Encounter e WHERE e.voided = false AND e.encounterType.uuid = '9fcfcc91-ad60-4d84-9710-11cc25258719' AND e.patient.age >= 2 AND e.patient.patientId NOT IN (SELECT o.patient.patientId FROM Obs o WHERE o.voided = false AND o.concept.conceptId = 99428))";
		
		Query query = getSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?formUuid=860c5f2f-cf3c-4c3f-b0c4-9958b6a5a938&patientId=" + patient.getUuid());
			ruleResult.setNotes("Exposed Infant # " + getExposedInfantNumber(patient) + " is over 18 months with no final outcome");
			ruleResult.setEntity(patient);
			
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
		rule.setRuleName("Incomplete Exposed Infant information");
		rule.setUuid("e0e6cb8d-8492-4bed-bf3f-08a3ecf3bedb");
		return rule;
	}
}
