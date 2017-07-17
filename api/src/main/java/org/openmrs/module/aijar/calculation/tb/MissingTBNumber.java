package org.openmrs.module.aijar.calculation.tb;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

import org.openmrs.Concept;
import org.openmrs.Obs;
import org.openmrs.Program;
import org.openmrs.calculation.BaseCalculation;
import org.openmrs.calculation.patient.PatientCalculation;
import org.openmrs.calculation.patient.PatientCalculationContext;
import org.openmrs.calculation.result.CalculationResultMap;
import org.openmrs.module.aijar.calculation.BooleanResult;
import org.openmrs.module.aijar.calculation.Calculations;
import org.openmrs.module.aijar.calculation.EmrCalculationUtils;
import org.openmrs.module.aijar.calculation.Filters;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.metadatadeploy.MetadataUtils;

public class MissingTBNumber  extends BaseCalculation implements PatientCalculation{
	
	private Concept tbIdentifierConcept;
	
	public Concept getTbIdentifierConcept() {
		return tbIdentifierConcept;
	}

	
	public void setTbIdentifierConcept(Concept tbIdentifierConcept) {
		this.tbIdentifierConcept = tbIdentifierConcept;
	}

	public	MissingTBNumber(Concept tbIdentifierConcept) {
		this.setTbIdentifierConcept(tbIdentifierConcept);
	}
	
    @Override
    public CalculationResultMap evaluate(Collection<Integer> cohort, Map<String, Object> map, PatientCalculationContext context) {
		Program tbProgram = MetadataUtils.existing(Program.class, Programs.TB_PROGRAM.uuid());

        CalculationResultMap ret = new CalculationResultMap();
		Set<Integer> inTbProgram = Filters.inProgram(tbProgram, cohort, context);		
        CalculationResultMap hsdTBNumbers = Calculations.lastObs(this.getTbIdentifierConcept(), cohort, context);
        
        for(Integer ptId: cohort){
        	if (inTbProgram.contains(ptId)) {

				Obs hsdTBNumber = EmrCalculationUtils.obsResultForPatient(hsdTBNumbers, ptId);
								
                if (hsdTBNumber == null) {
			        ret.put(ptId, new BooleanResult(true, this));
				}
				
			}            
        }
        return ret;
        
    }	
}
