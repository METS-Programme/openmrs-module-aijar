<%
    ui.includeFragment("appui", "standardEmrIncludes")
    ui.includeCss("referenceapplication", "login.css")

    def now = new Date()
    def year = now.getAt(Calendar.YEAR);
%>

<!DOCTYPE html>
<html>
<head>
    <title>${ui.message("referenceapplication.login.title")}</title>
    <link rel="shortcut icon" type="image/ico" href="/${ui.contextPath()}/images/openmrs-favicon.ico"/>
    <link rel="icon" type="image/png\" href="/${ui.contextPath()}/images/openmrs-favicon.png"/>
    ${ui.resourceLinks()}

    <style media="screen" type="text/css">
    body {
        font-family: "OpenSans", Arial, sans-serif;
        -webkit-font-smoothing: subpixel-antialiased;
        max-width: 1000px;
        margin: 10px auto;
        background-color: white;
    }

    #body-wrapper {
        margin-top: 10px;
        padding: 10px;
        background-color: white;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -o-border-radius: 5px;
        -ms-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
    }

    #body-wrapper #content {
        margin-top: 20px;
        padding: 10px;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -o-border-radius: 5px;
        -ms-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
    }

    .logo {
        margin: 0px;
        text-align: center;
    }

    #error-message {
        color: #B53D3D;
        text-align: center;
    }

    .footer{
        float: left;
        margin: 0px 15px;
        width: 95%;
        display: inline-block;
        font-size: 0.7em;
        color: #808080;
    }
    .footer .left_al {
        float: left;
    }

    .footer .right_al{
        float: right;
    }
    .footer a{
        color: #404040;
        font-size: 1em;
        padding: 5px;
        text-decoration: none;
    }
    .footer a:hover{
        color: #404040;
        font-size: 1em;
        padding: 5px;
        text-decoration: underline;
    }
    .footer a:active{
        color: #404040;
        font-size: 1em;
        padding: 5px;
        text-decoration: none;
    }
    .footer a:after{
        color: #404040;
        font-size: 1em;
        padding: 5px;
        text-decoration: none;
    }
    header {
        line-height: 1em;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -o-border-radius: 5px;
        -ms-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
        position: relative;
        background-color: white;
        color: #CCC;
    }

    header .logo img {
        width: 200px;
    }

    header .logo {
        float: none;
        margin: 4px;
    }

    #login-form ul.select {
        padding: 10px;
        background: beige;
    }

    ul.select li.selected {
        background-color: #94979A;
        color: white;
        border-color: transparent;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -o-border-radius: 5px;
        -ms-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
        padding: 5px;
        text-align: center;
    }

    ul.select li:hover {
        background-color: #AB3A15;
        color: white;
        cursor: pointer;
    }

    ul.select li {
        margin: 0 10px;
        text-align: left;
        display: inline-block;
        width: 20%;
        padding: 5px;
        color: #3B6692;
        background-color: #FFF;
        /* border-bottom: 1px solid #efefef; */
        border: dashed 1px #CEC6C6;
        text-align: center;
    }

    form fieldset, .form fieldset {
        border: solid 1px #CECECE;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -o-border-radius: 5px;
        -ms-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
        background: #FFFFFB;
    }
    </style>
</head>

<body>
<script type="text/javascript">
    var OPENMRS_CONTEXT_PATH = '${ ui.contextPath() }';
</script>

