package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.aijar.metadata.core.EncounterTypes;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.module.aijar.metadata.core.PersonAttributeTypes;
import org.openmrs.module.aijar.metadata.core.Roles;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.springframework.stereotype.Component;
import org.openmrs.module.aijar.metadata.core.Locations;

/**
 * Installs the most common metadata
 * <p/>
 * Created by ssmusoke on 06/01/2016.
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
        install(PatientIdentifierTypes.DISTRICT_TB_NUMBER);
        install(PatientIdentifierTypes.OLD_OPENMRS_IDENTIFICATION_NUMBER);
        install(PatientIdentifierTypes.OPENMRS_ID);
        install(PatientIdentifierTypes.OPENMRS_IDENTIFICATION_NUMBER);
        install(PatientIdentifierTypes.EXPOSED_INFANT_NUMBER);
        install(PatientIdentifierTypes.ANC_NUMBER);
        install(PatientIdentifierTypes.PNC_NUMBER);
        install(PatientIdentifierTypes.IPD_NUMBER);
        install(PatientIdentifierTypes.HCT_NUMBER);
        install(PatientIdentifierTypes.NATIONAL_ID);
        install(PatientIdentifierTypes.ART_PATIENT_NUMBER);
        install(PatientIdentifierTypes.RESEARCH_PATIENT_ID);
        install(PatientIdentifierTypes.SMC_CLIENT_NUMBER);
        install(PatientIdentifierTypes.UNIT_TB_NUMBER);
        install(PatientIdentifierTypes.HSD_TB_NUMBER);
        install(PatientIdentifierTypes.TRANSFER_IN_UNIT_TB_NUMBER);
        install(PatientIdentifierTypes.INTEGRATED_NUTRITION_REGISTER_NUMBER);
        log.info("Patient IdentifierTypes installed");

        // install person attribute types
        log.info("Installing PatientAttributeTypes");
        install(PersonAttributeTypes.MARITAL_STATUS);
        install(PersonAttributeTypes.HEALTH_CENTER);
        install(PersonAttributeTypes.HEALTH_FACILITY_DISTRICT);
        install(PersonAttributeTypes.TELEPHONE_NUMBER_2);
        install(PersonAttributeTypes.TELEPHONE_NUMBER_3);
        install(PersonAttributeTypes.OCCUPATION);
        log.info("Person AttributeTypes installed");
        
        // install roles
        log.info("Installing roles");
        install(Roles.MID_WIFE);
        log.info("Roles installed");

        //Install Encounter Type
        log.info("Installing EncounterTypes");
        install(EncounterTypes.PNC_ENCOUNTER_TYPE);
        install(EncounterTypes.TB_Summary);
        install(EncounterTypes.TB_Encounter);
        install(EncounterTypes.TB_Discontinuation);
        
        //Install Location
        log.info("Installing Locations");
        install(Locations.TB_CLINIC);
    }
}
