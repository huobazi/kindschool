/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("anchor",function(e){var n=this,a="anchor",i=n.lang(a+".");n.plugin.anchor={edit:function(){var t=['<div style="padding:20px;">','<div class="ke-dialog-row">','<label for="keName">'+i.name+"</label>",'<input class="ke-input-text" type="text" id="keName" name="name" value="" style="width:100px;" />',"</div>","</div>"].join(""),l=n.createDialog({name:a,width:300,title:n.lang(a),body:t,yesBtn:{name:n.lang("yes"),click:function(){n.insertHtml('<a name="'+o.val()+'">').hideDialog().focus()}}}),c=l.div,o=e('input[name="name"]',c),d=n.plugin.getSelectedAnchor();d&&o.val(unescape(d.attr("data-ke-name"))),o[0].focus(),o[0].select()},"delete":function(){n.plugin.getSelectedAnchor().remove()}},n.clickToolbar(a,n.plugin.anchor.edit)});