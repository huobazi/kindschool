/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("plainpaste",function(e){var t=this,i="plainpaste";t.clickToolbar(i,function(){var n=t.lang(i+"."),a='<div style="padding:10px 20px;"><div style="margin-bottom:10px;">'+n.comment+"</div>"+'<textarea class="ke-textarea" style="width:408px;height:260px;"></textarea>'+"</div>",l=t.createDialog({name:i,width:450,title:t.lang(i),body:a,yesBtn:{name:t.lang("yes"),click:function(){var i=o.val();i=e.escape(i),i=i.replace(/ {2}/g," &nbsp;"),i="p"==t.newlineTag?i.replace(/^/,"<p>").replace(/$/,"</p>").replace(/\n/g,"</p><p>"):i.replace(/\n/g,"<br />$&"),t.insertHtml(i).hideDialog().focus()}}}),o=e("textarea",l.div);o[0].focus()})});