package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.datatype.LocationDatatype;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.openmrs.module.metadatadeploy.bundle.CoreConstructors;
import org.openmrs.module.metadatadeploy.descriptor.PatientIdentifierTypeDescriptor;
import org.springframework.stereotype.Component;

import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.globalProperty;

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
        install(PatientIdentifierTypes.OLD_OPENMRS_IDENTIFICATION_NUMBER);
        install(PatientIdentifierTypes.OPENMRS_ID);
        install(PatientIdentifierTypes.OPENMRS_IDENTIFICATION_NUMBER);
        log.info("Patient IdentifierTypes installed");


        install(globalProperty(AijarConstants.GP_DEFAULT_LOCATION, "The facility for which this installation is configured",
                LocationDatatype.class, null, null));

    }

    // Bundle helper method to install PatientIdentifier descriptor
    protected void install(PatientIdentifierTypeDescriptor d) {
        install(CoreConstructors.patientIdentifierType(d.name(), d.description(), d.format(), d.formatDescription(), d.validator(), d.locationBehavior(), d.required(), d.uuid()));
    }
}
