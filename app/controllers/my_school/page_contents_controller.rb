#encoding:utf-8
class  MySchool::PageContentsController < MySchool::ManageController
  def index
    @page_contents = PageContent.all(:conditions=>{:kindergarten_id=>@kind.id})
  end

  def show
    @page_content = PageContent.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @content_entries = @page_content.content_entries
    @flag = false
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
        elsif params[:tp] == "official_website_about_us"
          content_entries = @page_content.content_entries
          unless params[:content].blank?
            if  content_entries.find_by_number('official_website_about_us_content').blank?
             entry = ContentEntry.new(:number=>"official_website_about_us_content",:content=>(params[:content]))
             @page_content.content_entries<< entry
            end
          end
          unless params[:title].blank?
           if  content_entries.find_by_number('official_website_about_us_title').blank?
             entry = ContentEntry.new(:number=>"official_website_about_us_title",:title=>(params[:title]))
             @page_content.content_entries << entry
           end
          end
          unless params[:img].blank?
            if  content_entries.find_by_number('official_website_about_us_img').blank?
             entry = ContentEntry.new(:number=>"official_website_about_us_img")
             img = PageImg.new(:uploaded_data=> params[:img])
             entry.page_img = img
             @page_content.content_entries << entry
            end
          end
          unless params[:img_top].blank?
            if  content_entries.find_by_number('official_website_about_us_img_top').blank?
             entry = ContentEntry.new(:number=>"official_website_about_us_img_top")
             img = PageImg.new(:uploaded_data=> params[:img_top])
             entry.page_img = img
             @page_content.content_entries << entry
            end
          end
          unless params[:img_bottom].blank?
            if  content_entries.find_by_number('official_website_about_us_img_bottom').blank?
             entry = ContentEntry.new(:number=>"official_website_about_us_img_bottom")
             img = PageImg.new(:uploaded_data=> params[:img_bottom])
             entry.page_img = img
             @page_content.content_entries << entry
            end
          end
        elsif params[:tp] == "official_website_feature"
          # if @page_content.content_entries.blank?
          if params[:title].blank?
              raise "标题不能为空."
          end
             entry = ContentEntry.new(:title=>params[:title],:content=>(params[:content]||""))
            if params[:img]
              img = PageImg.new(:uploaded_data=> params[:img])
              entry.page_img = img
            end
            @page_content.content_entries << entry
        elsif params[:tp] == "official_website_admissions_information"
          content_entries = @page_content.content_entries
          unless params[:title].blank?
            if  content_entries.find_by_number('official_website_admissions_title').blank?
             entry = ContentEntry.new(:number=>"official_website_admissions_title",:title=>(params[:title]),:content=>(params[:content]||""))
             @page_content.content_entries<< entry
            end
          end
          unless params[:mid_title].blank?
            if  content_entries.find_by_number('official_website_admissions_mid_title').blank?
             entry = ContentEntry.new(:number=>"official_website_admissions_mid_title",:title=>(params[:mid_title]),:content=>(params[:mid_content])||"")
             @page_content.content_entries<< entry
            end
          end
        elsif params[:tp] == "official_website_home"
          content_entries = @page_content.content_entries
          unless params[:home_publicity_img].blank?
            if content_entries.find_by_number('official_home_pub_img').blank?
               entry = ContentEntry.new(:number=>"official_home_pub_img")
               img = PageImg.new(:uploaded_data=> params[:home_publicity_img])
               entry.page_img = img
               @page_content.content_entries<< entry
            end 
          end
          if !params[:teacher_title].blank? || !params[:teacher_content].blank? || !params[:img].blank?
          entry = ContentEntry.new(:number=>"official_home_teacher",:title=>params[:teacher_title],:content=>(params[:teacher_content]||""))  
            if params[:teacher_img]
              img = PageImg.new(:uploaded_data=> params[:teacher_img])
              entry.page_img = img
            end
            @page_content.content_entries << entry
          end
        end
        if @page_content.save!
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
    @content_entries = @page_content.content_entries
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
        elsif params[:tp] == "official_website_home"
          @entry = ContentEntry.find(params[:entry_id])
            if @entry.number == "official_home_pub_img"
               unless params[:home_publicity_img].blank?
                # img = PageImg.new(:uploaded_data=> params[:home_publicity_img])
                # @entry.page_img = img
                unless @entry.page_img.blank?
                  @entry.page_img.update_attributes(:uploaded_data=> params[:home_publicity_img])
                else
                  img = PageImg.new(:uploaded_data=> params[:home_publicity_img])
                  @entry.page_img = img
                end
               end
            elsif @entry.number == "official_home_teacher"
              if params[:teacher_img]
               # img = PageImg.new(:uploaded_data=> params[:teacher_img])
               # @entry.page_img = img
               unless @entry.page_img.blank?
                 @entry.page_img.update_attributes(:uploaded_data=> params[:teacher_img])
               else
                 img = PageImg.new(:uploaded_data=> params[:teacher_img])
                 @entry.page_img = img
               end
              end            
               @entry.title = params[:teacher_title]
               @entry.content = params[:teacher_content]
            end 
        elsif params[:tp]=="official_website_feature"
          if params[:title].blank? #&& params[:img].blank?
            raise "标题不能为空."
          end
          @entry = ContentEntry.find(params[:entry_id])
          @entry.update_attributes(:title=>params[:title],:content=>params[:content])
          if params[:img]
              img = PageImg.new(:uploaded_data=> params[:img])
              @entry.page_img = img
          end
        elsif params[:tp]=="official_website_about_us"
           @entry = ContentEntry.find(params[:entry_id])
           puts "22222222222222222222222222222"
           puts @entry.inspect
           page_content = @entry.page_content
           content_entries = page_content.content_entries
           puts "1111111111111111111"
           unless params[:content].blank?
            if @entry = content_entries.find_by_number('official_website_about_us_content')
             @entry.content=params[:content]
            end
           end
          unless params[:title].blank?
           if @entry = content_entries.find_by_number('official_website_about_us_title')
             @entry.title=params[:title]
           end
          end
          unless params[:img].blank?
            if @entry = content_entries.find_by_number('official_website_about_us_img')
             # @entry.page_img.destroy
             unless @entry.page_img.blank?
               @entry.page_img.update_attributes(:uploaded_data=> params[:img])
             else
               img = PageImg.new(:uploaded_data=> params[:img])
               @entry.page_img = img
             end
              # @entry.save!
            end
          end
          unless params[:img_top].blank?
            if @entry = content_entries.find_by_number('official_website_about_us_img_top')
             # @entry.page_img.destroy
             # img = PageImg.new(:uploaded_data=> params[:img_top])
             # @entry.page_img = img
             unless @entry.page_img.blank?
               @entry.page_img.update_attributes(:uploaded_data=> params[:img_top])
             else
               img = PageImg.new(:uploaded_data=> params[:img_top])
               @entry.page_img = img
             end
              # @entry.save
            end
          end
          unless params[:img_bottom].blank?
            if @entry = content_entries.find_by_number('official_website_about_us_img_bottom')
             # @entry.page_img.destroy             
             # img = PageImg.new(:uploaded_data=> params[:img_bottom])
             # @entry.page_img = img
             unless @entry.page_img.blank?
               @entry.page_img.update_attributes(:uploaded_data=> params[:img_bottom])
             else
               img = PageImg.new(:uploaded_data=> params[:img_bottom])
               @entry.page_img = img
             end
              # @entry.save
            end
          end
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
