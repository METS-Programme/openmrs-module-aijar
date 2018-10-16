package org.openmrs.module.aijar.page.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.APIException;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import static org.openmrs.module.aijar.AijarConstants.GP_DSDM_PROGRAM_UUID_NAME;

public class AddPatientProgramPageController {
    protected final Log log = LogFactory.getLog(this.getClass());

    public void get(@SpringBean PageModel pageModel, @RequestParam(value = "breadcrumbOverride", required = false) String breadcrumbOverride, @SpringBean("patientService") PatientService patientService, @RequestParam("patientId") Patient patient) {

        List<Program> programs = Context.getProgramWorkflowService().getAllPrograms();

        /**
         * Removing Programs in List that patient is actively in
         */

        for (PatientProgram patientProgram : getPatientActiveProgram(patient)) {
            programs.remove(patientProgram.getProgram());
        }

        pageModel.addAttribute("programs", programs);
        pageModel.addAttribute("patientProgram", getPatientActiveProgram(patient));
        pageModel.addAttribute("patientId", patient.getPatientId());
        pageModel.addAttribute("patient", patient);
        pageModel.addAttribute("locations", Context.getLocationService().getAllLocations());
        pageModel.put("birthDate", patient.getBirthdate());
    }

    public String post(UiSessionContext context, @SpringBean PageModel pageModel, @RequestParam(value = "breadcrumbOverride", required = false) String breadcrumbOverride, @SpringBean("patientService") PatientService patientService, @RequestParam("patientId") Patient patient, @RequestParam(value = "completionDate", required = false) Date completionDate, @RequestParam("enrolmentDate") Date enrolmentDate, @RequestParam("programId") Program program, @RequestParam("locationId") Location location, UiUtils ui, @RequestParam(value = "returnUrl", required = false) String returnUrl) {
        List<PatientProgram> patientPrograms = getPatientActiveProgram(patient);
        try {

            /**
             * Completing all DSDM active programs of the patient
             */
            if (!patientPrograms.isEmpty()) {
                for (PatientProgram patientProgram : patientPrograms) {
                    if (getDSDMPrograms().contains(patientProgram.getProgram())) {
                        patientProgram.setDateCompleted(enrolmentDate);
                        Context.getProgramWorkflowService().savePatientProgram(patientProgram);
                    }
                }
            }

            PatientProgram patientProgram = new PatientProgram();
            patientProgram.setPatient(patient);
            patientProgram.setLocation(location);
            patientProgram.setDateEnrolled(enrolmentDate);
            patientProgram.setProgram(program);
            Context.getProgramWorkflowService().savePatientProgram(patientProgram);
            return "redirect:" + ui.pageLink("coreapps", "clinicianfacing/patient", SimpleObject.create("patientId", patient.getId(), "returnUrl", returnUrl));
        } catch (APIException e) {
            log.error(e.getMessage(), e);
            return "redirect:" + ui.pageLink("coreapps", "markPatientDead", SimpleObject.create("patientId", patient.getId(), "returnUrl", returnUrl));
        }
    }

    /**
     * Get List of DSDM Programs
     *
     * @return
     */
    public List<Program> getDSDMPrograms() {
        String dsdmuuids = Context.getAdministrationService().getGlobalProperty(GP_DSDM_PROGRAM_UUID_NAME);

        List<String> listOfDSDMPrograms = Arrays.asList(dsdmuuids.split("\\s*,\\s*"));
        List<Program> dsdmPrograms = new ArrayList<>();

        for (String s : listOfDSDMPrograms) {

            Program dsdmProgram = Context.getProgramWorkflowService().getProgramByUuid(s);
            if (dsdmProgram != null) {
                dsdmPrograms.add(dsdmProgram);
            }
        }

        return dsdmPrograms;
    }

    /**
     * Filter out only Active Programs of a patient
     *
     * @param patient
     * @return
     */
    public List<PatientProgram> getPatientActiveProgram(Patient patient) {
        List<PatientProgram> activePatientPrograms = new ArrayList<>();
        for (PatientProgram patientProgram : Context.getProgramWorkflowService().getPatientPrograms(patient, null, null, null, null, null, false)) {
            if (patientProgram.getActive()) {
                activePatientPrograms.add(patientProgram);
            }
        }
        return activePatientPrograms;
    }
}
