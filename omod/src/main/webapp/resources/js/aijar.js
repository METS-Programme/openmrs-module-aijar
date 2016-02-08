/* deceased Patient patient data entry functionality */
jq('#checkbox-autogenerate-identifier').click(function () {
    if (jq('#checkbox-deceased').is(':checked')) {
        NavigatorController.getFieldById('deceased-status').show();
    }
    else {
        NavigatorController.getFieldById('deceased-status').hide();
    }
})

/* Remove the ability to edit the different patient identifiers by removing the link */

jq(".editPatientIdentifier").each(function () {
    // check if the contents is Add then remove it along with the em before which is empty
    if (jq(this).text() == 'Add') {
        jq(this).parent().prev("em").hide(); // hide the label for the patient identifier which is the EM just before the
        // parent span containing the link
        jq(this).hide(); // hide this link
    } else {
        jq(this).attr('href', '').css({'cursor': 'pointer', 'pointer-events': 'none'}); // remove the href attribute so
        // that the link is not clickable
        jq(this).unbind("click"); // remove the click event enabling the editing of the patient identifier
        jq(this).removeClass('editPatientIdentifier'); // also remove the class in case this script is loaded before the
        // onclick is added
    }
});
