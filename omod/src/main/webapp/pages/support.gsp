<%
    ui.decorateWith("appui", "standardEmrPage", [ title: ui.message("referenceapplication.home.title") ])

    def htmlSafeId = { extension ->
        "${ extension.id.replace(".", "-") }-${ extension.id.replace(".", "-") }-extension"
    }
%>
<script type="text/javascript">
    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {label: "${ ui.escapeJs(ui.message("aijar.app.support.list.label")) }"}
    ]
</script>

<div id="home-container">
    <div id="content" style=" margin: 20px;  ">
        <h2>Uganda EMR Support Desk</h2>

        <p>UgandaEMR Help Desk: <a href="mailto:openmrs-support-ug@googlegroups.com"
                                   target="_blank">openmrs-support-ug@googlegroups
            .com</a></p>

        <p>UgandaEMR Community: <a href="mailto:openmrs-uganda@googlegroups.com"
                                   target="_blank">openmrs-uganda@googlegroups.com</a></p>

        <h2>UgandaEMR TWG Contact Numbers</h2>
        <ul style="list-style:square;margin-left:25px;">
            <li>Mpango Jonathan (METS) - 0756524011</li>
            <li>Stephen S Musoke (METS) - 0706553260</li>
            <li>Alfred Bagenda (MoH) - 0706937715 </li>
        </ul>
        <p></p>

        <h2>Online Demo</h2>

        <p>
            <a href="http://mets.or.ug:8082/aijar/login.htm" target="_blank">http://mets.or.ug:8082/aijar/login.htm</a>
            <br><br>

            <span style="color: black;border-bottom: solid 1px black;">
                Login credentials
            </span>

            <br><br>
            Username: manager
            <br>
            Password: Manager123
        </p>
    </div>
</div>

