
package org.openmrs.module.aijar.web.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.openmrs.module.webservices.rest.web.v1_0.controller.BaseRestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AppointmentCountController extends BaseRestController {

    

    @RequestMapping(value = "/rest/" + RestConstants.VERSION_1
            + "/ugandaemr/appointmentcount", method = RequestMethod.GET)
    @ResponseBody
    public SimpleObject getNumberOfPatients(
            @RequestParam(required = true, value = "nextAppointmentDate") Date nextAppointmentDate,
            @RequestParam(value = "encounterType", defaultValue = "") String encounterType) {

        AdministrationService administrationService = Context.getAdministrationService();
        SimpleObject response = new SimpleObject();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String returnDate = formatter.format(nextAppointmentDate);


        String sql = "SELECT COUNT(obs.person_id) FROM obs WHERE obs.concept_id=5096 AND obs.value_datetime='" + returnDate
                + "' AND obs.voided = 0";
        String encounterFilterWhereClause = "";
        if (!StringUtils.isEmpty(encounterType)) {
            encounterFilterWhereClause = " AND obs.encounter_id IN ( SELECT encounter.encounter_id FROM encounter INNER JOIN encounter_type ON encounter.encounter_type = encounter_type.encounter_type_id WHERE encounter_type.uuid IN('"
                    + StringUtils.join(encounterType.split(","), "','") + "'))";
        }
        List numberOfPatients= administrationService.executeSQL(sql + encounterFilterWhereClause, true);
        response.add("appointmentdate", returnDate);
        response.add("encountertype", encounterType);
        response.add("appointmentcount", ((ArrayList)numberOfPatients.get(0)).get(0));

        return response;
    }
}
