package org.openmrs.module.aijar.tasks;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.openmrs.*;
import org.openmrs.api.EncounterService;
import org.openmrs.api.ObsService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.metadata.core.EncounterTypes;
import org.openmrs.scheduler.SchedulerException;
import org.openmrs.scheduler.SchedulerService;
import org.openmrs.scheduler.Task;
import org.openmrs.scheduler.TaskDefinition;
import org.openmrs.scheduler.tasks.AbstractTask;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import static org.openmrs.module.aijar.AijarConstants.*;

public class MigrateARTPatientTransfersTask extends AbstractTask {

    public void execute() {
        String queryStringTransferOut = "from Obs obs where obs.concept =" + TRANSFER_OUT_DATE_CONCEPT_ID + " and voided=false";
        Query query = getSession().createQuery(queryStringTransferOut);
        List<Obs> obsList = query.list();
        List<Encounter> encounters = new ArrayList<>();
        for (Obs obs : obsList) {
            if (!encounters.contains(obs.getEncounter())) {
                generateTransferOutEncounter(obs);
            }
        }
        stopTransferService();

    }

    private void stopTransferService() {
        TaskDefinition task = new TaskDefinition();
        task = Context.getSchedulerService().getTaskByName(ART_TRANSFER_SCHEDULE_NAME);
        if (task != null) {
            try {
                Context.getSchedulerService().shutdownTask(task);
            } catch (SchedulerException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * This Method gets an encounter uses its information and creates another encounter basing on obs the encounter has
     *
     * @param obs
     * @return
     */
    private Encounter generateTransferOutEncounter(Obs obs) {
        Visit visit = new Visit();

        Collection<Patient> patients = new ArrayList<>();
        patients.add(obs.getEncounter().getPatient());

        List<Visit> visits = Context.getVisitService().getVisits(null, patients, null, null, getTransformDate(obs.getValueDatetime(), 000000), getTransformDate(obs.getValueDatetime(), 000000), getTransformDate(obs.getValueDatetime(), 235959), getTransformDate(obs.getValueDatetime(), 235959), null, true, false);

        if (visits.size() <= 0) {
            visit.setLocation(Context.getLocationService().getLocation("ART Clinic"));
            visit.setPatient(obs.getEncounter().getPatient());
            visit.setStartDatetime(obs.getValueDatetime());
            visit.setStopDatetime(obs.getValueDatetime());
            visit.setVisitType(Context.getVisitService().getVisitTypeByUuid(FACILITY_VISIT_TYPE_UUID));
            visit.setCreator(Context.getAuthenticatedUser());
            visit.setDateCreated(obs.getDateCreated());
            Context.getVisitService().saveVisit(visit);
        } else {
            visit = visits.get(0);
        }

        Encounter encounter = new Encounter();
        List<Obs> obs1 = new ArrayList<>();
        encounter.setEncounterDatetime(obs.getValueDatetime());
        encounter.setVisit(visit);
        encounter.setLocation(visit.getLocation());
        encounter.setEncounterType(Context.getEncounterService().getEncounterType(EncounterTypes.TRANSFER_OUT.name()));
        encounter.setForm(Context.getFormService().getFormByUuid("45d9db68-e4b5-11e7-80c1-9a214cf093ae"));
        encounter.setPatient(obs.getEncounter().getPatient());
        encounter.setCreator(obs.getCreator());
        encounter.setLocation(obs.getLocation());
        encounter.setDateCreated(obs.getValueDatetime());
        obs1.add(createObs(getObs(obs.getEncounter()).getConcept(), getObs(obs.getEncounter()).getValueText(), obs.getEncounter(),encounter));
        obs1.add(createObs(getConceptFromString(TRANSFER_FROM_CLINIC_CONCEPT_ID), ART_CLINIC_CONCEPT_ID, obs.getEncounter(),encounter));
        Context.getEncounterService().saveEncounter(encounter);
        return encounter;
    }


    private Obs getObs(Encounter encounter) {
        List<Obs> obsList = new ArrayList<>();
        Obs obs = new Obs();
        Concept concept = Context.getConceptService().getConcept(TRANSFER_OUT_PLACE_CONCEPT_ID);
        obsList = Context.getObsService().getObservationsByPersonAndConcept(encounter.getPatient().getPerson(), concept);
        if (obsList.size() > 0) {
            obs = obsList.get(0);
        }
        return obs;
    }

    private Obs createObs(Concept concept, String answer, Encounter oldEncounter,Encounter newEncounter) {
        Obs obs = new Obs();
        obs.setCreator(oldEncounter.getCreator());
        obs.setPerson(oldEncounter.getPatient().getPerson());
        obs.setLocation(oldEncounter.getLocation());
        obs.setConcept(concept);
        obs.setValueCoded(getConceptFromString(answer));
        obs.setValueText(answer);
        obs.setDateCreated(newEncounter.getDateCreated());
        obs.setEncounter(newEncounter);
        obs.setObsDatetime(newEncounter.getEncounterDatetime());
        return obs;
    }


    private Concept getConceptFromString(String conceptString) {
        Concept concept = new Concept();

        if (concept == null) {
            concept = Context.getConceptService().getConcept(conceptString);
        }
        return concept;
    }

    private Date getTransformDate(Date date, long time) {

        return date;
    }

    public Session getSession() {
        return Context.getRegisteredComponent("sessionFactory", SessionFactory.class).getCurrentSession();
    }
}
