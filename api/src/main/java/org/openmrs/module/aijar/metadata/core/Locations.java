package org.openmrs.module.aijar.metadata.core;

import java.util.Arrays;
import java.util.List;

import org.openmrs.module.metadatadeploy.descriptor.LocationDescriptor;
import org.openmrs.module.metadatadeploy.descriptor.LocationTagDescriptor;

public class Locations {
	
	public static LocationDescriptor TB_CLINIC = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "8ab22b55-9a17-4121-bf08-6134a9a2439f";
		}

		@Override
		public String description() {
			return "Clinic where TB Care and Treatment Services are provided";
		}

		@Override
		public String name() {
			return "TB Clinic";
		}
		
		@Override
		public List<LocationTagDescriptor> tags() {			
			
			return Arrays.asList(
					LocationTags.LOGIN_LOCATION,
					LocationTags.VISIT_LOCATION
					);
			
		}
		
	};

}
