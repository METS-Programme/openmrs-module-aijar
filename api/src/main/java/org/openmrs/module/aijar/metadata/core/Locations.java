package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.LocationDescriptor;
import org.openmrs.module.metadatadeploy.descriptor.LocationTagDescriptor;

import java.util.Arrays;
import java.util.List;

/**
 * Locations defined these are the different service points within the facility include ART Clinic, ANC, TB
 * <p/>
 * Created by ssmusoke on 09/01/2016.
 */
public class Locations {

    public static LocationDescriptor HEALTH_FACILITY = new LocationDescriptor() {
        @Override
        public String name() {
            return "Health Center Name";
        }

        @Override
        public String description() {
            return "The health center where services are provided";
        }

        public String uuid() {
            return "e9bc61b5-69ff-414b-9cf0-0c22d6dfca2b";
        }

        public List<LocationTagDescriptor> tags() {
            return Arrays.asList(LocationTags.VISIT_LOCATION, LocationTags.ADMISSION_LOCATION, LocationTags.LOGIN_LOCATION, LocationTags.TRANSFER_LOCATION);
        }
    };
}
