# encoding: utf-8
module MySchool::ManageHelper
  def choose_operate_show(controller_view)
    (session[:operates]||[]).include?(controller_view)
  end
  def calculated_figures
    str = current_user.name + current_user.role.try(:name).to_s
    200-str.size
  end

  def paginate(scope, options = {}, &block)
    js = <<EOF
      <script>
      $("#redirect_page").keydown(function(e){
        var page_number = $("#page_number").val();
        var e = e || event,
        keycode = e.which || e.keyCode;
        if (keycode==13) {
          window.location.href = "#{request.original_url.sub(/\?page.*/, '')}" + "?page=" + page_number;
        }
      });
      </script>
EOF
    str ||= super
    if scope.total_count > scope.limit_value
      str << raw("<ul id='redirect_page'><li><span>每页#{scope.limit_value.to_s}条/总共#{scope.total_count.to_s}条记录</span>&nbsp;&nbsp;")
      if PAGE_CONTROLLER.include?("#{controller_name}/#{action_name}")
        str << raw("<span>
        跳到第<input type='' class='input-mini' id='page_number' value='#{params[:page] ? params[:page] : ""}' />页
        </span>")
      end
      str << raw("</li></ul>")
    end
    str << js.to_s.html_safe
  end

  def render_report_link(options = {})
    render partial: "/my_school/commons/report_link", locals: {:resource_id => options[:resource_id], :resource_type => options[:resource_type]}
  end

end
