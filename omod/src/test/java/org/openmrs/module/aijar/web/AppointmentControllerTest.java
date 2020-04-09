package org.openmrs.module.aijar.web;

import org.apache.commons.beanutils.PropertyUtils;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.openmrs.module.webservices.rest.web.v1_0.controller.RestControllerTestUtils;

import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.bind.annotation.RequestMethod;

public class AppointmentControllerTest extends RestControllerTestUtils {

    @Before
    public void setUp() throws Exception {
        executeDataSet("org/openmrs/module/aijar/include/standardTestDataset.xml");
        executeDataSet("org/openmrs/module/aijar/include/appointmentDataSet.xml");
    }

    @Test
    public void shouldReturnPatientsWhenNoSpecifiedEncounterUuids() throws Exception {
        String requestURI = "/rest/" + RestConstants.VERSION_1 + "/ugandaemr/appointmentcount";
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);
        request.addParameter("nextAppointmentDate", "14/08/2008");
        SimpleObject result = deserialize(handle(request));
        Assert.assertEquals("2008-08-14",PropertyUtils.getProperty(result, "appointmentdate"));
        Assert.assertEquals("",PropertyUtils.getProperty(result, "encountertype"));
        Assert.assertEquals(3,PropertyUtils.getProperty(result, "appointmentcount"));

    }

    @Test
    public void shouldReturnPatientsWithSpecifiedEncounterUuid() throws Exception {
        String requestURI = "/rest/" + RestConstants.VERSION_1 + "/ugandaemr/appointmentcount";
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);
        request.addParameter("nextAppointmentDate", "14/08/2008");
        request.addParameter("encounterType", "8d5b2be0-c2cc-11de-8d13-0010c6dffd0f");
        SimpleObject result = deserialize(handle(request));
        Assert.assertEquals("2008-08-14",PropertyUtils.getProperty(result, "appointmentdate"));
        Assert.assertEquals("8d5b2be0-c2cc-11de-8d13-0010c6dffd0f",PropertyUtils.getProperty(result, "encountertype"));
        Assert.assertEquals(2,PropertyUtils.getProperty(result, "appointmentcount"));
    }

    @Test
    public void shouldReturnPatientsWithSpecifiedEncounterUuids() throws Exception {
        String requestURI = "/rest/" + RestConstants.VERSION_1 + "/ugandaemr/appointmentcount";
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);
        request.addParameter("nextAppointmentDate", "14/08/2008");
        request.addParameter("encounterType",
                "8d5b2be0-c2cc-11de-8d13-0010c6dffd0f,334bf97e-28e2-4a27-8727-a5ce31c7cd66");
        SimpleObject result = deserialize(handle(request));
        Assert.assertEquals("2008-08-14",PropertyUtils.getProperty(result, "appointmentdate"));
        Assert.assertEquals("8d5b2be0-c2cc-11de-8d13-0010c6dffd0f,334bf97e-28e2-4a27-8727-a5ce31c7cd66",PropertyUtils.getProperty(result, "encountertype"));
        Assert.assertEquals(3,PropertyUtils.getProperty(result, "appointmentcount"));
    }

}

