{* Purpose of this template: Display item information for previewing from other modules *}
<dl id="document{$document.id}">
<dt>{$document.title|notifyfilters:'pdfviewer.filter_hooks.documents.filter'|htmlentities}</dt>
{if $document.title ne ''}<dd>{$document.title}</dd>{/if}
</dl>
