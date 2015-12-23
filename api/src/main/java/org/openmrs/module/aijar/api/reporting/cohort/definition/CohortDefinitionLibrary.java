package org.openmrs.module.aijar.api.reporting.cohort.definition;

import org.openmrs.EncounterType;
import org.openmrs.api.context.Context;
import org.openmrs.module.reporting.cohort.definition.AgeCohortDefinition;
import org.openmrs.module.reporting.cohort.definition.CohortDefinition;
import org.openmrs.module.reporting.cohort.definition.EncounterCohortDefinition;
import org.openmrs.module.reporting.cohort.definition.GenderCohortDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Date;

/**
 * Created by ssmusoke on 10/12/2015.
 */
@Component
public class CohortDefinitionLibrary {

    public CohortDefinition getMales() {
        GenderCohortDefinition males = new GenderCohortDefinition();
        males.setName("Males");
        males.setMaleIncluded(true);
        return males;
    }

    public CohortDefinition getFemales() {
        GenderCohortDefinition males = new GenderCohortDefinition();
        males.setName("Females");
        males.setFemaleIncluded(true);
        return males;
    }

    public CohortDefinition getAgeAtMost(int ageInYears) {
        AgeCohortDefinition ageAtMost = new AgeCohortDefinition();
        ageAtMost.setName("Age at Most " + ageInYears + " years");
        ageAtMost.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        ageAtMost.setMaxAge(ageInYears);

        return ageAtMost;
    }

    public CohortDefinition getAgeAtLeast(int ageInYears) {
        AgeCohortDefinition ageAtLeast = new AgeCohortDefinition();
        ageAtLeast.setName("Age at Least " + ageInYears + " years");
        ageAtLeast.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        ageAtLeast.setMinAge(ageInYears);

        return ageAtLeast;
    }

    public CohortDefinition getAgeInRange(int minAge, int maxAge) {
        AgeCohortDefinition ageInRange = new AgeCohortDefinition();
        ageInRange.setName("Age between " + minAge + " years and " + maxAge + " years");
        ageInRange.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        ageInRange.setMinAge(minAge);
        ageInRange.setMaxAge(maxAge);

        return ageInRange;
    }

    public CohortDefinition cumulativeEnrolled() {
        // Summary Page Encounter Type
        // TODO: Change this to the ART Card Summary page as the EID card will also have a summary page
        EncounterType enrolledInCare = Context.getEncounterService().getEncounterTypeByUuid("8d5b27bc-c2cc-11de-8d13-0010c6dffd0f");
        EncounterCohortDefinition cumulativeEnrolled = new EncounterCohortDefinition();
        cumulativeEnrolled.setName("Cumulative Enrolled");

        cumulativeEnrolled.setEncounterTypeList(Arrays.asList(enrolledInCare));
        cumulativeEnrolled.addParameter(new Parameter("onOrAfter", "Start Date", Date.class));
        cumulativeEnrolled.addParameter(new Parameter("onOrBefore", "End Date", Date.class));

        return cumulativeEnrolled;

    }


}
