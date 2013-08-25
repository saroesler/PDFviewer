{* purpose of this template: documents display view in admin area *}
{include file='admin/header.tpl'}
<div class="pdfviewer-document pdfviewer-display">
{gt text='Document' assign='templateTitle'}
{assign var='templateTitle' value=$document.title|default:$templateTitle}
{pagesetvar name='title' value=$templateTitle|@html_entity_decode}
<div class="z-admin-content-pagetitle">
    {icon type='display' size='small' __alt='Details'}
    <h3>{$templateTitle|notifyfilters:'pdfviewer.filter_hooks.documents.filter'} ({$document.workflowState|pdfviewerObjectState:false|lower}){icon id='itemactionstrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h3>
</div>


<dl>
    <dt>{gt text='Datei'}</dt>
    <dd>  <a href="{$document.dateiFullPathURL}" title="{$document.title|replace:"\"":""}"{if $document.dateiMeta.isImage} rel="imageviewer[document]"{/if}>
      {if $document.dateiMeta.isImage}
          {thumb image=$document.dateiFullPath objectid="document-`$document.id`" manager=$documentThumbManagerDatei tag=true img_alt=$document.title}
      {else}
          {gt text='Download'} ({$document.dateiMeta.size|pdfviewerGetFileSize:$document.dateiFullPath:false:false})
      {/if}
      </a>
    </dd>
    <dt>{gt text='Begindate'}</dt>
    <dd>{$document.begindate|dateformat:'datebrief'}</dd>
    <dt>{gt text='Enddate'}</dt>
    <dd>{$document.enddate|dateformat:'datebrief'}</dd>
    
</dl>
{include file='admin/include_standardfields_display.tpl' obj=$document}

{if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
    {* include display hooks *}
    {notifydisplayhooks eventname='pdfviewer.ui_hooks.documents.display_view' id=$document.id urlobject=$currentUrlObject assign='hooks'}
    {foreach key='providerArea' item='hook' from=$hooks}
        {$hook}
    {/foreach}
    {if count($document._actions) gt 0}
        <p id="itemactions">
        {foreach item='option' from=$document._actions}
            <a href="{$option.url.type|pdfviewerActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
        {/foreach}
        </p>
        <script type="text/javascript">
        /* <![CDATA[ */
            document.observe('dom:loaded', function() {
                pdfviInitItemActions('document', 'display', 'itemactions');
            });
        /* ]]> */
        </script>
    {/if}
{/if}

</div>
{include file='admin/footer.tpl'}

