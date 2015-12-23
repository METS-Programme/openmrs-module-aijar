package org.openmrs.module.aijar.api.reporting.builder.common;

import org.openmrs.module.aijar.api.reporting.cohort.ReportingUtils;
import org.openmrs.module.aijar.api.reporting.cohort.dimension.CommonDimensionLibrary;
import org.openmrs.module.aijar.api.reporting.cohort.indicator.CohortIndicatorLibrary;
import org.openmrs.module.reporting.dataset.definition.CohortIndicatorDataSetDefinition;
import org.openmrs.module.reporting.dataset.definition.DataSetDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Date;

/**
 * Created by ssmusoke on 10/12/2015.
 */
public class MoH106aReportBuilder {

    @Autowired
    CohortIndicatorLibrary cohortIndicatorLibrary;

    @Autowired
    CommonDimensionLibrary commonDimensionLibrary;

    public DataSetDefinition dataSetDefinition() {
        CohortIndicatorDataSetDefinition cidsd = new CohortIndicatorDataSetDefinition();
        cidsd.setName("MOH106a");
        cidsd.addParameter(new Parameter("startDate", "Start Date", Date.class));
        cidsd.addParameter(new Parameter("endDate", "End Date", Date.class));

        cidsd.addDimension("Gender", ReportingUtils.map(commonDimensionLibrary.genders()));
        cidsd.addDimension("Ages", ReportingUtils.map(commonDimensionLibrary.ages()));

        String indParams = "startDate=${startDate},endDate=${endDate}";

        cidsd.addColumn("A", "A Label", ReportingUtils.map(cohortIndicatorLibrary.cumulativeEnrolled()), "");

        return cidsd;
    }

    public void buildReport() {
        ReportDefinition rd = new ReportDefinition();
        rd.setName("MOH 106a");
        rd.addParameter(new Parameter("onOrAfter", "Start Date", Date.class));
        rd.addParameter(new Parameter("onOrBefore", "End Date", Date.class));
        rd.addDataSetDefinition("MoH106a", ReportingUtils.map(dataSetDefinition(), "startDate=${startDate},endDate=${endDate}"));

    }
}
