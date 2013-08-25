{* purpose of this template: build the Form to edit an instance of document *}
{include file='admin/header.tpl'}
{pageaddvar name='javascript' value='modules/Pdfviewer/javascript/Pdfviewer_editFunctions.js'}
{pageaddvar name='javascript' value='modules/Pdfviewer/javascript/Pdfviewer_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit document' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{elseif $mode eq 'create'}
    {gt text='Create document' assign='templateTitle'}
    {assign var='adminPageIcon' value='new'}
{else}
    {gt text='Edit document' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{/if}
<div class="pdfviewer-document pdfviewer-edit">
    {pagesetvar name='title' value=$templateTitle}
    <div class="z-admin-content-pagetitle">
        {icon type=$adminPageIcon size='small' alt=$templateTitle}
        <h3>{$templateTitle}</h3>
    </div>
{form enctype='multipart/form-data' cssClass='z-form'}
    {* add validation summary and a <div> element for styling the form *}
    {pdfviewerFormFrame}

    {formsetinitialfocus inputId='title'}


    <fieldset>
        <legend>{gt text='Document'}</legend>
        
        <div class="z-formrow">
            {formlabel for='title' __text='Title' mandatorysym='1'}
            {formtextinput group='document' id='title' mandatory=true readOnly=false __title='Enter the title of the document' textMode='singleline' maxLength=255 cssClass='required' }
            {pdfviewerValidationError id='title' class='required'}
        </div>
        
        <div class="z-formrow">
            {assign var='mandatorySym' value='1'}
            {if $mode ne 'create'}
                {assign var='mandatorySym' value='0'}
            {/if}
            {formlabel for='datei' __text='Datei' mandatorysym=$mandatorySym}<br />{* break required for Google Chrome *}
            {if $mode eq 'create'}
                {formuploadinput group='document' id='datei' mandatory=true readOnly=false cssClass='required validate-upload' }
            {else}
                {formuploadinput group='document' id='datei' mandatory=false readOnly=false cssClass=' validate-upload' }
                <p class="z-formnote"><a id="resetDateiVal" href="javascript:void(0);" class="z-hide">{gt text='Reset to empty value'}</a></p>
            {/if}
            
                <div class="z-formnote">{gt text='Allowed file extensions:'} <span id="fileextensionsdatei">gif, jpeg, jpg, png, pdf</span></div>
            {if $mode ne 'create'}
                {if $document.datei ne ''}
                    <div class="z-formnote">
                        {gt text='Current file'}:
                        <a href="{$document.dateiFullPathUrl}" title="{$document.title|replace:"\"":""}"{if $document.dateiMeta.isImage} rel="imageviewer[document]"{/if}>
                        {if $document.dateiMeta.isImage}
                            {thumb image=$document.dateiFullPath objectid="document-`$document.id`" manager=$documentThumbManagerDatei tag=true img_alt=$document.title}
                        {else}
                            {gt text='Download'} ({$document.dateiMeta.size|pdfviewerGetFileSize:$document.dateiFullPath:false:false})
                        {/if}
                        </a>
                    </div>
                {/if}
            {/if}
            {pdfviewerValidationError id='datei' class='required'}
            {pdfviewerValidationError id='datei' class='validate-upload'}
        </div>
        {*
        <div class="z-formrow">
            {formlabel for='begindate' __text='Begindate' mandatorysym='1'}
            {if $mode ne 'create'}
                {formdateinput group='document' id='begindate' mandatory=true __title='Enter the begindate of the document' useSelectionMode=true cssClass='required' }
            {else}
                {formdateinput group='document' id='begindate' mandatory=true __title='Enter the begindate of the document' useSelectionMode=true defaultValue='today' cssClass='required' }
            {/if}
            {pdfviewerValidationError id='begindate' class='required'}
        </div>
        
        <div class="z-formrow">
            {formlabel for='enddate' __text='Enddate' mandatorysym='1'}
            {if $mode ne 'create'}
                {formdateinput group='document' id='enddate' mandatory=true __title='Enter the enddate of the document' useSelectionMode=true cssClass='required' }
            {else}
                {formdateinput group='document' id='enddate' mandatory=true __title='Enter the enddate of the document' useSelectionMode=true defaultValue='today' cssClass='required' }
            {/if}
            {pdfviewerValidationError id='enddate' class='required'}
        </div>
        *}
    </fieldset>
    
    {if $mode ne 'create'}
        {include file='admin/include_standardfields_edit.tpl' obj=$document}
    {/if}
    {* include display hooks *}
    {assign var='hookid' value=null}
    {if $mode ne 'create'}
        {assign var='hookid' value=$document.id}
    {/if}
    {notifydisplayhooks eventname='pdfviewer.ui_hooks.documents.form_edit' id=$hookId assign='hooks'}
    {if is_array($hooks) && count($hooks)}
        {foreach key='providerArea' item='hook' from=$hooks}
            <fieldset>
                {$hook}
            </fieldset>
        {/foreach}
    {/if}

    {* include possible submit actions *}
    <div class="z-buttons z-formbuttons">
    {assign var="counter" value=1}
    {foreach item='action' from=$actions}
    	{if $action.id != 'defer'} 
			{if $counter>0}
				{assign var='actionIdCapital' value=$action.id|@ucwords}
				{gt text=$action.title assign='actionTitle'}
				{*gt text=$action.description assign='actionDescription'*}{* TODO: formbutton could support title attributes *}
				{if $action.id eq 'delete'}
				    {gt text='Really delete this document?' assign='deleteConfirmMsg'}
				    {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass confirmMessage=$deleteConfirmMsg}
				{else}
					{if $action.id=='update'}
						{formbutton id="btn`$actionIdCapital`" commandName=$action.id text=Save class=$action.buttonClass}
					{else}
				    	{formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass}
				    {/if}
				{/if}
			{/if}
		{/if}
        {assign var="counter" value=$counter+1}
    {/foreach}
        {formbutton id='btnCancel' commandName='cancel' __text='Cancel' class='z-bt-cancel'}
    </div>
    {/pdfviewerFormFrame}
{/form}

</div>
{include file='admin/footer.tpl'}

{icon type='edit' size='extrasmall' assign='editImageArray'}
{icon type='delete' size='extrasmall' assign='deleteImageArray'}


<script type="text/javascript">
/* <![CDATA[ */

    var formButtons, formValidator;

    function handleFormButton (event) {
        var result = formValidator.validate();
        if (!result) {
            // validation error, abort form submit
            Event.stop(event);
        } else {
            // hide form buttons to prevent double submits by accident
            formButtons.each(function (btn) {
                btn.addClassName('z-hide');
            });
        }

        return result;
    }

    document.observe('dom:loaded', function() {

        pdfviAddCommonValidationRules('document', '{{if $mode ne 'create'}}{{$document.id}}{{/if}}');
        {{* observe validation on button events instead of form submit to exclude the cancel command *}}
        formValidator = new Validation('{{$__formid}}', {onSubmit: false, immediate: true, focusOnError: false});
        {{if $mode ne 'create'}}
            var result = formValidator.validate();
        {{/if}}

        formButtons = $('{{$__formid}}').select('div.z-formbuttons input');

        formButtons.each(function (elem) {
            if (elem.id != 'btnCancel') {
                elem.observe('click', handleFormButton);
            }
        });

        Zikula.UI.Tooltips($$('.pdfviewerFormTooltips'));
        pdfviInitUploadField('datei');
    });

/* ]]> */
</script>
