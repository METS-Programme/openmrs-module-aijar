package org.openmrs.module.aijar.calculation;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.openmrs.Cohort;
import org.openmrs.Obs;
import org.openmrs.api.APIException;
import org.openmrs.api.context.Context;
import org.openmrs.calculation.ConfigurableCalculation;
import org.openmrs.calculation.patient.PatientCalculation;
import org.openmrs.calculation.patient.PatientCalculationContext;
import org.openmrs.calculation.result.CalculationResult;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.calculation.result.ListResult;
import org.openmrs.calculation.result.ObsResult;
import org.openmrs.calculation.result.ResultUtil;
import org.openmrs.calculation.result.SimpleResult;
import org.openmrs.module.reporting.cohort.EvaluatedCohort;
import org.openmrs.module.reporting.cohort.definition.CohortDefinition;
import org.openmrs.module.reporting.cohort.definition.service.CohortDefinitionService;
import org.openmrs.module.reporting.data.DataDefinition;
import org.openmrs.module.reporting.data.patient.EvaluatedPatientData;
import org.openmrs.module.reporting.data.patient.definition.PatientDataDefinition;
import org.openmrs.module.reporting.data.patient.service.PatientDataService;
import org.openmrs.module.reporting.data.person.EvaluatedPersonData;
import org.openmrs.module.reporting.data.person.definition.PersonDataDefinition;
import org.openmrs.module.reporting.data.person.service.PersonDataService;
import org.openmrs.module.reporting.evaluation.EvaluationContext;
import org.openmrs.module.reporting.evaluation.EvaluationException;

/**
 * Calculation utility methods
 */
public class CalculationUtils {

	/**
	 * Instantiates and configures a patient calculation
	 * @param clazz the calculation class
	 * @param configuration the configuration
	 * @return the calculation instance
	 */
	public static PatientCalculation instantiateCalculation(Class<? extends PatientCalculation> clazz, String configuration) {
		try {
			PatientCalculation calc = clazz.newInstance();

			if (configuration != null && ConfigurableCalculation.class.isAssignableFrom(clazz)) {
				((ConfigurableCalculation) calc).setConfiguration(configuration);
			}

			return calc;
		}
		catch (Exception ex) {
			throw new RuntimeException(ex);
		}
	}

	/**
	 * Extracts patients from calculation result map with non-false/empty results
	 * @param results calculation result map
	 * @return the extracted patient ids
	 */
	public static Set<Integer> patientsThatPass(CalculationResultMap results) {
		return patientsThatPass(results, null);
	}

	/**
	 * Extracts patients from calculation result map with matching results
	 * @param results calculation result map
	 * @param requiredResult the required result value
	 * @return the extracted patient ids
	 */
	public static Set<Integer> patientsThatPass(CalculationResultMap results, Object requiredResult) {
		Set<Integer> ret = new HashSet<Integer>();
		for (Map.Entry<Integer, CalculationResult> e : results.entrySet()) {
			CalculationResult result = e.getValue();

			// If there is no required result, just check trueness of result, otherwise check result matches required result
			if ((requiredResult == null && ResultUtil.isTrue(result)) || (result != null && result.getValue().equals(requiredResult))) {
				ret.add(e.getKey());
			}
		}
		return ret;
	}

	/**
	 * Evaluates a data definition on each patient using a reporting context
	 * @param dataDefinition the data definition
	 * @param cohort the patient ids
	 * @param parameterValues the parameters for the reporting context
	 * @param calculation the calculation (optional)
	 * @param calculationContext the calculation context
	 * @return the calculation result map
	 */
	public static CalculationResultMap evaluateWithReporting(DataDefinition dataDefinition, Collection<Integer> cohort, Map<String, Object> parameterValues, PatientCalculation calculation, PatientCalculationContext calculationContext) {
		try {
			EvaluationContext reportingContext = ensureReportingContext(calculationContext, cohort, parameterValues);
			Map<Integer, Object> data;

			if (dataDefinition instanceof PersonDataDefinition) {
				EvaluatedPersonData result = Context.getService(PersonDataService.class).evaluate((PersonDataDefinition) dataDefinition, reportingContext);
				data = result.getData();
			}
			else if (dataDefinition instanceof PatientDataDefinition) {
				EvaluatedPatientData result = Context.getService(PatientDataService.class).evaluate((PatientDataDefinition) dataDefinition, reportingContext);
				data = result.getData();
			}
			else {
				throw new RuntimeException("Unknown DataDefinition type: " + dataDefinition.getClass());
			}

			CalculationResultMap ret = new CalculationResultMap();
			for (Integer ptId : cohort) {
				Object reportingResult = data.get(ptId);
				ret.put(ptId, toCalculationResult(reportingResult, calculation, calculationContext));
			}

			return ret;
		} catch (EvaluationException ex) {
			throw new APIException(ex);
		}
	}

