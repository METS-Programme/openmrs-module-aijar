package org.openmrs.module.aijar.calculation;


import org.openmrs.Program;
import org.openmrs.calculation.patient.PatientCalculationContext;

import java.util.Collection;
import java.util.Set;

/**
 * Utility class of filters which take a cohort and return another cohort
 */
public class Filters {

	/**
	 * Patients who are alive
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the filtered cohort
	 */
	public static Set<Integer> alive(Collection<Integer> cohort, PatientCalculationContext context) {
		return CalculationUtils.patientsThatPass(Calculations.alive(cohort, context));
	}

	/**
	 * Patients who are female
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the filtered cohort
	 */
	public static Set<Integer> female(Collection<Integer> cohort, PatientCalculationContext context) {
		return CalculationUtils.patientsThatPass(Calculations.genders(cohort, context), "F");
	}

	/**
	 * Patients who are in the specified program
	 * @param program the program
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the filtered cohort
	 */
	public static Set<Integer> inProgram(Program program, Collection<Integer> cohort, PatientCalculationContext context) {
		return CalculationUtils.patientsThatPass(Calculations.activeEnrollment(program, cohort, context));
	}
}