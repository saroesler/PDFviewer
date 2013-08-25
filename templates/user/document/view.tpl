{* purpose of this template: documents view view in user area *}
<script type='text/javascript'>
function Redirect(url)
{
Fenster = window.open(url, '_blank');
  Fenster.focus();
}
</script>
{include file='user/header.tpl'}
<div class="pdfviewer-document pdfviewer-view" style="margin:100px; margin-left:200px;">

{*Output latest Dokument*}
{if isset($items[0])}
	<a href="{$items[0].dateiFullPathURL}" target="_blank" style="text-decoration:none;"><p style="font-size:24px;">{$items[0].title}</p></a>
{else}
	{gt text="No Dokument found!"}
{/if}



{assign var='own' value=0}
{if isset($showOwnEntries) && $showOwnEntries eq 1}
    {assign var='own' value=1}
{/if}
{assign var='all' value=0}
<br/>
{assign var="table_counter" value=0} 
<ul style="list-style-type: none;">
{foreach item='document' from=$items}
	{if $table_counter>0}
	<li>
		<p style="font-size:20px;">
            

              <a href="{$document.dateiFullPathURL}"  style="text-decoration:none;" target="_blank" title="{$document.title|replace:"\"":""}"{if $document.dateiMeta.isImage} rel="imageviewer[document]"
    {/if}>
				{$document.title|notifyfilters:'pdfviewer.filterhook.documents'}
                 ({$document.dateiMeta.size|pdfviewerGetFileSize:$document.dateiFullPath:false:false})
              </a>
     	</p>
     </li>
        
    {/if}
    {assign var="table_counter" value=$table_counter+1} 
{foreachelse}
    {gt text='No documents found.'}
{/foreach}
</ul>

{if !isset($showAllEntries) || $showAllEntries ne 1}
    {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page'}
{/if}


{notifydisplayhooks eventname='pdfviewer.ui_hooks.documents.display_view' urlobject=$currentUrlObject assign='hooks'}
{foreach key='providerArea' item='hook' from=$hooks}
    {$hook}
{/foreach}
</div>
{include file='user/footer.tpl'}

