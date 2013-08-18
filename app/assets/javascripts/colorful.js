// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require kindeditor


$(function(){
    $("div.head div.center_menu").hover(function(){
        $(this).find(".show_menu").show();
    },function(){
        $(this).find(".show_menu").hide();
    })

    $(".work_action a").hover(function(){
        $(this).find("div:first").hide();
        $(this).find("div:last").show();
    },function(){
        $(this).find("div:first").show();
        $(this).find("div:last").hide();
    })
    function tabs(tabTit,on,tabCon){
        $(tabCon).each(function(){
            $(this).children().eq(0).show();
        });
        $(tabTit).each(function(){
            $(this).children().eq(0).addClass(on);
        });
        $(tabTit).children().hover(function(){
            $(this).addClass(on).siblings().removeClass(on);
            var index = $(tabTit).children().index(this);
            $(tabCon).children().eq(index).show().siblings().hide();
        });
    }
    tabs(".tab-hd","active",".tab-bd");

});
$(document).ready(function() {
    $('a[href*=#]').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var $target = $(this.hash);
            $target = $target.length && $target || $('[name=' + this.hash.slice(1) + ']');
            if ($target.length) {
                var targetOffset = $target.offset().top;
                $('html,body').animate({
                    scrollTop: targetOffset
                },
                1000);
                return false;
            }
        }
    });
});

/*
 *	$('#write_cokies').click(function(){
		$.cookie('name', 'test',{expires: 7});
	});
	$('#read_ookies').click(function(){
		var test = $.cookie('name');
		alert (test);
	});
	$('#delete_cookies').click(function(){
		$.cookie('name', null);
	});
 **/
jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') {
        options = options || {};
        if (value === null) {
            value = '';
            options = $.extend({}, options);
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString();
        }
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else {
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

$(document).ready(function() {
    var dt = new Date();
    var currentDate = new Date()
    var day = currentDate.getDate()
    var month = currentDate.getMonth() + 1
    var year = currentDate.getFullYear()
    var now = year + "-" + month + "-" + day

    $(".time_datepicker").one("click", function() {
        $(this).val(now);
    })

    $('[data-remote]').live('ajax:before', function() {
        var $loader = $('#remote-loader');
        if (!$loader.length) {
            $loader = $('<div id="remote-loader"></div>').hide().prependTo($('body'));
        }
        $loader.html('<span class="label label-warning">正在加载...</span>');
        $loader.fadeIn();
    }).ajaxSuccess(function() {
        var $loader = $('#remote-loader');
        $loader.html('<span class="label label-warning">操作成功</span>');
        setTimeout(function() {
            $loader.fadeOut(function(){
                $(this).remove();
            });
        }, 500);
    }).ajaxError(function() {
        var $loader = $('#remote-loader');
        var $error = $('<span class="label label-important">操作失败</span>');
        $loader.html($error);
        $error.click(function() {
            $loader.fadeOut(function(){
                $(this).remove();
            });
        });
    });



})


