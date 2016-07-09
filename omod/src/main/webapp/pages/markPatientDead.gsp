<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("aijar.markpatientdeceased.title")])

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
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {
            label: "${ ui.escapeJs(ui.message("aijar.markpatient.deceased.title")) }",
            link: '${ ui.urlBind("/" + contextPath + "coreapps/clinicianfacing/patient.page?patientId="+patientId, [ patientId: patient ] ) }'
        }
    ];
</script>
${ui.includeFragment("coreapps", "patientHeader", [patient: patient])}
<h3>${ui.message("aijar.markpatientdeceased.title")}</h3>
<form method="post">
    <fieldset>
        <p>

            <input id="checkbox-deceased" name="dead" <% if (person?.getDead() == true) {
                'value="' + person?.getDead() + '"'
            } %> type="checkbox"/>
            <label for="checkbox-deceased">
                <span>${ui.message("aijar.markpatientdeceased.deceased")} </span>
            </label>
        </p>
        <p>
            ${ui.includeFragment("uicommons", "field/datetimepicker", [
                    label        : "aijar.markpatientdeceased.dateofdeath",
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
        <p>
            <label for="cause-of-death">
                <span>${ui.message("aijar.markpatientdeceased.causeofdeath")} (${ui.message("emr.formValidation.messages.requiredField.label")})</span>
            </label>
            <select name="causeOfDeath" id="cause-of-death">
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
    </fieldset>
</form>