package org.openmrs.module.aijar.tasks;

import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Person;
import org.openmrs.Relationship;
import org.openmrs.api.context.Context;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;

/**
 * Tests the task to link infants to mothers, builds on @link MotherToBabyPairLinkingPostSubmissionActionTest
 */
public class LinkExposedInfantToMotherTaskTest extends BaseModuleWebContextSensitiveTest {
	LinkExposedInfantToMotherTask task;
	
	@Before
	public void setup() throws Exception {
		executeDataSet("org/openmrs/module/aijar/include/standardTestDataset.xml");
		executeDataSet("org/openmrs/module/aijar/include/exposedInfantData.xml");
	}
	
	@Test
	public void shouldlinkExposedInfantToMother() {
		task = new LinkExposedInfantToMotherTask();
		task.execute();
		
		Person infant = Context.getPersonService().getPerson(10005);
		List<Relationship> parents = Context.getPersonService().getRelationshipsByPerson(infant);
		
		
		Assert.assertEquals("Infant linked to mother via ART number", 1, parents.size());
		Assert.assertEquals("Mother ID is 7", 7, parents.get(0).getPersonA().getPersonId().longValue() );
		Assert.assertEquals("8d91a210-c2cc-11de-8d13-0010c6dffd0f", parents.get(0).getRelationshipType().getUuid());
	}
}
