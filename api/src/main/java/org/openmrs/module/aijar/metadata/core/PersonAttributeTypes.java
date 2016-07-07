package org.openmrs.module.aijar.metadata.core;

import org.openmrs.Concept;
import org.openmrs.Location;
import org.openmrs.module.metadatadeploy.descriptor.PersonAttributeTypeDescriptor;

/**
 * Constants for all defined person attiribute types
 * <p/>
 * Created by ssmusoke on 09/01/2016.
 */
public class PersonAttributeTypes {

	public static PersonAttributeTypeDescriptor MARITAL_STATUS = new PersonAttributeTypeDescriptor() {

		@Override
		public double sortWeight() {
			return 0;
		}

		@Override
		public Class<?> format() {
			return Concept.class;
		}

		@Override
		public String name() {
			return "Marital Status";
		}

		@Override
		public String description() {
			return "Marital status of this person";
		}

		public String uuid() {
			return "8d871f2a-c2cc-11de-8d13-0010c6dffd0f";
		}
	};

	public static PersonAttributeTypeDescriptor HEALTH_CENTER = new PersonAttributeTypeDescriptor() {

		@Override
		public double sortWeight() {
			return 3;
		}

		@Override
		public Class<?> format() {
			return Location.class;
		}

		@Override
		public String name() {
			return "Health Center";
		}

		@Override
		public String description() {
			return "Specific Location of this person's home health center";
		}

		public String uuid() {
			return "8d87236c-c2cc-11de-8d13-0010c6dffd0f";
		}
	};

	public static PersonAttributeTypeDescriptor HEALTH_FACILITY_DISTRICT = new PersonAttributeTypeDescriptor() {

		@Override
		public double sortWeight() {
			return 6;
		}

		@Override
		public String name() {
			return "Health Facility District";
		}

		@Override
		public String description() {
			return "District/region in which this patient' home health center resides";
		}

		public String uuid() {
			return "8d872150-c2cc-11de-8d13-0010c6dffd0f";
		}
	};
}
