package org.openmrs.module.aijar.api.reporting.cohort.definition;

import org.openmrs.Concept;
import org.openmrs.EncounterType;
import org.openmrs.api.PatientSetService;
import org.openmrs.module.aijar.api.reporting.Dictionary;
import org.openmrs.module.reporting.cohort.definition.*;
import org.openmrs.module.reporting.common.SetComparator;
import org.openmrs.module.reporting.common.TimeQualifier;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Date;

/**
 * Created by ssmusoke on 10/12/2015.
 */
@Component
public class CohortDefinitionLibrary {
    /**
     * Patients who are male
     *
     * @return the cohort definition
     */
    public CohortDefinition getMales() {
        GenderCohortDefinition males = new GenderCohortDefinition();
        males.setName("Males");
        males.setMaleIncluded(true);
        return males;
    }

    /**
     * Patients who are female
     * @return the cohort definition
     */
    public CohortDefinition getFemales() {
        GenderCohortDefinition males = new GenderCohortDefinition();
        males.setName("Females");
        males.setFemaleIncluded(true);
        return males;
    }

    /**
     * Patients who at most maxAge years old on ${effectiveDate}
     * @return the cohort definition
     */
    public CohortDefinition getAgeAtMost(int ageInYears) {
        AgeCohortDefinition ageAtMost = new AgeCohortDefinition();
        ageAtMost.setName("Age at Most " + ageInYears + " years");
        ageAtMost.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        ageAtMost.setMaxAge(ageInYears);

        return ageAtMost;
    }

    /**
     * Patients who are at least minAge years old on ${effectiveDate}
     * @return the cohort definition
     */
    public CohortDefinition getAgeAtLeast(int ageInYears) {
        AgeCohortDefinition ageAtLeast = new AgeCohortDefinition();
        ageAtLeast.setName("Age at Least " + ageInYears + " years");
        ageAtLeast.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        ageAtLeast.setMinAge(ageInYears);

        return ageAtLeast;
    }

    /**
     * Patients who are between minAge years old and maxAge years old on ${effectiveDate}
     * @return the cohort definition
     */
    public CohortDefinition getAgeInRange(int minAge, int maxAge) {
        AgeCohortDefinition ageInRange = new AgeCohortDefinition();
        ageInRange.setName("Age between " + minAge + " years and " + maxAge + " years");
        ageInRange.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        ageInRange.setMinAge(minAge);
        ageInRange.setMaxAge(maxAge);

        return ageInRange;
    }

    /**
     * Patients who have an obs between ${onOrAfter} and ${onOrBefore}
     *
     * @param question the question concept
     * @param answers  the answers to include
     * @return the cohort definition
     */
    public CohortDefinition hasObs(Concept question, Concept... answers) {
        CodedObsCohortDefinition cd = new CodedObsCohortDefinition();
        cd.setName("has obs between dates");
        cd.setQuestion(question);
        cd.setOperator(SetComparator.IN);
        cd.setTimeModifier(PatientSetService.TimeModifier.ANY);
        cd.addParameter(new Parameter("onOrBefore", "Before Date", Date.class));
        cd.addParameter(new Parameter("onOrAfter", "After Date", Date.class));
        if (answers.length > 0) {
            cd.setValueList(Arrays.asList(answers));
        }
        return cd;
    }

    /**
     * Patients who have an encounter between ${onOrAfter} and ${onOrBefore}
     *
     * @param types the encounter types
     * @return the cohort definition
     */
    public CohortDefinition hasEncounter(EncounterType... types) {
        EncounterCohortDefinition cd = new EncounterCohortDefinition();
        cd.setName("has encounter between dates");
        cd.setTimeQualifier(TimeQualifier.ANY);
        cd.addParameter(new Parameter("onOrBefore", "Before Date", Date.class));
        cd.addParameter(new Parameter("onOrAfter", "After Date", Date.class));
        if (types.length > 0) {
            cd.setEncounterTypeList(Arrays.asList(types));
        }
        return cd;
    }

    /**
     * Patients who have an upcoming appointment in between ${onOrAfter} and ${onOrBefore}
     *
     * @return the cohort definition
     */
    public CohortDefinition nextAppointment() {
        Concept transferInDate = Dictionary.getConcept("5096");

        DateObsCohortDefinition cd = new DateObsCohortDefinition();
        cd.setName("transferred in between dates");
        cd.setQuestion(transferInDate);
        cd.addParameter(new Parameter("onOrAfter", "After Date", Date.class));
        cd.addParameter(new Parameter("onOrBefore", "Before Date", Date.class));
        return cd;
    }



}
