/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("wordpaste",function(e){var t=this,i="wordpaste";t.clickToolbar(i,function(){var n=t.lang(i+"."),a='<div style="padding:10px 20px;"><div style="margin-bottom:10px;">'+n.comment+"</div>"+'<iframe class="ke-textarea" frameborder="0" style="width:408px;height:260px;"></iframe>'+"</div>",l=t.createDialog({name:i,width:450,title:t.lang(i),body:a,yesBtn:{name:t.lang("yes"),click:function(){var i=r.body.innerHTML;i=e.clearMsWord(i,t.filterMode?t.htmlTags:e.options.htmlTags),t.insertHtml(i).hideDialog().focus()}}}),o=l.div,s=e("iframe",o),r=e.iframeDoc(s);e.IE||(r.designMode="on"),r.open(),r.write("<!doctype html><html><head><title>WordPaste</title></head>"),r.write('<body style="background-color:#FFF;font-size:12px;margin:2px;">'),e.IE||r.write("<br />"),r.write("</body></html>"),r.close(),e.IE&&(r.body.contentEditable="true"),s[0].contentWindow.focus()})});