package org.openmrs.module.aijar.fragment.controller;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
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
	
	    DecimalFormat df = new DecimalFormat("#.#");
	    Person person = personService.getPerson(patient.getPersonId());
	    List<Person> who = new ArrayList<Person>();
	    who.add(person);

	    List<Concept> cd4 = new ArrayList<Concept>();
	    // Encounter cd4 count
	    cd4.add(conceptService.getConcept("5497"));
	    // cd4 at Art initiation
	    cd4.add(conceptService.getConcept("99082"));

	    List<Concept> currentRegimen = new ArrayList<Concept>();
	    currentRegimen.add(conceptService.getConcept("90315"));
	    
	    List<Concept> height = new ArrayList<Concept>();
	    height.add(conceptService.getConcept("5090"));
	    List<Concept> weight = new ArrayList<Concept>();
	    weight.add(conceptService.getConcept("90236")); // for adults
	    weight.add(conceptService.getConcept("5089")); // for infants
	    List<Concept> viralLoadDate = new ArrayList<Concept>();
	    viralLoadDate.add(conceptService.getConcept("163023"));
	    List<Concept> viralLoadResult = new ArrayList<Concept>();
	    viralLoadResult.add(conceptService.getConcept("1305"));
	    List<Concept> viralLoadValue = new ArrayList<Concept>();
	    viralLoadValue.add(conceptService.getConcept("856"));
	
	    //TODO:use pretty print for date formatting.
	    DateFormat formatter = new SimpleDateFormat("dd.MMM.yyyy");
		Obs latestCd4 = getMostRecentObservation(obsService, who, cd4);
        if (latestCd4 == null) {
	        model.addAttribute("lastcd4", "None Available");
	        model.addAttribute("lastcd4date", "");
	        model.addAttribute("lastcd4joiner", "");
        } else {
	        model.addAttribute("lastcd4", latestCd4.getValueNumeric());
	        model.addAttribute("lastcd4date", formatter.format(latestCd4.getObsDatetime()));
	        model.addAttribute("lastcd4joiner", "on");
        }

	    Obs currentRegimenObs = getMostRecentObservation(obsService, who, currentRegimen);
	    if (currentRegimenObs == null) {
		    model.addAttribute("currentregimen", "None Available");
		    model.addAttribute("currentregimendate","");
		    model.addAttribute("currentregimenjoiner", "");
        } else {
		    model.addAttribute("currentregimen", currentRegimenObs.getValueCoded().getName());
		    model.addAttribute("currentregimendate", formatter.format(currentRegimenObs.getObsDatetime()));
		    model.addAttribute("currentregimenjoiner", "from");
        }
        
        Obs latestViralLoadDate = getMostRecentObservation(obsService, who, viralLoadDate);
	    if (latestViralLoadDate == null) {
		    model.addAttribute("viralloaddate", "No VL results");
	    } else {
		    model.addAttribute("viralloaddate", "Sample taken on " + formatter.format(latestViralLoadDate.getValueDate()));
	    }
	    
	    Obs latestViralLoadResult = getMostRecentObservation(obsService, who, viralLoadResult);
	    Obs latestViralLoadValue = getMostRecentObservation(obsService, who, viralLoadValue);
	    if (latestViralLoadResult == null) {
		    model.addAttribute("viralloadresult", "");
	    } else {
		    model.addAttribute("viralloadresult", "Not Detected");
	    	if (latestViralLoadResult.getValueCoded().getId() == 1306) {
			    model.addAttribute("viralloadresult", "Not Detected");
		    } else {
			    if (latestViralLoadValue == null) {
				    model.addAttribute("viralloadresult", "Detected, No Viral Load Result Available");
			    } else {
				    model.addAttribute("viralloadresult", "with " + getViralLoadValue(latestViralLoadValue) + " copies/ml");
			    }
		    }
	    }
	    // handle legacy cases of data where a viral load was entered but was put as 0 for not detected
	    // The previous check for viral load result is a new addition so previous data may not follow it to the letter
	    if (getViralLoadValue(latestViralLoadValue) != null) {
		    model.addAttribute("viralloadresult", "with " + getViralLoadValue(latestViralLoadValue) + " copies/ml");
		    // if there is no viral load date, use the obs_datetime value
		    if (latestViralLoadDate == null) {
			    model.addAttribute("viralloaddate", "Sample taken on " + formatter.format(latestViralLoadValue.getObsDatetime()));
		    }
	    }
	    
	    Obs currentHeight = getMostRecentObservation(obsService, who, height);
	    if (currentHeight == null) {
		    model.addAttribute("height", "");
	    } else {
		    model.addAttribute("height", currentHeight.getValueNumeric() + " cm");
	    }
	
	    Obs currentWeight = getMostRecentObservation(obsService, who, weight);
	    if (currentWeight == null) {
		    model.addAttribute("weight", "");
	    } else {
		    model.addAttribute("weight", currentWeight.getValueNumeric() + " kg");
	    }
	    
	    if (currentHeight == null || currentWeight == null) {
		    model.addAttribute("bmi", "");
	    } else {
		    model.addAttribute("bmi", df.format(currentWeight.getValueNumeric()*10000/(currentHeight.getValueNumeric() *
				                                                                             currentHeight.getValueNumeric())));
	    }
    }
    
    private Obs getMostRecentObservation(ObsService obsService, List<Person> who, List<Concept> concepts) {
    	List<Obs> obs = obsService.getObservations(who, null, concepts, null, null, null, null, 1, null, null, null,
			    false);
	    if (obs.size() > 0) {
	    	return obs.get(0);
	    }
	    return null;
    }
	
	/**
	 * Get the numeric or text value of the viral load value - caters for both current and legacy data collection needs
	 *
	 * @param result The Obs containing the viral load result
	 * @return The viral load value
	 */
	private Object getViralLoadValue(Obs result) {
		if (result == null) {
			return null;
		}
	    if (result.getValueNumeric() == null) {
		    return result.getValueText();
	    }
	    return result.getValueNumeric();
    }
}
