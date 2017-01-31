<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("aijar.markpatientdeceased.title")])

    def htmlSafeId = { extension ->
        "${extension.id.replace(".", "-")}-${extension.id.replace(".", "-")}-extension"
    }

    Calendar cal = Calendar.getInstance()
    def maxAgeYear = cal.get(Calendar.YEAR)
    def minAgeYear = maxAgeYear - patient.getAge()
    def breadcrumbMiddle = breadcrumbOverride ?: '';
%>
<script type="text/javascript">

    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {
            label: "${ ui.escapeJs(ui.message("aijar.markpatientdeceased.label")) }",
            link: '${ ui.urlBind("/" + contextPath + "coreapps/clinicianfacing/patient.page?patientId="+patientId, [ patientId: patient ] ) }'
        }
    ];

    jq(function () {

        jq('#deceased').change(function () {
            if (this.checked) {
                showContainer('#death-date-container');
                showContainer('#cause-of-death-container');
            } else {
                hideContainer('#death-date-container');
                hideContainer('#cause-of-death-container');
            }
        });

        jq('#deceased').each(function () {
            if (this.checked) {
                showContainer('#death-date-container');
                showContainer('#cause-of-death-container');
            } else {
                hideContainer('#death-date-container');
                hideContainer('#cause-of-death-container');
            }
        });
    });
</script>
<style type="text/css">
#death-date-display {
    min-width: 35%;
}
</style>
${ui.includeFragment("coreapps", "patientHeader", [patient: patient])}
<h3>${ui.message("aijar.markpatientdeceased.label")}</h3>

<form method="post">
    <fieldset style="min-width: 40%">
        <span id="deceased-container">
            <% if (patient?.getDead() == true) {

            %>
            <input checked="checked" id="deceased" name="dead" type="checkbox"/>
            <% } else {
            %>
            <input id="deceased" name="dead" type="checkbox"/>
            <%
                }
            %>
            <label for="deceased">
                <span>${ui.message("aijar.markpatientdeceased.label")}</span>
            </label>
        </span>

        <p>
            <span id="death-date-container">
                ${ui.includeFragment("uicommons", "field/datetimepicker", [
                        label        : "aijar.markpatientdeceased.dateofdeath",
                        formFieldName: "deathDate",
                        left         : true,
                        defaultDate  : patient?.getDeathDate() ?: null,
                        useTime      : false,
                        showEstimated: false,
                        initialValue : new Date(),
                        startDate    : birthDate,
                        endDate      : new Date(),
                        minYear      : minAgeYear,
                        maxYear      : maxAgeYear,
                        id           : 'death-date'
                ])}
            </span>
        </p>
        <p>
            <span id="cause-of-death-container">
                <label for="cause-of-death">
                    <span>${ui.message("aijar.markpatientdeceased.causeofdeath")} (${ui.message("emr.formValidation.messages.requiredField.label")})</span>
                </label>
                <select name="causeOfDeath" id="cause-of-death">
                    <option value="">Select Cause Of Death</option>
                    <% if (!conceptAnswers.isEmpty()) {
                        conceptAnswers.each {
                    %>
                    <% if (patient?.getCauseOfDeath()?.getUuid() == it.getAnswerConcept().getUuid()) { %>
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
            </span>
        </p>
        <p>
            <span>
                <input type="submit" value="Submit">
            </span>
        </p>
    </fieldset>
</form>