#encoding:utf-8
#表格
class MySchool::ContentPatternsController < MySchool::ManageController

  def index
    @content_patterns =  @kind.content_patterns 
  end
  def edit
    @content_pattern =  @kind.content_patterns.find(params[:id])  
  end

   def update
    @content_pattern =  @kind.content_patterns.find(params[:id])  
    respond_to do |format|
      if @content_pattern.update_attributes(params[:content_pattern])
        format.html { redirect_to my_school_content_patterns_path, notice: '表格 was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

end
