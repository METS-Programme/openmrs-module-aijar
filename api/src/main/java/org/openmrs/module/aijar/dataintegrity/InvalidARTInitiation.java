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
 * Invalid ART Initiation data
 *
 * <ol>
 * <li>Patients with ART regimen but no ART Start date</li>
 * <li>Encounters with other ART regimen to be cleaned out</li>
 * <li>Encounters without ART regimen after ART start date</li>
 * </ol>
 *
 * */
@Component
public class InvalidARTInitiation extends BasePatientRuleDefinition {
	
	private Log log = LogFactory.getLog(getClass());
	
	@Override
	public List<RuleResult<Patient>> evaluate() {
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		ruleResults.addAll(patientsOnARTWithoutARTStartDate());
		
		return ruleResults;
	}
	
	private List<RuleResult<Patient>> patientsOnARTWithoutARTStartDate() {
		String queryString = "SELECT patient from Obs o join o.person as patient WHERE o.voided = false AND o.concept.conceptId = 90315 AND o.person.personId NOT IN (SELECT oo.person.personId FROM Obs oo WHERE oo.voided = false AND oo.concept.conceptId = 99161) GROUP BY o.person.personId";
		
		Query query = getSessionFactory().openSession().createQuery(queryString);
		
		List<Patient> patientList = query.list();
		
		List<RuleResult<Patient>> ruleResults = new ArrayList<>();
		for (Patient patient : patientList) {
			RuleResult<Patient> ruleResult = new RuleResult<>();
			ruleResult.setActionUrl("htmlformentryui/htmlform/enterHtmlFormWithStandardUi.page?formUuid=52653a60-8300-4c13-be4d-4b746da06fee&patientId=" + patient.getUuid());
			ruleResult.setNotes("Client# " + getHIVClinicNumber(patient) + " No ART Start Date");
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
		rule.setRuleName("Invalid ART Initiation");
		rule.setUuid("cff2fc9e-329c-4c08-a432-e90b428268e3");
		return rule;
	}
}
