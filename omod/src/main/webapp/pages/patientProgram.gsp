<%
    ui.decorateWith("appui", "standardEmrPage", [title: ui.message("aijar.program.title")])
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("aijar.app.program.label")}",
          link: "${ui.pageLink("coreapps", "findpatient/findPatient?app=aijar.program")}"
        },
        { label: "${ ui.escapeJs(ui.format(patient.givenName)) }, ${ ui.escapeJs(ui.format(patient.familyName)) }"}
    ];
</script>

<table>
    <thead>
	    <tr>
	        <th>${ ui.message("general.name") }</th>
	        <th>${ ui.message("aijar.program.enrollmentDate") }</th>
	        <th>${ ui.message("aijar.program.entryPoint") }</th>
	        <th>${ ui.message("aijar.program.completionDate") }</th>
	        <th>${ ui.message("aijar.program.outcome") }</th>
	    </tr>
    </thead>
    
    <tbody>
	    <% programs.each { program -> %>
		    <tr>
		        <td>
		        	${program.program.name}
		        </td>
		        <td> <% if (program.dateEnrolled != null) { %>  ${ ui.formatDatePretty(program.dateEnrolled) } <% } %> </td>
		        <td> <% if (program.location != null) { %>  ${program.location} <% } %> </td>
		        <td> <% if (program.dateCompleted != null) { %>  ${ ui.formatDatePretty(program.dateCompleted) } <% } %> </td>
		        <td> <% if (program.outcome != null) { %>  ${program.outcome} <% } %> </td>
		    </tr>
	    <% } %>
		    <tr>
		        <td align="center" colspan="5">
		        	<button type="button">${ ui.message("aijar.program.enroll") }</button>
		        </td>
		    </tr>
    </tbody>
</table>