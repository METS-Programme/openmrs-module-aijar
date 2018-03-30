<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("Import data from FamilyConnect EMTCT module")])

    def htmlSafeId = { extension ->
        "${extension.id.replace(".", "-")}-${extension.id.replace(".", "-")}-extension"
    }
%>
<script type="text/javascript">
    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {label: "${ ui.escapeJs(ui.message("Import data from FamilyConnect EMTCT Module")) }"}
    ]
</script>

<div id="home-container">
    <div id="content" style=" margin: 20px;  ">
        <h2>Import data from FamilyConnect EMTCT Module</h2>

        <form method="post" enctype="multipart/form-data">
            <p class="narrow">
                <label>
                    Data File
                </label>
                <input type="file"/>
            </p>
            <strong>NOTES:</strong>
            <ul>
                <li>This file upload functionality only accepts CSV files</li>
                <li>The expected columns in the file are:
                    <ul><li>Phone number</li>
                        <li>Follow up date</li>
                        <li>Type of Care - ANC, EID, ART</li>
                        <li>Outcome</li>
                        <li>Followup Type</li>
                        <li>ART Number</li>
                        <li>OpenMRS ID</li>
                        <li>EID Number</li>
                        <li>Health Facility</li>
                    </ul>
                </li>
            </ul>

        </form>
    </div>
</div>
