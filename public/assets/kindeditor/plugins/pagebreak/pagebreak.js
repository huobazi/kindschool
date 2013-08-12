/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("pagebreak",function(e){var t=this,i="pagebreak",n=e.undef(t.pagebreakHtml,'<hr style="page-break-after: always;" class="ke-pagebreak" />');t.clickToolbar(i,function(){var i=t.cmd,a=i.range;t.focus(),a.enlarge(!0),i.split(!0);var l="br"==t.newlineTag||e.WEBKIT?"":'<p id="__kindeditor_tail_tag__"></p>';if(t.insertHtml(n+l),""!==l){var o=e("#__kindeditor_tail_tag__",t.edit.doc);a.selectNodeContents(o[0]),o.removeAttr("id"),i.select()}})});