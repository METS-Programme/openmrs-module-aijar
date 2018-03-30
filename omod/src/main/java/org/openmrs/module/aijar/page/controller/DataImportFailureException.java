package org.openmrs.module.aijar.page.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.BAD_REQUEST)
public class DataImportFailureException extends RuntimeException {

	private static final long serialVersionUID = -1585539279614932751L;

	public DataImportFailureException(String message, Throwable cause) {
		super(message, cause);
	}
}
