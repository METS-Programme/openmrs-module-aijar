package org.openmrs.module.aijar.api.deploy.source;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.EncounterType;
import org.openmrs.module.metadatadeploy.source.AbstractCsvResourceSource;

import java.io.IOException;

/**
 * Created by ssmusoke on 06/01/2016.
 */
public class EncounterTypeCsvSource extends AbstractCsvResourceSource<EncounterType> {

    protected Log log = LogFactory.getLog(getClass());

    public EncounterTypeCsvSource(String csvFile) throws IOException {
        super(csvFile, false);
    }

    @Override
    protected EncounterType parseLine(String[] line) throws Exception {
        EncounterType encounterType = new EncounterType();
        encounterType.setName(line[0]);
        encounterType.setDescription(line[1]);
        encounterType.setUuid(line[2]);
        return encounterType;
    }
}
