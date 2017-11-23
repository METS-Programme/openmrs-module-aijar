<%
    ui.decorateWith("appui", "standardEmrPage", [ title: ui.message("UgandaEMR Support Desk") ])

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

        <p>UgandaEMR Help Desk: <a href="mailto:ugandaemr-support-ug@googlegroups.com"
                                   target="_blank">openmrs-support-ug@googlegroups
            .com</a></p>

        <p>UgandaEMR Community: <a href="mailto:ugandaemr@googlegroups.com"
                                   target="_blank">ugandaemr@googlegroups.com</a></p>

        <h2>UgandaEMR TWG Contact Numbers</h2>
        <ul style="list-style:square;margin-left:25px;">
            <li>Mpango Jonathan (METS) - 0756524011</li>
            <li>Stephen S Musoke (METS) - 0706553260</li>
            <li>Lubwama Samuel (METS) - 0774216355</li>
            <li>Alfred Bagenda (MoH) - 0706937715 </li>
        </ul>
        <p></p>

        <h2>Online Demo</h2>

        <p>
            <a href="http://bit.ly/ugandaemr-demo" target="_blank" title="UgandaEMR Online Demo">http://bit.ly/ugandaemr-demo</a>
            <br><br>

            <span style="color: black;border-bottom: solid 1px black;">
                Login credentials
            </span>

            <br><br>
            Username: manager
            <br>
            Password: Manager123
        </p>

        <h2>User Manual</h2>

        <p>
            <a href="http://bit.ly/ugandaemr-usermanual-pdf" target="_blank" title="UgandaEMR User Manual - PDF Format"><i class="icon-download-alt"></i> Download (PDF 50MB) http://bit.ly/ugandaemr-usermanual-pdf</a>
            <br/><br/>
            <a href="http://bit.ly/ugandaemr-usermanual" target="_blank" title="UgandaEMR User Manual - Read Online">Read Online http://bit.ly/ugandaemr-usermanual</a>
        </p>
    </div>
</div>

