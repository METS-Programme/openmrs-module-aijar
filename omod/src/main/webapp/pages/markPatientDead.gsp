<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("referenceapplication.home.title")])

    def htmlSafeId = { extension ->
        "${extension.id.replace(".", "-")}-${extension.id.replace(".", "-")}-extension"
    }

    Calendar cal = Calendar.getInstance()
    def maxAgeYear = cal.get(Calendar.YEAR)
    def minAgeYear = maxAgeYear - person.getAge()
    def breadcrumbMiddle = breadcrumbOverride ?: '';
%>
<script type="text/javascript">

    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.escapeJs(ui.format(patient.patient)) }" ,
            link: '${ ui.urlBind("/" + contextPath + "coreapps/clinicianfacing/patient.page?patientId="+patientId, [ patientId: patient ] ) }'}
    ];
</script>
<div class="info-section patientsummary">
    <div class="info-header">
        <h3>${ui.message("aijar.markpatient.deceased").toUpperCase()}</h3>
        <h3>${ui.message("aijar.markpatient.deceased").toUpperCase()}</h3>
    </div>
</div>

<form method="post">

    <fieldset style="border: none; min-width: 98%;">
        <table style="border: none">
            <td>
                <p>
                    <input id="checkbox-deceased" name="dead" <% if (person?.getDead() == true) {
                        'value="' + person?.getDead() + '"'
                    } %> type="checkbox"/>
                    <label for="checkbox-deceased">Deceased</label>
                </p>
            </td>
            <td>
                <p>
                    ${ui.includeFragment("uicommons", "field/datetimepicker", [
                            label        : "",
                            formFieldName: "deathDate",
                            left         : true,
                            classes      : ['required'],
                            defaultDate  : person?.getDeathDate() ?: new Date(),
                            useTime      : false,
                            showEstimated: false,
                            initialValue : new Date(),
                            minYear      : minAgeYear,
                            maxYear      : maxAgeYear,
                    ])}
                </p>
            </td>
            <td>
                <p>
                    <label for="deceased-status">
                        <span>(${ui.message("emr.formValidation.messages.requiredField.label")})</span>
                    </label>
                    <select name="causeOfDeath" id="deceased-status" style="height:34px;">
                        <% if (!conceptAnswers.isEmpty()) {
                            conceptAnswers.each {
                        %>
                        <% if (person?.getCauseOfDeath()?.getUuid() == it.getAnswerConcept().getUuid()) { %>
                        <option selected="selected"
                                value="${it.getAnswerConcept().getUuid()}">${it.getAnswerConcept().getName()}</option>
                        <% } else { %>
                        <option value="${it.getAnswerConcept().getUuid()}">${it.getAnswerConcept().getName()}</option>
                        <% } %>
                        <%
                                }
                            }
                        %>
                    </select>
                    <span class="field-error"></span>
                    <input type="submit" value="Post">
                </p>
            </td>
        </table>
    </fieldset>

</form>