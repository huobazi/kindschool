#encoding:utf-8
ActiveAdmin.register HelpCategory do
  menu :parent => "微壹平台", :priority => 1

  index do
    column :name
    column :remark
    column :code
    column :parent
    column :tp_id do  |obj|
      HelpCategory::TPID[obj.tp_id.to_i]
    end
    default_actions
  end

  filter :name
  filter :parent
  filter :help_movie
  filter :code
  filter :created_at

  form do |f|
    f.inputs "新建视频分类" do
      f.input :parent_id, :as=>:select,:collection=> nested_set_options(HelpCategory){|i, level| "#{'-' * level} #{i.name}" },:include_blank=>'===请选择==='#.inspect
      f.input :name
      f.input :code
      f.input :remark
      f.input :tp_id, :as=>:select ,:collection=>[["学生",0],["老师",1],["管理员",2]],:include_blank=>'===请选择==='
      f.input :help_movie_id, :as=>:select ,:collection=>HelpMovie.all.collect{ |p| [p.name,p.id]},:include_blank=>'===请选择==='
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :parent
      row :name
      row :code
      row :remark
      row :tp_id do |obj|
        HelpCategory::TPID[obj.tp_id]
      end
      row :help_movie
    end
  end

end
