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
            label: "${ ui.escapeJs(ui.message("aijar.markpatientdeceased.label")) }",
            link: '${ ui.urlBind("/" + contextPath + "coreapps/clinicianfacing/patient.page?patientId="+patientId, [ patientId: patient ] ) }'
        }
    ];

    jq(function() {
        enable_disable_mark_patient_dead();
        jq("#checkbox-deceased").change(enable_disable_mark_patient_dead);
        jq("#checkbox-deceased").each(enable_disable_mark_patient_dead);
    });

    function enable_disable_mark_patient_dead() {
        if (this.checked) {
            jq("#death-date-display").attr('disabled', false);
            jq("#cause-of-death").prop('disabled', false);
            jq("#death-date-display").fadeTo(250, 1);
        } else {
            jq("#death-date-display").attr('disabled', true);
            jq("#cause-of-death").prop('disabled', true);
            jq("#death-date-display").fadeTo(250, 0.25);
        }
    }
</script>
${ui.includeFragment("coreapps", "patientHeader", [patient: patient])}
<h3>${ui.message("aijar.markpatientdeceased.label")}</h3>

<form method="post">
    <fieldset style="min-width: 40%">
        <p>
            <% if (person?.getDead() == true) {

            %>
            <input checked="checked" id="checkbox-deceased" name="dead" type="checkbox"/>
            <% } else {
            %>
            <input id="checkbox-deceased" name="dead" type="checkbox"/>
            <%
                }
            %>
            <label for="checkbox-deceased">
                <span>${ui.message("aijar.markpatientdeceased.label")}</span>
            </label>
        </p>

        <p>
            ${ui.includeFragment("uicommons", "field/datetimepicker", [
                    label        : "aijar.markpatientdeceased.dateofdeath",
                    formFieldName: "deathDate",
                    left         : true,
                    defaultDate  : person?.getDeathDate() ?: null,
                    useTime      : false,
                    showEstimated: false,
                    initialValue : new Date(),
                    minYear      : minAgeYear,
                    maxYear      : maxAgeYear,
                    id:'death-date'
            ])}
        </p>

        <p>
            <label for="cause-of-death">
                <span>${ui.message("aijar.markpatientdeceased.causeofdeath")} (${ui.message("emr.formValidation.messages.requiredField.label")})</span>
            </label>
            <select name="causeOfDeath" id="cause-of-death">
                <option value="null">Select Cause Of Death</option>
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
            <input type="submit" value="Submit">
        </p>
    </fieldset>
</form>