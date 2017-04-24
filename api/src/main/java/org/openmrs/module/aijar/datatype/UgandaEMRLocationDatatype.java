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

package org.openmrs.module.aijar.datatype;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Location;
import org.openmrs.api.context.Context;
import org.openmrs.customdatatype.SerializingCustomDatatype;
import org.springframework.stereotype.Component;

/**
 * Custom datatype for {@link Location}.
 * (This should be moved to the OpenMRS core.)
 */
@Component
public class UgandaEMRLocationDatatype extends SerializingCustomDatatype<Location> {

    /**
     * @see SerializingCustomDatatype#deserialize(String)
     */
    @Override
    public Location deserialize(String serializedValue) {
        if (StringUtils.isEmpty(serializedValue)) {
            return null;
        }

        return Context.getLocationService().getLocation(Integer.valueOf(serializedValue));
    }

    /**
     * @see SerializingCustomDatatype#serialize(Object)
     */
    @Override
    public String serialize(Location typedValue) {
        if (typedValue == null) {
            return null;
        }

        return typedValue.getLocationId().toString();
    }
}