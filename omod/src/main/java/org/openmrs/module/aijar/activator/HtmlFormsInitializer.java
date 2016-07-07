package org.openmrs.module.aijar.activator;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.FormService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.utils.ExtensionFormUtil;
import org.openmrs.module.formentryapp.FormEntryAppService;
import org.openmrs.module.formentryapp.FormManager;
import org.openmrs.module.formentryapp.page.controller.forms.ExtensionForm;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryService;
import org.openmrs.module.htmlformentryui.HtmlFormUtil;
import org.openmrs.ui.framework.resource.ResourceFactory;
import org.openmrs.util.OpenmrsUtil;

/**
 * Sets up the HFE forms
 * 1) Scans the webapp/resources/htmlforms folder
 * 2) Attempts to create an HFE form from each of the files
 * 3) Adds the forms as in Configure Metadata \ Manage Forms
 */
public class HtmlFormsInitializer implements Initializer {

	protected static final Log log = LogFactory.getLog(HtmlFormsInitializer.class);

	protected static final String providerName = "aijar";

	protected static final String formsPath = "htmlforms/";

	/* variable for testing forms during development */
	private List<HtmlForm> htmlForms;

	/**
	 * @see Initializer#started()
	 */
	public synchronized void started() {
		log.info("Setting HFE forms for " + AijarConstants.MODULE_ID);

		final ResourceFactory resourceFactory = Context.getRegisteredComponent("coreResourceFactory", ResourceFactory.class);
		htmlForms = new ArrayList<HtmlForm>();


		// Scanning the forms resources folder
		final List<String> formFiles = new ArrayList<String>();
		final File formsDir = resourceFactory.getResource(formsPath); // The ResourceFactory can't return File
		// instances,
		System.out.println("The forms dir is " + formsDir.getAbsolutePath());
		// hence the
		// ResourceProvider need

		if (formsDir == null || formsDir.isDirectory() == false) {
			log.error("No HTML forms could be retrieved from the provided folder: " + providerName + ":" + formsPath);
			return;
		}

		// Save form + add its meta data
		final FormManager formManager = Context.getRegisteredComponent("formManager", FormManager.class);
		final FormEntryAppService hfeAppService = Context.getRegisteredComponent("formEntryAppService",
				FormEntryAppService.class);
		final FormService formService = Context.getFormService();
		final HtmlFormEntryService hfeService = Context.getService(HtmlFormEntryService.class);
		for (File formFile : formsDir.listFiles()) {

			// Save form
			HtmlForm htmlForm = null;
			try {
				System.out.println("Adding HTML form at " + formsDir.getAbsolutePath() + formFile.getName());
				String fileXml = OpenmrsUtil.getFileAsString(formFile);
				htmlForm = HtmlFormUtil.getHtmlFormFromResourceXml(formService, hfeService, fileXml);
				// add the forms for testing purposes
				htmlForms.add(htmlForm);

				// Adds meta data
				ExtensionForm extensionForm = ExtensionFormUtil.getExtensionFormFromUiResourceAndForm(fileXml,
						hfeAppService,
						formManager, htmlForm.getForm());
				log.info("The form at " + extensionForm.getLabel() + " has been successfully loaded with its metadata");
			}
			catch (IOException e) {
				log.error("Could not open HTML form from the following resource file: " + formFile.getName(), e);
				continue;
			}
			catch (IllegalArgumentException e) {
				log.error("Error while parsing the form's XML: " + formFile, e);
				continue;
			}
			catch (Exception e) {
				log.error(
						"The form was created but its extension point could not be created in Manage Forms \\ Configure "
								+ "Metadata: "
								+ formFile, e);
				continue;
			}

		}
	}

	/**
	 * The list of loaded forms for testing purposes
	 */
	public List<HtmlForm> getAvailableForms() {
		return htmlForms;
	}

	/**
	 * @see Initializer#stopped()
	 */
	public void stopped() {
		//TODO: Perhaps disable the forms?
	}

}