	/**
	 * Evaluates a cohort definition on the given base set of patients using a reporting context
	 * @param cohortDefinition the cohort definition
	 * @param cohort the patient ids
	 * @param parameterValues the parameters for the reporting context
	 * @param calculationContext the calculation context
	 * @return the evaluated cohort
	 */
	public static EvaluatedCohort evaluateWithReporting(CohortDefinition cohortDefinition, Collection<Integer> cohort, Map<String, Object> parameterValues, PatientCalculationContext calculationContext) {
		try {
			EvaluationContext reportingContext = ensureReportingContext(calculationContext, cohort, parameterValues);
			return Context.getService(CohortDefinitionService.class).evaluate(cohortDefinition, reportingContext);
		}
		catch (EvaluationException ex) {
			throw new APIException(ex);
		}
	}

	/**
	 * Convenience method to wrap a plain object in the appropriate calculation result subclass
	 * @param obj the plain object
	 * @param calculation the calculation (optional)
	 * @param calculationContext the calculation context
	 * @return the calculation result
	 */
	protected static CalculationResult toCalculationResult(Object obj, PatientCalculation calculation, PatientCalculationContext calculationContext) {
		if (obj == null) {
			return null;
		}
		else if (obj instanceof Obs) {
			return new ObsResult((Obs) obj, calculation, calculationContext);
		}
		else if (obj instanceof Collection) {
			ListResult ret = new ListResult();
			for (Object item : (Collection) obj) {
				ret.add(toCalculationResult(item, calculation, calculationContext));
			}
			return ret;
		}
		else if (obj instanceof Boolean) {
			return new BooleanResult((Boolean) obj, calculation, calculationContext);
		}
		else {
			return new SimpleResult(obj, calculation, calculationContext);
		}
	}

	/**
	 * Returns the reporting {@link org.openmrs.module.reporting.evaluation.EvaluationContext} stored in calculationContext, creating and storing
	 * a new one if necessary.
	 *
	 * (Note: for now we never store this, and always return a new one)
	 *
	 * @param calculationContext the calculation context
	 * @param cohort the patient ids
	 * @param parameterValues the parameters for the reporting context
	 * @return the reporting evaluation context
	 */
	protected static EvaluationContext ensureReportingContext(PatientCalculationContext calculationContext, Collection<Integer> cohort, Map<String, Object> parameterValues) {
		EvaluationContext ret = new EvaluationContext();
		ret.setEvaluationDate(calculationContext.getNow());
		ret.setBaseCohort(new Cohort(cohort));
		ret.setParameterValues(parameterValues);
		calculationContext.addToCache("reportingEvaluationContext", ret);
		return ret;
	}

	/**
	 * Ensures all patients exist in a result map. If map is missing entries for any of patientIds, they are added with a null result
	 * @param results the calculation result map
	 * @param cohort the patient ids
	 */
	public static CalculationResultMap ensureNullResults(CalculationResultMap results, Collection<Integer> cohort) {
		for (Integer ptId : cohort) {
			if (!results.containsKey(ptId)) {
				results.put(ptId, null);
			}
		}
		return results;
	}

	/**
	 * Ensures all patients exist in a result map. If map is missing entries for any of patientIds, they are added with an empty list result
	 * @param results the calculation result map
	 * @param cohort the patient ids
	 */
	public static CalculationResultMap ensureEmptyListResults(CalculationResultMap results, Collection<Integer> cohort) {
		for (Integer ptId : cohort) {
			if (!results.containsKey(ptId) || results.get(ptId) == null) {
				results.put(ptId, new ListResult());
			}
		}
		return results;
	}

	/**
	 * Extracts actual values from a list result. Always returns a list even if result is null.
	 * @param result the list result
	 * @param <T> the type of each value
	 * @return the list of values
	 */
	public static <T> List<T> extractResultValues(ListResult result) {
		List<T> values = new ArrayList<T>();
		if (result != null) {
			for (SimpleResult resultItem : (List<SimpleResult>) result.getValue()) {
				values.add((T)resultItem.getValue());
			}
		}
		return values;
	}
}
