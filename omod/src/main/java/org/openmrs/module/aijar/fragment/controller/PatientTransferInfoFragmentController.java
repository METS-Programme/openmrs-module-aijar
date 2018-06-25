package org.openmrs.module.aijar.fragment.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;

import java.text.ParseException;
import java.util.Map;

import static org.openmrs.module.aijar.AijarConstants.*;

/**
 * Created By slubwama 10/04/2018
 */
public class PatientTransferInfoFragmentController {

    private static final Log log = LogFactory.getLog(PatientTransferInfoFragmentController.class);

    public void controller(FragmentConfiguration config, FragmentModel model, @FragmentParam("patientId") Patient patient) throws ParseException {
        AijarService aijarService = Context.getService(AijarService.class);
        Map map = aijarService.transferredOut(patient);
        Map transferInMap = aijarService.transferredIn(patient);

        if ((boolean) map.get(PATIENT_TRANSERRED_OUT)) {
            model.addAttribute(PATIENT_TRANSERRED_OUT, map.get(PATIENT_TRANSERRED_OUT));
            model.addAttribute(PATIENT_TRANSFERED_OUT_DATE, map.get(PATIENT_TRANSFERED_OUT_DATE));
            model.addAttribute(PATIENT_TRANSFERED_OUT_LOCATION, map.get(PATIENT_TRANSFERED_OUT_LOCATION));
        } else {
            model.addAttribute(PATIENT_TRANSERRED_OUT, map.get(PATIENT_TRANSERRED_OUT));
        }

        if ((boolean) transferInMap.get(PATIENT_TRANSERRED_IN)) {
            model.addAttribute(PATIENT_TRANSERRED_IN, transferInMap.get(PATIENT_TRANSERRED_IN));
            model.addAttribute(PATIENT_TRANSFERED_IN_DATE, transferInMap.get(PATIENT_TRANSFERED_IN_DATE));
            model.addAttribute(PATIENT_TRANSFERED_IN_LOCATION, transferInMap.get(PATIENT_TRANSFERED_IN_LOCATION));
        } else {
            model.addAttribute(PATIENT_TRANSERRED_IN, transferInMap.get(PATIENT_TRANSERRED_IN));
        }
    }
}
