<script type='text/javascript'>
function Redirect(url)
{
Fenster = window.open(url, '_blank');
  Fenster.focus();
  history.back();
}
</script>

<body onload="Redirect('{$url}')">
<p>{gt text="You are downloading following URL: "}{$url}</p>
<p>{gt text="If your are not downloading the file please klick"} <a href="{$url}">{gt text="here"}</a></p>
</body>
