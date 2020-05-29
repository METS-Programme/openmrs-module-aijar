package org.openmrs.module.aijar.web.controller;

import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.test.Util;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.openmrs.module.webservices.rest.web.v1_0.controller.MainResourceControllerTest;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.bind.annotation.RequestMethod;

public class PublicHolidayControllerTest extends MainResourceControllerTest {

    @Before
    public void setUp() throws Exception {
        executeDataSet("org/openmrs/module/aijar/include/standardTestDataset.xml");
    }

    @Override
    public long getAllCount() {
        return 2;
    }

    @Override
    public String getURI() {
        return "/rest/" + RestConstants.VERSION_1 + "/" + AijarConstants.UGANDAEMR_MODULE_ID + "/publicHoliday";
    }

    @Override
    public String getUuid() {
        return "8d5b27bc-c2cc-11de-8d13-0010c6dffd0f";
    }

    @Override
    @Test
    public void shouldGetAll() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), getURI());

        SimpleObject result = deserialize(handle(request));
        List<Object> results = Util.getResultsList(result);

        Assert.assertNotNull(result);
        Assert.assertEquals(3, results.size());
        Assert.assertEquals("New Years Day", PropertyUtils.getProperty(results.get(0), "name"));

    }

    @Test
    public void shouldGetPublicHolidayByUuid() throws Exception {
        String requestURI = getURI() + "/" + getUuid();
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);

        SimpleObject result = deserialize(handle(request));

        Assert.assertNotNull(result);
        Assert.assertEquals("New Years Day", PropertyUtils.getProperty(result, "name"));
        Assert.assertEquals(true, PropertyUtils.getProperty(result, "isPublicHoliday"));

    }

    @Test
    public void shouldGetPublicHolidayByDate() throws Exception {
        String requestURI = getURI() + "/01-01-2020";
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);

        SimpleObject result = deserialize(handle(request));

        Assert.assertNotNull(result);
        Assert.assertEquals("New Years Day", PropertyUtils.getProperty(result, "name"));
        Assert.assertEquals(true, PropertyUtils.getProperty(result, "isPublicHoliday"));

    }

    @Test
    public void shouldSavePublicHoliday() throws Exception {

        SimpleObject publicHoliday = new SimpleObject();
        publicHoliday.add("description", "testing this public holiday");
        publicHoliday.add("date", "2020-12-27");
        String json = new ObjectMapper().writeValueAsString(publicHoliday);

        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.POST.toString(), getURI());
        request.addHeader("content-type", "application/json");
        request.setContent(json.getBytes());

        SimpleObject newPublicHoliday = deserialize(handle(request));

        Assert.assertNotNull(PropertyUtils.getProperty(newPublicHoliday, "uuid"));

    }

    @Test
    public void shouldSearchAndReturnListOfPublicHolidaysWithSpecifiedDate() throws Exception {

        MockHttpServletRequest req = new MockHttpServletRequest(RequestMethod.GET.toString(), getURI());
        req.addParameter("date", "01/01/2020");

        SimpleObject result = deserialize(handle(req));
        List<Object> hits = (List<Object>) result.get("results");

        Assert.assertEquals(1, hits.size()); 
        Assert.assertEquals("New Years Day", PropertyUtils.getProperty(hits.get(0), "name"));
        
    }

    @Override
    @Test
    public void shouldGetRefByUuid() throws Exception {
        String requestURI = getURI() + "/" + getUuid();
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);
        request.addParameter("v", "ref");

        SimpleObject result = deserialize(handle(request));

        Assert.assertNotNull(PropertyUtils.getProperty(result, "uuid"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "description"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "name"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "date"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "isPublicHoliday"));
    }

    @Override
    @Test
    public void shouldGetDefaultByUuid() throws Exception {
        String requestURI = getURI() + "/" + getUuid();
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);

        SimpleObject result = deserialize(handle(request));

        Assert.assertNotNull(PropertyUtils.getProperty(result, "uuid"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "description"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "name"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "date"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "isPublicHoliday"));
    }

    @Override
    @Test
    public void shouldGetFullByUuid() throws Exception {

        String requestURI = getURI() + "/" + getUuid();
        MockHttpServletRequest request = new MockHttpServletRequest(RequestMethod.GET.toString(), requestURI);
        request.addParameter("v", "full");

        SimpleObject result = deserialize(handle(request));

        Assert.assertNotNull(PropertyUtils.getProperty(result, "uuid"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "description"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "name"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "date"));
        Assert.assertNotNull(PropertyUtils.getProperty(result, "isPublicHoliday"));
    }
}