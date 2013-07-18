#encoding:utf-8
#升学策略
class MySchool::CareerStrategiesController < MySchool::ManageController
  def index
    @career_strategies =  @kind.career_strategies
  end

  def new
    @career_strategy = CareerStrategy.new()
  end
end
