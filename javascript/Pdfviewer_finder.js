'use strict';

var currentPdfviewerEditor = null;
var currentPdfviewerInput = null;

/**
 * Returns the attributes used for the popup window. 
 * @return {String}
 */
function getPopupAttributes() {
    var pWidth, pHeight;

    pWidth = screen.width * 0.75;
    pHeight = screen.height * 0.66;
    return 'width=' + pWidth + ',height=' + pHeight + ',scrollbars,resizable';
}

/**
 * Open a popup window with the finder triggered by a Xinha button.
 */
function PdfviewerFinderXinha(editor, pdfviURL) {
    var popupAttributes;

    // Save editor for access in selector window
    currentPdfviewerEditor = editor;

    popupAttributes = getPopupAttributes();
    window.open(pdfviURL, '', popupAttributes);
}

/**
 * Open a popup window with the finder triggered by a CKEditor button.
 */
function PdfviewerFinderCKEditor(editor, pdfviURL) {
    // Save editor for access in selector window
    currentPdfviewerEditor = editor;

    editor.popup(
        Zikula.Config.baseURL + Zikula.Config.entrypoint + '?module=Pdfviewer&type=external&func=finder&editor=ckeditor',
        /*width*/ '80%', /*height*/ '70%',
        'location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes,scrollbars=yes'
    );
}



var pdfviewer = {};

pdfviewer.finder = {};

pdfviewer.finder.onLoad = function (baseId, selectedId) {
    $('Pdfviewer_sort').observe('change', pdfviewer.finder.onParamChanged);
    $('Pdfviewer_sortdir').observe('change', pdfviewer.finder.onParamChanged);
    $('Pdfviewer_pagesize').observe('change', pdfviewer.finder.onParamChanged);
    $('Pdfviewer_gosearch').observe('click', pdfviewer.finder.onParamChanged)
                           .observe('keypress', pdfviewer.finder.onParamChanged);
    $('Pdfviewer_submit').addClassName('z-hide');
    $('Pdfviewer_cancel').observe('click', pdfviewer.finder.handleCancel);
};

pdfviewer.finder.onParamChanged = function () {
    $('selectorForm').submit();
};

pdfviewer.finder.handleCancel = function () {
    var editor, w;

    editor = $F('editorName');
    if (editor === 'xinha') {
        w = parent.window;
        window.close();
        w.focus();
    } else if (editor === 'tinymce') {
        pdfviClosePopup();
    } else if (editor === 'ckeditor') {
        pdfviClosePopup();
    } else {
        alert('Close Editor: ' + editor);
    }
};


function getPasteSnippet(mode, itemId) {
    var itemUrl, itemTitle, itemDescription, pasteMode;

    itemUrl = $F('url' + itemId);
    itemTitle = $F('title' + itemId);
    itemDescription = $F('desc' + itemId);
    pasteMode = $F('Pdfviewer_pasteas');

    if (pasteMode === '2' || pasteMode !== '1') {
        return itemId;
    }

    // return link to item
    if (mode === 'url') {
        // plugin mode
        return itemUrl;
    } else {
        // editor mode
        return '<a href="' + itemUrl + '" title="' + itemDescription + '">' + itemTitle + '</a>';
    }
}


// User clicks on "select item" button
pdfviewer.finder.selectItem = function (itemId) {
    var editor, html;

    editor = $F('editorName');
    if (editor === 'xinha') {
        if (window.opener.currentPdfviewerEditor !== null) {
            html = getPasteSnippet('html', itemId);

            window.opener.currentPdfviewerEditor.focusEditor();
            window.opener.currentPdfviewerEditor.insertHTML(html);
        } else {
            html = getPasteSnippet('url', itemId);
            var currentInput = window.opener.currentPdfviewerInput;

            if (currentInput.tagName === 'INPUT') {
                // Simply overwrite value of input elements
                currentInput.value = html;
            } else if (currentInput.tagName === 'TEXTAREA') {
                // Try to paste into textarea - technique depends on environment
                if (typeof document.selection !== 'undefined') {
                    // IE: Move focus to textarea (which fortunately keeps its current selection) and overwrite selection
                    currentInput.focus();
                    window.opener.document.selection.createRange().text = html;
                } else if (typeof currentInput.selectionStart !== 'undefined') {
                    // Firefox: Get start and end points of selection and create new value based on old value
                    var startPos = currentInput.selectionStart;
                    var endPos = currentInput.selectionEnd;
                    currentInput.value = currentInput.value.substring(0, startPos)
                                        + html
                                        + currentInput.value.substring(endPos, currentInput.value.length);
                } else {
                    // Others: just append to the current value
                    currentInput.value += html;
                }
            }
        }
    } else if (editor === 'tinymce') {
        html = getPasteSnippet('html', itemId);
        window.opener.tinyMCE.activeEditor.execCommand('mceInsertContent', false, html);
        // other tinymce commands: mceImage, mceInsertLink, mceReplaceContent, see http://www.tinymce.com/wiki.php/Command_identifiers
    } else if (editor === 'ckeditor') {
        /** to be done*/
    } else {
        alert('Insert into Editor: ' + editor);
    }
    pdfviClosePopup();
};


