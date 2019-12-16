<%
    ui.includeFragment("appui", "standardEmrIncludes")
    ui.includeCss("referenceapplication", "login.css")
    ui.includeCss("appui","bootstrap.min.css")
    ui.includeCss("appui","bootstrap.min.js")

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
        background-color: #FAFAFA;
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
        background: #FAFAFA;
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
        margin-left: 150px;
        font-size: 0.7em;
        color: #808080;
    }
    .footer .left_al {
        margin-right: auto;
        margin-left: auto;
    }
    .center {
        margin: auto;
        width: 60%;
        padding: 10px;
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
    #footer
    {
        margin-right: 300px;
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
    #header-container
    {
     width: 400px;
    }

    header .logo {
        float: none;
        margin: 4px;
    }


    #login-form ul.select {
        padding: 10px;
        background: beige;
    }
    #fieldset{
        margin-left: 200px;
        margin-top: 100px;
    }
   #header{
       background: #FAFAFA;
   }
   #header-image{
       background: #FAFAFA;
       margin-left: 200px;
   }
   #subtitle{
       width: 100%;
       font-size: 1.6em;
       text-align: center;
       font-weight: bold;
       font-family:Arial-BoldMT
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
    h3
    {
        margin-left: 30px;
        padding-top: 5px;
        font-family: "Trebuchet MS";
        color: black;
    }
    h3.dialog-header{
        font-weight: bolder;
    }
    #uganda
    {
        font-weight: bolder;
        font-size: 50px
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
    <div class="container">
    <header id="header">

            <div class="row" id="header-image">
                <img  src="${ui.resourceLink("aijar", "images/homepage.png")}"/>

            </div>
    </header>

        <form id="login-form" method="post" autocomplete="off">
            <fieldset id="fieldset">

                <div id="subtitle"> ${healthCenter} </div>
                ${ui.includeFragment("referenceapplication", "infoAndErrorMessages")}
            <table class="table-table table-borderless table-condensed table-hover">
                <tr>
                    <td>
                    <label for="username">
                        ${ui.message("referenceapplication.login.username")}:
                    </label>
                    </td>
                <td>
                    <div class="input-group form-group" style="padding-top: 10px">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="icon-user"></i></span>
                        </div>
                    <input id="username" type="text" name="username"  class="form-control icon-user"
                           placeholder="${ui.message("referenceapplication.login.username.placeholder")}"/>

                    </div>
                </td>
                </tr>
                <tr>
                    <td>

                        <label for="password">
                            ${ui.message("referenceapplication.login.password")}:
                        </label>
                    </td>
                    <td>
                        <div class="input-group form-group" style="padding-top: 10px">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="icon-key"></i></span>
                        </div>
                        <input id="password" type="password" name="password" class="form-control icon-key"
                               placeholder="${ui.message("referenceapplication.login.password.placeholder")}"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Select Location:
                    </td>
                    <td>
                        <select  class="custom-select" name="sessionLocation" id="sessionLocationInput">
                            <option value="" >Select Location</option>
                            <% locations.sort { ui.format(it) }.each { %>
                            <option value="${it.id}">${it.name}</option>
                            <% } %>
                        </select>

                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input id="loginButton" class="confirm" type="submit"
                               value="${ui.message("referenceapplication.login.button")}"/>
                      <span style="padding-left: 150px;font-size: 12px">
                          <a id="cantLogin" href="javascript:void(0)">
                            <i class="icon-question-sign small"></i>
                            ${ui.message("referenceapplication.login.cannotLogin")}
                        </a>
                      </span>

                    </td>
                </tr>

</table>

            </fieldset>

            <input type="hidden" name="redirectUrl" value="${redirectUrl}"/>

        </form>

    </div>
    <div class="footer">
        <div class="center">
            Supported by <a href="http://www.mets.or.ug" target="_blank"
                                                            title="Makerere University School of Public Health METS Programme">MakSPH METS Programme</a>|  ${ui.message("aijar.build.info")}
        </div>
        <div class="center">
            &#169; ${year} All Rights Reserved <a href="http://www.health.go.ug" target="_blank"
                                                  title="Ministry of Health Uganda">Ministry of Health - Republic of Uganda</a>
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
</div>
</body>
</html>