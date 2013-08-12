#encoding:utf-8
#个人锦集
#
class MySchool::PersonalSetsController < MySchool::ManageController
  def index
    userrole = current_user.get_users_ranges[:tp]
    if userrole == :student
      @flag="student"
    elsif userrole == :teacher
      @flag= "teacher"
    end
  	@sets = current_user.personal_sets.search(params[:personal_set] || {}).page(params[:page] || 1).per(10)
  end
  
  def new
  	@personal_set = PersonalSet.new()
  end
  def create
    @personal_set = current_user.personal_sets.new()
    unless params[:uploaded_data].blank?
      photo_gallery = PhotoGallery.new(:uploaded_data=>params[:uploaded_data])
      @personal_set.resource = photo_gallery
    end
    unless params[:content].blank?
      text_set = TextSet.new(:content=>params[:content])
      @personal_set.resource = text_set
    end
    respond_to do |format|
      if @personal_set.save
        format.html { redirect_to my_school_personal_sets_path, :notice=> '个人集锦创建成功.' }
      else
        format.html { render :action=> "new" }
      end
    end

  end
  #没有编辑功能
  def edit
  	# @personal_set = PersonalSet.new()
  end
end
