/**
* jCarouselLite - jQuery plugin to navigate images/any content in a carousel style widget.
* @requires jQuery v1.2 or above
*
* http://gmarwaha.com/jquery/jcarousellite/
*
* Copyright (c) 2007 Ganeshji Marwaha (gmarwaha.com)
* Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/licenses/gpl.html
*
* Version: 1.0.1
* Note: Requires jquery 1.2 or above from version 1.0.1
*/
!function(e){function t(t,i){return parseInt(e.css(t[0],i))||0}function i(e){return e[0].offsetWidth+t(e,"marginLeft")+t(e,"marginRight")}function n(e){return e[0].offsetHeight+t(e,"marginTop")+t(e,"marginBottom")}e.fn.jCarouselLite=function(t){return t=e.extend({btnPrev:null,btnNext:null,btnGo:null,mouseWheel:!1,auto:null,speed:200,easing:null,vertical:!1,circular:!0,visible:3,start:0,scroll:1,beforeStart:null,afterEnd:null},t||{}),this.each(function(){function s(){return f.slice(g).slice(0,p)}function o(i){if(!a){if(t.beforeStart&&t.beforeStart.call(this,s()),t.circular)i<=t.start-p-1?(u.css(r,-((m-2*p)*v)+"px"),g=i==t.start-p-1?m-2*p-1:m-2*p-t.scroll):i>=m-p+1?(u.css(r,-(p*v)+"px"),g=i==m-p+1?p+1:p+t.scroll):g=i;else{if(0>i||i>m-p)return;g=i}a=!0,u.animate("left"==r?{left:-(g*v)}:{top:-(g*v)},t.speed,t.easing,function(){t.afterEnd&&t.afterEnd.call(this,s()),a=!1}),t.circular||(e(t.btnPrev+","+t.btnNext).removeClass("disabled"),e(g-t.scroll<0&&t.btnPrev||g+t.scroll>m-p&&t.btnNext||[]).addClass("disabled"))}return!1}var a=!1,r=t.vertical?"top":"left",l=t.vertical?"height":"width",c=e(this),u=e("ul",c),h=e("li",u),d=h.size(),p=t.visible;t.circular&&(u.prepend(h.slice(d-p-1+1).clone()).append(h.slice(0,p).clone()),t.start+=p);var f=e("li",u),m=f.size(),g=t.start;c.css("visibility","visible"),f.css({overflow:"hidden","float":t.vertical?"none":"left"}),u.css({margin:"0",padding:"0",position:"relative","list-style-type":"none","z-index":"1"}),c.css({overflow:"hidden",position:"relative","z-index":"2",left:"0px"});var v=t.vertical?n(f):i(f),b=v*m,y=v*p;f.css({width:f.width(),height:f.height()}),u.css(l,b+"px").css(r,-(g*v)),c.css(l,y+"px"),t.btnPrev&&e(t.btnPrev).click(function(){return o(g-t.scroll)}),t.btnNext&&e(t.btnNext).click(function(){return o(g+t.scroll)}),t.btnGo&&e.each(t.btnGo,function(i,n){e(n).click(function(){return o(t.circular?t.visible+i:i)})}),t.mouseWheel&&c.mousewheel&&c.mousewheel(function(e,i){return i>0?o(g-t.scroll):o(g+t.scroll)}),t.auto&&(jCarouselLiteTime=setInterval(function(){o(g+t.scroll)},t.auto+t.speed)),e(this).hover(function(){clearInterval(jCarouselLiteTime)},function(){jCarouselLiteTime=setInterval(function(){o(g+t.scroll)},t.auto+t.speed)})})}}(jQuery);