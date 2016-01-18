/* deceased Patient patient data entry functionality */
jq('#checkbox-autogenerate-identifier').click(function () {
    if (jq('#checkbox-deceased').is(':checked')) {
        NavigatorController.getFieldById('deceased-status').show();
    }
    else {
        NavigatorController.getFieldById('deceased-status').hide();
    }
})
