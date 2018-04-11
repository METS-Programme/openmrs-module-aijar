<div class="info-section patientsummary">
    <div class="info-header">
        <i class=" icon-user-md"></i>

        <h3>${ui.message("aijar.patient.transfer.header")}</h3>

    </div>
    <% if (transferredOut == true) { %>
    <div class="info-body" style="background: yellow">

        <div>
            <strong>${ui.message("aijar.patient.transfer.out.date")}:</strong>
            ${ui.format(dateTransferredOut)}
        </div>

        <div>
            <strong>${ui.message("aijar.patient.transfer.out.location")}:</strong>
            ${transferredOutTo}
        </div>
    </div>
    <% } %>
    <% if (transferredIn == true) { %>
    <div class="info-body" style="">

        <div>
            <strong>${ui.message("aijar.patient.transfer.in.date")}:</strong>
            ${ui.format(dateTransferredIn)}
        </div>

        <div>
            <strong>${ui.message("aijar.patient.transfer.in.location")}:</strong>
            ${transferredInTo}
        </div>
    </div>
    <% } %>
</div>