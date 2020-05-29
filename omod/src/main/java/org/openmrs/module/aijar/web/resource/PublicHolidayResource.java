package org.openmrs.module.aijar.web.resource;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.metadata.core.PublicHoliday;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.RequestContext;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.openmrs.module.webservices.rest.web.annotation.Resource;
import org.openmrs.module.webservices.rest.web.representation.DefaultRepresentation;
import org.openmrs.module.webservices.rest.web.representation.FullRepresentation;
import org.openmrs.module.webservices.rest.web.representation.RefRepresentation;
import org.openmrs.module.webservices.rest.web.representation.Representation;
import org.openmrs.module.webservices.rest.web.resource.api.PageableResult;
import org.openmrs.module.webservices.rest.web.resource.impl.DelegatingCrudResource;
import org.openmrs.module.webservices.rest.web.resource.impl.DelegatingResourceDescription;
import org.openmrs.module.webservices.rest.web.resource.impl.NeedsPaging;
import org.openmrs.module.webservices.rest.web.response.ResourceDoesNotSupportOperationException;
import org.openmrs.module.webservices.rest.web.response.ResponseException;

@Resource(name = RestConstants.VERSION_1 + "/" + AijarConstants.UGANDAEMR_MODULE_ID
        + "/publicHoliday", supportedClass = PublicHoliday.class, supportedOpenmrsVersions = { "1.9.*", "1.10.*",
                "1.11.*", "1.12.*", "2.0.*", "2.1.*", "2.2.*", "2.3.*", "2.4.*" })
public class PublicHolidayResource extends DelegatingCrudResource<PublicHoliday> {

    @Override
    public PublicHoliday newDelegate() {
        return new PublicHoliday();
    }

    @Override
    public PublicHoliday save(PublicHoliday publicHoliday) {
        return Context.getService(AijarService.class).savePublicHoliday(publicHoliday);
    }

    @Override
    public PublicHoliday getByUniqueId(String uniqueId) {
        PublicHoliday publicHoliday = Context.getService(AijarService.class).getPublicHolidaybyUuid(uniqueId);
        if (publicHoliday == null) {
            Date checkDate = null;
            try {
                checkDate = new SimpleDateFormat("dd-MM-yyyy").parse(uniqueId);
            } catch (ParseException e) {
                e.printStackTrace();
                return null;
            }
            publicHoliday = Context.getService(AijarService.class).getPublicHolidayByDate(checkDate);
        }
        return publicHoliday;
    }

    @Override
    protected void delete(PublicHoliday delegate, String reason, RequestContext context) throws ResponseException {
        throw new ResourceDoesNotSupportOperationException("delete of public Holiday not supported");

    }

    @Override
    public void purge(PublicHoliday delegate, RequestContext context) throws ResponseException {
        throw new ResourceDoesNotSupportOperationException("delete of public Holiday not supported");

    }

    @Override
	public NeedsPaging<PublicHoliday> doGetAll(RequestContext context) throws ResponseException {
		return new NeedsPaging<PublicHoliday>(new ArrayList<PublicHoliday>(Context.getService(AijarService.class).getAllPublicHolidays()),
                context);
    }
    @Override
    public List<Representation> getAvailableRepresentations() {
        return Arrays.asList(Representation.DEFAULT, Representation.FULL);
    }

    @Override
    public DelegatingResourceDescription getRepresentationDescription(Representation rep) {
        if (rep instanceof DefaultRepresentation) {
			DelegatingResourceDescription description = new DelegatingResourceDescription();
            description.addProperty("uuid");
            description.addProperty("name");
			description.addProperty("date");
			description.addProperty("description");
			description.addProperty("isPublicHoliday", findMethod("isPublicHoliday"));
			description.addSelfLink();
			
			return description;
		} else if (rep instanceof FullRepresentation) {
			DelegatingResourceDescription description = new DelegatingResourceDescription();
            description.addProperty("uuid");
            description.addProperty("name");
			description.addProperty("date");
            description.addProperty("description");
            description.addProperty("isPublicHoliday", findMethod("isPublicHoliday"));
            description.addSelfLink();
            description.addLink("full", ".?v=" + RestConstants.REPRESENTATION_FULL);
			return description;
		} else if (rep instanceof RefRepresentation) {
			DelegatingResourceDescription description = new DelegatingResourceDescription();
            description.addProperty("uuid");
            description.addProperty("name");
			description.addProperty("date");
            description.addProperty("description");
            description.addProperty("isPublicHoliday", findMethod("isPublicHoliday"));
			description.addSelfLink();
            return description;
        }
		return null;
    }

    @Override
    public DelegatingResourceDescription getCreatableProperties() throws ResourceDoesNotSupportOperationException {
        DelegatingResourceDescription description = new DelegatingResourceDescription();
        description.addProperty("description");
        description.addProperty("date");
        return description;
    }

    public boolean isPublicHoliday(PublicHoliday publicHoliday) {
        return (publicHoliday != null) ? true : false;
    }
    
    @Override
	protected PageableResult doSearch(RequestContext context) {

        String dateQuery = context.getParameter("date");

        List<PublicHoliday> publicHolidaysByQuery= null;
       
        if (dateQuery != null) {
            Date checkDate = null;
            try {
                checkDate = new SimpleDateFormat("dd/MM/yyyy").parse(dateQuery);
            } catch (ParseException e) {
                e.printStackTrace();
                return null;
            }
            publicHolidaysByQuery = Context.getService(AijarService.class).getPublicHolidaysByDate(checkDate);
            
        }
        
        return new NeedsPaging<PublicHoliday> (publicHolidaysByQuery, context);
	}
}