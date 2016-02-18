package org.openmrs.module.aijar.page.controller;

import java.net.MalformedURLException;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Location;
import org.openmrs.api.LocationService;
import org.openmrs.api.context.Context;
import org.openmrs.api.context.ContextAuthenticationException;
import org.openmrs.module.appframework.service.AppFrameworkService;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.emrapi.EmrApiConstants;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by ssmusoke on 18/02/2016.
 */
public class AijarLoginPageController {

	//see TRUNK-4536 for details why we need this
	private static final String GET_LOCATIONS = "Get Locations";

	// RA-592: don't use PrivilegeConstants.VIEW_LOCATIONS
	private static final String VIEW_LOCATIONS = "View Locations";

	protected final Log log = LogFactory.getLog(getClass());

	/**
	 * @should redirect the user to the home page if they are already authenticated
	 * @should show the user the login page if they are not authenticated
	 * @should set redirectUrl in the page model if any was specified in the request
	 * @should set the referer as the redirectUrl in the page model if no redirect param exists
	 * @should set redirectUrl in the page model if any was specified in the session
	 * @should not set the referer as the redirectUrl in the page model if referer URL is outside context path
	 * @should set the referer as the redirectUrl in the page model if referer URL is within context path
	 */
	public String get(PageModel model,
	                  UiUtils ui,
	                  PageRequest pageRequest,
	                  @CookieValue(value = "referenceapplication.lastSessionLocation", required = false) String
			                  lastSessionLocationId,
	                  @SpringBean("locationService") LocationService locationService,
	                  @SpringBean("appFrameworkService") AppFrameworkService appFrameworkService) {

		if (Context.isAuthenticated()) {
			return "redirect:" + ui.pageLink("referenceapplication", "home");
		}

		String redirectUrl = getStringSessionAttribute("_REFERENCE_APPLICATION_REDIRECT_URL_", pageRequest.getRequest());
		if (StringUtils.isBlank(redirectUrl)) {
			redirectUrl = pageRequest.getRequest().getParameter("redirectUrl");
		}

		if (StringUtils.isBlank(redirectUrl)) {
			redirectUrl = getRedirectUrlFromReferer(pageRequest);
		}

		if (redirectUrl == null) {
			redirectUrl = "";
		}

		model.addAttribute("redirectUrl", redirectUrl);
		Location lastSessionLocation = null;
		try {
			Context.addProxyPrivilege(VIEW_LOCATIONS);
			Context.addProxyPrivilege(GET_LOCATIONS);
			model.addAttribute("locations", appFrameworkService.getLoginLocations());
			lastSessionLocation = locationService.getLocation(Integer.valueOf(lastSessionLocationId));
		}
		catch (NumberFormatException ex) {
			// pass
		}
		finally {
			Context.removeProxyPrivilege(VIEW_LOCATIONS);
			Context.removeProxyPrivilege(GET_LOCATIONS);
		}

		model.addAttribute("lastSessionLocation", lastSessionLocation);

		return null;
	}

	private String getRedirectUrlFromReferer(PageRequest pageRequest) {
		String referer = pageRequest.getRequest().getHeader("Referer");
		String redirectUrl = "";
		if (referer != null) {
			if (referer.contains("http://") || referer.contains("https://")) {
				try {
					URL refererUrl = new URL(referer);
					String refererPath = refererUrl.getPath();
					String refererContextPath = refererPath.substring(0, refererPath.indexOf('/', 1));
					if (StringUtils.equals(pageRequest.getRequest().getContextPath(), refererContextPath)) {
						redirectUrl = refererPath;
					}
				}
				catch (MalformedURLException e) {
					log.error(e.getMessage());
				}
			} else {
				redirectUrl = pageRequest.getRequest().getHeader("Referer");
			}
		}
		return StringEscapeUtils.escapeHtml(redirectUrl);
	}

