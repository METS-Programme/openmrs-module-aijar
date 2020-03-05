<div class="info-section patientsummary">
    <div class="info-header">
        <i class=" icon-user-md"></i>

        <h3>${ui.message("aijar.patient.transfer.header")}</h3>

    </div>
    <% if (transferredOut == true) { %>
    <div class="info-body">

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
    <% if (transferredIn == true && transferredOut==false) { %>
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
<% if(TransferHistory.size>0){%>
    <table>
        <thead>
        <tr><th>Transfer Type</th><th>Date</th></tr>
        </thead>

        <tbody>
        <%TransferHistory.reverse().each{%>
        <tr><td>${it.encounterType.name}</td><td>${Date.parse("yyyy-M-d H:m:s",it.encounterDatetime.toString()).format("d.MMM.yyyy")}</td></tr>
        <%}%>
        </tbody>
    </table>
    <%} else{%>
    <div class="info-body">${ui.message("aijar.patient.transfer.nodata")}</div>
    <%}%>
</div>