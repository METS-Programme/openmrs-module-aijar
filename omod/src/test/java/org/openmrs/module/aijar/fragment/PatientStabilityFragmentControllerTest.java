package org.openmrs.module.aijar.fragment;

import org.junit.Test;
import org.openmrs.module.aijar.fragment.controller.PatientStabilityFragmentController;
import org.openmrs.ui.framework.fragment.FragmentRequest;

import java.util.Date;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by ssmusoke on 18/02/2016.
 */
public class PatientStabilityFragmentControllerTest {

	@Test
	public void testDateSubtraction() {
		PatientStabilityFragmentController patientStabilityFragmentController=new PatientStabilityFragmentController();

		patientStabilityFragmentController.getDateBefore(new Date(),-12);
	}
}
