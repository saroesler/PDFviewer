{* Purpose of this template: Display documents in text mailings *}
{foreach item='document' from=$items}
{$document.title}
{modurl modname='Pdfviewer' type='user' func='display' ot=$objectType id=$document.id fqurl=true}
-----
{foreachelse}
{gt text='No documents found.'}
{/foreach}
