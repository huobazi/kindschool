/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("link",function(e){var t=this,i="link";t.plugin.link={edit:function(){var a=t.lang(i+"."),n='<div style="padding:20px;"><div class="ke-dialog-row"><label for="keUrl" style="width:60px;">'+a.url+"</label>"+'<input class="ke-input-text" type="text" id="keUrl" name="url" value="" style="width:260px;" /></div>'+'<div class="ke-dialog-row"">'+'<label for="keType" style="width:60px;">'+a.linkType+"</label>"+'<select id="keType" name="type"></select>'+"</div>"+"</div>",l=t.createDialog({name:i,width:450,title:t.lang(i),body:n,yesBtn:{name:t.lang("yes"),click:function(){var i=e.trim(r.val());return"http://"==i||e.invalidUrl(i)?(alert(t.lang("invalidUrl")),r[0].focus(),void 0):(t.exec("createlink",i,s.val()).hideDialog().focus(),void 0)}}}),o=l.div,r=e('input[name="url"]',o),s=e('select[name="type"]',o);r.val("http://"),s[0].options[0]=new Option(a.newWindow,"_blank"),s[0].options[1]=new Option(a.selfWindow,""),t.cmd.selection();var d=t.plugin.getSelectedLink();d&&(t.cmd.range.selectNode(d[0]),t.cmd.select(),r.val(d.attr("data-ke-src")),s.val(d.attr("target"))),r[0].focus(),r[0].select()},"delete":function(){t.exec("unlink",null)}},t.clickToolbar(i,t.plugin.link.edit)});