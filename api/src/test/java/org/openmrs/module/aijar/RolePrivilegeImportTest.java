package org.openmrs.module.aijar;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.api.UserService;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataexchange.DataImporter;
import org.openmrs.test.BaseModuleContextSensitiveTest;

public class RolePrivilegeImportTest extends BaseModuleContextSensitiveTest {


    protected static final String ROLE_PRIVILLEGE_DATASET_XML = "metadata/Role_Privilege.xml";

    @Test
    public void shouldImportWithOutAnyError() {
        UserService userService= Context.getUserService();
        DataImporter dataImporter = Context.getRegisteredComponent("dataImporter", DataImporter.class);
        dataImporter.importData(ROLE_PRIVILLEGE_DATASET_XML);
        Assert.assertNotNull(userService.getPrivilege("App: ugandaemrpoc.findPatient"));
        Assert.assertNotNull(userService.getRole("Data Clerk"));
        Assert.assertTrue(userService.getRole("Data Clerk").getPrivileges().contains(userService.getPrivilege("App: ugandaemrpoc.findPatient")));
    }
}
