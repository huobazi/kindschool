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
//= require uploadify
//= require highcharts/highcharts
//= require highcharts/highcharts-more


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
    var currentDate = new Date();
    var day = currentDate.getDate();
    var month = currentDate.getMonth() + 1;
    var year = currentDate.getFullYear();
    var now = year + "-" + month + "-" + day;

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
  }).ajaxError(function(event, xhr, status) {
    var $loader = $('#remote-loader');
    var error_message = "<span class='label label-important'>" + xhr.responseText + "</span>";
    var $error = $($(error_message));
    $loader.html($error);
    $error.click(function() {
      $loader.fadeOut(function(){
        $(this).remove();
      });
    });
  })

  $("#check_all").live('click', function(){
    $(".check").attr("checked",this.checked);
  })

  $(".hidden-wrap").live('click', function(event) {
    event.preventDefault();
    $(this).parent().hide();
  })

  $("body").delegate('div.topic', 'mouseover', function() {
    $(this).addClass('is-topic-mouseover');
  })

  $("body").delegate('div.topic', 'mouseout', function() {
    $(this).removeClass('is-topic-mouseover');
  })

  $("body").delegate('div.topic', 'click', function() {
    var check = $(this).find(".check");
    check.trigger('click');
  })

  $("body").delegate('.check', 'click', function(event) {
    event.stopPropagation();
    $(".select_all_wrap").show();
  })

  $("body").delegate('.topic a', 'click', function(event) {
    event.stopPropagation();
    var link = $(this);
    if( link.data('confirm') ) {
      if($.rails.allowAction(link)) {
        $.rails.handleMethod($(this));
        return false;
      } else {
        return false;
      }
    }
  })

  $("body").delegate(".table-hover tr", 'click', function() {
    var check = $(this).find(".check");
    check.trigger('click');
  })

  $("body").delegate('.table-hover tr a', 'click', function(event) {
    event.stopPropagation();
  })

  $("body").delegate(".list tr", 'click', function() {
    var check = $(this).find(".check");
    check.trigger('click');
  })

  $("body").delegate('.list tr a', 'click', function(event) {
    event.stopPropagation();
  })

  $('.search_form form').submit(function() {
    var valuesToSubmit = $(this).serialize();
    if ( $(".topics").length > 0 ) {
      var record_wrap = ".topics"
    } else {
      var record_wrap = ".work_list"
    }
    $.ajax({
      url: $(this).attr('action'),
      data: valuesToSubmit,
      beforeSend: function() {
        $('<img class="loading_img loadding_pt" src="/t/colorful/gif_preloader.gif" alt="" />').appendTo(record_wrap);
      },
      success: function() {
        $(record_wrap).find("img.loadding_pt").hide();
      }
    })
    return false;
  })

})
