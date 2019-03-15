package org.openmrs.module.aijar.fragment;

import org.junit.Test;
import org.openmrs.module.aijar.fragment.controller.PatientStabilityFragmentController;

import java.util.Date;

public class PatientStabilityFragmentControllerTest {

    @Test
    public void testDateSubtraction() {
        PatientStabilityFragmentController patientStabilityFragmentController = new PatientStabilityFragmentController();

        patientStabilityFragmentController.getDateBefore(new Date(), -12,0);
    }
}
