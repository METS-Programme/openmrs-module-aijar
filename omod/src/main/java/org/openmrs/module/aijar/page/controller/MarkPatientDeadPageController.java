package org.openmrs.module.aijar.page.controller;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.api.PatientService;
import org.openmrs.api.PersonService;
import org.openmrs.api.context.Context;
import org.openmrs.api.impl.PatientServiceImpl;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collection;
import java.util.Date;
import java.util.regex.Pattern;

/**
 * Created by lubwamasamuel on 15/06/2016.
 */
public class MarkPatientDeadPageController{
    public void controller(UiSessionContext sessionContext, PageModel model) {
    }

    public void get(@SpringBean PageModel pageModel, @RequestParam(value = "breadcrumbOverride",required = false) String breadcrumbOverride, @RequestParam("patientId") String patientId) {
        PatientService patientService = Context.getPatientService();

        String conceptId = Context.getAdministrationService().getGlobalProperty("concept.causeOfDeath");

        Patient patient = patientService.getPatientByUuid(patientId);
        pageModel.put("person", patient.getPerson());
        pageModel.put("birthDate",patient.getBirthdate());
        pageModel.put("patient", patient);
        pageModel.put("patientId", patientId);
        pageModel.put("breadcrumbOverride", breadcrumbOverride);
        if (conceptId != null && !conceptId.contains("[a-zA-Z]+")) {
            pageModel.put("conceptAnswers", getConceptAnswerByConcept(Integer.parseInt(conceptId)));
        }
    }

    public String post(@RequestParam(value = "causeOfDeath",required = false) String causeOfDeath, @RequestParam(value = "dead",required = false) Boolean dead, @RequestParam(value = "deathDate",required = false) Date deathDate, @RequestParam("patientId") String patientId) {

        try {
            PatientService patientService = Context.getPatientService();
            Patient patient = patientService.getPatientByUuid(patientId);

            Date date=new Date();

            if (dead!=null && !causeOfDeath.equals("null") && deathDate != null  && !deathDate.before(patient.getPerson().getBirthdate()) && !deathDate.after(date)) {
                patient.getPerson().setDead(dead);
                patient.getPerson().setCauseOfDeath(getConceptByUUId(causeOfDeath));
                patient.getPerson().setDeathDate(deathDate);
            } else {
                patient.getPerson().setDeathDate(null);
                patient.getPerson().setDead(false);
                patient.getPerson().setCauseOfDeath(null);
            }

            patientService.savePatient(patient);
            return "redirect:/coreapps/clinicianfacing/patient.page?patientId=" + patient.getUuid() + "";
        } catch (Exception e) {
            System.out.println(e);
            return null;
        }

    }

    private Concept getConceptByUUId(String conceptUUId) {
        return Context.getConceptService().getConceptByUuid(conceptUUId);
    }

    private Collection<ConceptAnswer> getConceptAnswerByConcept(Integer conceptId) {
        Concept concept = Context.getConceptService().getConcept(conceptId);
        return concept.getAnswers();
    }

}
