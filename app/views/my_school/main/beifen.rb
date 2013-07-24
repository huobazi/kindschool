<div class="control-group">
  <label class="control-label"><span class="required"></span>关于幼儿园的介绍</label>
</div>
<div class="control-group">
  <% if action_name == "edit_content" %>
    <%= text_field_tag :content,"#{@entry.content}", :class => 'profile_input required'%>
    <%= hidden_field_tag "entry_id",@entry.id %>
  <% else %>
    <%= text_field_tag :content,"", :class => 'profile_input '%>
  <% end %>
</div>
<div class="control-group">
  <label class="control-label"><span class="required"></span>中间标题</label>
  <div class="controls">
    <label class="show_label">
      <% if action_name == "edit_content" %>
        <%= text_field_tag :title,"#{@entry.title}", :class => 'profile_input required'%>
      <% else %>
        <%= text_field_tag :title,"", :class => 'profile_input required'%>
      <% end %>
    </label>
  </div>
</div>
<div class="control-group">
  <% if @entry && @entry.page_img %>
    <label class="control-label">上传图片</label>
    <div class="controls">
      <label class="show_label">
        <%= file_field_tag 'img', :class => 'profile_input' %>
      </label>
      <img src="<%= @entry.page_img.public_filename %>" alt="展示图片" />
      <%= hidden_field_tag "entry_id",@entry.id %>
    </div>

  <% else %>
    
    <label class="control-label"><span class="required"></span>上传图片</label>
    <div class="controls">
      <label class="show_label">
        <%= file_field_tag 'img', :class => 'profile_input required' %>
      </label>
    </div>
    <label class="control-label"><span class="required"></span>上传右上角图片</label>
    <div class="controls">
      <label class="show_label">
        <%= file_field_tag 'img_top', :class => 'profile_input required' %>
      </label>
    </div>
    <label class="control-label"><span class="required"></span>上传右下角图片</label>
    <div class="controls">
      <label class="show_label">
        <%= file_field_tag 'img_bottom', :class => 'profile_input required' %>
      </label>
    </div>
  <% end %>

</div>