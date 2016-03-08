<%
    ui.decorateWith("appui", "standardEmrPage", [ title: ui.message("referenceapplication.home.title") ])

    def htmlSafeId = { extension ->
        "${ extension.id.replace(".", "-") }-${ extension.id.replace(".", "-") }-extension"
    }
%>

<div id="home-container">
    <div id="content" style=" margin: 20px;  ">
        <h2>Uganda EMR Support Desk</h2>
        <p>UgandaEMR help desk: <a href="mailto:openmrs-support-ug@googlegroups.com">openmrs-support-ug@googlegroups.com</a> </p>
        <p>UgandaEMR Community: <a href="mailto:openmrs-uganda@googlegroups.com">openmrs-uganda@googlegroups.com</a> </p>

        <h2>UgandaEMR TWG Contact Nos
        </h2>
        <ul style="list-style:square;margin-left:25px;">
            <li>Mr. Mpango Jonathan (METS) - 0756524011</li>
            <li>Mr. Stephen S Musoke (METS) - 0706553260</li>
            <li>Mr. Alfred Bagenda (MoH) - 0706937715 </li>
        </ul>
        <p></p>

        <h2>Online Demo</h2>

        <p>
            http://mets.or.ug:8082/aijar/login.htm
            <br><br>

            <span style="color: black;border-bottom: solid 1px black;">
                Login credentials
            </span>

            <br><br>
            U:manager
            <br>
            P:Manager123
        </p>

    </div>






    <div id="content" style=" margin: 20px;  ">
        <h2>Uganda EMR Support Desk</h2>

        <p>UgandaEMR help desk: <a href="mailto:openmrs-support-ug@googlegroups.com">openmrs-support-ug@googlegroups.com</a> </p>
        <p>UgandaEMR Community: <a href="mailto:openmrs-uganda@googlegroups.com">openmrs-uganda@googlegroups.com</a> </p>
        <h2>UgandaEMR TWG Contact Nos
        </h2>
        <ul style="list-style:square;margin-left:25px;">
            <li>Mr. Mpango Jonathan (METS) - 0756524011</li>
            <li>Mr. Stephen S Musoke (METS) - 0706553260</li>
            <li>Mr. Alfred Bagenda (MoH) - 0706937715 </li>
        </ul>
        <p></p>

        <h2>Online Demo</h2>

        <p> http://mets.or.ug:8082/aijar/login.htm <br>Login credentials <br>U:manager <br>P:Manager123</p>

    </div>
</div>

