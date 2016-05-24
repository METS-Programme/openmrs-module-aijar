/* deceased Patient patient data entry functionality */
jq('#checkbox-autogenerate-identifier').click(function () {
    if (jq('#checkbox-deceased').is(':checked')) {
        NavigatorController.getFieldById('deceased-status').show();
    }
    else {
        NavigatorController.getFieldById('deceased-status').hide();
    }
})

/* Remove the ability to edit the different patient identifiers by removing the link  */
jq(document).ready(function () {
    // remove the span with link to add a patient identifier with the em before containing the identifier name, and the
    // break for spacing after the span
    jq("div.identifiers > span.add-id").next("br").remove();
    jq("div.identifiers > span.add-id").prev("em").remove();
    jq("div.identifiers > span.add-id").remove();
    // remove the link to enable editing of the patient identifier
    jq(".editPatientIdentifier").each(function () {
        jq(this).attr('href', '').css({'cursor': 'pointer', 'pointer-events': 'none'}); // remove the href attribute so
        // that the link is not clickable
        jq(this).unbind("click"); // remove the click event enabling the editing of the patient identifier
        jq(this).removeClass('editPatientIdentifier'); // also remove the class in case this script is loaded before the
        // onclick is added
    });

    // change the first em to the text National ID
    jq('em:contains("Patient ID")').text("National ID");

    /* Add validation to all HTML forms built using HTML Form entry - their ID is htmlform
     */
    jq.validator.addMethod( "ugphone", function( phone_number, element ) {
        phone_number = phone_number.replace( /\(|\)|\s+|-/g, "" );
        return this.optional( element ) || phone_number.length == 10 &&
                                           phone_number.match( /^[0-9]{1,10}$/ );
    }, "Please specify a valid mobile number without any spaces like 0712345678" );
});


