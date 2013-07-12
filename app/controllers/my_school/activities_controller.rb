#encoding:utf-8
class MySchool::ActivityController < MySchool::ManageController
  # 活动

  def index
    @activities = @kind.activities.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
