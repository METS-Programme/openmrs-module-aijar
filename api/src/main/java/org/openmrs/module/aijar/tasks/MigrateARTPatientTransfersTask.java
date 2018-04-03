package org.openmrs.module.aijar.tasks;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.EncounterTypes;
import org.openmrs.scheduler.SchedulerException;
import org.openmrs.scheduler.TaskDefinition;
import org.openmrs.scheduler.tasks.AbstractTask;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import static org.openmrs.module.aijar.AijarConstants.*;

public class MigrateARTPatientTransfersTask extends AbstractTask {
    protected final Log log = LogFactory.getLog(this.getClass());

    public void execute() {
        log.info("Start Migrate Transfer Outs From Art Summary Page To Transfer Out Encounters");
        transferOut();
        log.info("Completed Transfer Out Migration");

        log.info("Start Migrate Transfer Ins From Art Summary Page To Transfer Out Encounters");
        transferIn();
        log.info("Completed Transfer In Migration");
        stopTransferService();
    }


    private void transferOut() {
        String queryStringTransferOut = "from Obs obs where obs.concept =" + TRANSFER_OUT_DATE_CONCEPT_ID + " and voided=false";
        Query query = getSession().createQuery(queryStringTransferOut);
        List<Obs> obsList = query.list();
        List<Encounter> encounters = new ArrayList<>();
        List<Encounter> transferEncounters = new ArrayList<>();
        for (Obs obs : obsList) {
            if (!encounters.contains(obs.getEncounter())) {
                Encounter encounter = generateTransferInOutEncounter(obs, TRANSFER_OUT_PLACE_CONCEPT_ID, EncounterTypes.TRANSFER_OUT.name(), obs.getValueDate());
            }
        }
    }

    private void transferIn() {
        String queryStringTransferOut = "from Obs obs where obs.concept =" + TRANSFER_IN_CONCEPT_ID + " and voided=false";
        Query query = getSession().createQuery(queryStringTransferOut);
        List<Obs> obsList = query.list();
        List<Encounter> encounters = new ArrayList<>();
        List<Encounter> transferEncounters = new ArrayList<>();
        for (Obs obs : obsList) {
            if (!encounters.contains(obs.getEncounter())) {
                Encounter encounter = generateTransferInOutEncounter(obs, TRANSFER_IN_FROM_PLACE_CONCEPT_ID, EncounterTypes.TRANSFER_IN.name(), obs.getEncounter().getEncounterDatetime());
                ;
            }
        }
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
    private Encounter generateTransferInOutEncounter(Obs obs, String transferPlace, String encounterTypeName, Date visitEncounterDate) {
        Visit visit = new Visit();
        Encounter encounter = new Encounter();
        EncounterType encounterType = Context.getEncounterService().getEncounterType(encounterTypeName);
        Form form = Context.getFormService().getFormByUuid("45d9db68-e4b5-11e7-80c1-9a214cf093ae");

        Collection<Patient> patients = new ArrayList<>();
        patients.add(obs.getEncounter().getPatient());

        List<Visit> visits = Context.getVisitService().getVisits(null, patients, null, null, getTransformDate(visitEncounterDate, 000000), getTransformDate(visitEncounterDate, 000000), getTransformDate(visitEncounterDate, 235959), getTransformDate(visitEncounterDate, 235959), null, true, false);

        if (visits.size() <= 0) {
            visit.setLocation(Context.getLocationService().getLocation("ART Clinic"));
            visit.setPatient(obs.getEncounter().getPatient());
            visit.setStartDatetime(visitEncounterDate);
            visit.setStopDatetime(visitEncounterDate);
            visit.setVisitType(Context.getVisitService().getVisitTypeByUuid(FACILITY_VISIT_TYPE_UUID));
            visit.setCreator(Context.getAuthenticatedUser());
            visit.setDateCreated(obs.getDateCreated());
            Context.getVisitService().saveVisit(visit);
        } else {
            visit = visits.get(0);
        }


        List<Obs> obs1 = new ArrayList<>();
        encounter.setEncounterDatetime(visitEncounterDate);
        encounter.setVisit(visit);
        encounter.setLocation(visit.getLocation());
        encounter.setEncounterType(encounterType);
        encounter.setForm(form);
        encounter.setPatient(obs.getEncounter().getPatient());
        encounter.setCreator(obs.getCreator());
        encounter.setLocation(obs.getLocation());
        encounter.setDateCreated(visitEncounterDate);
        encounter.addObs(createObs(getConceptFromString(TRANSFER_FROM_CLINIC_CONCEPT_ID), "", getConceptFromString(ART_CLINIC_CONCEPT_ID), encounter));
        encounter.addObs(createObs(getConceptFromString(transferPlace), getTransferPlaceObs(obs.getEncounter(), transferPlace).getValueText(), null, encounter));
        encounter = Context.getEncounterService().saveEncounter(encounter);
        return encounter;
    }

    private Obs getTransferPlaceObs(Encounter encounter, String transferPlace) {
        List<Obs> obsList = new ArrayList<>();
        Obs obs = new Obs();
        Concept concept = Context.getConceptService().getConcept(transferPlace);
        obsList = Context.getObsService().getObservationsByPersonAndConcept(encounter.getPatient().getPerson(), concept);
        if (obsList.size() > 0) {
            obs = obsList.get(0);
        }
        return obs;
    }

    private Obs createObs(Concept concept, String answer, Concept conceptAnswer, Encounter newEncounter) {
        if (concept != null) {
            Obs obs = new Obs(newEncounter.getPatient(), concept, newEncounter.getEncounterDatetime(), newEncounter.getLocation());
            if (conceptAnswer != null && concept.getDatatype().isCoded()) {
                obs.setValueCoded(conceptAnswer);
                return obs;
            } else if (answer != null && concept.getDatatype().isText()) {
                obs.setValueText(answer);
                return obs;
            } else if (answer == null && concept.getDatatype().isText()) {
                obs.setValueText("Unknown");
                return obs;
            } else {
                return null;
            }

        } else {
            return null;
        }
    }


    private Concept getConceptFromString(String conceptString) {
        if (Context.getConceptService().getConcept(conceptString) != null) {
            return Context.getConceptService().getConcept(conceptString);
        } else {
            return null;
        }
    }

    private Date getTransformDate(Date date, long time) {
        return date;
    }

    public Session getSession() {
        return Context.getRegisteredComponent("sessionFactory", SessionFactory.class).getCurrentSession();
    }


}
