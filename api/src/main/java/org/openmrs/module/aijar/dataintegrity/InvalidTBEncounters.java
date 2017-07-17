package org.openmrs.module.aijar.dataintegrity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.Query;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.calculation.patient.PatientCalculation;
import org.openmrs.calculation.patient.PatientCalculationService;
import org.openmrs.calculation.result.CalculationResult;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.module.aijar.calculation.tb.MissingTBNumber;
import org.openmrs.module.aijar.calculation.tb.NoOutcome9MonthsAfterTreatmentStartDate;
import org.openmrs.module.aijar.metadata.concept.Dictionary;
import org.openmrs.module.dataintegrity.DataIntegrityRule;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.openmrs.module.reporting.cohort.Cohorts;
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
		ruleResults.addAll(patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient(99031, "District TB Number"));
		ruleResults.addAll(patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient(164955, "Unit TB Number"));
		ruleResults.addAll(patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient(99370, "HSD TB Number"));
		ruleResults.addAll(patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients(99031, "District TB Number"));
		ruleResults.addAll(patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients(164955, "Unit TB Number"));
		ruleResults.addAll(patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients(99370, "HSD TB Number"));
		ruleResults.addAll(patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment());
		return ruleResults;
	}

	/**
	 * Patients with similar TB identifiers: duplicated across multiple patients
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients(Integer identifierConceptId, String identifierTitle) {
		log.info("Executing rule to find Patients with similar TB identifiers: duplicated across multiple patients");
		String queryString = "SELECT o.encounter.patient FROM Obs o WHERE o.voided = false AND o.encounter.patient.dead = 0 AND o.encounter.voided = 0 AND o.valueText IN " 
				+ " (SELECT ob.valueText FROM Obs ob WHERE ob.concept.conceptId = " + identifierConceptId + " AND ob.voided = 0 GROUP BY ob.concept.conceptId, ob.valueText HAVING COUNT(ob.valueText) > 1)"; 
		Query query = getSession().createQuery(queryString);
		
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
	public List<RuleResult<Patient>> patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient(Integer identifierConceptId, String identifierTitle) {
		log.info("Executing rule to find Patients with similar TB identifiers: duplicated for a single patient");
		String queryString = "SELECT o.encounter.patient FROM Obs o WHERE o.concept.conceptId = " + identifierConceptId 
							+ " AND o.voided = false AND o.encounter.voided = 0 AND o.encounter.patient.dead = 0 GROUP BY o.person, o.concept.conceptId, o.valueText HAVING COUNT(*) > 1";
		Query query = getSession().createQuery(queryString);
		
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
		
		Collection<Integer> cohort = Cohorts.allPatients().getMemberIds();
		Concept tbIdentifierConcept = Dictionary.getConcept(tbIdentifierConceptUuid);
		PatientCalculation calculation = new MissingTBNumber(tbIdentifierConcept);		
		CalculationResultMap resultMap = Context.getService(PatientCalculationService.class).evaluate(cohort, calculation);
		log.info("There are " + resultMap.size() + " patients with missing " + identifierTitle + " identifiers");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();		
		for(Map.Entry<Integer, CalculationResult> entry:resultMap.entrySet() ){			
			RuleResult<Patient> ruleResult = new RuleResult<>();
			Patient patient = Context.getPatientService().getPatient(entry.getKey());
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client# " + entry.getKey() + ", has missing " + identifierTitle + " identifier");
			ruleResult.setEntity(patient);
			
			ruleResults.add(ruleResult);
		}
		
		return ruleResults;		
	}	
	
	/**
	 * Patients with no final outcome after 9 months at start of treatment 
	 * @return List<RuleResult<Patient>>
	 */
	public List<RuleResult<Patient>> patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment() {
		log.info("Executing rule to find patients with no final TB Outcome 9 months after start of treatment");
		
		Collection<Integer> cohort = Cohorts.allPatients().getMemberIds();
		PatientCalculation calculation = new NoOutcome9MonthsAfterTreatmentStartDate();		
		CalculationResultMap resultMap = Context.getService(PatientCalculationService.class).evaluate(cohort, calculation);
		log.info("There are " + resultMap.size() + " patients with no final TB Outcome 9 months after start of treatment");
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();		
		for(Map.Entry<Integer, CalculationResult> entry:resultMap.entrySet() ){			
			RuleResult<Patient> ruleResult = new RuleResult<>();
			Patient patient = Context.getPatientService().getPatient(entry.getKey());
			ruleResult.setActionUrl("coreapps/patientdashboard/patientDashboard.page?patientId=" + patient.getUuid());
			ruleResult.setNotes("Client# " + entry.getKey() + ", has no final TB Outcome 9 months after start of treatment");
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
