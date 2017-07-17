/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.aijar.calculation;

import java.util.Date;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.calculation.CalculationContext;
import org.openmrs.calculation.patient.PatientCalculation;
import org.openmrs.calculation.patient.PatientCalculationService;
import org.openmrs.calculation.result.CalculationResult;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.util.OpenmrsUtil;

/**
 * Calculation utility methods, also used by some reporting classes
 */
public class EmrCalculationUtils {

	/**
	 * Evaluates the specified calculation for a single patient
	 * @param calculationClass the calculation class
	 * @param configuration the calculation configuration
	 * @param patient the patient
	 * @return the calculation result
	 */
	public static CalculationResult evaluateForPatient(Class <? extends PatientCalculation> calculationClass, String configuration, Patient patient) {
		PatientCalculation calculation = CalculationUtils.instantiateCalculation(calculationClass, configuration);
		return Context.getService(PatientCalculationService.class).evaluate(patient.getId(), calculation);
	}

	/**
	 * Convenience method to fetch a patient result as an obs
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the obs result
	 */
	public static Obs obsResultForPatient(CalculationResultMap results, Integer patientId) {
		return resultForPatient(results, patientId);
	}

	/**
	 * Convenience method to fetch a patient result as a numeric obs value
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the numeric obs value
	 */
	public static Double numericObsResultForPatient(CalculationResultMap results, Integer patientId) {
		Obs o = obsResultForPatient(results, patientId);
		return o == null ? null : o.getValueNumeric();
	}

	/**
	 * Convenience method to fetch a patient result as a coded obs value
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the coded obs value
	 */
	public static Concept codedObsResultForPatient(CalculationResultMap results, Integer patientId) {
		Obs o = obsResultForPatient(results, patientId);
		return o == null ? null : o.getValueCoded();
	}

	/**
	 * Convenience method to fetch a patient result as a datetime obs value
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the datetime obs value
	 */
	public static Date datetimeObsResultForPatient(CalculationResultMap results, Integer patientId) {
		Obs o = obsResultForPatient(results, patientId);
		return o == null ? null : o.getValueDatetime();
	}

	/**
	 * Convenience method to fetch a patient result as an encounter
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the encounter result
	 */
	public static Encounter encounterResultForPatient(CalculationResultMap results, Integer patientId) {
		return resultForPatient(results, patientId);
	}

	/**
	 * Convenience method to fetch a patient result as a date
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the date result
	 */
	public static Date datetimeResultForPatient(CalculationResultMap results, Integer patientId) {
		return resultForPatient(results, patientId);
	}

	/**
	 * Convenience method to fetch a patient result value
	 * @param results the calculation result map
	 * @param patientId the patient id
	 * @return the result value
	 */
	public static <T> T resultForPatient(CalculationResultMap results, Integer patientId) {
		CalculationResult result = results.get(patientId);
		if (result != null && !result.isEmpty()) {
			return (T) result.getValue();
		}
		return null;
	}



	/**
	 * Find the last obs before the given date. Assumes obs are ordered with ascending dates.
	 * @param obss the list of obs
	 * @param onOrBefore the day
	 * @return the last obs or null if no obs are before the given date
	 */
	public static Obs findLastOnOrBefore(List<Obs> obss, Date onOrBefore) {
		Date before = OpenmrsUtil.getLastMomentOfDay(onOrBefore);

		Obs result = null;
		for (Obs obs : obss) {
			if (obs.getObsDatetime().before(before)) {
				result = obs;
			}
			else {
				break;
			}
		}
		return result;
	}

	/**
	 * Calculates the days since the given date
	 * @param date the date
	 * @param calculationContext the calculation context
	 * @return the number of days
	 */
	public static int daysSince(Date date, CalculationContext calculationContext) {
		DateTime d1 = new DateTime(date.getTime());
		DateTime d2 = new DateTime(calculationContext.getNow().getTime());
		return Days.daysBetween(d1, d2).getDays();
	}
}