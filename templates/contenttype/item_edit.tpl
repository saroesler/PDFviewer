{* Purpose of this template: edit view of specific item detail view content type *}

<div style="margin-left: 80px">
    <div class="z-formrow">
        {formlabel for='Pdfviewer_objecttype' __text='Object type'}
        {pdfviewerObjectTypeSelector assign='allObjectTypes'}
        {formdropdownlist id='Pdfviewer_objecttype' dataField='objectType' group='data' mandatory=true items=$allObjectTypes}
        <div class="z-sub z-formnote">{gt text='If you change this please save the element once to reload the parameters below.'}</div>
    </div>
    <div{* class="z-formrow"*}>
        {pdfviewerItemSelector id='id' group='data' objectType=$objectType}
        
    </div>

    <div{* class="z-formrow"*}>
        {formradiobutton id='linkButton' value='link' dataField='displayMode' group='data' mandatory=1}
        {formlabel for='linkButton' __text='Link to object'}
        {formradiobutton id='embedButton' value='embed' dataField='displayMode' group='data' mandatory=1}
        {formlabel for='embedButton' __text='Embed object display'}
    </div>
</div>
