package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.module.dataintegrity.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.springframework.stereotype.Component;

/**
 * Incomplete ART information data
 *
 * <ol>
 * <li>Patients with ART regimen but no ART Start date</li>
 * <li>Encounters with other ART regimen to be cleaned out</li>
 * <li>Encounters without ART regimen after ART start date</li>
 * </ol>
 *
 * */
@Component
public class IncompleteARTInformation extends BasePatientRuleDefinition {
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		ruleResults.addAll(patientsOnARTWithoutARTStartDate());
		ruleResults.addAll(patientsOnARTWithoutStartRegimen());
		ruleResults.addAll(patientsOnARTWithOtherRegimen());
		
		return ruleResults;
	}
	
	/**
	 * Patients on ART without an ART start date
	 * @return
	 */
	private List<RuleResult<Patient>> patientsOnARTWithoutARTStartDate() {
		log.info("Executing rule to find patients on ART without ART start date");
		String queryString = "SELECT o.encounter from Obs o join o.person as patient WHERE o.voided = false AND o.concept.conceptId = 90315 AND o.person.dead=0 AND o.person.personId NOT IN (SELECT oo.person.personId FROM Obs oo WHERE oo.voided = false AND oo.concept.conceptId = 99161) GROUP BY o.person.personId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Encounter> encounterList = query.list();
		log.info("There are " + encounterList.size() + " patients on ART without an ART start date");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Encounter encounter : encounterList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			String actionUrl = "htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?formUuid=52653a60-8300-4c13-be4d-4b746da06fee&patientId=" + encounter.getPatient().getPatientId();
			if (encounter.getVisit() != null) {
				actionUrl = actionUrl +"&visitId=" + encounter.getVisit().getId();
			}
			ruleResult.setActionUrl(actionUrl);
			ruleResult.setNotes("Client #" + getHIVClinicNumber(encounter.getPatient()) + " has no ART Start Date");
			ruleResult.setEntity(encounter.getPatient());
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients on ART without an Start Regimen
	 * @return
	 */
	private List<RuleResult<Patient>> patientsOnARTWithoutStartRegimen() {
		log.info("Executing rule to find patients on ART without start regimen");
		String queryString = "SELECT o.encounter from Obs o join o.person as patient WHERE o.voided = false AND o.person.dead=0 AND o.concept.conceptId = 90315 AND o.person.personId NOT IN (SELECT oo.person.personId FROM Obs oo WHERE oo.voided = false AND oo.concept.conceptId = 99161) GROUP BY o.person.personId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Encounter> encounterList = query.list();
		log.info("There are " + encounterList.size() + " patients on ART without a start regimen");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Encounter encounter : encounterList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			String actionUrl = "htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?formUuid=52653a60-8300-4c13-be4d-4b746da06fee&patientId=" + encounter.getPatient().getPatientId();
			if (encounter.getVisit() != null) {
				actionUrl = actionUrl +"&visitId=" + encounter.getVisit().getId();
			}
			ruleResult.setActionUrl(actionUrl);
			ruleResult.setNotes("Client #" + getHIVClinicNumber(encounter.getPatient()) + " has no Baseline Regimen at start of ART");
			ruleResult.setEntity(encounter.getPatient());
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients on ART without Other Regimen
	 * @return
	 */
	private List<RuleResult<Patient>> patientsOnARTWithOtherRegimen() {
		log.info("Executing rule to find patients on ART with Other as a regimen");
		String queryString = "SELECT o.encounter from Obs o WHERE o.voided = false AND o.person.dead=0 AND o.concept.conceptId = 90315 AND o.valueCoded.conceptId = 90002 GROUP BY o.person.personId";
		
		Query query = getSession().createQuery(queryString);
		
		List<Encounter> encounterList = query.list();
		log.info("There are " + encounterList.size() + " patients on ART with other as regimen");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Encounter encounter : encounterList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			Patient patient = encounter.getPatient();
			// link to the Encounter page
			String actionUrl = "htmlformentryui/htmlform/editHtmlFormWithStandardUi.page?formUuid=12de5bc5-352e-4faf-9961-a2125085a75c&encounterId=" + encounter.getEncounterId() + "&patientId=" + patient.getId();
			if (encounter.getVisit() != null) {
				actionUrl = actionUrl + "&visitId=" + encounter.getVisit().getId();
			}
			ruleResult.setActionUrl(actionUrl);
			ruleResult.setNotes("Client #" + getHIVClinicNumber(patient) + " has ART regimen Other for visit on " + encounter.getEncounterDatetime());
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
		rule.setRuleName("Incomplete ART Information");
		rule.setUuid("cff2fc9e-329c-4c08-a432-e90b428268e3");
		return rule;
	}
}
