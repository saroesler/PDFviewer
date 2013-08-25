{* Purpose of this template: Display one certain document within an external context *}
<div id="document{$document.id}" class="pdfviexternaldocument">
{if $displayMode eq 'link'}
    <p class="pdfviexternallink">
    <a href="{modurl modname='Pdfviewer' type='user' func='display' ot='document' id=$document.id}" title="{$document.title|replace:"\"":""}">
    {$document.title|notifyfilters:'pdfviewer.filter_hooks.documents.filter'}
    </a>
    </p>
{/if}
{checkpermissionblock component='Pdfviewer::' instance='::' level='ACCESS_EDIT'}
    {if $displayMode eq 'embed'}
        <p class="pdfviexternaltitle">
            <strong>{$document.title|notifyfilters:'pdfviewer.filter_hooks.documents.filter'}</strong>
        </p>
    {/if}
{/checkpermissionblock}

{if $displayMode eq 'link'}
{elseif $displayMode eq 'embed'}
    <div class="pdfviexternalsnippet">
        &nbsp;
    </div>

    {* you can distinguish the context like this: *}
    {*if $source eq 'contentType'}
        ...
    {elseif $source eq 'scribite'}
        ...
    {/if*}

    {* you can enable more details about the item: *}
    {*
        <p class="pdfviexternaldesc">
            {if $document.title ne ''}{$document.title}<br />{/if}
        </p>
    *}
{/if}
</div>
