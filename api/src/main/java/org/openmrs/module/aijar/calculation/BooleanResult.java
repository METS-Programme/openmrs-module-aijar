package org.openmrs.module.aijar.calculation;

import org.openmrs.calculation.Calculation;
import org.openmrs.calculation.CalculationContext;
import org.openmrs.calculation.result.SimpleResult;

/**
 * Represents a {@link org.openmrs.calculation.result.CalculationResult} for a boolean value
 *
 * Could be moved into the Calculation Module
 */
public class BooleanResult extends SimpleResult {

	/**
	 * Creates a new boolean result
	 * @param value the result value
	 * @param calculation the calculation
	 */
	public BooleanResult(Boolean value, Calculation calculation) {
		super(value, calculation);
	}

	/**
	 * Creates a new boolean result
	 * @param value the result value
	 * @param calculation the calculation
	 * @param context the calculation context
	 */
	public BooleanResult(Boolean value, Calculation calculation, CalculationContext context) {
		super(value, calculation, context);
	}

	/**
	 * @see org.openmrs.calculation.result.SimpleResult#isEmpty()
	 */
	@Override
	public boolean isEmpty() {
		return value == null || !((Boolean) value);
	}

}