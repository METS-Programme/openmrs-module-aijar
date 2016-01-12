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

    public static LocationDescriptor ART_CLINIC = new LocationDescriptor() {
        @Override
        public String name() {
            return "ART Clinic";
        }

        @Override
        public String description() {
            return "The clinic where ART services are provided";
        }

        public String uuid() {
            return "e9bc61b5-69ff-414b-9cf0-0c22d6dfca2b";
        }

        public List<LocationTagDescriptor> tags() {
            return Arrays.asList(LocationTags.VISIT_LOCATION, LocationTags.ADMISSION_LOCATION, LocationTags.LOGIN_LOCATION, LocationTags.TRANSFER_LOCATION);
        }
    };

    public static LocationDescriptor ANC_CLINIC = new LocationDescriptor() {
        @Override
        public String name() {
            return "ANC Clinic";
        }

        @Override
        public String description() {
            return "The clinic where ante-natal services are provided";
        }

        public String uuid() {
            return "86863db4-6101-4ecf-9a86-5e716d6504e4";
        }

        public List<LocationTagDescriptor> tags() {
            return Arrays.asList(LocationTags.VISIT_LOCATION, LocationTags.ADMISSION_LOCATION, LocationTags.LOGIN_LOCATION, LocationTags.TRANSFER_LOCATION);
        }
    };


}
