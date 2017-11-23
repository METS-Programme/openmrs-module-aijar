package org.openmrs.module.aijar.activator;

/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 * <p/>
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * <p/>
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */


/**
 * Interface for code to be run during the module activation process
 * @see {@link https://raw.githubusercontent.com/PIH/openmrs-module-pihmalawi/master/api/src/main/java/org/openmrs/module/pihmalawi/activator/Initializer.java}
 */
public interface Initializer {

    /**
     * Run during the activator started method
     */
    void started();

    /**
     * Run during the activator stopped method
     */
    void stopped();
}