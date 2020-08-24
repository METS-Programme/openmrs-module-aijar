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

	public static LocationDescriptor TRIAGE = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "ff01eaab-561e-40c6-bf24-539206b521ce";
		}

		@Override
		public String description() {
			return "A location for categorization of patients";
		}

		@Override
		public String name() {
			return "Triage";
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

	public static LocationDescriptor RECEPTION = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "4501e132-07a2-4201-9dc8-2f6769b6d412";
		}

		@Override
		public String description() {
			return "A Location for registering patients";
		}

		@Override
		public String name() {
			return "Reception";
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

	public static LocationDescriptor PHARMACY = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "3ec8ff90-3ec1-408e-bf8c-22e4553d6e17";
		}

		@Override
		public String description() {
			return "A place for preparing, dispensing, and reviewing drugs and providing additional clinical services";
		}

		@Override
		public String name() {
			return "Pharmacy";
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

	public static LocationDescriptor COUNSELING_CENTER = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "7c231e1a-1db5-11ea-978f-2e728ce88125";
		}

		@Override
		public String description() {
			return "A location where counseling and screening is done for a patient";
		}

		@Override
		public String name() {
			return "Counseling Center";
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

	public static LocationDescriptor Community = new LocationDescriptor(){

		@Override
		public String uuid() {
			return "841cb8d9-b662-41ad-9e7f-d476caac48aa";
		}

		@Override
		public String description() {
			return "This is a location that serves all clients on community based DSD Models";
		}

		@Override
		public String name() {
			return "COMMUNITY";
		}

		@Override
		public LocationDescriptor parent() {
			return PARENT;
		}

		@Override
		public List<LocationTagDescriptor> tags() {

			return Arrays.asList(
					LocationTags.VISIT_LOCATION
			);

		}

	};

}
