package org.openmrs.module.aijar.fragment.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.api.ConceptService;
import org.openmrs.api.ObsService;
import org.openmrs.api.PersonService;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class PatientRegistrationSummaryFragmentController {

    private static final Log log = LogFactory.getLog(PatientRegistrationSummaryFragmentController.class);

    public void controller(FragmentConfiguration config,
                           FragmentModel model,
                           @SpringBean("obsService") ObsService obsService,
                           @SpringBean("conceptService") ConceptService conceptService,
                           @SpringBean("personService") PersonService personService,
                           @FragmentParam("patientId") Patient patient) throws ParseException {

        Person person = personService.getPerson(patient.getPersonId());
       PersonAttribute telephone_number= person.getAttribute("Telephone Number");
        PersonAttribute caregivers_name= person.getAttribute("Care giver's Name");
        PersonAttribute caregivers_contact= person.getAttribute("Care giver's Telephone Number");
        PersonAttribute common_name= person.getAttribute("Common Name");
        PersonAttribute landmark= person.getAttribute("Land Mark Feature");


        if(telephone_number==null)
        {
            model.addAttribute("telephone","Not Captured");
        }
        else{
            model.addAttribute("telephone",telephone_number);

        }
        if(caregivers_name==null)
        {
            model.addAttribute("caregivers_name","Not Captured");
        }
        else{
            model.addAttribute("caregivers_name",caregivers_name);

        }
        if(caregivers_contact==null)
        {
            model.addAttribute("caregivers_contact","Not Captured");

        }
        else{
            model.addAttribute("caregivers_contact",caregivers_contact);
        }
        if(common_name==null)
        {
            model.addAttribute("commonname","Not Captured");

        }
        else{
            model.addAttribute("commonname",common_name);

        }
        if(landmark==null)
        {
            model.addAttribute("landmark","Not Captured");

        }
        else{
            model.addAttribute("landmark",landmark);

        }



    }
}
	

