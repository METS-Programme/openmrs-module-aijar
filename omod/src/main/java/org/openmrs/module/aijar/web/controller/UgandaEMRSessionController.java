/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.aijar.web.controller;

import org.apache.commons.lang3.LocaleUtils;
import org.openmrs.Location;
import org.openmrs.api.APIException;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.ConversionUtil;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.openmrs.module.webservices.rest.web.api.RestService;
import org.openmrs.module.webservices.rest.web.representation.CustomRepresentation;
import org.openmrs.module.webservices.rest.web.representation.Representation;
import org.openmrs.module.webservices.rest.web.v1_0.controller.BaseRestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.context.request.WebRequest;

import javax.servlet.http.HttpServletRequest;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * Controller that lets a client check the status of their session this is a UgandaEMR override which is needed for the community app, and log out. (Authenticating is
 * handled through a filter, and may happen through this or any other resource.
 */
@Controller
@RequestMapping(value = "/rest/" + RestConstants.VERSION_1 + "/" + AijarConstants.UGANDAEMR_MODULE_ID
		+ "/session")
public class UgandaEMRSessionController extends BaseRestController {
	
	public static final String USER_CUSTOM_REP = "(uuid,display,username,systemId,person:(uuid,names:(display,givenName,middleName,familyName,familyName2)),roles:(uuid,name,privileges:(uuid,name)))";
	
	@Autowired
	RestService restService;
	
	/**
	 * Tells the user their sessionId, and whether or not they are authenticated.
	 * 
	 * @param request
	 * @return
	 * <strong>Should</strong> return the session id if the user is authenticated
	 * <strong>Should</strong> return the session id if the user is not authenticated
	 */
	@RequestMapping(method = RequestMethod.GET)
	@ResponseBody
	public Object get(WebRequest request) {
		boolean authenticated = Context.isAuthenticated();
		SimpleObject session = new SimpleObject();
		session.add("sessionId", request.getSessionId()).add("authenticated", authenticated);
		if (authenticated) {
			session.add("healthFacilityId", Context.getAdministrationService().getGlobalProperty("ugandaemr.dhis2.organizationuuid"));
			session.add("user", ConversionUtil.convertToRepresentation(Context.getAuthenticatedUser(),
			    new CustomRepresentation(USER_CUSTOM_REP)));
			session.add("locale", Context.getLocale());
		}
		return session;
	}
	
}