<script type="text/javascript">
    jQuery(function () {
        updateSelectedOption = function () {
            jQuery('#sessionLocation li').removeClass('selected');
            var sessionLocationVal = jQuery('#sessionLocationInput').val();
            if (sessionLocationVal != null && sessionLocationVal != "" && sessionLocationVal != 0) {
                jQuery('#sessionLocation li[value|=' + sessionLocationVal + ']').addClass('selected');
                jQuery('#loginButton').removeClass('disabled');
                jQuery('#loginButton').removeAttr('disabled');
            } else {
                jQuery('#loginButton').addClass('disabled');
                jQuery('#loginButton').attr('disabled', 'disabled');
            }
        };

        updateSelectedOption();

        jQuery('#sessionLocation li').click(function () {
            jQuery('#sessionLocationInput').val(jQuery(this).attr("value"));
            updateSelectedOption();
        });

        jQuery('#username').focus();

        var cannotLoginController = emr.setupConfirmationDialog({
                                                                    selector: '#cannotLoginPopup',
                                                                    actions: {
                                                                        confirm: function () {
                                                                            cannotLoginController.close();
                                                                        }
                                                                    }
                                                                });

        jQuery('a#cantLogin').click(function () {
            cannotLoginController.show();
        });

        pageReady = true;
    });
</script>

<div id="body-wrapper">
    <header>
        <div class="logo">
            <a href="${ui.pageLink("referenceapplication", "home")}">
                <img src="${ui.resourceLink("aijar", "images/moh_logo_large.png")}"/>
            </a>
        </div>
    </header>

    ${ui.includeFragment("referenceapplication", "infoAndErrorMessages")}
    <div id="content">
        <div style="width: 100%; font-size: 1.6em; text-align: center; margin: 25px 0 10px 20px;">${healthCenter}</div>
        <form id="login-form" method="post" autocomplete="off">
            <fieldset>

                <legend>
                    <i class="icon-lock small"></i>
                    ${ui.message("referenceapplication.login.loginHeading")}
                </legend>

                <p class="left">
                    <label for="username">
                        ${ui.message("referenceapplication.login.username")}:
                    </label>
                    <input id="username" type="text" name="username"
                           placeholder="${ui.message("referenceapplication.login.username.placeholder")}"/>
                </p>

                <p class="left">

                    <label for="password">
                        ${ui.message("referenceapplication.login.password")}:
                    </label>
                    <input id="password" type="password" name="password"
                           placeholder="${ui.message("referenceapplication.login.password.placeholder")}"/>
                </p>

                <p class="clear">
                    <label for="sessionLocation">
                        Select appropriate area for your session:
                        <!--${ui.message("referenceapplication.login.sessionLocation")}:-->
                    </label>
                <ul id="sessionLocation" class="select">
                    <% locations.sort { ui.format(it) }.each { %>
                    <li id="${it.name}" value="${it.id}">${ui.format(it)}</li>
                    <% } %>
                </ul>
            </p>

                <input type="hidden" id="sessionLocationInput" name="sessionLocation"
                    <% if (lastSessionLocation != null) { %> value="${lastSessionLocation.id}" <% } %>/>

                <p></p>

                <p>
                    <input id="loginButton" class="confirm" type="submit"
                           value="${ui.message("referenceapplication.login.button")}"/>
                </p>

                <p>
                    <a id="cantLogin" href="javascript:void(0)">
                        <i class="icon-question-sign small"></i>
                        ${ui.message("referenceapplication.login.cannotLogin")}
                    </a>
                </p>

            </fieldset>

            <input type="hidden" name="redirectUrl" value="${redirectUrl}"/>

        </form>

    </div>
    <div class="footer">
        <div class="left_al">
            &#169; ${year} All Rights Reserved <a href="http://www.health.go.ug" target="_blank"
                                                  title="Ministry of Health Uganda">Ministry of Health - Republic of Uganda</a>
        </div>
        <div class="right_al">
${ui.message("aijar.build.info")} powered by <a href="http://www.mets.or.ug" target="_blank"
                                                        title="Makerere University School of Public Health METS Programme">METS Programme</a>
        </div>
    </div>
</div>

<div id="cannotLoginPopup" class="dialog" style="display: none">
    <div class="dialog-header">
        <i class="icon-info-sign"></i>

        <h3>${ui.message("referenceapplication.login.cannotLogin")}</h3>
    </div>

    <div class="dialog-content">
        <p class="dialog-instructions">${ui.message("referenceapplication.login.cannotLoginInstructions")}</p>

        <button class="confirm">${ui.message("referenceapplication.okay")}</button>
    </div>
</div>

</body>
</html>