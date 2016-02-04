package org.openmrs.module.aijar.fragment.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.api.ConceptService;
import org.openmrs.api.ObsService;
import org.openmrs.api.PersonService;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by ssmusoke on 26/01/2016.
 */
public class PatientSummaryFragmentController {

    private static final Log log = LogFactory.getLog(PatientSummaryFragmentController.class);

    public void controller(FragmentConfiguration config,
                           FragmentModel model,
                           @SpringBean("obsService") ObsService obsService,
                           @SpringBean("conceptService") ConceptService conceptService,
                           @SpringBean("personService") PersonService personService,
                           @FragmentParam("patientId") Patient patient) throws ParseException {

        Person person = personService.getPerson(patient.getPersonId());
        List<Obs> cd4Counts = obsService.getLastNObservations(1, person, conceptService.getConcept("5497"), false);
        if (cd4Counts.size() > 0) {
            DateFormat formatter = new SimpleDateFormat("dd.MMM.yyyy");
            model.addAttribute("lastcd4", cd4Counts.get(0).getValueNumeric());
            model.addAttribute("lastcd4date", formatter.format(cd4Counts.get(0).getObsDatetime()));
            model.addAttribute("lastcd4joiner", "on");
        } else {
            model.addAttribute("lastcd4", "None Available");
            model.addAttribute("lastcd4date", "");
            model.addAttribute("lastcd4joiner", "");
        }


        List<Obs> currentRegimens = obsService.getLastNObservations(1, person, conceptService.getConcept("90315"), false);
        if (currentRegimens.size() > 0) {
            model.addAttribute("currentregimen", currentRegimens.get(0).getValueCoded().getName());
        } else {
            model.addAttribute("currentregimen", "None Available");
        }
    }


}
