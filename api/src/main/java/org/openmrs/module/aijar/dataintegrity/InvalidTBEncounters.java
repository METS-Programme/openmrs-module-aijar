package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;
import org.joda.time.DateTime;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.concept.Dictionary;
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
		
		ruleResults.addAll(patientsWithMissingTBNumberIdentifiers("304df0d0-afe4-4a61-a917-d684b100a65a", "Unit TB Number"));
		ruleResults.addAll(patientsWithMissingTBNumberIdentifiers("d1cda288-4853-4450-afbc-76bd4e65ea70", "HSD TB Number"));
		ruleResults.addAll(patientsWithMissingTBNumberIdentifiers("67e9ec2f-4c72-408b-8122-3706909d77ec", "District TB Number"));
		ruleResults.addAll(patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient("67e9ec2f-4c72-408b-8122-3706909d77ec", "District TB Number"));
		ruleResults.addAll(patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient("304df0d0-afe4-4a61-a917-d684b100a65a", "Unit TB Number"));
		ruleResults.addAll(patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient("d1cda288-4853-4450-afbc-76bd4e65ea70", "HSD TB Number"));
		ruleResults.addAll(patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients("67e9ec2f-4c72-408b-8122-3706909d77ec", "District TB Number"));
		ruleResults.addAll(patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients("304df0d0-afe4-4a61-a917-d684b100a65a", "Unit TB Number"));
		ruleResults.addAll(patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients("d1cda288-4853-4450-afbc-76bd4e65ea70", "HSD TB Number"));
		ruleResults.addAll(patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment(DateTime.now()));
		return ruleResults;
	}

	/**
	 * Patients with similar TB identifiers: duplicated across multiple patients
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients(String identifierConceptUuid, String identifierTitle) {
		log.info("Executing rule to find Patients with similar TB identifiers: duplicated across multiple patients");
		String queryString = "SELECT o.encounter.patient FROM Obs o WHERE o.voided = false AND o.encounter.patient.dead = 0 AND o.encounter.voided = 0 AND o.valueText IN " 
				+ " (SELECT ob.valueText FROM Obs ob WHERE ob.concept.uuid = :identifierConceptUuid AND ob.voided = 0 GROUP BY ob.concept.conceptId, ob.valueText HAVING COUNT(ob.valueText) > 1)"; 
		Query query = getSession().createQuery(queryString);
		query.setParameter("identifierConceptUuid", identifierConceptUuid);
		
		List<Patient> patientList = query.list();
		Set<Patient> uniquePatientList = new HashSet<Patient>(patientList);
		log.info("There are " + uniquePatientList.size() + " Patients with similar " + identifierTitle + " identifiers: duplicated for a single patient,");
				
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : uniquePatientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Patient #" + patient.getId() + " with similar " + identifierTitle + " identifiers: duplicated for a single patient,");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}

	/**
	 * Patients with similar TB identifiers: duplicated for a single patient,
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient(String identifierConceptUuid, String identifierTitle) {
		log.info("Executing rule to find Patients with similar TB identifiers: duplicated for a single patient");
		String queryString = "SELECT o.encounter.patient FROM Obs o WHERE o.concept.uuid = :identifierConceptUuid" 
							+ " AND o.voided = false AND o.encounter.voided = 0 AND o.encounter.patient.dead = 0 GROUP BY o.person, o.concept.conceptId, o.valueText HAVING COUNT(*) > 1";
		Query query = getSession().createQuery(queryString);
		query.setParameter("identifierConceptUuid", identifierConceptUuid);
		
		List<Patient> patientList = query.list();
		Set<Patient> uniquePatientList = new HashSet<Patient>(patientList);
		log.info("There are " + uniquePatientList.size() + " Patients with similar " + identifierTitle + " identifiers: duplicated for a single patient,");

		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : uniquePatientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Patient #" + patient.getId() + " with similar " + identifierTitle + " identifiers: duplicated for a single patient,");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;
	}
	
	/**
	 * Patients with missing TB Number identifiers
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithMissingTBNumberIdentifiers(String tbIdentifierConceptUuid, String identifierTitle) {
		log.info("Executing rule to find patients with missing " + identifierTitle + " TB identifiers");

		String queryString = "SELECT pp.patient FROM PatientProgram pp WHERE pp.voided = 0 AND pp.program.uuid = :tbProgramUuid GROUP BY pp.patient.patientId";

		Query query = getSession().createQuery(queryString);
		query.setParameter("tbProgramUuid", Programs.TB_PROGRAM.uuid());
		
		List<Patient> patientList = query.list();
		log.info("There are " + patientList.size() + " Enrolled in TB program");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		Program tbProgram = Context.getProgramWorkflowService().getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//For each patient enrolled in the TB program, check if the current identifier is missing
		for (Patient patient : patientList) {
			List<Obs> patientObs = Context.getObsService().getObservationsByPersonAndConcept(patient.getPerson(), Dictionary.getConcept(tbIdentifierConceptUuid));
			boolean identifierFound = false;
			if (patientObs.size() == 0) {
				identifierFound = false;
			} else {
				for (Obs obs : patientObs) {
					if (obs.getValueText() != null ) {
						PatientProgram pp = Context.getProgramWorkflowService().getPatientPrograms(patient, tbProgram, null, null, null, null, false).get(0);
						Date treatmentStartDate = obs.getEncounter().getEncounterDatetime();
						
						//Compare the TB treatment start date matching the given Obs with the tb program enrollment date. 
						//If the TB treatment date falls on or after the program enrollment date, consider this a valid identifier 
						if (treatmentStartDate.equals(pp.getDateEnrolled()) || treatmentStartDate.after(pp.getDateEnrolled())){
							identifierFound = true;
						}
					}
				}				
			}
			
			if (!identifierFound) {
				RuleResult<Patient> ruleResult = new RuleResult<>();
				ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
				ruleResult.setNotes("Client# " + patient.getId() + ", has missing " + identifierTitle + " identifier");
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
		log.info("There are " + uniquePatientList.size() + " Patients with no final TB Outcome 9 months after start of treatment");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : uniquePatientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Patient #" + patient.getId() + " has no final TB Outcome 9 months after start of treatment");
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
