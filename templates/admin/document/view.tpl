{* purpose of this template: documents view view in admin area *}
{include file='admin/header.tpl'}
<div class="pdfviewer-document pdfviewer-view">
{gt text='Document list' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type='view' size='small' alt=$templateTitle}
    <h3>{$templateTitle}</h3>
</div>

{checkpermissionblock component='Pdfviewer:Document:' instance='::' level='ACCESS_EDIT'}
    {gt text='Create document' assign='createTitle'}
    <a href="{modurl modname='Pdfviewer' type='admin' func='edit' ot='document'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
{/checkpermissionblock}
{assign var='own' value=0}
{if isset($showOwnEntries) && $showOwnEntries eq 1}
    {assign var='own' value=1}
{/if}
{assign var='all' value=0}
{if isset($showAllEntries) && $showAllEntries eq 1}
    {gt text='Back to paginated view' assign='linkTitle'}
    <a href="{modurl modname='Pdfviewer' type='admin' func='view' ot='document'}" title="{$linkTitle}" class="z-icon-es-view">
        {$linkTitle}
    </a>
    {assign var='all' value=1}
{/if}

{*include file='admin/document/view_quickNav.tpl'*}{* see template file for available options *}

<form class="z-form" id="documents_view" action="{modurl modname='Pdfviewer' type='admin' func='handleselectedentries'}" method="post">
    <div>
        <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
        <input type="hidden" name="ot" value="document" />
        <table class="z-datatable" >
            <colgroup>
                <col id="cselect" />
                <col id="cworkflowstate" />
                <col id="ctitle" />
                <col id="cdatei" />
                <col id="citemactions" />
            </colgroup>
            <thead>
            <tr>
                <th id="hselect" scope="col" align="center" valign="middle">
                    <input type="checkbox" id="toggle_documents" />
                </th>
                <th id="htitle" scope="col" class="z-left">
                    {gt text="Title"}
                </th>
                <th id="hdatei" scope="col" class="z-left">
                    {gt text="Datei"}
                </th>
                <th id="hitemactions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
            </tr>
            </thead>
            <tbody>
        
        {foreach item='document' from=$items}
            <tr class="{cycle values='z-odd, z-even'}">
                <td headers="hselect" align="center" valign="top" style="text-align:center">
                    <input type="checkbox" name="items[]" value="{$document.id}" class="documents_checkbox" />
                </td>
                <td headers="htitle" class="z-left">
                    {$document.title|notifyfilters:'pdfviewer.filterhook.documents'}
                </td>
                <td headers="hdatei" class="z-left">
                      <a href="{$document.dateiFullPathURL}" title="{$document.title|replace:"\"":""}"{if $document.dateiMeta.isImage} rel="imageviewer[document]"{/if}>
                      {if $document.dateiMeta.isImage}
                          {thumb image=$document.dateiFullPath objectid="document-`$document.id`" manager=$documentThumbManagerDatei tag=true img_alt=$document.title}
                      {else}
                          {gt text='Download'} ({$document.dateiMeta.size|pdfviewerGetFileSize:$document.dateiFullPath:false:false})
                      {/if}
                      </a>
                </td>
                <td id="itemactions{$document.id}" headers="hitemactions" class="z-right z-nowrap z-w02">
                    {if count($document._actions) gt 0}
                        {foreach item='option' from=$document._actions}
                            <a href="{$option.url.type|pdfviewerActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                        {/foreach}
                        {icon id="itemactions`$document.id`trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                pdfviInitItemActions('document', 'view', 'itemactions{{$document.id}}');
                            });
                        /* ]]> */
                        </script>
                    {/if}
                </td>
            </tr>
        {foreachelse}
            <tr class="z-admintableempty">
              <td class="z-left" colspan="7">
            {gt text='No documents found.'}
              </td>
            </tr>
        {/foreach}
        
            </tbody>
        </table>
        
        {if !isset($showAllEntries) || $showAllEntries ne 1}
            {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page'}
        {/if}
        <fieldset>
            <label for="pdfviewer_action">{gt text='With selected documents'}</label>
            <select id="pdfviewer_action" name="action">
                <option value="">{gt text='Choose action'}</option>
                <option value="delete">{gt text='Delete'}</option>
            </select>
            <input type="submit" value="{gt text='Submit'}" />
        </fieldset>
    </div>
</form>

</div>
{include file='admin/footer.tpl'}

<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
    {{* init the "toggle all" functionality *}}
    if ($('toggle_documents') != undefined) {
        $('toggle_documents').observe('click', function (e) {
            Zikula.toggleInput('documents_view');
            e.stop()
        });
    }
    });
/* ]]> */
</script>
