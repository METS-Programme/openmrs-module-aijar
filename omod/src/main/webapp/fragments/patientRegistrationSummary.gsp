<div class="info-section patientsummary">
    <div class="info-header">
        <i class=" icon-user-md"></i>

        <h3>${ui.message("aijar.patientsummarydashboard.patientregistrationsummary.heading").toUpperCase()}</h3>

    </div>

    <div class="info-body">
        <div>
            <strong>${ui.message("aijar.patientsummarydashboard.patientregistrationsummary.telephone")}:</strong>
            ${lastcd4} ${lastcd4joiner} ${lastcd4date}
        </div>
        <div>
            <strong>${ui.message("aijar.patientsummarydashboard.patientregistrationsummary.caregiver")}:</strong>
            ${currentregimen} ${currentregimenjoiner} ${currentregimendate}
        </div>
        <div>
            <strong>${ui.message("aijar.patientsummarydashboard.patientregistrationsummary.caregiverphone")}:</strong>
            ${bmi} (${height} ${weight})
        </div>
    </div>
</div>