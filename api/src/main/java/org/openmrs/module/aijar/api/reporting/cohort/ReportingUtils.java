package org.openmrs.module.aijar.api.reporting.cohort;

import org.openmrs.module.reporting.cohort.definition.CohortDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Mapped;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.evaluation.parameter.Parameterizable;
import org.openmrs.module.reporting.evaluation.parameter.ParameterizableUtil;
import org.openmrs.module.reporting.indicator.CohortIndicator;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ssmusoke on 10/12/2015.
 */
public class ReportingUtils {

    public static <T extends Parameterizable> Mapped<T> map(T parameterizable) {
        if (parameterizable == null) {
            throw new IllegalArgumentException("Parameterizable cannot be null");
        } else {
            return new Mapped(parameterizable, (Map) null);
        }
    }

    public static <T extends Parameterizable> Mapped<T> map(T parameterizable, String mappings) {
        if (parameterizable == null) {
            throw new IllegalArgumentException("Parameterizable cannot be null");
        } else {
            if (mappings == null) {
                mappings = "";
            }

            return new Mapped(parameterizable, ParameterizableUtil.createParameterMappings(mappings));
        }
    }

    public static <T extends Parameterizable> Mapped<T> map(T parameterizable, Object... mappings) {
        if (parameterizable == null) {
            throw new IllegalArgumentException("Parameterizable cannot be null");
        } else {
            HashMap paramMap = new HashMap();

            for (int m = 0; m < mappings.length; m += 2) {
                String param = (String) mappings[m];
                Object value = mappings[m + 1];
                paramMap.put(param, value);
            }

            return new Mapped(parameterizable, paramMap);
        }
    }

    public static CohortIndicator cohortIndicator(String name, Mapped<CohortDefinition> cohort) {
        CohortIndicator cohortIndicator = new CohortIndicator();
        cohortIndicator.setName(name);
        cohortIndicator.addParameter(new Parameter("startDate", "Start Date", Date.class));
        cohortIndicator.addParameter(new Parameter("endDate", "End Date", Date.class));
        cohortIndicator.setCohortDefinition(cohort);

        return cohortIndicator;
    }
}
