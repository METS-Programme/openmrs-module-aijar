package org.openmrs.module.aijar.api.reporting.builder.common;

import org.openmrs.Location;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.reporting.Helper;
import org.openmrs.module.reporting.cohort.definition.SqlCohortDefinition;
import org.openmrs.module.reporting.data.converter.BirthdateConverter;
import org.openmrs.module.reporting.data.converter.PropertyConverter;
import org.openmrs.module.reporting.data.patient.definition.PatientIdentifierDataDefinition;
import org.openmrs.module.reporting.data.person.definition.BirthdateDataDefinition;
import org.openmrs.module.reporting.data.person.definition.GenderDataDefinition;
import org.openmrs.module.reporting.data.person.definition.PreferredNameDataDefinition;
import org.openmrs.module.reporting.dataset.definition.PatientDataSetDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.evaluation.parameter.ParameterizableUtil;
import org.openmrs.module.reporting.report.ReportDesign;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.openmrs.module.reporting.report.service.ReportService;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;


public class SetupMissedAppointmentsReport {
    public void setup() throws Exception {

        ReportDefinition rd = createReportDefinition();

        ReportDesign design = Helper.createRowPerPatientXlsOverviewReportDesign(rd, "MissedAppointmentsReport.xls",
                "MissedAppointmentsReport.xls_", null);

        Properties props = new Properties();
        props.put("repeatingSections", "sheet:1,row:9,dataset:dataSet");
        props.put("sortWeight", "5000");
        design.setProperties(props);

        Helper.saveReportDesign(design);
    }

    public void delete() {
        ReportService rs = Context.getService(ReportService.class);
        for (ReportDesign rd : rs.getAllReportDesigns(false)) {
            if ("MissedAppointmentsReport.xls_".equals(rd.getName())) {
                rs.purgeReportDesign(rd);
            }
        }
        Helper.purgeReportDefinition("Missed Appointments Report");
    }

    private ReportDefinition createReportDefinition() {

        ReportDefinition reportDefinition = new ReportDefinition();
        reportDefinition.setName("Missed Appointments Report");

        reportDefinition.addParameter(new Parameter("location", "Health Center", Location.class));

        SqlCohortDefinition location = new SqlCohortDefinition();
        location.setQuery("select p.patient_id from patient p, person_attribute pa, person_attribute_type pat where p.patient_id = pa.person_id and pat.name ='Health Center' and pa.voided = 0 and pat.person_attribute_type_id = pa.person_attribute_type_id and pa.value = :location");
        location.setName("At location");
        location.addParameter(new Parameter("location", "location", Location.class));

        reportDefinition.setBaseCohortDefinition(location, ParameterizableUtil.createParameterMappings("location=${location}"));
        reportDefinition.addParameter(new Parameter("startDate", "Start Date", Date.class));
        reportDefinition.addParameter(new Parameter("endDate", "End Date", Date.class));
        createDataSetDefinition(reportDefinition);

        Helper.saveReportDefinition(reportDefinition);

        return reportDefinition;
    }

    private void createDataSetDefinition(ReportDefinition reportDefinition) {

        // Create new dataset definition
        PatientDataSetDefinition dataSetDefinition = new PatientDataSetDefinition();
        dataSetDefinition.setName("Missed Appointments Report Data Set");

        dataSetDefinition.addParameter(new Parameter("location", "Location", Location.class));
        dataSetDefinition.addParameter(new Parameter("startDate", "Start Date", Date.class));
        dataSetDefinition.addParameter(new Parameter("endDate", "End Date", Date.class));

        //You can add filters on the dataset here

        //Add Columns
        //We want to display the Chronic HIVCare/HIVCare Number:
        PatientIdentifierDataDefinition d = new PatientIdentifierDataDefinition();
        d.addType(Context.getPatientService().getPatientIdentifierTypeByUuid("e1731641-30ab-102d-86b0-7a5022ba4115"));

        dataSetDefinition.addColumn("ID", d, new HashMap<String, Object>());
        dataSetDefinition.addColumn("givenName", new PreferredNameDataDefinition(), new HashMap<String, Object>(), new PropertyConverter(PersonName.class, "givenName"));
        dataSetDefinition.addColumn("familyName", new PreferredNameDataDefinition(), new HashMap<String, Object>(), new PropertyConverter(PersonName.class, "familyName"));
        dataSetDefinition.addColumn("Sex", new GenderDataDefinition(), (String) null);
        dataSetDefinition.addColumn("Birthdate", new BirthdateDataDefinition(), (String) null, new BirthdateConverter("dd/MMM/yyyy"));


        Map<String, Object> mappings = new HashMap<String, Object>();
        mappings.put("location", "${location}");
        mappings.put("startDate", "${startDate}");
        mappings.put("endDate", "${endDate}");


        reportDefinition.addDataSetDefinition("dataSet", dataSetDefinition, mappings);
    }
}
