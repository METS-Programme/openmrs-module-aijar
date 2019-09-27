<%
    def returnUrl = "/${contextPath}/registrationapp/registrationSummary.page?patientId=${patient.patient.id}&appId=${appId}"

%>


<div class="clear"></div>
<div class="container">
    <div class="dashboard clear">
        <div class="info-container column">
            ${ ui.includeFragment("registrationapp", "summary/section", [patient: patient, appId: appId, sectionId: "identifiers"]) }

            <% if (firstColumnFragments) {
                firstColumnFragments.each {
                    // create a base map from the fragmentConfig if it exists, otherwise just create an empty map
                    def configs = [:];
                    if(it.extensionParams.fragmentConfig != null){
                        configs = it.extensionParams.fragmentConfig;
                    }
                    configs << [patient: patient, patientId: patient.patient.id, app: it.appId, appId: appId, returnUrl: returnUrl ]
            %>
                    ${ ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment, configs)}
            <% }
            } %>
        </div>

        <div class="info-container column">
            ${ ui.includeFragment("registrationapp", "summary/section", [patient: patient, appId: appId, sectionId: "contactInfo"]) }

            <% if (secondColumnFragments) {
                secondColumnFragments.each {
                    // create a base map from the fragmentConfig if it exists, otherwise just create an empty map
                    def configs = [:];
                    if(it.extensionParams.fragmentConfig != null){
                        configs = it.extensionParams.fragmentConfig;
                    }
                    configs << [patient: patient, patientId: patient.patient.id, app: it.appId, appId: appId, returnUrl: returnUrl ]
            %>
                    ${ ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment, configs)}
            <% }
            } %>

        </div>

        <div class="action-container column">
            <div class="action-section">
                <ul>
                    <h3>${ ui.message("coreapps.clinicianfacing.overallActions") }</h3>
                    <%
                        overallActions.each { ext -> %>
                            <a href="${ ui.escapeJs(ext.url("/" + ui.contextPath(), appContextModel, returnUrl)) }" id="${ ext.id }">
                                <li>
                                    <i class="${ ext.icon }"></i>
                                    ${ ui.message(ext.label) }
                                </li>
                            </a>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
</div>