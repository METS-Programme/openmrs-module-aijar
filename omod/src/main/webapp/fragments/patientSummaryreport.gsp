<div class="info-section patientsummary">
    <div class="info-header">
        <i class=" icon-user-md"></i>

        <h3>${ui.message("aijar.patientdashboard.patientsummary.heading").toUpperCase()}</h3>

    </div>

    <div class="info-body">
        <div>
            <strong>${ui.message("aijar.patientdashboard.person.lastcd4")}:</strong>
            ${lastcd4} ${lastcd4joiner} ${lastcd4date}
        </div>
        <div>
            <strong>${ui.message("aijar.patientdashboard.person.currentregimen")}:</strong>
            ${currentregimen} ${currentregimenjoiner} ${currentregimendate}
        </div>
        <div>
            <strong>${ui.message("aijar.patientdashboard.person.bmi")}:</strong>
            ${bmi} (${height} ${weight})
        </div>
    </div>
</div>