function pdfviClosePopup() {
    window.opener.focus();
    window.close();
}




//=============================================================================
// Pdfviewer item selector for Forms
//=============================================================================

pdfviewer.itemSelector = {};
pdfviewer.itemSelector.items = {};
pdfviewer.itemSelector.baseId = 0;
pdfviewer.itemSelector.selectedId = 0;

pdfviewer.itemSelector.onLoad = function (baseId, selectedId) {
    pdfviewer.itemSelector.baseId = baseId;
    pdfviewer.itemSelector.selectedId = selectedId;

    // required as a changed object type requires a new instance of the item selector plugin
    $(baseId + '_objecttype').observe('change', pdfviewer.itemSelector.onParamChanged);

    if ($(baseId + '_catid') !== undefined) {
        $(baseId + '_catid').observe('change', pdfviewer.itemSelector.onParamChanged);
    }
    $(baseId + '_id').observe('change', pdfviewer.itemSelector.onItemChanged);
    $(baseId + '_sort').observe('change', pdfviewer.itemSelector.onParamChanged);
    $(baseId + '_sortdir').observe('change', pdfviewer.itemSelector.onParamChanged);
    $('Pdfviewer_gosearch').observe('click', pdfviewer.itemSelector.onParamChanged)
                           .observe('keypress', pdfviewer.itemSelector.onParamChanged);

    pdfviewer.itemSelector.getItemList();
};

pdfviewer.itemSelector.onParamChanged = function () {
    $('ajax_indicator').removeClassName('z-hide');

    pdfviewer.itemSelector.getItemList();
};

pdfviewer.itemSelector.getItemList = function () {
    var baseId, pars, request;

    baseId = pdfviewer.itemSelector.baseId;
    pars = 'objectType=' + baseId + '&';
    if ($(baseId + '_catid') !== undefined) {
        pars += 'catid=' + $F(baseId + '_catid') + '&';
    }
    pars += 'sort=' + $F(baseId + '_sort') + '&' +
            'sortdir=' + $F(baseId + '_sortdir') + '&' +
            'searchterm=' + $F(baseId + '_searchterm');

    request = new Zikula.Ajax.Request('ajax.php?module=Pdfviewer&func=getItemListFinder', {
        method: 'post',
        parameters: pars,
        onFailure: function(req) {
            Zikula.showajaxerror(req.getMessage());
        },
        onSuccess: function(req) {
            var baseId;
            baseId = pdfviewer.itemSelector.baseId;
            pdfviewer.itemSelector.items[baseId] = req.getData();
            $('ajax_indicator').addClassName('z-hide');
            pdfviewer.itemSelector.updateItemDropdownEntries();
            pdfviewer.itemSelector.updatePreview();
        }
    });
};

pdfviewer.itemSelector.updateItemDropdownEntries = function () {
    var baseId, itemSelector, items, i, item;

    baseId = pdfviewer.itemSelector.baseId;
    itemSelector = $(baseId + '_id');
    itemSelector.length = 0;

    items = pdfviewer.itemSelector.items[baseId];
    for (i = 0; i < items.length; ++i) {
        item = items[i];
        itemSelector.options[i] = new Option(item.title, item.id, false);
    }

    if (pdfviewer.itemSelector.selectedId > 0) {
        $(baseId + '_id').value = pdfviewer.itemSelector.selectedId;
    }
};

pdfviewer.itemSelector.updatePreview = function () {
    var baseId, items, selectedElement, i;

    baseId = pdfviewer.itemSelector.baseId;
    items = pdfviewer.itemSelector.items[baseId];

    $(baseId + '_previewcontainer').addClassName('z-hide');

    if (items.length === 0) {
        return;
    }

    selectedElement = items[0];
    if (pdfviewer.itemSelector.selectedId > 0) {
        for (var i = 0; i < items.length; ++i) {
            if (items[i].id === pdfviewer.itemSelector.selectedId) {
                selectedElement = items[i];
                break;
            }
        }
    }

    if (selectedElement !== null) {
        $(baseId + '_previewcontainer').update(window.atob(selectedElement.previewInfo))
                                       .removeClassName('z-hide');
    }
};

pdfviewer.itemSelector.onItemChanged = function () {
    var baseId, itemSelector, preview;

    baseId = pdfviewer.itemSelector.baseId;
    itemSelector = $(baseId + '_id');
    preview = window.atob(pdfviewer.itemSelector.items[baseId][itemSelector.selectedIndex].previewInfo);

    $(baseId + '_previewcontainer').update(preview);
    pdfviewer.itemSelector.selectedId = $F(baseId + '_id');
};
