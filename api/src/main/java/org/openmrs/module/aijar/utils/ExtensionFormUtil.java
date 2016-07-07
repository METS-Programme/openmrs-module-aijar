package org.openmrs.module.aijar.utils;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.LogFactory;
import org.openmrs.Form;
import org.openmrs.module.appframework.domain.Extension;
import org.openmrs.module.formentryapp.FormEntryAppService;
import org.openmrs.module.formentryapp.FormManager;
import org.openmrs.module.formentryapp.page.controller.forms.ExtensionForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 * Equivalent of HtmlFormUtil for ExtensionForm objects.
 *
 * @author Dimitri Renault
 */
public class ExtensionFormUtil {

	public static final String DEFAULT_UILOCATION = "patientDashboard.overallActions";

	protected static final org.apache.commons.logging.Log log = LogFactory.getLog(ExtensionFormUtil.class);

	protected static final String DISPLAY_STYLE = "displayStyle";

	/**
	 * Returns the ExtensionForm corresponding to a Form instance AND saves it.
	 *
	 * @param fileXml The XML string for the file
	 * @param form         The Form instance
	 */
	public static ExtensionForm getExtensionFormFromUiResourceAndForm(String fileXml, FormEntryAppService hfeAppService,
	                                                                  FormManager formManager, Form form) throws Exception {

		final ExtensionForm extensionForm = getExtensionFormFromXML(fileXml);
		extensionForm.setId("");
		extensionForm.setLabel(form.getName());
		extensionForm.setForm(form);

		// If this form is already saved on the specified UI location, we remove it first
		final List<Extension> extensions = hfeAppService.getFormExtensions(form);
		String defaultPrivilege = "";
		for (Extension extension : extensions) {
			final ExtensionForm runningExtensionForm = new ExtensionForm();
			runningExtensionForm.copyFrom(extension);
			if (runningExtensionForm.getUiLocation().equals(extensionForm.getUiLocation())) {
				defaultPrivilege = extension.getRequiredPrivilege();
				hfeAppService.purgeFormExtension(form, extension);
				break;
			}
		}
		if (extensionForm.getRequiredPrivilege() == null) {
			extensionForm.setRequiredPrivilege(defaultPrivilege);
		}

		// Then if the provided UI location is valid, we add it to that one
		final Set<String> allowedUiLocations = new HashSet<String>(formManager.getUILocations(form));
		if (allowedUiLocations.contains(extensionForm.getUiLocation())) {
			if (extensionForm.getOrder() != null) {    // This must be satisfied when the XML has been parsed (a bit clunky)
				final Extension extension = new Extension();
				extensionForm.copyTo(extension);

				extension.setType("link");
				Map<String, String> options = new HashMap<String, String>();
				options.put(DISPLAY_STYLE, extensionForm.getDisplayStyle());
				extension.setUrl(getFormUrl(extensionForm.getForm(), options));
				//				extension.setUrl(formManager.getFormUrl(extensionForm.getForm(), options));

				hfeAppService.saveFormExtension(form, extension);
			}
		}

		return extensionForm;
	}

	/**
	 * @return A <i>partially</i> filled ExtensionForm from the XML representation of a form.
	 */
	protected static ExtensionForm getExtensionFormFromXML(String formXml) throws Exception {

		Document doc = HtmlFormEntryUtil.stringToDocument(formXml);
		Node htmlFormNode = HtmlFormEntryUtil.findChild(doc, "htmlform");

		String processFlag = getAttributeStringValue(htmlFormNode, "formAddMetadata", "");
		processFlag = processFlag.trim().toLowerCase();
		boolean doProcess = processFlag.equalsIgnoreCase("yes") || processFlag.equalsIgnoreCase("true") || processFlag
				.equalsIgnoreCase("1");

		final ExtensionForm extensionForm = new ExtensionForm();
		if (doProcess) {
			extensionForm.setOrder(getAttributeIntegerValue(htmlFormNode, "formOrder", 0));
			extensionForm.setUiLocation(getAttributeStringValue(htmlFormNode, "formUILocation", DEFAULT_UILOCATION));
			extensionForm.setIcon(getAttributeStringValue(htmlFormNode, "formIcon", "icon-file"));
			extensionForm.setDisplayStyle(getAttributeStringValue(htmlFormNode, "formDisplayStyle", "Simple"));
			extensionForm.setShowIf(getAttributeStringValue(htmlFormNode, "formShowIf", ""));
			extensionForm.setRequiredPrivilege(getAttributeStringValue(htmlFormNode, "formPrivilege", null));
		}

		return extensionForm;
	}

	protected static String getAttributeStringValue(Node htmlForm, String attributeName, String defaultValue) {
		Node item = htmlForm.getAttributes().getNamedItem(attributeName);
		return item == null ? defaultValue : item.getNodeValue();
	}

	protected static int getAttributeIntegerValue(Node htmlForm, String attributeName, int defaultValue) {
		String stringValue = getAttributeStringValue(htmlForm, attributeName, (new Integer(defaultValue)).toString());
		int val = defaultValue;
		try {
			val = Integer.parseInt(stringValue);
		}
		catch (NumberFormatException e) {
			log.error(stringValue + "could not be parsed to an integer while parsing\n" + htmlForm.toString(), e);
		}
		return val;
	}

	/**
	 * {@link FormManager#getFormUrl(Form, Map)} eventually fails if there is no authenticated user.
	 * Hence the need for this simpler version of it.
	 */
	protected static String getFormUrl(Form form, Map<String, String> options) {
		String displayStyle = options.get(DISPLAY_STYLE);
		String url = "htmlformentryui/htmlform/enterHtmlFormWith" + displayStyle
				+ "Ui.page?patientId={{patient.uuid}}&visitId={{visit.uuid}}&formUuid=";
		return url + form.getUuid();
	}
}
