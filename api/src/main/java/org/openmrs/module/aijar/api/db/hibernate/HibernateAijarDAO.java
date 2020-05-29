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
package org.openmrs.module.aijar.api.db.hibernate;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.openmrs.api.APIException;
import org.openmrs.module.aijar.api.db.AijarDAO;
import org.openmrs.module.aijar.ugandaemr.PublicHoliday;

/**
 * It is a default implementation of {@link AijarDAO}.
 */
public class HibernateAijarDAO implements AijarDAO {
	protected final Log log = LogFactory.getLog(this.getClass());
	private SessionFactory sessionFactory;

	/**
	 * @param sessionFactory the sessionFactory to set
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	/**
	 * @return the sessionFactory
	 */
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	public List<PublicHoliday> getAllPublicHolidays() {
		return (List<PublicHoliday>) getSessionFactory().getCurrentSession().createCriteria(PublicHoliday.class).list();
	}

	public PublicHoliday getPublicHolidayByDate(Date publicHolidayDate) throws APIException {
		return (PublicHoliday) getSessionFactory().getCurrentSession().createCriteria(PublicHoliday.class).add(Restrictions.eq("date", publicHolidayDate)).add(Restrictions.eq("voided", false)).uniqueResult();
	}

	public PublicHoliday savePublicHoliday(PublicHoliday publicHoliday) {
        getSessionFactory().getCurrentSession().saveOrUpdate(publicHoliday);
		return publicHoliday;
	}

	@Override
	public PublicHoliday getPublicHolidaybyUuid(String uuid) {
		return (PublicHoliday) getSessionFactory().getCurrentSession().createCriteria(PublicHoliday.class).add(Restrictions.eq("uuid", uuid))
		.uniqueResult();
	}

	@Override
	public List<PublicHoliday> getPublicHolidaysByDate(Date publicHolidayDate) {
		return (List<PublicHoliday>) getSessionFactory().getCurrentSession().createCriteria(PublicHoliday.class).add(Restrictions.eq("date", publicHolidayDate)).list();
	}

}