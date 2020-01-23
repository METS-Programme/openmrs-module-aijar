package org.openmrs.module.aijar.tasks;

import org.openmrs.Visit;
import org.openmrs.api.VisitService;
import org.openmrs.api.context.Context;
import org.openmrs.scheduler.tasks.AbstractTask;
import org.openmrs.util.OpenmrsUtil;

import java.util.List;

public class StopActiveFacilityVisitTask extends AbstractTask {
    @Override
    public void execute() {
        VisitService visitService = Context.getVisitService();
        List<Visit> visitList = visitService.getAllVisits();
        for (Visit visit : visitList) {
            if (visit.getStopDatetime() == null && visit.getVisitType()==visitService.getVisitTypeByUuid("7b0f5697-27e3-40c4-8bae-f4049abfb4ed")) {
                visitService.endVisit(visit, OpenmrsUtil.getLastMomentOfDay(visit.getStartDatetime()));
            }
        }
    }
}
