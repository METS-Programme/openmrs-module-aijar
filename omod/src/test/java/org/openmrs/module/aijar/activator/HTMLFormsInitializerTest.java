package org.openmrs.module.aijar.activator;

import java.io.File;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;
import org.openmrs.api.context.Context;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryService;
import org.openmrs.module.htmlformentry.HtmlFormValidator;
import org.openmrs.test.Verifies;
import org.openmrs.ui.framework.resource.ModuleResourceProvider;
import org.openmrs.ui.framework.resource.ResourceFactory;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;
import org.springframework.validation.Errors;

/**
 * Validate that the forms to be deployed are well formed
 */
public class HTMLFormsInitializerTest extends BaseModuleWebContextSensitiveTest {

	/**
	 * @see {@link HtmlFormValidator#validate(Object, Errors)}
	 */
	@Test
	@Verifies(value = "inbuilt HTML forms are well formed", method = "validate(Object,Errors)")
	public void validate_formsAreWellFormed() throws Exception {

		ModuleResourceProvider rp = Mockito.mock(ModuleResourceProvider.class);
		Mockito.when(rp.getResource(Mockito.eq("htmlforms/"))).thenReturn(new File
				("src/main/webapp/resources/htmlforms/"));
		final ResourceFactory resourceFactory = Context.getRegisteredComponent("coreResourceFactory", ResourceFactory
				.class);
		resourceFactory.addResourceProvider("aijar", rp);

		HtmlFormsInitializer hfi = new HtmlFormsInitializer();
		hfi.started();
		List<HtmlForm> forms = hfi.getAvailableForms();

		if (forms.size() == 0) {
			Assert.assertTrue("There are no HTML forms loaded", false);
		}

		// check that the file on the file system is the same as that which has been saved
		HtmlFormEntryService hfe = Context.getService(HtmlFormEntryService.class);
		for (HtmlForm form : forms) {
			System.out.println("Verifying " + form.getName() + " was saved correctly");
			HtmlForm savedVersion = hfe.getHtmlFormByUuid(form.getUuid());
			Assert.assertEquals(savedVersion, form);
		}
	}
	
}
