/* =============================================================
 * bootstrap-collapse.js v2.3.1
 * http://twitter.github.com/bootstrap/javascript.html#collapse
 * =============================================================
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
 * ============================================================ */
!function(e){"use strict";var t=function(t,i){this.$element=e(t),this.options=e.extend({},e.fn.collapse.defaults,i),this.options.parent&&(this.$parent=e(this.options.parent)),this.options.toggle&&this.toggle()};t.prototype={constructor:t,dimension:function(){var e=this.$element.hasClass("width");return e?"width":"height"},show:function(){var t,i,n,a;if(!this.transitioning&&!this.$element.hasClass("in")){if(t=this.dimension(),i=e.camelCase(["scroll",t].join("-")),n=this.$parent&&this.$parent.find("> .accordion-group > .in"),n&&n.length){if(a=n.data("collapse"),a&&a.transitioning)return;n.collapse("hide"),a||n.data("collapse",null)}this.$element[t](0),this.transition("addClass",e.Event("show"),"shown"),e.support.transition&&this.$element[t](this.$element[0][i])}},hide:function(){var t;!this.transitioning&&this.$element.hasClass("in")&&(t=this.dimension(),this.reset(this.$element[t]()),this.transition("removeClass",e.Event("hide"),"hidden"),this.$element[t](0))},reset:function(e){var t=this.dimension();return this.$element.removeClass("collapse")[t](e||"auto")[0].offsetWidth,this.$element[null!==e?"addClass":"removeClass"]("collapse"),this},transition:function(t,i,n){var a=this,o=function(){"show"==i.type&&a.reset(),a.transitioning=0,a.$element.trigger(n)};this.$element.trigger(i),i.isDefaultPrevented()||(this.transitioning=1,this.$element[t]("in"),e.support.transition&&this.$element.hasClass("collapse")?this.$element.one(e.support.transition.end,o):o())},toggle:function(){this[this.$element.hasClass("in")?"hide":"show"]()}};var i=e.fn.collapse;e.fn.collapse=function(i){return this.each(function(){var n=e(this),a=n.data("collapse"),o=e.extend({},e.fn.collapse.defaults,n.data(),"object"==typeof i&&i);a||n.data("collapse",a=new t(this,o)),"string"==typeof i&&a[i]()})},e.fn.collapse.defaults={toggle:!0},e.fn.collapse.Constructor=t,e.fn.collapse.noConflict=function(){return e.fn.collapse=i,this},e(document).on("click.collapse.data-api","[data-toggle=collapse]",function(t){var i,n=e(this),a=n.attr("data-target")||t.preventDefault()||(i=n.attr("href"))&&i.replace(/.*(?=#[^\s]+$)/,""),o=e(a).data("collapse")?"toggle":n.data();n[e(a).hasClass("in")?"addClass":"removeClass"]("collapsed"),e(a).collapse(o)})}(window.jQuery);