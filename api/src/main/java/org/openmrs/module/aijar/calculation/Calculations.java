package org.openmrs.module.aijar.calculation;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;

import org.openmrs.Concept;
import org.openmrs.EncounterType;
import org.openmrs.Program;
import org.openmrs.calculation.patient.PatientCalculationContext;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.module.reporting.common.TimeQualifier;
import org.openmrs.module.reporting.common.VitalStatus;
import org.openmrs.module.reporting.data.patient.definition.EncountersForPatientDataDefinition;
import org.openmrs.module.reporting.data.patient.definition.ProgramEnrollmentsForPatientDataDefinition;
import org.openmrs.module.reporting.data.person.definition.AgeDataDefinition;
import org.openmrs.module.reporting.data.person.definition.GenderDataDefinition;
import org.openmrs.module.reporting.data.person.definition.ObsForPersonDataDefinition;
import org.openmrs.module.reporting.data.person.definition.VitalStatusDataDefinition;
import org.openmrs.util.OpenmrsUtil;

/**
 * Utility class of common base calculations
 */
public class Calculations {

	private static final DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");

	/**
	 * Evaluates alive-ness of each patient
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the alive-nesses in a calculation result map
	 */
	public static CalculationResultMap alive(Collection<Integer> cohort, PatientCalculationContext context) {
		VitalStatusDataDefinition def = new VitalStatusDataDefinition("alive");
		CalculationResultMap vitals = CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);

