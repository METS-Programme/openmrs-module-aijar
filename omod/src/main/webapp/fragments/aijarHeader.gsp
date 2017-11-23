<%
    def addContextPath = {
        if (!it)
            return null
        if (it.startsWith("/")) {
            it = "/" + org.openmrs.ui.framework.WebConstants.CONTEXT_PATH + it
        }
        return it
    }

    def logoIconUrl = addContextPath(configSettings?."logo-icon-url") ?: ui.resourceLink("aijar", "images/moh_logo_without_word.png")
    def logoLinkUrl = addContextPath(configSettings?."logo-link-url") ?: "/${org.openmrs.ui.framework.WebConstants.CONTEXT_PATH}"

    def multipleLoginLocations = (loginLocations.size > 1);

    def enableUserAccountExt = userAccountMenuItems.size > 0;

%>
<script type="text/javascript">

    var sessionLocationModel = {
        id: ko.observable(),
        text: ko.observable()
    };

    jq(function () {

        ko.applyBindings(sessionLocationModel, jq('.change-location').get(0));
        sessionLocationModel.id(${ sessionContext.sessionLocationId });
        sessionLocationModel.text("${ ui.format(sessionContext.sessionLocation) }");

        // we only want to activate the functionality to change location if there are actually multiple login locations
        <% if (multipleLoginLocations) { %>

        jq(".change-location a").click(function () {
            jq('#session-location').show();
            jq(this).addClass('focus');
            jq(".change-location a i:nth-child(3)").removeClass("icon-caret-down");
            jq(".change-location a i:nth-child(3)").addClass("icon-caret-up");
        });

        jq('#session-location').mouseleave(function () {
            jq('#session-location').hide();
            jq(".change-location a").removeClass('focus');
            jq(".change-location a i:nth-child(3)").addClass("icon-caret-down");
            jq(".change-location a i:nth-child(3)").removeClass("icon-caret-up");
        });

        jq("#session-location ul.select li").click(function (event) {
            var element = jq(event.target);
            var locationId = element.attr("locationId");
            var locationName = element.attr("locationName");

            var data = {locationId: locationId};

            jq("#spinner").show();

            jq.post(emr.fragmentActionLink("appui", "session", "setLocation", data), function (data) {
                sessionLocationModel.id(locationId);
                sessionLocationModel.text(locationName);
                jq('#session-location li').removeClass('selected');
                element.addClass('selected');
                jq("#spinner").hide();
                jq(document).trigger("sessionLocationChanged");
            })

            jq('#session-location').hide();
            jq(".change-location a").removeClass('focus');
            jq(".change-location a i:nth-child(3)").addClass("icon-caret-down");
            jq(".change-location a i:nth-child(3)").removeClass("icon-caret-up");
        });

        <% if (enableUserAccountExt) { %>
        jq('.identifier').hover(
                function () {
                    jq('.appui-toggle').show();
                    jq('.appui-icon-caret-down').hide();
                },
                function () {
                    jq('.appui-toggle').hide();
                    jq('.appui-icon-caret-down').show();
                }
        );
        jq('.identifier').css('cursor', 'pointer');
        <% } %>
        <% } %>
    });

</script>
<header>
    <div class="logo">
        <a href="${logoLinkUrl}">
            <img src="${logoIconUrl}" style="height: 70px; width: 70px; background: whitesmoke; padding: 5px;"/>
        </a>
    </div>

    <div style="float: left;margin: 25px 0 10px 20px; color: #EFEFEF;width: 285px;">
        <div style="padding-bottom: 10px;">
            <span style="font-size: 1.2em; text-align: left;color: #FFFFFF;">Ministry of Health </span>
            <span style="color: #F1F1F1;font-size: 1.2em;">- Uganda</span><span style="color: #D2CB92;font-size: 1.2em;">EMR</span>
        </div>
        <span style="color: #848484;font-size: 0.9em;float: left; width: 100%; text-align: center;">Electronic Medical Records System</span>
    </div>
    <div style="float: left; font-size: 1.6em; text-align: center; margin: 25px 0 10px 20px; width: 22%;">
        ${healthCenter}
    </div>

    <% if (context.authenticated) { %>
    <ul class="user-options" style="padding: 20px;">
        <li class="identifier">
            <i class="icon-user small"></i>
            ${context.authenticatedUser.username ?: context.authenticatedUser.systemId}
            <% if (enableUserAccountExt) { %>
            <i class="icon-caret-down appui-icon-caret-down link"></i><i class="icon-caret-up link appui-toggle"
                                                                         style="display: none;"></i>
            <ul id="user-account-menu" class="appui-toggle">
                <% userAccountMenuItems.each { menuItem -> %>
                <li>
                    <a id="" href="/${contextPath}/${menuItem.url}">
                        ${ui.message(menuItem.label)}
                    </a>
                </li>
                <% } %>
            </ul>
            <% } %>
        </li>
        <li class="change-location">
            <a href="javascript:void(0);">
                <i class="icon-map-marker small"></i>
                <span data-bind="text: text"></span>
                <% if (multipleLoginLocations) { %>
                <i class="icon-caret-down link"></i>
                <% } %>
            </a>
        </li>
        <li class="logout">
            <a href="/${contextPath}/logout">
                ${ui.message("emr.logout")}
                <i class="icon-signout small"></i>
            </a>
        </li>
    </ul>

    <div id="session-location">
        <div id="spinner" style="position:absolute; display:none">
            <img src="${ui.resourceLink("uicommons", "images/spinner.gif")}">
        </div>
        <ul class="select">
            <% loginLocations.sort { ui.format(it) }.each {
                def selected = (it == sessionContext.sessionLocation) ? "selected" : ""
            %>
            <li class="${selected}" locationId="${it.id}" locationName="${ui.format(it)}">${ui.format(it)}</li>
            <% } %>
        </ul>
    </div>
    <% } %>
</header>