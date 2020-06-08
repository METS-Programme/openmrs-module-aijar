/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.aijar.api.db;

import java.util.Date;
import java.util.List;

import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.ugandaemr.PublicHoliday;

/**
 *  Database methods for {@link AijarService}.
 */
public interface AijarDAO {
	
	/*
	 * Add DAO methods here
	 */
	public List<PublicHoliday> getAllPublicHolidays();

	public PublicHoliday getPublicHolidayByDate(Date publicHolidayDate);

	public PublicHoliday savePublicHoliday(PublicHoliday publicHolidays);

	public PublicHoliday getPublicHolidaybyUuid(String uuid);

	public List<PublicHoliday> getPublicHolidaysByDate(Date publicHolidayDate);
}