<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("aijar.dsdm.program.addPatientProgram")])

    def htmlSafeId = { extension ->
        "${extension.id.replace(".", "-")}-${extension.id.replace(".", "-")}-extension"
    }
%>
<script type="text/javascript">
    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {
            label: "${ ui.escapeJs(ui.message("aijar.dsdm.program.addPatientProgram")) }",
            link: '${ ui.urlBind("/" + contextPath + "coreapps/clinicianfacing/patient.page?patientId="+patientId, [ patientId: patient ] ) }'
        }
    ];

    jq(function () {
    jq(function () {
        jq('#add-patient-program').submit(function () {
            jq(".field-error").html("");
            var submitVal = true;
            var submitValStage = [];

            if (jq('#enrollmentdate-date-container').find("input[type=hidden]").val() == "") {
                jq("#enrolment-date > .field-error").append("${ui.message("Can No be Null")}").show();
                submitValStage.push(false);
            }

            if (submitValStage.indexOf(false) != -1) {
                submitVal = false;
            }

            return submitVal;
        });
    });
</script>
${ui.includeFragment("coreapps", "patientHeader", [patient: patient])}
<h3>${ui.message("aijar.dsdm.program.addPatientProgram")}</h3>

<form method="post" id="add-patient-program">
    <fieldset style="min-width: 40%">
        <p>
            <span id="patient-program">
                <label>Program</label>
                <select name="programId" id="program" required="required">
                    <option value="">${ui.message("aijar.dsdm.select.program")}</option>
                    <% if (programs != null) { %>
                    <% programs.each { %>
                    <option value="${it.uuid}">${it.name}</option>
                    <% }} %>
                </select>
            </span>
        </p>

        <p>
            <span id="enrollmentdate-date-container">
                ${ui.includeFragment("uicommons", "field/datetimepicker", [
                        label        : "Enrollment Date",
                        formFieldName: "enrolmentDate",
                        left         : true,
                        defaultDate  : null,
                        useTime      : false,
                        showEstimated: false,
                        initialValue : new Date(),
                        startDate    : birthDate,
                        endDate      : new Date(),
                        id           : 'enrolment-date',
                        required     : true
                ])}
            </span>
        </p>

        <p>
            <span id="completion-date-date-container">
                ${ui.includeFragment("uicommons", "field/datetimepicker", [
                        label        : "Completion Date",
                        formFieldName: "completionDate",
                        left         : true,
                        defaultDate  : null,
                        useTime      : false,
                        showEstimated: false,
                        initialValue : new Date(),
                        startDate    : birthDate,
                        endDate      : new Date(),
                        id           : 'completion-date',
                        required     : true
                ])}
            </span>
        </p>

        <p>
            <span id="location-program">
                <label>Location</label>
                <select name="locationId" id="location-of-death" required="required">
                    <option value="">${ui.message("aijar.dsdm.select.location")}</option>
                    <% if (locations != null) {
                        locations.each {
                    %>
                    <option value="${it.uuid}">${it.name}</option>
                    <% }
                    } %>
                </select>

            </span>
        </p>

        <p>
            <span>
                <input type="submit" class="confirm" value="Enroll">
            </span>
        </p>
    </fieldset>
</form>