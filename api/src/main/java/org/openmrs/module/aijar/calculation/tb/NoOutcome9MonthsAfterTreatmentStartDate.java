package org.openmrs.module.aijar.calculation.tb;

import java.util.Collection;
import java.util.Date;
import java.util.Map;
import java.util.Set;

import org.joda.time.DateTime;
import org.joda.time.Months;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Obs;
import org.openmrs.Program;
import org.openmrs.calculation.BaseCalculation;
import org.openmrs.calculation.patient.PatientCalculation;
import org.openmrs.calculation.patient.PatientCalculationContext;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.calculation.result.SimpleResult;
import org.openmrs.module.aijar.calculation.BooleanResult;
import org.openmrs.module.aijar.calculation.Calculations;
import org.openmrs.module.aijar.calculation.EmrCalculationUtils;
import org.openmrs.module.aijar.calculation.Filters;
import org.openmrs.module.aijar.metadata.concept.Dictionary;
import org.openmrs.module.aijar.metadata.core.EncounterTypes;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.metadatadeploy.MetadataUtils;
import org.openmrs.module.reporting.cohort.Cohorts;

public class NoOutcome9MonthsAfterTreatmentStartDate extends BaseCalculation implements PatientCalculation {
		
    @Override
    public CalculationResultMap evaluate(Collection<Integer> cohort, Map<String, Object> map, PatientCalculationContext context) {
		Program tbProgram = MetadataUtils.existing(Program.class, Programs.TB_PROGRAM.uuid());

        CalculationResultMap ret = new CalculationResultMap();
		Set<Integer> inTbProgram = Filters.inProgram(tbProgram, cohort, context);		
        CalculationResultMap lastEncounters = Calculations.lastEncounter(MetadataUtils.existing(EncounterType.class, EncounterTypes.TB_SUMMARY_ENCOUNTER.uuid()), inTbProgram, context);
        CalculationResultMap lastOutcomes = Calculations.lastObs(Dictionary.getConcept("e44c8c4c-db50-4d1e-9d6e-092d3b31cfd6"), cohort, context);
        
        for(Integer ptId: cohort){
        	if (inTbProgram.contains(ptId)) {
                Integer months = null;

				Encounter lastEncounter = EmrCalculationUtils.encounterResultForPatient(lastEncounters, ptId);
				Date lastTreatmentStartDate = lastEncounter != null ? lastEncounter.getEncounterDatetime() : null;
				Obs lastOutcome = EmrCalculationUtils.obsResultForPatient(lastOutcomes, ptId);
								
                if (lastEncounter != null) {
                    months = months(lastTreatmentStartDate, context);
                    if (months > 9) {
						if (lastOutcome == null) {
			                ret.put(ptId, new BooleanResult(true, this));
						}
					}
				}
				
			}            
        }
        return ret;
        
    }
    
    Integer months(Date d1, PatientCalculationContext context) {
        DateTime dateTime1 = new DateTime(d1.getTime());
        DateTime dateTime2 = new DateTime(context.getNow().getTime());
        return Math.abs(Months.monthsBetween(dateTime1, dateTime2).getMonths());
    }
	
}