		CalculationResultMap ret = new CalculationResultMap();
		for (int ptId : cohort) {
			boolean alive = false;
			if (vitals.get(ptId) != null) {
				VitalStatus vs = (VitalStatus) vitals.get(ptId).getValue();
				alive = !vs.getDead() || OpenmrsUtil.compareWithNullAsEarliest(vs.getDeathDate(), context.getNow()) > 0;
			}
			ret.put(ptId, new BooleanResult(alive, null, context));
		}
		return ret;
	}

	/**
	 * Evaluates genders of each patient
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the genders in a calculation result map
	 */
	public static CalculationResultMap genders(Collection<Integer> cohort, PatientCalculationContext context) {
		GenderDataDefinition def = new GenderDataDefinition("gender");
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates ages of each patient
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the ages in a calculation result map
	 */
	public static CalculationResultMap ages(Collection<Integer> cohort, PatientCalculationContext context) {
		AgeDataDefinition def = new AgeDataDefinition("age on");
		def.setEffectiveDate(context.getNow());
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates all obs of a given type of each patient
	 * @param concept the obs' concept
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the obss in a calculation result map
	 */
	public static CalculationResultMap allObs(Concept concept, Collection<Integer> cohort, PatientCalculationContext context) {
		ObsForPersonDataDefinition def = new ObsForPersonDataDefinition("all obs", TimeQualifier.ANY, concept, context.getNow(), null);
		return CalculationUtils.ensureEmptyListResults(CalculationUtils.evaluateWithReporting(def, cohort, null, null, context), cohort);
	}

	/**
	 * Evaluates the first obs of a given type of each patient
	 * @param concept the obs' concept
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the obss in a calculation result map
	 */
	public static CalculationResultMap firstObs(Concept concept, Collection<Integer> cohort, PatientCalculationContext context) {
		ObsForPersonDataDefinition def = new ObsForPersonDataDefinition("first obs", TimeQualifier.FIRST, concept, context.getNow(), null);
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates the first obs of a given type of each patient
	 * @param concept the obs' concept
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the obss in a calculation result map
	 */
	public static CalculationResultMap firstObsOnOrAfter(Concept concept, Date onOrAfter, Collection<Integer> cohort, PatientCalculationContext context) {
		ObsForPersonDataDefinition def = new ObsForPersonDataDefinition("first obs on or after", TimeQualifier.FIRST, concept, context.getNow(), onOrAfter);
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates the last obs of a given type of each patient
	 * @param concept the obs' concept
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the obss in a calculation result map
	 */
	public static CalculationResultMap lastObs(Concept concept, Collection<Integer> cohort, PatientCalculationContext context) {
		ObsForPersonDataDefinition def = new ObsForPersonDataDefinition("last obs", TimeQualifier.LAST, concept, context.getNow(), null);
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates the last obs of a given type of each patient that occurred at least the given number of days ago
	 * @param concept the obs' concept
	 * @param onOrBefore the number of days that must be elapsed between now and the observation
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the obss in a calculation result map
	 */
	public static CalculationResultMap lastObsOnOrBefore(Concept concept, Date onOrBefore, Collection<Integer> cohort, PatientCalculationContext context) {
		// Only interested in obs before now
		onOrBefore = CoreUtils.earliest(onOrBefore, context.getNow());

		ObsForPersonDataDefinition def = new ObsForPersonDataDefinition("last obs on or before", TimeQualifier.LAST, concept, onOrBefore, null);
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates the last obs of a given type of each patient that occurred at least the given number of days ago
	 * @param concept the obs' concept
	 * @param atLeastDaysAgo the number of days that must be elapsed between now and the observation
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the obss in a calculation result map
	 */
	public static CalculationResultMap lastObsAtLeastDaysAgo(Concept concept, int atLeastDaysAgo, Collection<Integer> cohort, PatientCalculationContext context) {
		Date onOrBefore = CoreUtils.dateAddDays(context.getNow(), -atLeastDaysAgo);
		return lastObsOnOrBefore(concept, onOrBefore, cohort, context);
	}

	/**
	 * Evaluates all encounters of a given type of each patient
	 * @param encounterType the encounter type
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the encounters in a calculation result map
	 */
	public static CalculationResultMap allEncounters(EncounterType encounterType, Collection<Integer> cohort, PatientCalculationContext context) {
		EncountersForPatientDataDefinition def = new EncountersForPatientDataDefinition();
		if (encounterType != null) {
			def.setName("all encounters of type " + encounterType.getName());
			def.addType(encounterType);
		}
		else {
			def.setName("all encounters of any type");
		}
		def.setWhich(TimeQualifier.ANY);
		def.setOnOrBefore(context.getNow());
		CalculationResultMap results = CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
		return CalculationUtils.ensureEmptyListResults(results, cohort);
	}

	/**
	 * Evaluates the first encounter of a given type of each patient
	 * @param encounterType the encounter type
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the encounters in a calculation result map
	 */
	public static CalculationResultMap firstEncounter(EncounterType encounterType, Collection<Integer> cohort, PatientCalculationContext context) {
		EncountersForPatientDataDefinition def = new EncountersForPatientDataDefinition();
		if (encounterType != null) {
			def.setName("first encounter of type " + encounterType.getName());
			def.addType(encounterType);
		}
		else {
			def.setName("first encounter of any type");
		}
		def.setWhich(TimeQualifier.FIRST);
		def.setOnOrBefore(context.getNow());
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates the last encounter of a given type of each patient
	 * @param encounterType the encounter type
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the encounters in a calculation result map
	 */
	public static CalculationResultMap lastEncounter(EncounterType encounterType, Collection<Integer> cohort, PatientCalculationContext context) {
		EncountersForPatientDataDefinition def = new EncountersForPatientDataDefinition();
		if (encounterType != null) {
			def.setName("last encounter of type " + encounterType.getName());
			def.addType(encounterType);
		}
		else {
			def.setName("last encounter of any type");
		}
		def.setWhich(TimeQualifier.LAST);
		def.setOnOrBefore(context.getNow());
		return CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
	}

	/**
	 * Evaluates all encounters of a given type of each patient appearing onOrAfter
	 * @param encounterType the encounter type
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the encounters in a calculation result map
	 */
	public static CalculationResultMap allEncountersOnOrAfter(EncounterType encounterType, Date onOrAfter,  Collection<Integer> cohort, PatientCalculationContext context) {
		EncountersForPatientDataDefinition def = new EncountersForPatientDataDefinition();
		if (encounterType != null) {
			def.setName("all encounters of type " + encounterType.getName());
			def.addType(encounterType);
		}
		else {
			def.setName("all encounters of any type");
		}
		def.setWhich(TimeQualifier.ANY);
		def.setOnOrAfter(onOrAfter);
		CalculationResultMap results = CalculationUtils.evaluateWithReporting(def, cohort, null, null, context);
		return CalculationUtils.ensureEmptyListResults(results, cohort);
	}

	/**
	 * Evaluates the active program enrollment of the specified program
	 * @param program the program
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the enrollments in a calculation result map
	 */
	public static CalculationResultMap allEnrollments(Program program, Collection<Integer> cohort, PatientCalculationContext context) {
		ProgramEnrollmentsForPatientDataDefinition def = new ProgramEnrollmentsForPatientDataDefinition();
		def.setName("all enrollments in " + program.getName());
		def.setWhichEnrollment(TimeQualifier.ANY);
		def.setProgram(program);
		def.setEnrolledOnOrBefore(context.getNow());
		CalculationResultMap results = CalculationUtils.evaluateWithReporting(def, cohort, new HashMap<String, Object>(), null, context);
		return CalculationUtils.ensureEmptyListResults(results, cohort);
	}

	/**
	 * Evaluates the active program enrollment of the specified program
	 * @param program the program
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the enrollments in a calculation result map
	 */
	public static CalculationResultMap activeEnrollment(Program program, Collection<Integer> cohort, PatientCalculationContext context) {
		return activeEnrollmentOn(program, context.getNow(), cohort, context);
	}

	/**
	 * Evaluates the last program enrollment on the specified program
	 * @param program the program
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the enrollments in a calculation result map
	 */
	public static CalculationResultMap activeEnrollmentOn(Program program, Date onDate, Collection<Integer> cohort, PatientCalculationContext context) {
		ProgramEnrollmentsForPatientDataDefinition def = new ProgramEnrollmentsForPatientDataDefinition();
		def.setName("active enrollment in " + program.getName() + " on " + dateFormatter.format(onDate));
		def.setWhichEnrollment(TimeQualifier.LAST);
		def.setProgram(program);
		def.setActiveOnDate(onDate);
		return CalculationUtils.evaluateWithReporting(def, cohort, new HashMap<String, Object>(), null, context);
	}


	/**
	 * Evaluates the first program enrollment of the specified program
	 * @param program the program
	 * @param cohort the patient ids
	 * @param context the calculation context
	 * @return the enrollments in a calculation result map
	 */
	public static CalculationResultMap firstEnrollments(Program program, Collection<Integer> cohort, PatientCalculationContext context) {
		ProgramEnrollmentsForPatientDataDefinition def = new ProgramEnrollmentsForPatientDataDefinition();
		def.setName("first in " + program.getName());
		def.setWhichEnrollment(TimeQualifier.FIRST);
		def.setProgram(program);
		def.setEnrolledOnOrBefore(context.getNow());
		CalculationResultMap results = CalculationUtils.evaluateWithReporting(def, cohort, new HashMap<String, Object>(), null, context);
		return CalculationUtils.ensureEmptyListResults(results, cohort);
	}
}