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

        SqlCohortDefinition missedAppointmentChortDefinition = new SqlCohortDefinition();
        missedAppointmentChortDefinition.setQuery("SELECT * FROM (SELECT A.person_id, B.nextAppointmentDate , gender as sex, birthdate, family_name, given_name, middle_name, identifier FROM obs A INNER JOIN " +
                "  (SELECT obs_id, person_id, max(value_datetime) nextAppointmentDate FROM obs WHERE  concept_id = 5096 AND Voided = 0 GROUP BY person_id) B ON A.obs_id = B.obs_id AND A.person_id = B.person_id " +
                "  INNER JOIN person c ON A.person_id = c.person_id INNER JOIN person_name d ON A.person_id = d.person_id INNER JOIN patient_identifier e ON A.person_id = e.patient_id AND identifier_type =  4) A " +
                "  WHERE  A.nextAppointmentDate BETWEEN :startDate AND :endDate" +
                "    AND A.person_id NOT IN (SELECT person_Id FROM (SELECT person_Id, max(obs_datetime) DeathDate FROM obs WHERE concept_id IN( 99112, 90306) AND value_numeric = 1  and voided = 0 GROUP BY person_Id)AA)");
        //location.setName("At location");
        //location.addParameter(new Parameter("location", "location", Location.class));
        missedAppointmentChortDefinition.addParameter(new Parameter("startDate", "Start Date", Date.class));
        missedAppointmentChortDefinition.addParameter(new Parameter("endDate", "End Date", Date.class));

        reportDefinition.setBaseCohortDefinition(missedAppointmentChortDefinition, ParameterizableUtil.createParameterMappings("startDate=${startDate}"));
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
        dataSetDefinition.addColumn("Birthdate", new BirthdateDataDefinition(), (String) null, new BirthdateConverter("dd/mm/yyyy"));


        Map<String, Object> mappings = new HashMap<String, Object>();
        mappings.put("startDate", "${startDate}");
        mappings.put("endDate", "${endDate}");

        reportDefinition.addDataSetDefinition("dataSet", dataSetDefinition, mappings);
    }
}
