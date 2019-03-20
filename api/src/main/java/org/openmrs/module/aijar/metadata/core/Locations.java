package org.openmrs.module.aijar.metadata.core;

import java.util.Arrays;
import java.util.List;

import org.openmrs.Location;
import org.openmrs.api.context.Context;
import org.openmrs.module.metadatadeploy.descriptor.LocationDescriptor;
import org.openmrs.module.metadatadeploy.descriptor.LocationTagDescriptor;

public class Locations {

	public static LocationDescriptor PARENT = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "629d78e9-93e5-43b0-ad8a-48313fd99117";
		}

		@Override
		public String description() {
			return "Health Center Location";
		}

		@Override
		public String name() {
			return Context.getLocationService().getLocationByUuid("629d78e9-93e5-43b0-ad8a-48313fd99117").getName();
		}

		@Override
		public List<LocationTagDescriptor> tags() {

			return Arrays.asList(
					LocationTags.LOGIN_LOCATION,
					LocationTags.VISIT_LOCATION
			);

		}

	};

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
		public LocationDescriptor parent() {
			return PARENT;
		}

		@Override
		public List<LocationTagDescriptor> tags() {

			return Arrays.asList(
					LocationTags.LOGIN_LOCATION,
					LocationTags.VISIT_LOCATION
			);

		}

	};

	public static LocationDescriptor OPD_CLINIC = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "11d5d2b8-0fdd-42e0-9f53-257c760bb9a3";
		}

		@Override
		public String description() {
			return "Clinic where Out-Patient Services are provided";
		}

		@Override
		public String name() {
			return "OPD Clinic";
		}

		@Override
		public LocationDescriptor parent() {
			return PARENT;
		}

		@Override
		public List<LocationTagDescriptor> tags() {

			return Arrays.asList(
					LocationTags.LOGIN_LOCATION,
					LocationTags.VISIT_LOCATION
			);

		}

	};

	public static LocationDescriptor UNKNOWN = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "8d6c993e-c2cc-11de-8d13-0010c6dffd0f";
		}

		@Override
		public String description() {
			return "Unknown location";
		}

		@Override
		public String name() {
			return "Unknown";
		}

		@Override
		public LocationDescriptor parent() {
			return PARENT;
		}

	};

}
