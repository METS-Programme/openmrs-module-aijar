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
        // remove the link to editing the patient identifier
        jq(this).removeAttr("href");
    }
});
