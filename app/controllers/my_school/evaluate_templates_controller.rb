#encoding:utf-8
#评估的模板下载
class MySchool::EvaluateTemplatesController < MySchool::ManageController
 def index
 	@evaluate_templates = EvaluateTemplate.page(params[:page] || 1).per(10)
 end
 def show
    @evaluate_template = EvaluateTemplate.find(params[:id])
 end

end
