/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.aijar;

import org.junit.Test;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataexchange.DataImporter;
import org.openmrs.test.BaseModuleContextSensitiveTest;

/**
 * Created by ningosi on 3/17/17.
 * Provide testing environment for imported concepts
 */
public class ConceptImportTest extends BaseModuleContextSensitiveTest {

    @Test
    public void shouldSaveProgramConcepts(){
        DataImporter dataImporter = Context.getRegisteredComponent("dataImporter", DataImporter.class);

        dataImporter.importData("metadata/Concepts_Programs-1.xml");
    }
}
