package org.openmrs.module.aijar.fragment;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.openmrs.ui.framework.fragment.FragmentRequest;

/**
 * Created by ssmusoke on 18/02/2016.
 */
public class AijarHeaderFragmentRequestMapperTest {

	@Test
	public void overrideRequestForHeaderFragment() {
		FragmentRequest request = new FragmentRequest("appui", "header");

		assertEquals(request.getMappedProviderName(), "appui");
		assertEquals(request.getMappedFragmentId(), "header");

		AijarHeaderFragmentRequestMapper mapper = new AijarHeaderFragmentRequestMapper();

		assertTrue(mapper.mapRequest(request));
		assertEquals(request.getMappedProviderName(), "aijar");
		assertEquals(request.getMappedFragmentId(), "aijarHeader");
	}
}
