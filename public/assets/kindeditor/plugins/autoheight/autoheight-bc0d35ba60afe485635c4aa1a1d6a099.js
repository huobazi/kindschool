/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("autoheight",function(e){var i=this;if(i.autoHeightMode){var t=i.edit,n=t.doc.body,a=e.removeUnit(i.height);t.iframe[0].scroll="no",n.style.overflowY="hidden",t.afterChange(function(){i.resize(null,Math.max((e.IE?n.scrollHeight:n.offsetHeight)+62,a))})}});