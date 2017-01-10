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

    /* Add validation rule for Uganda phone numbers, once applied to an element will validate the format and show a message
     */
    jq.validator.addMethod( "ugphone", function( phone_number, element ) {
        phone_number = phone_number.replace( /\(|\)|\s+|-/g, "" );
        return this.optional( element ) || phone_number.length == 10 &&
                                           phone_number.match( /^[0-9]{1,10}$/ );
    }, "Please specify a valid mobile number without any spaces like 0712345678" );
});

/**
 * Changes a field date in the format yy-mm-dd to dd/mm/yy which eas
 * @param dateValue
 */
function changeFieldDateToJavascriptDate(dateValue) {
    return jq.datepicker.formatDate('dd/mm/yy', jq.datepicker.parseDate('yy-mm-dd', dateValue));
}


jq(function() {
    enable_disable_mark_patient_dead();
    jq("#checkbox-deceased").change(enable_disable_mark_patient_dead);
    jq("#checkbox-deceased").each(enable_disable_mark_patient_dead);
});

function enable_disable_mark_patient_dead() {
    if (this.checked) {
        jq("#death-date-display").attr('disabled', false);
        jq("#cause-of-death").prop('disabled', false);
        jq("#death-date-display").fadeTo(250, 1);
    } else {
        jq("#eath-date-display").attr('disabled', true);
        jq("#cause-of-death").prop('disabled', true);
        jq("#death-date-display").fadeTo(250, 0.25);
    }
}


