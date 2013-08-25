{* Purpose of this template: edit view of generic item list content type *}

<div class="z-formrow">
    {gt text='Object type' domain='module_pdfviewer' assign='objectTypeSelectorLabel'}
    {formlabel for='Pdfviewer_objecttype' text=$objectTypeSelectorLabel}
    {pdfviewerObjectTypeSelector assign='allObjectTypes'}
    {formdropdownlist id='Pdfviewer_objecttype' dataField='objectType' group='data' mandatory=true items=$allObjectTypes}
    <div class="z-sub z-formnote">{gt text='If you change this please save the element once to reload the parameters below.' domain='module_pdfviewer'}</div>
</div>

{formvolatile}
{if $properties ne null && is_array($properties)}
    {nocache}
    {foreach key='registryId' item='registryCid' from=$registries}
        {assign var='propName' value=''}
        {foreach key='propertyName' item='propertyId' from=$properties}
            {if $propertyId eq $registryId}
                {assign var='propName' value=$propertyName}
            {/if}
        {/foreach}
        <div class="z-formrow">
            {modapifunc modname='Pdfviewer' type='category' func='hasMultipleSelection' ot=$objectType registry=$propertyName assign='hasMultiSelection'}
            {gt text='Category' domain='module_pdfviewer' assign='categorySelectorLabel'}
            {assign var='selectionMode' value='single'}
            {if $hasMultiSelection eq true}
                {gt text='Categories' domain='module_pdfviewer' assign='categorySelectorLabel'}
                {assign var='selectionMode' value='multiple'}
            {/if}
            {formlabel for="Pdfviewer_catids`$propertyName`" text=$categorySelectorLabel}
            {formdropdownlist id="Pdfviewer_catids`$propName`" items=$categories.$propName dataField="catids`$propName`" group='data' selectionMode=$selectionMode}
            <div class="z-sub z-formnote">{gt text='This is an optional filter.' domain='module_pdfviewer'}</div>
        </div>
    {/foreach}
    {/nocache}
{/if}
{/formvolatile}

<div class="z-formrow">
    {gt text='Sorting' domain='module_pdfviewer' assign='sortingLabel'}
    {formlabel text=$sortingLabel}
    <div>
        {formradiobutton id='Pdfviewer_srandom' value='random' dataField='sorting' group='data' mandatory=true}
        {gt text='Random' domain='module_pdfviewer' assign='sortingRandomLabel'}
        {formlabel for='Pdfviewer_srandom' text=$sortingRandomLabel}
        {formradiobutton id='Pdfviewer_snewest' value='newest' dataField='sorting' group='data' mandatory=true}
        {gt text='Newest' domain='module_pdfviewer' assign='sortingNewestLabel'}
        {formlabel for='Pdfviewer_snewest' text=$sortingNewestLabel}
        {formradiobutton id='Pdfviewer_sdefault' value='default' dataField='sorting' group='data' mandatory=true}
        {gt text='Default' domain='module_pdfviewer' assign='sortingDefaultLabel'}
        {formlabel for='Pdfviewer_sdefault' text=$sortingDefaultLabel}
    </div>
</div>

<div class="z-formrow">
    {gt text='Amount' domain='module_pdfviewer' assign='amountLabel'}
    {formlabel for='Pdfviewer_amount' text=$amountLabel}
    {formintinput id='Pdfviewer_amount' dataField='amount' group='data' mandatory=true maxLength=2}
</div>

<div class="z-formrow">
    {gt text='Template' domain='module_pdfviewer' assign='templateLabel'}
    {formlabel for='Pdfviewer_template' text=$templateLabel}
    {pdfviewerTemplateSelector assign='allTemplates'}
    {formdropdownlist id='Pdfviewer_template' dataField='template' group='data' mandatory=true items=$allTemplates}
</div>

<div id="customtemplatearea" class="z-formrow z-hide">
    {gt text='Custom template' domain='module_pdfviewer' assign='customTemplateLabel'}
    {formlabel for='Pdfviewer_customtemplate' text=$customTemplateLabel}
    {formtextinput id='Pdfviewer_customtemplate' dataField='customTemplate' group='data' mandatory=false maxLength=80}
    <div class="z-sub z-formnote">{gt text='Example' domain='module_pdfviewer'}: <em>itemlist_[objecttype]_display.tpl</em></div>
</div>

<div class="z-formrow z-hide">
    {gt text='Filter (expert option)' domain='module_pdfviewer' assign='filterLabel'}
    {formlabel for='Pdfviewer_filter' text=$filterLabel}
    {formtextinput id='Pdfviewer_filter' dataField='filter' group='data' mandatory=false maxLength=255}
    <div class="z-sub z-formnote">({gt text='Syntax examples' domain='module_pdfviewer'}: <kbd>name:like:foobar</kbd> {gt text='or' domain='module_pdfviewer'} <kbd>status:ne:3</kbd>)</div>
</div>

{pageaddvar name='javascript' value='prototype'}
<script type="text/javascript">
/* <![CDATA[ */
    function pdfviToggleCustomTemplate() {
        if ($F('Pdfviewer_template') == 'custom') {
            $('customtemplatearea').removeClassName('z-hide');
        } else {
            $('customtemplatearea').addClassName('z-hide');
        }
    }

    document.observe('dom:loaded', function() {
        pdfviToggleCustomTemplate();
        $('Pdfviewer_template').observe('change', function(e) {
            pdfviToggleCustomTemplate();
        });
    });
/* ]]> */
</script>
