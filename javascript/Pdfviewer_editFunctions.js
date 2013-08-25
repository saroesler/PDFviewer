'use strict';


/**
 * Resets the value of an upload / file input field.
 */
function pdfviResetUploadField(fieldName) {
    if ($(fieldName) != undefined) {
        $(fieldName).setAttribute('type', 'input');
        $(fieldName).setAttribute('type', 'file');
    }
}

/**
 * Initialises the reset button for a certain upload input.
 */
function pdfviInitUploadField(fieldName) {
    if ($('reset' + fieldName.capitalize() + 'Val') != undefined) {
        $('reset' + fieldName.capitalize() + 'Val').observe('click', function (evt) {
            evt.preventDefault();
            pdfviResetUploadField(fieldName);
        }).removeClassName('z-hide');
    }
}

/**
 * Resets the value of a date or datetime input field.
 */
function pdfviResetDateField(fieldName) {
    if ($(fieldName) != undefined) {
        $(fieldName).value = '';
    }
    if ($(fieldName + 'cal') != undefined) {
        $(fieldName + 'cal').update(Zikula.__('No date set.', 'module_Pdfviewer'));
    }
}

/**
 * Initialises the reset button for a certain date input.
 */
function pdfviInitDateField(fieldName) {
    if ($('reset' + fieldName.capitalize() + 'Val') != undefined) {
        $('reset' + fieldName.capitalize() + 'Val').observe('click', function (evt) {
            evt.preventDefault();
            pdfviResetDateField(fieldName);
        }).removeClassName('z-hide');
    }
}

