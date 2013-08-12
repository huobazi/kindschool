/*
  Client Side Validations - SimpleForm - v2.1.0
  https://github.com/dockyard/client_side_validations-simple_form

  Copyright (c) 2013 DockYard, LLC
  Licensed under the MIT license
  http://www.opensource.org/licenses/mit-license.php
*/
!function(){ClientSideValidations.formBuilders["SimpleForm::FormBuilder"]={add:function(e,t,i){return this.wrappers[t.wrapper].add.call(this,e,t,i)},remove:function(e,t){return this.wrappers[t.wrapper].remove.call(this,e,t)},wrappers:{"default":{add:function(e,t,i){var n,s;return n=e.parent().find(""+t.error_tag+"."+t.error_class),s=e.closest(t.wrapper_tag),null==n[0]&&(n=$("<"+t.error_tag+"/>",{"class":t.error_class,text:i}),s.append(n)),s.addClass(t.wrapper_error_class),n.text(i)},remove:function(e,t){var i,n;return n=e.closest(""+t.wrapper_tag+"."+t.wrapper_error_class),n.removeClass(t.wrapper_error_class),i=n.find(""+t.error_tag+"."+t.error_class),i.remove()}},bootstrap:{add:function(e,t,i){var n,s,o;return n=e.parent().find(""+t.error_tag+"."+t.error_class),null==n[0]&&(o=e.closest(t.wrapper_tag),n=$("<"+t.error_tag+"/>",{"class":t.error_class,text:i}),o.append(n)),s=e.closest("."+t.wrapper_class),s.addClass(t.wrapper_error_class),n.text(i)},remove:function(e,t){var i,n,s;return n=e.closest("."+t.wrapper_class+"."+t.wrapper_error_class),s=e.closest(t.wrapper_tag),n.removeClass(t.wrapper_error_class),i=s.find(""+t.error_tag+"."+t.error_class),i.remove()}}}}}.call(this);