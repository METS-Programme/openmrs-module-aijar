package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.aijar.metadata.core.*;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.encounterRole;
import org.springframework.stereotype.Component;

/**
 * Installs the common metadata
 */
@Component
public class CommonMetadataBundle extends AbstractMetadataBundle {

    /**
     * @see org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle#install()
     */
    public void install() throws Exception {
        // install the patient identifier types
        log.info("Installing PatientIdentifierTypes");
        install(PatientIdentifierTypes.HIV_CARE_NUMBER);
        install(PatientIdentifierTypes.OLD_OPENMRS_IDENTIFICATION_NUMBER);
        install(PatientIdentifierTypes.OPENMRS_ID);
        install(PatientIdentifierTypes.OPENMRS_IDENTIFICATION_NUMBER);
        install(PatientIdentifierTypes.EXPOSED_INFANT_NUMBER);
        install(PatientIdentifierTypes.ANC_NUMBER);
        install(PatientIdentifierTypes.PNC_NUMBER);
        install(PatientIdentifierTypes.IPD_NUMBER);
        install(PatientIdentifierTypes.NATIONAL_ID);
        install(PatientIdentifierTypes.ART_PATIENT_NUMBER);
        install(PatientIdentifierTypes.RESEARCH_PATIENT_ID);
        install(PatientIdentifierTypes.SMC_CLIENT_NUMBER);
        install(PatientIdentifierTypes.REFUGEE_IDENTIFICATION_NUMBER);
        install(PatientIdentifierTypes.PATIENT_IUC_HEALTH_ID);
        log.info("Patient IdentifierTypes installed");

        // install person attribute types
        log.info("Installing PatientAttributeTypes");
        install(PersonAttributeTypes.MARITAL_STATUS);
        install(PersonAttributeTypes.HEALTH_CENTER);
        install(PersonAttributeTypes.HEALTH_FACILITY_DISTRICT);
        install(PersonAttributeTypes.TELEPHONE_NUMBER_2);
        install(PersonAttributeTypes.TELEPHONE_NUMBER_3);
        install(PersonAttributeTypes.OCCUPATION);
        install(PersonAttributeTypes.NATIONALITY);
        log.info("Person AttributeTypes installed");

        // install roles
        log.info("Installing roles");
        install(Roles.MID_WIFE);
        log.info("Roles installed");


        //Install Encounter Type
        log.info("Installing EncounterTypes");
        install(EncounterTypes.PNC_ENCOUNTER_TYPE);
        install(EncounterTypes.SMC_FOLLOW_UP_ENCOUNTER);
        install(EncounterTypes.OPD_ENCOUNTER);
        install(EncounterTypes.TB_SUMMARY_ENCOUNTER);
        install(EncounterTypes.TB_FOLLOWUP_ENCOUNTER);
        install(EncounterTypes.VIRAL_LOAD_NON_SUPPRESSED);
        install(EncounterTypes.APPOINTMENT_FOLLOW_UP);
        install(EncounterTypes.TRIAGE);
        install(EncounterTypes.MEDICATION_DISPENSE);
        install(EncounterTypes.MISSED_APPOINTMENT_TRACKING);
        install(EncounterTypes.TRANSFER_IN);
        install(EncounterTypes.TRANSFER_OUT);

        //installing programs metadata
        log.info("Installing Programs");
        install(Programs.HIV_PROGRAM);
        install(Programs.TB_PROGRAM);
        install(Programs.MCH_PROGRAM);
        install(Programs.NUTRITION_PROGRAM);
        install(Programs.FBIM_PROGRAM);
        install(Programs.FBG_PROGRAM);
        install(Programs.FTR_PROGRAM);
        install(Programs.CCLAD_PROGRAM);
        install(Programs.CDDP_PROGRAM);

        //install Locations
        log.info("Installing Locations");
        install(Locations.TB_CLINIC);
        install(Locations.OPD_CLINIC);
        install(Locations.UNKNOWN);
        install(Locations.PHARMACY);
        install(Locations.RECEPTION);
        install(Locations.TRIAGE);
        install(Locations.COUNSELING_CENTER);
        install(Locations.Community);


        // Install Encounter Role
        install(encounterRole(EncounterRoles.ASSISTANT_CIRCUMCISER_NAME,EncounterRoles.ASSISTANT_CIRCUMCISER_DESCRIPTION,EncounterRoles.ASSISTANT_CIRCUMCISER_UUID));
        install(encounterRole(EncounterRoles.PHARMACIST_NAME,EncounterRoles.PHARMACIST_DESCRIPTION,EncounterRoles.PHARMACIST_UUID));
    }
}
