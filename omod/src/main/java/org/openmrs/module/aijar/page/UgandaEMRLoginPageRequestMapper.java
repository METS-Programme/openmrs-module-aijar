package org.openmrs.module.aijar.page;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.ui.framework.page.PageRequest;
import org.openmrs.ui.framework.page.PageRequestMapper;
import org.springframework.stereotype.Component;

/**
 *
 * Overrides the mapping to the login page for the reference application to a a customized page for UgandaEMR
 *
 */
@Component
public class UgandaEMRLoginPageRequestMapper implements PageRequestMapper {

	protected final Log log = LogFactory.getLog(getClass());
	/**
	 * Implementations should call {@link PageRequest#setProviderNameOverride(String)} and
	 * {@link PageRequest#setPageNameOverride(String)}, and return true if they want to remap a request,
	 * or return false if they didn't remap it.
	 *
	 * @param request may have its providerNameOverride and pageNameOverride set
	 * @return true if this page was mapped (by overriding the provider and/or page), false otherwise
	 */
	public boolean mapRequest(PageRequest request) {
		if (request.getProviderName().equals("referenceapplication")) {
			if (request.getPageName().equals("login")) {
				// change to the custom login provided by the module
				request.setProviderNameOverride("aijar");
				request.setPageNameOverride("aijarLogin");

				log.info(request.toString());
				return true;
			}
		}
		return false;
	}
}
