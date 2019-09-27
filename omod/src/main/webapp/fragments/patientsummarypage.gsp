<%
    def patient = config.patient
    def appId  = config.appId

    def returnUrl = "/${contextPath}/registrationapp/registrationSummary.page?patientId=${patient.patient.id}&appId=${appId}";


%>
<% if (section) { %>
<div class="info-section">
    <div class="info-body summary-section">
        ${ ui.includeFragment("registrationapp", "summary/section", [patient: patient, appId: appId, sectionId: "address"]) }
        <!-- display basic baked-in identifiers information if identifiers section -->
        <!-- display other fields -->
        <% section.questions.each { question ->
            // TODO do we want to display any labels for questions?
            def fields = question.fields %>
            <div id="${ address }">
                <h3>${ ui.message("aijar.registrationapp.currentaddress.question") }</h3>
                <p class="left">
                    <% fields.each { field ->
                        def displayValue = "";
                        if (field.type == 'personAttribute') {
                            displayValue = uiUtils.getAttribute(patient.patient, field.uuid)?.replace("\n", "<br />");
                        }
                        else if (field.type == 'personAddress') {
                            displayValue = ui.format(config.patient.personAddress).replace("\n", "<br />");
                        }
                        else if (field.type == "patientIdentifier") {
                            displayValue = uiUtils.getIdentifier(patient.patient, field.uuid)
                        }
                        // TODO support other types besides personAttribute and personAddress
                    %>
                        ${ displayValue ?: ''}&nbsp;
                    <% } %>
                </p>
            </div>
        <% } %>
    </div>
</div>
<% } %>