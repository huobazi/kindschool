/* ===========================================================
 * bootstrap-popover.js v2.3.1
 * http://twitter.github.com/bootstrap/javascript.html#popovers
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */
!function(e){"use strict";var t=function(e,t){this.init("popover",e,t)};t.prototype=e.extend({},e.fn.tooltip.Constructor.prototype,{constructor:t,setContent:function(){var e=this.tip(),t=this.getTitle(),i=this.getContent();e.find(".popover-title")[this.options.html?"html":"text"](t),e.find(".popover-content")[this.options.html?"html":"text"](i),e.removeClass("fade top bottom left right in")},hasContent:function(){return this.getTitle()||this.getContent()},getContent:function(){var e,t=this.$element,i=this.options;return e=("function"==typeof i.content?i.content.call(t[0]):i.content)||t.attr("data-content")},tip:function(){return this.$tip||(this.$tip=e(this.options.template)),this.$tip},destroy:function(){this.hide().$element.off("."+this.type).removeData(this.type)}});var i=e.fn.popover;e.fn.popover=function(i){return this.each(function(){var n=e(this),a=n.data("popover"),o="object"==typeof i&&i;a||n.data("popover",a=new t(this,o)),"string"==typeof i&&a[i]()})},e.fn.popover.Constructor=t,e.fn.popover.defaults=e.extend({},e.fn.tooltip.defaults,{placement:"right",trigger:"click",content:"",template:'<div class="popover"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'}),e.fn.popover.noConflict=function(){return e.fn.popover=i,this}}(window.jQuery);