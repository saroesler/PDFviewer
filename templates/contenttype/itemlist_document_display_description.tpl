{* Purpose of this template: Display documents within an external context *}
<dl>
    {foreach item='document' from=$items}
        <dt>{$document.title}</dt>
        <dd><a href="{modurl modname='Pdfviewer' type='user' func='display' ot=$objectType id=$item.id}">{gt text='Read more'}</a>
        </dd>
    {foreachelse}
        <dt>{gt text='No entries found.'}</dt>
    {/foreach}
</dl>
