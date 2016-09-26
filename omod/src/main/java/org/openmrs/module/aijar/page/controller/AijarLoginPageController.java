package org.openmrs.module.aijar.page.controller;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Locale;

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
import org.openmrs.module.emrapi.utils.GeneralUtils;
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
 * Created by ssmusoke on 18/02/2016.
 */
@Controller
public class AijarLoginPageController {
	
	private static final String GET_LOCATIONS = "Get Locations";
	private static final String VIEW_LOCATIONS = "View Locations";
	protected final Log log = LogFactory.getLog(this.getClass());
	
	public AijarLoginPageController() {
	}
	
	public String get(PageModel model, UiUtils ui, PageRequest pageRequest, @CookieValue(value = "referenceapplication.lastSessionLocation",required = false) String lastSessionLocationId, @SpringBean("locationService") LocationService locationService, @SpringBean("appFrameworkService") AppFrameworkService appFrameworkService) {
		if(Context.isAuthenticated()) {
			return "redirect:" + ui.pageLink("referenceapplication", "home");
		} else {
			String redirectUrl = this.getStringSessionAttribute("_REFERENCE_APPLICATION_REDIRECT_URL_", pageRequest.getRequest());
			if(StringUtils.isBlank(redirectUrl)) {
				redirectUrl = pageRequest.getRequest().getParameter("redirectUrl");
			}
			
			if(StringUtils.isBlank(redirectUrl)) {
				redirectUrl = this.getRedirectUrlFromReferer(pageRequest);
			}
			
			if(redirectUrl == null) {
				redirectUrl = "";
			}
			
			model.addAttribute("redirectUrl", redirectUrl);
			Location lastSessionLocation = null;
			
			try {
				Context.addProxyPrivilege("View Locations");
				Context.addProxyPrivilege("Get Locations");
				model.addAttribute("locations", appFrameworkService.getLoginLocations());
				lastSessionLocation = locationService.getLocation(Integer.valueOf(lastSessionLocationId));
			} catch (NumberFormatException var13) {
				;
			} finally {
				Context.removeProxyPrivilege("View Locations");
				Context.removeProxyPrivilege("Get Locations");
			}
			
			model.addAttribute("lastSessionLocation", lastSessionLocation);
			return null;
		}
	}
	
	private String getRedirectUrlFromReferer(PageRequest pageRequest) {
		String referer = pageRequest.getRequest().getHeader("Referer");
		String redirectUrl = "";
		if(referer != null) {
			String manualLogout = (String)pageRequest.getSession().getAttribute("manual-logout", String.class);
			if(!"true".equals(manualLogout)) {
				if(!referer.contains("http://") && !referer.contains("https://")) {
					redirectUrl = pageRequest.getRequest().getHeader("Referer");
				} else {
					try {
						URL e = new URL(referer);
						String refererPath = e.getFile();
						String refererContextPath = refererPath.substring(0, refererPath.indexOf(47, 1));
						if(StringUtils.equals(pageRequest.getRequest().getContextPath(), refererContextPath)) {
							redirectUrl = refererPath;
						}
					} catch (MalformedURLException var8) {
						this.log.error(var8.getMessage());
					}
				}
			}
			
			pageRequest.getSession().setAttribute("manual-logout", (Object)null);
		}
		
		return StringEscapeUtils.escapeHtml(redirectUrl);
	}
	
	public String post(@RequestParam(value = "username",required = false) String username, @RequestParam(value = "password",required = false) String password, @RequestParam(value = "sessionLocation",required = false) Integer sessionLocationId, @SpringBean("locationService") LocationService locationService, UiUtils ui, PageRequest pageRequest, UiSessionContext sessionContext) {
		String redirectUrl = pageRequest.getRequest().getParameter("redirectUrl");
		redirectUrl = this.getRelativeUrl(redirectUrl, pageRequest);
		Location sessionLocation = null;
		if(sessionLocationId != null) {
			try {
				Context.addProxyPrivilege("View Locations");
				Context.addProxyPrivilege("Get Locations");
				sessionLocation = locationService.getLocation(sessionLocationId);
			} finally {
				Context.removeProxyPrivilege("View Locations");
				Context.removeProxyPrivilege("Get Locations");
			}
		}
		
		if(sessionLocation != null && sessionLocation.hasTag("Login Location").booleanValue()) {
			pageRequest.setCookieValue("referenceapplication.lastSessionLocation", sessionLocationId.toString());
			
			try {
				Context.authenticate(username, password);
				if(Context.isAuthenticated()) {
					if(this.log.isDebugEnabled()) {
						this.log.debug("User has successfully authenticated");
					}
					
					sessionContext.setSessionLocation(sessionLocation);
					Locale ex = GeneralUtils.getDefaultLocale(Context.getUserContext().getAuthenticatedUser());
					if(ex != null) {
						Context.getUserContext().setLocale(ex);
						pageRequest.getResponse().setLocale(ex);
						(new CookieLocaleResolver()).setDefaultLocale(ex);
					}
					
					if(StringUtils.isNotBlank(redirectUrl)) {
						if(!redirectUrl.contains("login.")) {
							if(this.log.isDebugEnabled()) {
								this.log.debug("Redirecting user to " + redirectUrl);
							}
							
							return "redirect:" + redirectUrl;
						}
						
						if(this.log.isDebugEnabled()) {
							this.log.debug("Redirect contains \'login.\', redirecting to home page");
						}
					}
					
					return "redirect:" + ui.pageLink("referenceapplication", "home");
				}
			} catch (ContextAuthenticationException var14) {
				if(this.log.isDebugEnabled()) {
					this.log.debug("Failed to authenticate user");
				}
				
				pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_ERROR_MESSAGE_", ui.message("referenceapplication.error.login.fail", new Object[0]));
			}
		} else if(sessionLocation == null) {
			pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_ERROR_MESSAGE_", ui.message("referenceapplication.login.error.locationRequired", new Object[0]));
		} else {
			pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_ERROR_MESSAGE_", ui.message("referenceapplication.login.error.invalidLocation", new Object[]{sessionLocation.getName()}));
		}
		
		if(this.log.isDebugEnabled()) {
			this.log.debug("Sending user back to login page");
		}
		
		pageRequest.getSession().setAttribute("_REFERENCE_APPLICATION_REDIRECT_URL_", redirectUrl);
		return "redirect:" + ui.pageLink("referenceapplication", "login");
	}
	
	private String getStringSessionAttribute(String attributeName, HttpServletRequest request) {
		Object attributeValue = request.getSession().getAttribute(attributeName);
		request.getSession().removeAttribute(attributeName);
		return attributeValue != null?attributeValue.toString():null;
	}
	
	public String getRelativeUrl(String url, PageRequest pageRequest) {
		if(url == null) {
			return null;
		} else if(!url.startsWith("/") && (url.startsWith("http://") || url.startsWith("https://"))) {
			int indexOfContextPath = url.indexOf(pageRequest.getRequest().getContextPath());
			if(indexOfContextPath >= 0) {
				url = url.substring(indexOfContextPath);
				this.log.debug("Relative redirect:" + url);
				return url;
			} else {
				return null;
			}
		} else {
			return url;
		}
	}

}
