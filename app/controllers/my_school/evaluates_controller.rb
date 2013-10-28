#encoding:utf-8
#评估的管理
class MySchool::EvaluatesController < MySchool::ManageController
   def index
     @evaluate = @kind.evaluate
   end
end
