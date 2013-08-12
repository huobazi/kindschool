/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("code",function(e){var t=this,i="code";t.clickToolbar(i,function(){var a=t.lang(i+"."),n=['<div style="padding:10px 20px;">','<div class="ke-dialog-row">','<select class="ke-code-type">','<option value="js">JavaScript</option>','<option value="html">HTML</option>','<option value="css">CSS</option>','<option value="php">PHP</option>','<option value="pl">Perl</option>','<option value="py">Python</option>','<option value="rb">Ruby</option>','<option value="java">Java</option>','<option value="vb">ASP/VB</option>','<option value="cpp">C/C++</option>','<option value="cs">C#</option>','<option value="xml">XML</option>','<option value="bsh">Shell</option>','<option value="">Other</option>',"</select>","</div>",'<textarea class="ke-textarea" style="width:408px;height:260px;"></textarea>',"</div>"].join(""),o=t.createDialog({name:i,width:450,title:t.lang(i),body:n,yesBtn:{name:t.lang("yes"),click:function(){var i=e(".ke-code-type",o.div).val(),n=l.val(),c=""===i?"":" lang-"+i,r='<pre class="prettyprint'+c+'">\n'+e.escape(n)+"</pre> ";return""===e.trim(n)?(alert(a.pleaseInput),l[0].focus(),void 0):(t.insertHtml(r).hideDialog().focus(),void 0)}}}),l=e("textarea",o.div);l[0].focus()})});