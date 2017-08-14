package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;
import org.joda.time.DateTime;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.metadata.core.EncounterTypes;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.dataintegrity.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.springframework.stereotype.Component;

/**
 * Data integrity rules for the TB page which are:
 * <ol>
 *  <li>Patients with missing TB identifiers</li>
 *  <li>Patients with similar TB identifiers</li>
 *  <li>Patients with no final outcome after 9 months at start of treatment </li>
 * </ol>
 */
@Component
public class InvalidTBEncounters extends BasePatientRuleDefinition {



	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		
		ruleResults.addAll(patientsWithMissingTBNumbers(AijarConstants.UNIT_TB_NUMBER, "Unit TB Number"));
		ruleResults.addAll(patientsWithMissingTBNumbers(AijarConstants.HSD_TB_NUMBER, "HSD TB Number"));
		ruleResults.addAll(patientsWithMissingTBNumbers(AijarConstants.DISTRICT_TB_NUMBER, "District TB Number"));
		ruleResults.addAll(singlePatientWithDuplicateTBNumberAcrossMultipleTreatmentPrograms(AijarConstants.DISTRICT_TB_NUMBER, "District TB Number"));
		ruleResults.addAll(singlePatientWithDuplicateTBNumberAcrossMultipleTreatmentPrograms(AijarConstants.UNIT_TB_NUMBER, "Unit TB Number"));
		ruleResults.addAll(singlePatientWithDuplicateTBNumberAcrossMultipleTreatmentPrograms(AijarConstants.HSD_TB_NUMBER, "HSD TB Number"));
		ruleResults.addAll(multiplePatientsWithTheSameTBIdentifiers(AijarConstants.DISTRICT_TB_NUMBER, "District TB Number"));
		ruleResults.addAll(multiplePatientsWithTheSameTBIdentifiers(AijarConstants.UNIT_TB_NUMBER, "Unit TB Number"));
		ruleResults.addAll(multiplePatientsWithTheSameTBIdentifiers(AijarConstants.HSD_TB_NUMBER, "HSD TB Number"));
		ruleResults.addAll(patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment(DateTime.now()));
		return ruleResults;
	}

	/**
	 * Patients with similar TB identifiers: duplicated across multiple patients
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> multiplePatientsWithTheSameTBIdentifiers(String identifierConceptUuid, String identifierTitle) {
		log.info("Executing rule to find Patients with similar TB identifiers: duplicated across multiple patients");
		String queryString = "SELECT obs FROM Obs obs WHERE obs.obsId IN ("
				+ "SELECT min(o.obsId) FROM Obs o WHERE o.voided = false AND o.encounter.patient.dead = 0 AND o.encounter.voided = 0 AND o.concept.uuid = :identifierConceptUuid AND o.valueText IN " 
				+ " (SELECT ob.valueText FROM Obs ob WHERE ob.concept.uuid = :identifierConceptUuid AND ob.voided = 0 GROUP BY ob.concept.conceptId, ob.valueText HAVING COUNT(ob.valueText) > 1)" 
				+ " GROUP BY o.person.personId, o.concept.id, o.valueText HAVING count(*) = 1)"; 
		Query query = getSession().createQuery(queryString);
		query.setParameter("identifierConceptUuid", identifierConceptUuid);
		
		List<Obs> obsList = query.list();
		Set<Patient> uniquePatientList = new HashSet<Patient>();
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Obs obs : obsList) {
			Patient patient = obs.getEncounter().getPatient();
			
			RuleResult<Patient> ruleResult = new RuleResult<>();
			
			if (uniquePatientList.contains(patient) == false) {
				ruleResult.setActionUrl("htmlformentryui/htmlform/editHtmlFormWithStandardUi.page?patientId=" + patient.getUuid() + "&encounterId=" + obs.getEncounter().getId());
				ruleResult.setNotes("The " + identifierTitle + " " + getTbNumber(patient, obs.getEncounter(), identifierConceptUuid) + " is being used by another patient");
				ruleResult.setEntity(patient);
				
				ruleResults.add(ruleResult);				
			}
			
			uniquePatientList.add(patient);
		}
		
		log.info("There are " + uniquePatientList.size() + " Patients with similar " + identifierTitle);
		
		return ruleResults;
	}

	/**
	 * Patients with similar TB identifiers: duplicated for a single patient,
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> singlePatientWithDuplicateTBNumberAcrossMultipleTreatmentPrograms(String identifierConceptUuid, String identifierTitle) {
		log.info("Executing rule to find Patients with similar TB identifiers: duplicated for a single patient");
		String queryString = "SELECT o FROM Obs o WHERE o.voided = false AND o.encounter.patient.dead = 0 AND o.encounter.voided = 0 AND o.concept.uuid = :identifierConceptUuid AND o.obsId IN " 
				+ " (SELECT min(ob.obsId) FROM Obs ob WHERE ob.concept.uuid = :identifierConceptUuid AND ob.voided = 0 GROUP BY ob.person.personId, ob.concept.id, ob.valueText HAVING COUNT(ob.valueText) > 1)"; 
		
		Query query = getSession().createQuery(queryString);
		query.setParameter("identifierConceptUuid", identifierConceptUuid);
		
		List<Obs> obsList = query.list();
		Set<Patient> uniquePatientList = new HashSet<Patient>();
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Obs obs : obsList) {
			Patient patient = obs.getEncounter().getPatient();
			RuleResult<Patient> ruleResult = new RuleResult<>();
			
			if (uniquePatientList.contains(patient) == false) {
				ruleResult.setActionUrl("htmlformentryui/htmlform/editHtmlFormWithStandardUi.page?patientId=" + patient.getUuid() + "&encounterId=" + obs.getEncounter().getId());
				ruleResult.setNotes("The " + identifierTitle + " " + getTbNumber(patient, obs.getEncounter(), identifierConceptUuid) + " is used by the same patient across multiple treatment programs");
				ruleResult.setEntity(patient);
				
				ruleResults.add(ruleResult);				
			}
			
			uniquePatientList.add(patient);
		}
		
		log.info("There are " + uniquePatientList.size() + " Sharing the same " + identifierTitle);
		
		return ruleResults;
	}
	
	/**
	 * Patients with missing TB Number identifiers
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithMissingTBNumbers(String tbIdentifierConceptUuid, String identifierTitle) {
		log.info("Executing rule to find patients with missing " + identifierTitle + " TB identifiers");

		String queryString = "SELECT pp.patient FROM PatientProgram pp WHERE pp.voided = 0 AND pp.program.uuid = :tbProgramUuid GROUP BY pp.patient.patientId";

		Query query = getSession().createQuery(queryString);
		query.setParameter("tbProgramUuid", Programs.TB_PROGRAM.uuid());
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " Patients Enrolled in TB program");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		Program tbProgram = Context.getProgramWorkflowService().getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//For each patient enrolled in the TB program, look for encounters with missing identifier
		for (Patient patient : patientList) {
			String encounterQueryString = "FROM Encounter e WHERE e.patient.id = :patientId AND e.encounterType.uuid = :encounterType AND e.id NOT IN (SELECT o.encounter.id FROM Obs o WHERE o.concept.uuid = :conceptUuid)";
			
			Query encounterQuery = getSession().createQuery(encounterQueryString);
			encounterQuery.setParameter("patientId", patient.getId());
			encounterQuery.setParameter("encounterType", EncounterTypes.TB_SUMMARY_ENCOUNTER.uuid());
			encounterQuery.setParameter("conceptUuid", tbIdentifierConceptUuid);
			
			List<Encounter> patientEncounters = encounterQuery.list();
			
			for (Encounter encounter : patientEncounters) {
				RuleResult<Patient> ruleResult = new RuleResult<>();
				ruleResult.setActionUrl("htmlformentryui/htmlform/editHtmlFormWithStandardUi.page?patientId=" + patient.getUuid() + "&encounterId=" + encounter.getId());
				ruleResult.setNotes("Patient #" + getTbNumber(patient, encounter, null) + " has a missing " + identifierTitle );
				ruleResult.setEntity(patient);
				
				ruleResults.add(ruleResult);
			}				
		}
		
		return ruleResults;		
	}	
		
	/**
	 * Patients with no final outcome after 9 months at start of treatment 
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment(DateTime date) {
		log.info("Executing rule to find patients with no final TB Outcome 9 months after start of treatment");
		
		String queryString = "SELECT pp.patient FROM PatientProgram pp WHERE pp.voided = 0 AND pp.dateEnrolled <= :date AND pp.outcome IS NULL AND pp.program.uuid = '" + Programs.TB_PROGRAM.uuid() + "'";
		Query query = getSession().createQuery(queryString);
        DateTime nineMonthsBefore = date.plusMonths(-9);
        query.setParameter("date", nineMonthsBefore.toDate());
	
		List<Patient> patientsInProgramList = query.list();
				
		Set<Patient> uniquePatientList = new HashSet<Patient>(patientsInProgramList);
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : uniquePatientList) {
			//Fetch the latest encounter for this patient
			String encounterQueryString = "FROM Encounter e WHERE e.patient.id = :patientId AND e.voided = 0 AND e.encounterType.uuid = :encounterTypeUuid ORDER BY e.encounterDatetime DESC";
			Query encounterQuery = getSession().createQuery(encounterQueryString);
			encounterQuery.setMaxResults(1);
			encounterQuery.setParameter("patientId", patient.getId());
			encounterQuery.setParameter("encounterTypeUuid", EncounterTypes.TB_SUMMARY_ENCOUNTER.uuid());
			
			RuleResult<Patient> ruleResult = new RuleResult<>();
			
			List<Encounter> encounterList = encounterQuery.list();
			if (encounterList.size() > 0) {
				Encounter encounter = encounterList.get(0);
				ruleResult.setActionUrl("htmlformentryui/htmlform/editHtmlFormWithStandardUi.page?patientId=" + patient.getUuid() + "&encounterId=" + encounter);
				ruleResult.setNotes("Patient #" + getTbNumber(patient, encounter, null) + " has no final TB Outcome 9 months after start of treatment");
			} else {
				ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getId());
				ruleResult.setNotes("Patient #" + getOpenMrsId(patient) + " has no final TB Outcome 9 months after start of treatment");
			}
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
		rule.setRuleName("Invalid TB Encounters");
		rule.setUuid("94e9a389-b872-4b74-b72c-df9fa7197e39");
		return rule;
	}
	
}
