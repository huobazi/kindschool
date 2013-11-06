#encoding:utf-8
#评估的管理
class MySchool::EvaluatesController < MySchool::ManageController
   def index
     @evaluates = @kind.evaluate
     if @evaluates.blank?
     	@evaluate = Evaluate.new()
     else
     	@evaluate_entries = @evaluates.evaluate_entries.page(params[:page] || 1).per(10)
     end
   end
   def create
     @evaluate = Evaluate.new()
     @evaluate.kindergarten = @kind

      respond_to do |format|
        if @evaluate.save
          format.html { redirect_to my_school_evaluates_path, notice: '创建成功.' }
        else
          format.html { render action: "index" }
        end
      end
   end
end
