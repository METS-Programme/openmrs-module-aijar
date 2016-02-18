package org.openmrs.module.aijar.page;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.ui.framework.page.PageRequest;
import org.openmrs.ui.framework.page.PageRequestMapper;
import org.springframework.stereotype.Component;

/**
 * Created by ssmusoke on 18/02/2016.
 */
@Component
public class AijarLoginPageRequestMapper implements PageRequestMapper {

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

		System.out.println("The original request is " + request.toString());

		if (request.getProviderName().equals("referenceapplication")) {
			System.out.println("Reference Application Provider");
			if (request.getPageName().equals("login")) {
				System.out.println("Login Page");
				// change to the provided login
				request.setProviderNameOverride("aijar");
				request.setPageNameOverride("aijarLogin");

				System.out.println("Overriding the provider and page name");
				log.info(request.toString());
			}
		}
		System.out.println(request.toString());
		return true;
	}
}
