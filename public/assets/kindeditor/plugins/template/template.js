/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("template",function(e){function t(t){return a+t+"?ver="+encodeURIComponent(e.DEBUG?e.TIME:e.VERSION)}var i=this,n="template",a=(i.lang(n+"."),i.pluginsPath+n+"/html/");i.clickToolbar(n,function(){var a=i.lang(n+"."),l=['<div style="padding:10px 20px;">','<div class="ke-header">','<div class="ke-left">',a.selectTemplate+" <select>"];e.each(a.fileList,function(e,t){l.push('<option value="'+e+'">'+t+"</option>")}),html=[l.join(""),"</select></div>",'<div class="ke-right">','<input type="checkbox" id="keReplaceFlag" name="replaceFlag" value="1" /> <label for="keReplaceFlag">'+a.replaceContent+"</label>","</div>",'<div class="ke-clearfix"></div>',"</div>",'<iframe class="ke-textarea" frameborder="0" style="width:458px;height:260px;background-color:#FFF;"></iframe>',"</div>"].join("");var o=i.createDialog({name:n,width:500,title:i.lang(n),body:html,yesBtn:{name:i.lang("yes"),click:function(){var t=e.iframeDoc(d);i[r[0].checked?"html":"insertHtml"](t.body.innerHTML).hideDialog().focus()}}}),s=e("select",o.div),r=e('[name="replaceFlag"]',o.div),d=e("iframe",o.div);r[0].checked=!0,d.attr("src",t(s.val())),s.change(function(){d.attr("src",t(this.value))})})});