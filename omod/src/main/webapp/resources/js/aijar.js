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
    jq.validator.addMethod("ugphone", function (phone_number, element) {
        phone_number = phone_number.replace(/\(|\)|\s+|-/g, "");
        return this.optional(element) || phone_number.length == 10 &&
            phone_number.match(/^[0-9]{1,10}$/);
    }, "Please specify a valid mobile number without any spaces like 0712345678");
});

/**
 * Changes a field date in the format yy-mm-dd to dd/mm/yy which eas
 * @param dateValue
 */
function changeFieldDateToJavascriptDate(dateValue) {
    return jq.datepicker.formatDate('dd/mm/yy', jq.datepicker.parseDate('yy-mm-dd', dateValue));
}


/*
 * Hide the container, and disable all elements in it
 *
 * @param the Id of the container
 */
function hideContainer(container) {
    jq(container).addClass('hidden');
    jq(container + ' :input').attr('disabled', true);
    jq(container + ' :input').prop('checked', false);
}
/*
 * Show the container, and enable all elements in it
 *
 * @param the Id of the container
 */
function showContainer(container) {
    jq(container).removeClass('hidden');
    jq(container + ' :input').attr('disabled', false);
    jq(container + ' :input').prop('checked', false);
}