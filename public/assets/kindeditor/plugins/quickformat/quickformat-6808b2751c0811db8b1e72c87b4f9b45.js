/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("quickformat",function(e){function t(e){for(var t=e.first();t&&t.first();)t=t.first();return t}var i=this,n="quickformat",a=e.toMap("blockquote,center,div,h1,h2,h3,h4,h5,h6,p");i.clickToolbar(n,function(){i.focus();for(var n,l=i.edit.doc,o=i.cmd.range,s=e(l.body).first(),r=[],u=[],d=o.createBookmark(!0);s;){n=s.next();var p=t(s);p&&"img"==p.name||(a[s.name]?(s.html(s.html().replace(/^(\s|&nbsp;|　)+/gi,"")),s.css("text-indent","2em")):u.push(s),(!n||a[n.name]||a[s.name]&&!a[n.name])&&(u.length>0&&r.push(u),u=[])),s=n}e.each(r,function(t,i){var n=e('<p style="text-indent:2em;"></p>',l);i[0].before(n),e.each(i,function(e,t){n.append(t)})}),o.moveToBookmark(d),i.addBookmark()})});