{* Purpose of this template: Display search options *}
<input type="hidden" id="active_pdfviewer" name="active[Pdfviewer]" value="1" checked="checked" />
<div>
    <input type="checkbox" id="active_pdfviewer_documents" name="search_pdfviewer_types['document']" value="1"{if $active_document} checked="checked"{/if} />
    <label for="active_pdfviewer_documents">{gt text='Documents' domain='module_pdfviewer'}</label>
</div>
