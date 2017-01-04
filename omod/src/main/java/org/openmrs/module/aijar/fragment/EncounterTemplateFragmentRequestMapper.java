package org.openmrs.module.aijar.fragment;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.ui.framework.fragment.FragmentRequest;
import org.openmrs.ui.framework.fragment.FragmentRequestMapper;
import org.springframework.stereotype.Component;

/**
 *  Adds the creator and editing information to the encounter template
 */
@Component
public class EncounterTemplateFragmentRequestMapper implements FragmentRequestMapper {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	/**
	 * Implementations should call {@link FragmentRequest#setProviderNameOverride(String)} and
	 * {@link FragmentRequest#setFragmentIdOverride(String)}, and return true if they want to remap a request,
	 * or return false if they didn't remap it.
	 *
	 * @param request may have its providerNameOverride and pageNameOverride set
	 * @return true if this page was mapped (by overriding the provider and/or page), false otherwise
	 */
	public boolean mapRequest(FragmentRequest request) {
		if (request.getProviderName().equals("coreapps")) {
			if (request.getFragmentId().equals("patientdashboard/encountertemplate/defaultEncounterTemplate")) {
				// change to the custom login provided by the module
				request.setProviderNameOverride("aijar");
				request.setFragmentIdOverride("patientdashboard/encountertemplate/ugandaEMREncounterTemplate");
				
				log.info(request.toString());
				return true;
			}
		}
		return false;
	}
}
