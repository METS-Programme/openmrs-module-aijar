package org.openmrs.module.aijar.program;

import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.springframework.stereotype.Component;

import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.program;

/**
 * Created by codehub on 3/13/17.
 */
@Component
public class Programs extends AbstractMetadataBundle {

    public static final class _Program {
        public static final String HIV ="f44f899c-07e6-11e7-a90a-507b9dc4c741";
        public static final String TB ="ff55417e-07e6-11e7-ba17-507b9dc4c741";
        public static final String MCH="19c7dc6a-07e7-11e7-9cca-507b9dc4c741";
    }

    public static final class _Concept{
        public static final String HIV ="dcbc8ab6-30ab-102d-86b0-7a5022ba4115";
        public static final String TB ="dcbc8ab6-30ab-102d-86b0-7a5022ba4115";
        public static final String MCH="dcbc8ab6-30ab-102d-86b0-7a5022ba4115";
    }
    @Override
    public void install() throws Exception {
        install(program("HIV", "Treatment for HIV-positive patients", _Concept.HIV, _Program.HIV));
        install(program("TB", "Treatment for TBpatients", _Concept.TB, _Program.TB));
        install(program("MCH", "For mother child care", _Concept.MCH, _Program.MCH));
    }
}
