/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("lineheight",function(e){var t=this,a="lineheight",i=t.lang(a+".");t.clickToolbar(a,function(){var n="",l=t.cmd.commonNode({"*":".line-height"});l&&(n=l.css("line-height"));var o=t.createMenu({name:a,width:150});e.each(i.lineHeight,function(a,i){e.each(i,function(e,a){o.addItem({title:a,checked:n===e,click:function(){t.cmd.toggle('<span style="line-height:'+e+';"></span>',{span:".line-height="+e}),t.updateState(),t.addBookmark(),t.hideMenu()}})})})})});