package org.openmrs.module.aijar.page.controller;

import static org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants.COOKIE_NAME_LAST_SESSION_LOCATION;
import static org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants.REQUEST_PARAMETER_NAME_REDIRECT_URL;
import static org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_REDIRECT_URL;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Locale;

import javax.servlet.http.Cookie;
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
import org.openmrs.module.appui.AppUiConstants;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.emrapi.EmrApiConstants;
import org.openmrs.module.emrapi.utils.GeneralUtils;
import org.openmrs.module.referenceapplication.ReferenceApplicationConstants;
import org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants;
import org.openmrs.module.referenceapplication.page.controller.LoginPageController;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;

/**
 * Login page copied from the Reference Application Module
 */
@Controller
public class AijarLoginPageController {
	
	private static final String GET_LOCATIONS = "Get Locations";
	private static final String VIEW_LOCATIONS = "View Locations";
	protected final Log log = LogFactory.getLog(this.getClass());
	
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
	                  @CookieValue(value = COOKIE_NAME_LAST_SESSION_LOCATION, required = false) String lastSessionLocationId,
	                  @SpringBean("locationService") LocationService locationService,
	                  @SpringBean("appFrameworkService") AppFrameworkService appFrameworkService) {
		
		String redirectUrl = getRedirectUrl(pageRequest);
		
		if (Context.isAuthenticated()) {
			if(StringUtils.isNotBlank(redirectUrl)){
				return "redirect:" + getRelativeUrl(redirectUrl, pageRequest);
			}
			return "redirect:" + ui.pageLink(ReferenceApplicationConstants.MODULE_ID, "home");
		}
		
		model.addAttribute(REQUEST_PARAMETER_NAME_REDIRECT_URL, getRelativeUrl(redirectUrl, pageRequest));
		model.addAttribute("healthCenter", Context.getAdministrationService().getGlobalProperty("aijar.healthCenterName"));
		
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
	
	private boolean isUrlWithinOpenmrs(PageRequest pageRequest, String redirectUrl){
		if (StringUtils.isNotBlank(redirectUrl)) {
			if (redirectUrl.startsWith("http://") || redirectUrl.startsWith("https://")) {
				try {
					URL url = new URL(redirectUrl);
					String urlPath = url.getFile();
					String urlContextPath = urlPath.substring(0, urlPath.indexOf('/', 1));
					if (StringUtils.equals(pageRequest.getRequest().getContextPath(), urlContextPath)) {
						return true;
					}
				} catch (MalformedURLException e) {
					log.error(e.getMessage());
				}
			} else if(redirectUrl.startsWith(pageRequest.getRequest().getContextPath())){
				return true;
			}
		}
		return false;
	}
	
	private String getRedirectUrlFromReferer(PageRequest pageRequest) {
		String manualLogout = pageRequest.getSession().getAttribute(AppUiConstants.SESSION_ATTRIBUTE_MANUAL_LOGOUT, String.class);
		String redirectUrl = "";
		if(!Boolean.valueOf(manualLogout)){
			redirectUrl = pageRequest.getRequest().getHeader("Referer");
		} else {
			Cookie cookie = new Cookie(ReferenceApplicationWebConstants.COOKIE_NAME_LAST_USER, null);
			cookie.setMaxAge(0);
			pageRequest.getResponse().addCookie(cookie);
		}
		pageRequest.getSession().setAttribute(AppUiConstants.SESSION_ATTRIBUTE_MANUAL_LOGOUT, null);
		return redirectUrl;
	}
	
	private String getRedirectUrlFromRequest(PageRequest pageRequest){
		return pageRequest.getRequest().getParameter(REQUEST_PARAMETER_NAME_REDIRECT_URL);
	}
	
	private String getRedirectUrl(PageRequest pageRequest) {
		String redirectUrl = getRedirectUrlFromRequest(pageRequest);
		if (StringUtils.isBlank(redirectUrl)) {
			redirectUrl = getStringSessionAttribute(SESSION_ATTRIBUTE_REDIRECT_URL, pageRequest.getRequest());
		}
		if (StringUtils.isBlank(redirectUrl)) {
			redirectUrl = getRedirectUrlFromReferer(pageRequest);
		}
		if (StringUtils.isNotBlank(redirectUrl) && isUrlWithinOpenmrs(pageRequest, redirectUrl)) {
			return redirectUrl;
		}
		return "";
	}
	
	/**
	 * Processes requests to authenticate a user
	 *
	 * @param username
	 * @param password
	 * @param sessionLocationId
	 * @param locationService
	 * @param ui {@link UiUtils} object
	 * @param pageRequest {@link PageRequest} object
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
		
		String redirectUrl = pageRequest.getRequest().getParameter(REQUEST_PARAMETER_NAME_REDIRECT_URL);
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
			pageRequest.setCookieValue(COOKIE_NAME_LAST_SESSION_LOCATION, sessionLocationId.toString());
			
			try {
				Context.authenticate(username, password);
				
				if (Context.isAuthenticated()) {
					if (log.isDebugEnabled())
						log.debug("User has successfully authenticated");
					
					sessionContext.setSessionLocation(sessionLocation);
					//we set the username value to check it new or old user is trying to log in
					pageRequest.setCookieValue(ReferenceApplicationWebConstants.COOKIE_NAME_LAST_USER, String.valueOf(username.hashCode()));
					
					// set the locale based on the user's default locale
					Locale userLocale = GeneralUtils.getDefaultLocale(Context.getUserContext().getAuthenticatedUser());
					if (userLocale != null) {
						Context.getUserContext().setLocale(userLocale);
						pageRequest.getResponse().setLocale(userLocale);
						new CookieLocaleResolver().setDefaultLocale(userLocale);
					}
					
					if (StringUtils.isNotBlank(redirectUrl)) {
						//don't redirect back to the login page on success nor an external url
						if (isUrlWithinOpenmrs(pageRequest, redirectUrl)) {
							if (!redirectUrl.contains("login.") && isSameUser(pageRequest, username)) {
								if (log.isDebugEnabled())
									log.debug("Redirecting user to " + redirectUrl);
								return "redirect:" + redirectUrl;
							} else {
								if (log.isDebugEnabled())
									log.debug("Redirect contains 'login.', redirecting to home page");
							}
						}
					}
					
					return "redirect:" + ui.pageLink(ReferenceApplicationConstants.MODULE_ID, "home");
				}
			}
			catch (ContextAuthenticationException ex) {
				if (log.isDebugEnabled())
					log.debug("Failed to authenticate user");
				
				pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_ERROR_MESSAGE,
						ui.message(ReferenceApplicationConstants.MODULE_ID + ".error.login.fail"));
			}
			
		} else if (sessionLocation == null) {
			pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_ERROR_MESSAGE,
					ui.message("referenceapplication.login.error.locationRequired"));
		} else {
			// the UI shouldn't allow this, but protect against it just in case
			pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_ERROR_MESSAGE,
					ui.message("referenceapplication.login.error.invalidLocation", sessionLocation.getName()));
		}
		
		if (log.isDebugEnabled())
			log.debug("Sending user back to login page");
		
		//TODO limit login attempts by IP Address
		
		pageRequest.getSession().setAttribute(SESSION_ATTRIBUTE_REDIRECT_URL, redirectUrl);
		
		return "redirect:" + ui.pageLink(ReferenceApplicationConstants.MODULE_ID, "login");
	}
	
	private boolean isSameUser(PageRequest pageRequest, String username) {
		String cookieValue = pageRequest.getCookieValue(ReferenceApplicationWebConstants.COOKIE_NAME_LAST_USER);
		int storedUsername = 0;
		if (StringUtils.isNotBlank(cookieValue)) {
			storedUsername = Integer.parseInt(cookieValue);
		}
		return cookieValue == null || storedUsername == username.hashCode();
	}
	
	private String getStringSessionAttribute(String attributeName, HttpServletRequest request) {
		Object attributeValue = request.getSession().getAttribute(attributeName);
		request.getSession().removeAttribute(attributeName);
		return attributeValue != null ? attributeValue.toString() : null;
	}
	
	public String getRelativeUrl(String url, PageRequest pageRequest) {
		if (url == null)
			return null;
		
		if (url.startsWith("/") || (!url.startsWith("http://") && !url.startsWith("https://"))) {
			return url;
		}
		
		//This is an absolute url, discard the protocal, domain name/host and port section
		if(url.startsWith("http://")){
			url = StringUtils.removeStart(url, "http://");
		} else if(url.startsWith("https://")){
			url = StringUtils.removeStart(url, "https://");
		}
		int indexOfContextPath = url.indexOf(pageRequest.getRequest().getContextPath());
		if (indexOfContextPath >= 0) {
			url = url.substring(indexOfContextPath);
			log.debug("Relative redirect:" + url);
			
			return url;
		}
		
		return null;
	}
}
