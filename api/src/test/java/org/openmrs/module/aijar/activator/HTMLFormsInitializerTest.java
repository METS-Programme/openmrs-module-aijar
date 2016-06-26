package org.openmrs.module.aijar.activator;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormValidator;
import org.openmrs.test.BaseModuleContextSensitiveTest;
import org.openmrs.test.Verifies;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;

/**
 * Validate that the forms to be deployed are well formed
 */
public class HTMLFormsInitializerTest extends BaseModuleContextSensitiveTest {

	/**
	 * @see {@link HtmlFormValidator#validate(Object, Errors)}
	 */
	@Test
	@Verifies(value = "inbuilt HTML forms are well formed", method = "validate(Object,Errors)")
	public void validate_formsAreWellFormed() throws Exception {

		HtmlFormsInitializer hfi = new HtmlFormsInitializer();
		hfi.started();
		List<HtmlForm> forms = hfi.getAvailableForms();

		for (HtmlForm form : forms) {
			HtmlFormValidator hfv = new HtmlFormValidator();
			Errors errors = new BindException(form, "htmlForm");
			hfv.validate(form, errors);
			Assert.assertFalse("Error validating " + form.getName() + errors.toString(), errors.hasErrors());
		}
	}
	
}
