<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("Viral Load Upload")])

    def htmlSafeId = { extension ->
        "${extension.id.replace(".", "-")}-${extension.id.replace(".", "-")}-extension"
    }
    def breadcrumbMiddle = breadcrumbOverride ?: '';
%>
<script type="text/javascript">
    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {
            label: "${ ui.escapeJs(ui.message("Upload Viral Load Results")) }"
        }
    ];
</script>
<style>
#browser_file_container {
    width: 80%;
    padding-left: 0px;
    padding-right: 0px;
}

#upload_button_container {
    width: 20%;
    text-align: right;
    padding-left: 0px;
    padding-right: 0px;
}

#browser_file {
    width: 109%;
    text-align: right;
}

.div-col3 {
    padding-left: 30px;
    padding-right: 30px;
}

.div-col2 {
    padding-left: 30px;
    padding-right: 30px;
}
</style>

<div>
    <label style="text-align: center"><h1>Viral Load Upload Page</h1></label>

</div>

<form method="post" id="upload_vl" enctype="multipart/form-data" accept-charset="UTF-8">
    <div class="div-table">
        <div class="div-row" id="">
            <div class="div-col2" id="browser_file_container">
                <input type="file" name="file" accept=".csv" id="browser_file"/></div>

            <div class="div-col4" id="upload_button_container"><input type="submit" value="Upload file"/></div>
        </div>
    </div>
</form>

<p style="margin-top: 20px">This Page Allows you to upload viral Load results for patients from the Viral Load Dashboard</p>

<div class="div-table">
    <div class="div-row">
        <div class="div-col2">
            <p><label><h4>Instructions on How to Upload the results in The EMR</h4></label></p>

            <p>
                Step 1: Click on the choose botton above
            </p>

            <p>
                Step 2: Select CSV File to Upload
            </p>

            <p>
                Step 2: Click on the Upload Button
            </p>
        </div>

        <div class="div-col2" style="text-align: justify">

            <p><label><h4>Instructions on How to download the Results</h4></label></p>

            <p>
                Step 1: <a href="https://vldash.cphluganda.org" target="_blank"
                           title="Viral Load Dashboard">Access The Viral Load Dashboard</a>
            </p>

            <p>
                Step 2: Login with the Health Center Credentials (username and password)
            </p>

            <p>
                Step 3: On the Navigation Bar, Select Results
            </p>

            <p>
                Step 4: In the table below Click on the Health center name.
            </p>

            <p>
                Step 5: On the Tabs that Appear Click Download For Upload in EMR
            </p>
        </div>
    </div>
</div>

<div class="div-table" id="feedback">
    <div class="div-row">
        <% if (noPatientFound?.size() > 0) { %>
        <div class="div-col3" id="feedback_no_patient_found">
            <p><label><h4>No patients Found</h4></label></p>
            <table>
                <thead>
                <tr>
                    <th>No.</th>
                    <th>Patient ART NO</th>
                </tr>
                </thead>
                <tbody>
                <% noPatientFound?.eachWithIndex { element, index -> %>
                <tr>
                    <td>${index + 1}</td>
                    <td>${element}</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
        <% if (noEncounterFound?.size() > 0) { %>
        <div class="div-col3" style="text-align: justify" id="feedback_no_encounter_found">
            <p><label><h4>No Encounters Found</h4></label></p>

            <table>
                <thead>
                <tr>
                    <th>No.</th>
                    <th>Patient ART NO</th>
                </tr>
                </thead>
                <tbody>
                <% noEncounterFound?.eachWithIndex { element, index -> %>
                <tr>
                    <td>${index + 1}</td>
                    <td>${element}</td>
                </tr>
                <% } %>
                </tbody>
            </table>

        </div>
        <% } %>

        <% if (noEncounterFound?.size() > 0) { %>
        <div class="div-col3" style="text-align: justify" id="feedback_results_not_released">
            <p><label><h4>Results Not Released</h4></label></p>

            <table>
                <thead>
                <tr>
                    <th>No.</th>
                    <th>Patient ART NO</th>
                </tr>
                </thead>
                <tbody>
                <% patientResultNotReleased?.eachWithIndex { element, index -> %>
                <tr>
                    <td>${index + 1}</td>
                    <td>${element}</td>
                </tr>
                <% } %>
                </tbody>
            </table>

        </div>
        <% } %>
    </div>
</div>
</p>
