/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 * <p/>
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * <p/>
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */

package org.openmrs.module.aijar.api.reporting;

import org.openmrs.Concept;
import org.openmrs.ConceptNumeric;
import org.openmrs.api.context.Context;
import org.openmrs.module.metadatadeploy.MissingMetadataException;

import java.util.ArrayList;
import java.util.List;

/**
 * Dictionary for concepts used
 */
public class Dictionary extends Concept {

    /**
     * Gets a concept by an identifier (mapping or UUID)
     * @param identifier the identifier
     * @return the concept
     * @throws MissingMetadataException if the concept could not be found
     */
    public static Concept getConcept(String identifier) {
        Concept concept;

        if (identifier.contains(":")) {
            String[] tokens = identifier.split(":");
            concept = Context.getConceptService().getConceptByMapping(tokens[1].trim(), tokens[0].trim());
        } else {
            // Assume it's a UUID
            concept = Context.getConceptService().getConceptByUuid(identifier);
        }

        if (concept == null) {
            throw new MissingMetadataException(Concept.class, identifier);
        }

        // getConcept doesn't always return ConceptNumeric for numeric concepts
        if (concept.getDatatype().isNumeric() && !(concept instanceof ConceptNumeric)) {
            concept = Context.getConceptService().getConceptNumeric(concept.getId());

            if (concept == null) {
                throw new MissingMetadataException(ConceptNumeric.class, identifier);
            }
        }

        return concept;
    }

    /**
     * Convenience method to fetch a list of concepts
     * @param identifiers the concept identifiers
     * @return the concepts
     * @throws MissingMetadataException if a concept could not be found
     */
    public static List<Concept> getConcepts(String... identifiers) {
        List<Concept> concepts = new ArrayList<Concept>();
        for (String identifier : identifiers) {
            concepts.add(getConcept(identifier));
        }
        return concepts;
    }
}