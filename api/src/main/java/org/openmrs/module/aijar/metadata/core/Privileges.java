package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.PrivilegeDescriptor;

/**
 * Constants for all defined privileges
 */
public class Privileges {

    //
    // APP PRIVILEGES
    //

    public static PrivilegeDescriptor APP_APPOINTMENTSCHEDULINGUI_APPOINTMENT_TYPES = new PrivilegeDescriptor() {
        public String uuid() {
            return "80013028-96c8-4e96-b680-e19032f22571";
        }

        public String privilege() {
            return "App: appointmentschedulingui.appointmentTypes";
        }

        public String description() {
            return "Access to the Manage Service Types app";
        }
    };

    public static PrivilegeDescriptor APP_APPOINTMENTSCHEDULINGUI_HOME = new PrivilegeDescriptor() {
        public String uuid() {
            return "607be939-6684-49b1-9bf0-38f5153a5346";
        }

        public String privilege() {
            return "App: appointmentschedulingui.home";
        }

        public String description() {
            return "Access to the Appointment Scheduling home page";
        }
    };

    public static PrivilegeDescriptor APP_APPOINTMENTSCHEDULINGUI_PROVIDER_SCHEDULES = new PrivilegeDescriptor() {
        public String uuid() {
            return "18d90abd-1a59-49ea-b211-9726801cc434";
        }

        public String privilege() {
            return "App: appointmentschedulingui.providerSchedules";
        }

        public String description() {
            return "Access to the Manage Provider Schedules app";
        }
    };

    public static PrivilegeDescriptor APP_APPOINTMENTSCHEDULINGUI_VIEW_APPOINTMENTS = new PrivilegeDescriptor() {
        public String uuid() {
            return "a8a5bcb9-73d5-44a1-b90f-b38feccdaf21";
        }

        public String privilege() {
            return "App: appointmentschedulingui.viewAppointments";
        }

        public String description() {
            return "Access to Manage Appointments and Daily Scheduled Appointments (but not the ability to book appointments from these pages)";
        }
    };

    public static PrivilegeDescriptor APP_COREAPPS_ACTIVE_VISITS = new PrivilegeDescriptor() {
        public String uuid() {
            return "7ed67678-7b02-4fe6-8f53-f4a1a2ffa879";
        }

        public String privilege() {
            return "App: coreapps.activeVisits";
        }

        public String description() {
            return "Able to access the active visits app";
        }
    };

    public static PrivilegeDescriptor APP_COREAPPS_AWAITING_ADMISSION = new PrivilegeDescriptor() {
        public String uuid() {
            return "7232d5a2-f890-4834-a0ea-e88eadc8aae2";
        }

        public String privilege() {
            return "App: coreapps.awaitingAdmission";
        }

        public String description() {
            return "Privilege to use the Awaiting Admission app";
        }
    };

    public static PrivilegeDescriptor APP_COREAPPS_DATA_MANAGEMENT = new PrivilegeDescriptor() {
        public String uuid() {
            return "d82f58c3-f4f5-41de-8ff6-1b2d460d782d";
        }

        public String privilege() {
            return "App: coreapps.dataManagement";
        }

        public String description() {
            return "Able to access data management apps";
        }
    };

    public static PrivilegeDescriptor APP_COREAPPS_FIND_PATIENT = new PrivilegeDescriptor() {
        public String uuid() {
            return "e4eb01c1-967a-4091-a2a0-ec933903fd54";
        }

        public String privilege() {
            return "App: coreapps.findPatient";
        }

        public String description() {
            return "Able to access the find patient app";
        }
    };

    public static PrivilegeDescriptor APP_COREAPPS_PATIENT_DASHBOARD = new PrivilegeDescriptor() {
        public String uuid() {
            return "5873798c-39e9-430c-856a-a8bf372f992e";
        }

        public String privilege() {
            return "App: coreapps.patientDashboard";
        }

        public String description() {
            return "Able to access the patient dashboard";
        }
    };

