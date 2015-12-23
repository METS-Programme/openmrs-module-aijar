package org.openmrs.module.aijar.api.reporting.cohort.indicator;

import org.openmrs.module.aijar.api.reporting.cohort.ReportingUtils;
import org.openmrs.module.aijar.api.reporting.cohort.definition.CohortDefinitionLibrary;
import org.openmrs.module.reporting.indicator.CohortIndicator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by ssmusoke on 10/12/2015.
 */
@Component
public class CohortIndicatorLibrary {
    @Autowired
    CohortDefinitionLibrary cohortDefinitionLibrary;

    public CohortIndicator cumulativeEnrolled() {
        return ReportingUtils.cohortIndicator("Cumulative Enrolled",
                ReportingUtils.map(cohortDefinitionLibrary.cumulativeEnrolled(),
                        "onOrAfter=${startDate},onOrBefore=${endDate}"));


    }

}
