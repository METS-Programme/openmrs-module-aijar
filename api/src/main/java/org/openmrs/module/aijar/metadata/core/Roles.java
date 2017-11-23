package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.PrivilegeDescriptor;
import org.openmrs.module.metadatadeploy.descriptor.RoleDescriptor;

import java.util.Arrays;
import java.util.List;

/**
 * Basic roles
 * <p/>
 * Created by ssmusoke on 11/01/2016.
 */
public class Roles {

    public static RoleDescriptor DATA_MANAGER = new RoleDescriptor() {
        @Override
        public String role() {
            return "Aijar Role: Data Manager";
        }

        @Override
        public String description() {
            return "Aijar Role: Data Manager";
        }

        @Override
        public List<PrivilegeDescriptor> privileges() {
            return Arrays.asList(
                    Privileges.APP_COREAPPS_ACTIVE_VISITS,
                    Privileges.APP_COREAPPS_FIND_PATIENT,

                    Privileges.APP_COREAPPS_PATIENT_DASHBOARD,
                    Privileges.APP_COREAPPS_PATIENT_VISITS
            );
        }

        public String uuid() {
            return "f92705e3-6d34-4009-8ad3-b0ea80dab140";
        }
    };

    public static RoleDescriptor RECORDS_OFFICER = new RoleDescriptor() {
        @Override
        public String role() {
            return "Aijar Role: Records Officer";
        }

        @Override
        public String description() {
            return "Aijar Role: Records Officer";
        }

        @Override
        public List<PrivilegeDescriptor> privileges() {
            return null;
        }

        public String uuid() {
            return "f92705e3-6d34-4010-8ad3-b0ea80dab141";
        }
    };
    
    public static RoleDescriptor MID_WIFE = new RoleDescriptor() {
    
        @Override
        public String role() {
            return "Midwife";
        }
    
        @Override
        public String description() {
            return "Midwife role for Maternity";
        }
    
        @Override
        public List<PrivilegeDescriptor> privileges() {
            return null;
        }
    
        @Override
        public String uuid() {
            return "28de5e93-5462-4e25-8a6a-a980b637dc61";
        }
    };

}
