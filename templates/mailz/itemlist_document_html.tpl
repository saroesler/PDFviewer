{* Purpose of this template: Display documents in html mailings *}
{*
<ul>
{foreach item='document' from=$items}
    <li>
        <a href="{modurl modname='Pdfviewer' type='user' func='view' fqurl=true}
        ">{$document.title}
        </a>
    </li>
{foreachelse}
    <li>{gt text='No documents found.'}</li>
{/foreach}
</ul>
*}

{include file='contenttype/itemlist_document_display_description.tpl'}
