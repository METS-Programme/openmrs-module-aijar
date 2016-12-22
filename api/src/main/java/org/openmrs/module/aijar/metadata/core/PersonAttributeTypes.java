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

        @Override
        public boolean searchable() {return true;}
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
    
    public static PersonAttributeTypeDescriptor TELEPHONE_NUMBER_2 = new PersonAttributeTypeDescriptor() {
        @Override
        public double sortWeight() {
            return 8;
        }
        
        @Override
        public String name() {
            return "Alternate Telephone Number";
        }
        
        @Override
        public String description() {
            return "Alternate Telephone number";
        }
        
        public String uuid() {
            return "8c44d411-285f-46c6-9f17-c2f919823b34";
        }

        @Override
        public boolean searchable() {return true;}
    };
    
    public static PersonAttributeTypeDescriptor TELEPHONE_NUMBER_3 = new PersonAttributeTypeDescriptor() {
        @Override
        public double sortWeight() {
            return 10;
        }
        
        @Override
        public String name() {
            return "Second Alternate Telephone Number";
        }
        
        @Override
        public String description() {
            return "Second Alternate Telephone number";
        }
        
        public String uuid() {
            return "a00eda65-2f66-4fda-a683-c1787eb626a9";
        }

        @Override
        public boolean searchable() {return true;}
    };

    public static PersonAttributeTypeDescriptor OCCUPATION = new PersonAttributeTypeDescriptor() {
        @Override
        public double sortWeight() {
            return 12;
        }

        @Override
        public String name() {
            return "Occupation";
        }

        @Override
        public String description() {
            return "Occupation";
        }

        public String uuid() {
            return "b0868a16-4f8e-43da-abfc-6338c9d8f56a";
        }
    };
}
