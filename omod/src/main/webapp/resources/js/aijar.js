/* deceased Patient patient data entry functionality */
jq('#checkbox-autogenerate-identifier').click(function () {
    if (jq('#checkbox-deceased').is(':checked')) {
        NavigatorController.getFieldById('deceased-status').show();
    }
    else {
        NavigatorController.getFieldById('deceased-status').hide();
    }
});

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
    jQuery.validator.addMethod("ugphone", function (phone_number, element) {
        phone_number = phone_number.replace(/\(|\)|\s+|-/g, "");
        return this.optional(element) || phone_number.length == 10 &&
            phone_number.match(/^[0-9]{1,10}$/);
    }, "Please specify a valid mobile number without any spaces like 0712345678");

    jQuery.validator.addMethod("nationalid", function (nationalid, element) {
        nationalid = nationalid.replace(/\(|\)|\s+|-/g, "");
        return this.optional(element) || nationalid.match(/^$|^[A-Z][FM]\d{5}([A-Z0-9]){7}$/);
    }, "Enter a valid National ID example CF12345678ABCD");


    /* Validation of NIN on patient registration page */
    jQuery("#registration").validate({
        rules: {
            confirm_nationalid: {
                equalTo: "nationalid"
            }
        },
        messages: {
            confirm_nationalid: {
                equalTo: "Please confirm the National ID you have entered"
            }
        }
    });

    /* Reconfigure the toast message to stay for 15 seconds instead of the default 3 seconds */
    jq().toastmessage({stayTime: 15000});
});


/**
 * Difference in Dates in months
 * @param dt2
 * @param dt1
 * @returns {number}
 */
function diff_months(dt2, dt1) {
    var diff = (dt2.getTime() - dt1.getTime()) / 1000;
    diff /= (60 * 60 * 24 * 7 * 4);
    return Math.abs(Math.round(diff));
}

/**
 * Changes a field date in the format yy-mm-dd to dd/mm/yy which is easier to read
 * @param dateValue
 */
function changeFieldDateToJavascriptDate(dateValue) {
    return jq.datepicker.formatDate('dd/mm/yy', jq.datepicker.parseDate('yy-mm-dd', dateValue));
}

/**
 * Format a date for display on the screen
 *
 * TODO: Replace this with a function from OpenMRS JS Library
 * @param date
 * @returns {*}
 */
function formatDateForDisplay(date) {
    return jq.datepicker.formatDate('dd/mm/yy', date);
}


/**
 *
 * @param prime What to test
 * @param factor What to be tested
 * @param alternative_factor this is used when factorRequired is true and factor is expected to be null
 * @param message_to_throw
 * @param condition for example greater_than,less_than,equal_to,greater_or_equal,less_or_equal,not_equal
 * @param factorRequired this
 * @returns {boolean}
 */
function dateValidator(prime, factor, alternative_factor, message_to_throw, alternative_message_to_throw, condition, factorRequired) {
    var evaluationResult = true;

    getField(prime + '.error').html("").hide;

    if (getValue(factor + '.value') === '' && getValue(prime + '.value') !== '' && factorRequired === true) {
        getField(factor + '.error').html("Can Not Be Null").show;
        evaluationResult = false;
    }
    else if (getValue(factor + '.value') === '' && getValue(alternative_factor + '.value') === '' && getValue(prime + '.value') !== '' && factorRequired == false) {
        getField(alternative_factor + '.error').html("Can Not Be Null").show();
        evaluationResult = false;
    }

    if (getValue(factor + '.value') === '' && getValue(alternative_factor + '.value') !== "" && factorRequired === false) {
        factor = alternative_factor;
        message_to_throw = alternative_message_to_throw;
    }

    if (getValue(prime + '.value') !== '' && getValue(factor + '.value') !== '') {
        <!-- has a value -->

        switch (condition) {
            case "greater_than":
                if (getValue(prime + '.value') > getValue(factor + '.value')) {
                    getField(prime + '.error').html(message_to_throw).show();
                    evaluationResult = false;
                }
                break;
            case "less_than":
                if (getValue(prime + '.value') < getValue(factor + '.value')) {
                    getField(prime + '.error').html(message_to_throw).show();
                    evaluationResult = false;
                }
                break;
            case "equal_to":
                if (!(getValue(prime + '.value') === getValue(factor + '.value'))) {
                    getField(prime + '.error').html(message_to_throw).show();
                    evaluationResult = false;
                }
                break;
            case "greater_or_equal":
                if (getValue(prime + '.value') >= getValue(factor + '.value')) {
                    getField(prime + '.error').html(message_to_throw).show();
                    evaluationResult = false;
                }
                break;
            case "less_or_equal":
                if (getValue(prime + '.value') <= getValue(factor + '.value')) {
                    getField(prime + '.error').html(message_to_throw).show();
                    evaluationResult = false;
                }
                break;
            case "not_equal":
                if (getValue(prime + '.value') !== getValue(factor + '.value')) {
                    getField(prime + '.error').html(message_to_throw).show();
                    evaluationResult = false;
                }
                break;
        }

    }
    return evaluationResult;
}