	/**
	 * Processes requests to authenticate a user
	 *
	 * @param username
	 * @param password
	 * @param sessionLocationId
	 * @param locationService
	 * @param ui                {@link UiUtils} object
	 * @param pageRequest       {@link PageRequest} object
	 * @param sessionContext
	 * @return
	 * @should redirect the user back to the redirectUrl if any
	 * @should redirect the user to the home page if the redirectUrl is the login page
	 * @should send the user back to the login page if an invalid location is selected
	 * @should send the user back to the login page when authentication fails
	 */
	public String post(@RequestParam(value = "username", required = false) String username,
	                   @RequestParam(value = "password", required = false) String password,
	                   @RequestParam(value = "sessionLocation", required = false) Integer sessionLocationId,
	                   @SpringBean("locationService") LocationService locationService, UiUtils ui, PageRequest pageRequest,
	                   UiSessionContext sessionContext) {

		String redirectUrl = pageRequest.getRequest().getParameter("redirectUrl");
		redirectUrl = getRelativeUrl(redirectUrl, pageRequest);
		Location sessionLocation = null;
		if (sessionLocationId != null) {
			try {
				// TODO as above, grant this privilege to Anonymous instead of using a proxy privilege
				Context.addProxyPrivilege(VIEW_LOCATIONS);
				Context.addProxyPrivilege(GET_LOCATIONS);
				sessionLocation = locationService.getLocation(sessionLocationId);
			}
			finally {
				Context.removeProxyPrivilege(VIEW_LOCATIONS);
				Context.removeProxyPrivilege(GET_LOCATIONS);
			}
		}

		//TODO uncomment this to replace the if clause after it
		if (sessionLocation != null && sessionLocation.hasTag(EmrApiConstants.LOCATION_TAG_SUPPORTS_LOGIN)) {
			// Set a cookie, so next time someone logs in on this machine, we can default to that same location
			pageRequest.setCookieValue("referenceapplication.lastSessionLocation", sessionLocationId.toString());

			try {
				Context.authenticate(username, password);

				if (Context.isAuthenticated()) {
					if (log.isDebugEnabled()) {
						log.debug("User has successfully authenticated");
					}

					sessionContext.setSessionLocation(sessionLocation);

					if (StringUtils.isNotBlank(redirectUrl)) {
						//don't redirect back to the login page on success nor an external url
						if (!redirectUrl.contains("login.")) {
							if (log.isDebugEnabled()) {
								log.debug("Redirecting user to " + redirectUrl);
							}

							return "redirect:" + redirectUrl;
						} else {
							if (log.isDebugEnabled()) {
								log.debug("Redirect contains 'login.', redirecting to home page");
							}
						}
					}

					return "redirect:" + ui.pageLink("referenceapplication", "home");
				}
			}
			catch (ContextAuthenticationException ex) {
				if (log.isDebugEnabled()) {
					log.debug("Failed to authenticate user");
				}

				pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_ERROR_MESSAGE_",
						ui.message("referenceapplication" + ".error.login.fail"));
			}

		} else if (sessionLocation == null) {
			pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_ERROR_MESSAGE_",
					ui.message("referenceapplication.login.error.locationRequired"));
		} else {
			// the UI shouldn't allow this, but protect against it just in case
			pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_ERROR_MESSAGE_",
					ui.message("referenceapplication.login.error.invalidLocation", sessionLocation.getName()));
		}

		if (log.isDebugEnabled()) {
			log.debug("Sending user back to login page");
		}

		//TODO limit login attempts by IP Address

		pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_REDIRECT_URL_", redirectUrl);

		return "redirect:" + ui.pageLink("referenceapplication", "login");
	}

	private String getStringSessionAttribute(String attributeName, HttpServletRequest request) {
		String attributeValue = (String) request.getSession().getAttribute(attributeName);
		request.getSession().removeAttribute(attributeName);
		return attributeValue;
	}

	public String getRelativeUrl(String url, PageRequest pageRequest) {
		if (url == null) {
			return null;
		}

		if (url.startsWith("/") || (!url.startsWith("http://") && !url.startsWith("https://"))) {
			return url;
		}

		//This is an absolute url, discard the protocal, domain name/host and port section
		int indexOfContextPath = url.indexOf(pageRequest.getRequest().getContextPath());
		if (indexOfContextPath >= 0) {
			url = url.substring(indexOfContextPath);
			log.debug("Relative redirect:" + url);

			return url;
		}

		return null;
	}
}
