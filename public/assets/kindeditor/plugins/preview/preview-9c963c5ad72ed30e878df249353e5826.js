/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("preview",function(e){var t=this,i="preview";t.clickToolbar(i,function(){var n=(t.lang(i+"."),'<div style="padding:10px 20px;"><iframe class="ke-textarea" frameborder="0" style="width:708px;height:400px;"></iframe></div>'),a=t.createDialog({name:i,width:750,title:t.lang(i),body:n}),l=e("iframe",a.div),o=e.iframeDoc(l);o.open(),o.write(t.fullHtml()),o.close(),e(o.body).css("background-color","#FFF"),l[0].contentWindow.focus()})});