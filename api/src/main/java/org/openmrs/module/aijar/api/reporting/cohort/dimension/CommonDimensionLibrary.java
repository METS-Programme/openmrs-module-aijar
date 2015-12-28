package org.openmrs.module.aijar.api.reporting.cohort.dimension;

import org.openmrs.module.aijar.api.reporting.cohort.ReportingUtils;
import org.openmrs.module.aijar.api.reporting.cohort.definition.CohortDefinitionLibrary;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.indicator.dimension.CohortDefinitionDimension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * Created by ssmusoke on 10/12/2015.
 */
@Component
public class CommonDimensionLibrary {

    @Autowired
    private CohortDefinitionLibrary cohortDefinitionLibrary;

    /**
     * Gender dimension
     * @return the dimension
     */
    public CohortDefinitionDimension genders() {
        CohortDefinitionDimension dimGender = new CohortDefinitionDimension();
        dimGender.setName("Gender");
        dimGender.addCohortDefinition("M", ReportingUtils.map(cohortDefinitionLibrary.getMales()));
        dimGender.addCohortDefinition("F", ReportingUtils.map(cohortDefinitionLibrary.getFemales()));

        return dimGender;
    }
    /**
     * Dimension of age using the standard age groups
     * @return the dimension
     */
    public CohortDefinitionDimension standardAgeGroups() {
        CohortDefinitionDimension dimAges = new CohortDefinitionDimension();
        dimAges.setName("AgesGroup (< 2 years, 2 - 5 years, 5 - 14 years, 15+ years)");
        dimAges.addParameter(new Parameter("effectiveDate", "Effective Date", Date.class));
        dimAges.addCohortDefinition("< 2 years", ReportingUtils.map(cohortDefinitionLibrary.getAgeAtMost(2), "effectiveDate=${effectiveDate}"));
        dimAges.addCohortDefinition("2 - 5 years", ReportingUtils.map(cohortDefinitionLibrary.getAgeInRange(2, 5), "effectiveDate=${effectiveDate}"));
        dimAges.addCohortDefinition("2 - 5 years", ReportingUtils.map(cohortDefinitionLibrary.getAgeInRange(5, 14), "effectiveDate=${effectiveDate}"));
        dimAges.addCohortDefinition("15+ years", ReportingUtils.map(cohortDefinitionLibrary.getAgeAtLeast(15), "effectiveDate=${effectiveDate}"));

        return dimAges;
    }
}