    public static PrivilegeDescriptor APP_COREAPPS_PATIENT_VISITS = new PrivilegeDescriptor() {
        public String uuid() {
            return "\t61572c7b-bcec-475c-a710-468b31a74b7e";
        }

        public String privilege() {
            return "App: coreapps.patientVisits";
        }

        public String description() {
            return "Able to access the patient visits screen";
        }
    };


   /* public static PrivilegeDescriptor APP_COREAPPS_PATIENT_DASHBOARD = new PrivilegeDescriptor() {
        public String uuid() { return "b37491af-10df-4465-863c-0a7f5d612c08"; }
        public String privilege() { return CoreAppsConstants.PRIVILEGE_PATIENT_DASHBOARD; }
        public String description() { return "Able to access the patient dashboard"; }
    };

    public static PrivilegeDescriptor APP_COREAPPS_PATIENT_VISITS = new PrivilegeDescriptor() {
        public String uuid() { return "908aa2ce-cdd6-4b77-9664-bbcdb011432a"; }
        public String privilege() { return CoreAppsConstants.PRIVILEGE_PATIENT_VISITS; }
        public String description() { return "Able to access the patient visits screen"; }
    };*/

    public static PrivilegeDescriptor APP_DISPENSING_APP_DISPENSE = new PrivilegeDescriptor() {
        public String uuid() {
            return "769a12c2-6ff0-42ba-888e-52e66ed16fb7";
        }

        public String privilege() {
            return "App: dispensing.app.dispense";
        }

        public String description() {
            return "Access to dispensing medication app";
        }
    };

    public static PrivilegeDescriptor APP_EMR_ARCHIVES_ROOM = new PrivilegeDescriptor() {
        public String uuid() {
            return "24fb3877-c07e-436f-8005-ce7a81245fcd";
        }

        public String privilege() {
            return "App: emr.archivesRoom";
        }

        public String description() {
            return "Run the Archives Room app";
        }
    };

    public static PrivilegeDescriptor APP_EMR_INPATIENTS = new PrivilegeDescriptor() {
        public String uuid() {
            return "60ce8766-57cc-4e4f-8356-6bbe3f56f980";
        }

        public String privilege() {
            return "App: emr.inpatients";
        }

        public String description() {
            return "Right to view the Impatient app";
        }
    };

    public static PrivilegeDescriptor APP_EMR_SYSTEM_ADMINISTRATION = new PrivilegeDescriptor() {
        public String uuid() {
            return "6d01acf6-ba11-4634-866b-489eaa951681";
        }

        public String privilege() {
            return "App: emr.systemAdministration";
        }

        public String description() {
            return "Run the System Administration app";
        }
    };

    public static PrivilegeDescriptor APP_LEGACY_ADMIN = new PrivilegeDescriptor() {
        public String uuid() {
            return "18c8d715-8845-44e3-ac62-4b613f00e082";
        }

        public String privilege() {
            return "App: legacy.admin";
        }

        public String description() {
            return "Run the (Legacy) OpenMRS Administration app";
        }
    };

    public static PrivilegeDescriptor APP_REGISTRATION_REGISTER_PATIENT = new PrivilegeDescriptor() {
        public String uuid() {
            return "744d914c-8b1f-4f0e-abfb-b4ee17ad0865";
        }

        public String privilege() {
            return "App: registrationapp.registerPatient";
        }

        public String description() {
            return "Able to access the register patient app";
        }
    };

    public static PrivilegeDescriptor APP_REPORTINGUI_ADHOC_ANALYSIS = new PrivilegeDescriptor() {
        public String uuid() {
            return "89cde56a-d8cc-4261-b491-38a1296edce0";
        }

        public String privilege() {
            return "App: reportingui.adHocAnalysis";
        }

        public String description() {
            return "Use the Ad Hoc Analysis tool";
        }
    };

    public static PrivilegeDescriptor APP_REPORTINGUI_REPORTS = new PrivilegeDescriptor() {
        public String uuid() {
            return "a4bb96b4-b3cb-4e3c-9251-a7c0ca173035";
        }

        public String privilege() {
            return "App: reportingui.reports";
        }

        public String description() {
            return "Use the Reports app provided by the reportingui module";
        }
    };

}