/**
 *
 * @param prime What to test
 * @param factor What to be tested
 * @param alternative_factor this is used when factorRequired is true and factor is expected to be null
 * @param message_to_throw
 * @param condition for example greater_than,less_than,equal_to,greater_or_equal,less_or_equal,not_equal
 * @param factorRequired this
 * @returns {boolean}
 */
function validateRequiredField(prime, factor, message_to_throw, input_type) {
    var evaluationResult = true;
    var selected_value = null;
    getField(prime + '.error').html("").hide;

    if (input_type === "select") {
        selected_value = jq("#" + factor).find(":selected").text().trim().toLowerCase();
        if (selected_value !== '' && getValue(prime + '.value') === '') {
            getField(prime + '.error').html(message_to_throw).show;
            jq('#' + prime).find("span").removeAttr("style");
            evaluationResult = false;
        }
    }
    else if (input_type === "hidden") {
        selected_value = jq("#" + factor).find("input:hidden").val();
        if (selected_value !== '' && getValue(prime + '.value') === '') {
            getField(prime + '.error').html(message_to_throw).show;
            jq('#' + prime).find("span").removeAttr("style");
            evaluationResult = false;
        }
    }
    else if (input_type === "check_box") {
        selected_value = jq("#" + factor).find(":checkbox:first");
        if (selected_value.prop('checked') && getValue(prime + '.value') === '') {
            getField(prime + '.error').html(message_to_throw).show;
            jq('#' + prime).find("span").removeAttr("style");
            evaluationResult = false;
        }
    }
    else if (input_type === "text") {
        selected_value = selected_value = jq("#" + factor).find("input:text").val();
        if (selected_value !== "" && getValue(prime + '.value') === '') {
            getField(prime + '.error').html(message_to_throw).show;
            jq('#' + prime).find("span").removeAttr("style");
            evaluationResult = false;
        }
    }
    return evaluationResult;
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


function enableContainer(container) {
    jq(container).find("input").attr("disabled", false);
    jq(container).find('select').attr("disabled", false);
    jq(container).find("input").fadeTo(250, 1);
    jq(container).find("select").fadeTo(250, 1);
}

/*
 * Show the container, and enable all elements in it
 *
 * @param the Id of the container
 */
function disableContainer(container) {
    jq(container).find("input").attr("disabled", true);
    jq(container).find('select').attr("disabled", true);
    jq(container).find("input").fadeTo(250, 0.25);
    jq(container).find("select").fadeTo(250, 0.25);
}


/*
 *This is a helper object that contains functions to perform basic functions on a form field
 *
 *@param: selector string or JQuery object
 */
var fieldHelper = {
    $jqObj: function () {
        return {};
    },
    disable: function (args) {
        if (args instanceof jQuery) {
            this.$jqObj = args;
        } else if (typeof args === 'string') {
            this.$jqObj = jq(args);
        }

        this.$jqObj.attr('disabled', true).fadeTo(250, 0.25);

    },
    enable: function (args) {
        if (args instanceof jQuery) {
            this.$jqObj = args;
        } else if (typeof args === 'string') {
            this.$jqObj = jq(args);
        }

        this.$jqObj.removeAttr('disabled').fadeTo(250, 1);
    },
    makeReadonly: function (args) {
        if (args instanceof jQuery) {
            this.$jqObj = args;
        } else if (typeof args === 'string') {
            this.$jqObj = jq(args);
        }

        this.$jqObj.attr('readonly', true).fadeTo(250, 0.25);
    },
    removeReadonly: function (args) {
        if (args instanceof jQuery) {
            this.$jqObj = args;
        } else if (typeof args === 'string') {
            this.$jqObj = jq(args);
        }

        this.$jqObj.removeAttr('readonly').fadeTo(250, 1)
    },
    clear: function (args) {
        if (args instanceof jQuery) {
        	this.$jqObj = args;
        } else if (typeof args === 'string') {
        	this.$jqObj = jq(args);
        }
        if (this.$jqObj.is('input[type=text], select')) {
        	this.$jqObj.val('');
        } else if (this.$jqObj.is('input[type="radio"], input[type="checkbox"]')) {
        	this.$jqObj.removeAttr('checked');
        }

    },
    clearAllFields: function (args) {
        if (args instanceof jQuery) {
        	this.$jqObj = args;
        } else if (typeof args === 'string') {
        	this.$jqObj = jq(args);
        }

        this.$jqObj.find('input[type="text"], select').val('').change();

        this.$jqObj.find('input[type="radio"], input[type="checkbox"]').removeAttr('checked');
    },
    customizeDateTimePickerWidget: function(args) {
        //Remove the colon(:) in the date time picker
        if (args instanceof jQuery) {
	        this.$jqObj = args;
        } else if (typeof args === 'string') {
	        this.$jqObj = jq(args);
        }

        this.$jqObj.contents().filter(function() {
	      return this.nodeType === 3;
	    }).remove();


	    // Insert label for time just before the timepicker field
	    var $timeLabel = jq('<label/>').html('Time');
	    $('.hfe-hours').before($timeLabel);
    }
};

function blockEncounterOnSameDateEncounter(encounterDate, instruction) {

    if (!(instruction == 'block' || instruction == 'warn'))
        return;

    var date = jq(encounterDate).val();
    var formId = jq('[name=htmlFormId]').val();
    var patientId = jq('[name=personId]').val();

    if (jq('[name=encounterId]').val() == null) {
        jq.get(
            getContextPath() + '/module/aijar/lastEnteredForm.form',
            {formId: formId, patientId: patientId, date: date, dateFormat: 'yyyy-MM-dd'},
            function (responseText) {

                if (responseText == "true") {
                    if (instruction == "warn") {

                        // get the localized warning message and display it
                        jq.get(getContextPath() + "/module/htmlformentry/localizedMessage.form",
                            {messageCode: "htmlformentry.error.warnMultipleEncounterOnDate"},
                            function (responseText) {
                                jq().toastmessage('showWarningToast', responseText);
                            }
                        );

                    } else if (instruction == "block") {

                        // get the localized blocking message and display it
                        jq.get(getContextPath() + "/module/htmlformentry/localizedMessage.form",
                            {messageCode: "htmlformentry.error.blockMultipleEncounterOnDate"},
                            function (responseText) {
                                jq().toastmessage('showWarningToast', responseText);
                                var parameters = window.location.search.split("&", 2);
                                var url = window.location.origin + "/" + OPENMRS_CONTEXT_PATH + "/" + "coreapps/patientdashboard/patientDashboard.page" + parameters[0] + "&" + parameters[1] + "&";
                                setTimeout(function () {
                                    window.location.href = url;
                                }, 2000);

                            }
                        );

                        //clear the date and continue entering the form
                        jq(encounterDate).val('');
                    }
                } else {
                    //make sure everything is enabled
                }
            }
        );
    }
}

