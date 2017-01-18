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
public class MarkPatientDeadPageController extends PatientServiceImpl{
    public void controller(UiSessionContext sessionContext, PageModel model) {
    }

    public void get(@SpringBean PageModel pageModel, @RequestParam(value = "breadcrumbOverride",required = false) String breadcrumbOverride, @RequestParam("patientId") String patientId) {
        PersonService personService = Context.getPersonService();
        PatientService patientService = Context.getPatientService();

        String conceptId = Context.getAdministrationService().getGlobalProperty("concept.causeOfDeath");

        Patient patient = patientService.getPatientByUuid(patientId);
        Person person = personService.getPerson(patient.getPatientId());
        pageModel.put("person", person);
        pageModel.put("patient", patient);
        pageModel.put("patientId", patientId);
        pageModel.put("breadcrumbOverride", breadcrumbOverride);
        if (conceptId != null && !conceptId.contains("[a-zA-Z]+")) {
            pageModel.put("conceptAnswers", getConceptAnswerByConcept(Integer.parseInt(conceptId)));
        }
    }

    public String post(@RequestParam(value = "causeOfDeath",required = false) String causeOfDeath, @RequestParam(value = "dead",required = false) Boolean dead, @RequestParam(value = "deathDate",required = false) Date deathDate, @RequestParam("patientId") String patientId) {
        PersonService personService = Context.getPersonService();

        try {
            PatientService patientService = Context.getPatientService();
            Patient patient = patientService.getPatientByUuid(patientId);


            Person person = personService.getPerson(patient.getPatientId());
            Date date=new Date();

            if (dead!=null && !causeOfDeath.equals("null") && deathDate != null  && !deathDate.before(person.getBirthdate()) && !deathDate.after(date)) {
                person.setDead(dead);
                person.setCauseOfDeath(getConceptByUUId(causeOfDeath));
                person.setDeathDate(deathDate);
            } else {
                person.setDeathDate(null);
                person.setDead(false);
                person.setCauseOfDeath(null);
            }

            personService.savePerson(person);
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
