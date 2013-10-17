# encoding: utf-8
module Weixin::WeixinStatusHelper

  def show_unread(module_name, search=nil, tp=nil)
    count = AccessStatu.unread_count(@kind, module_name, current_user, search, tp)
    unless count == 0
      count
    end
  end

  def show_unread_html(module_name, search=nil, tp=nil)
    unless AccessStatu.unread_count(@kind, module_name, current_user, search, tp) == 0
      raw "(<span style='font-size: 1em'>" + show_unread(module_name, search, tp).to_s + "</span>)"
    end
  end

end
