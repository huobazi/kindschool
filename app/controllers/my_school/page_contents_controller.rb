#encoding:utf-8
class  MySchool::PageContentsController < MySchool::ManageController
  def index
    @page_contents = PageContent.all(:conditions=>{:kindergarten_id=>@kind.id})
  end

  def show
    @page_content = PageContent.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def delete_content
    @page_content = PageContent.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    if entry = @page_content.content_entries.find_by_id(params[:entry_id])
      if entry.delete
        flash[:notice]="操作成功."
      else
        flash[:notice]="操作失败."
      end
    else
      flash[:error]="操作失败,记录不存在."
    end
    redirect_to :action => :show,:controller=>"/my_school/page_contents",:id=>@page_content.id
  end

  def add_content
    PageContent.transaction do
      begin
        @page_content = PageContent.find_by_id_and_kindergarten_id(params[:id],@kind.id)
        if params[:tp] == "showcase"
          if params[:title].blank? && params[:img].blank?
            raise "标题或者图片不能为空."
          else
            entry = ContentEntry.new(:title=>params[:title],:content=>params[:content])
            if params[:img]
              img = PageImg.new(:uploaded_data=> params[:img])
              entry.page_img = img
            end
            @page_content.content_entries << entry
          end
        elsif params[:tp] == "about_me"
          if @page_content.content_entries.blank?
            entry = ContentEntry.new(:content=>(params[:content]||""))
            @page_content.content_entries << entry
          else
            entry = @page_content.content_entries.first
            entry.update_attributes(:content=>(params[:content]||""))
          end
        elsif params[:tp] == "contact_us"
          if @page_content.content_entries.blank?
            entry = ContentEntry.new(:content=>(params[:content]||""))
            @page_content.content_entries << entry
          else
            entry = @page_content.content_entries.first
            entry.update_attributes(:content=>(params[:content]||""))
          end
        end
        if @page_content.save
          flash[:notice] = "添加成功."
        else
          flash[:error] = "添加失败."
        end
        redirect_to(:action => :show,:controller=>"/my_school/page_contents",:id=>@page_content.id)
      rescue Exception => ex
        flash[:error] = ex.message
        redirect_to(:action => :show,:controller=>"/my_school/page_contents",:id=>@page_content.id)
      end
    end
  end

  def edit_content
    @page_content = PageContent.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    if @entry = @page_content.content_entries.find_by_id(params[:entry_id])
    else
      flash[:error]="操作失败,记录不存在."
      redirect_to(:action => :show,:controller=>"/my_school/page_contents",:id=>@page_content.id)
    end
  end

  def update_content
    PageContent.transaction do
      begin
        @page_content = PageContent.find_by_id_and_kindergarten_id(params[:id],@kind.id)
        if params[:tp] == "showcase"
          if params[:title].blank? && params[:img].blank?
            raise "标题或者图片不能为空."
          else
            @entry = ContentEntry.find(params[:entry_id])
            @entry.update_attributes(:title=>params[:title],:content=>params[:content])
            if params[:img]
              img = PageImg.new(:uploaded_data=> params[:img])
              @entry.page_img = img
            end
          end
        elsif params[:tp] == "about_me"
          @entry = ContentEntry.find(params[:entry_id])
          @entry.update_attributes(:content=>(params[:content]||""))
        elsif params[:tp] == "contact_us"
          @entry = ContentEntry.find(params[:entry_id])
          @entry.update_attributes(:content=>(params[:content]||""))
        end
        if @entry.save
          flash[:notice] = "更新成功."
        else
          flash[:error] = "更新失败."
        end
        redirect_to(:action => :show,:controller=>"/my_school/page_contents",:id=>@page_content.id)
      rescue Exception => ex
        flash[:error] = ex.message
        redirect_to(:action => :show,:controller=>"/my_school/page_contents",:id=>@page_content.id)
      end
    end
  end
end
