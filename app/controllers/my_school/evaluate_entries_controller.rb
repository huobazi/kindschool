#encoding:utf-8
#评估的管理分路
class MySchool::EvaluateEntriesController < MySchool::ManageController
   
   def new
   	@evaluate = Evaluate.find(params[:evaluate_id])
   	@evaluate_entry = EvaluateEntry.new()
   end

   def edit
     @evaluate = Evaluate.find(params[:evaluate_id])
     @evaluate_entry = EvaluateEntry.find(params[:id])
   end
   
   def update
     @evaluate = Evaluate.find(params[:evaluate_id])
     @evaluate_entry = EvaluateEntry.find(params[:id])
     respond_to do |format|
      if @evaluate_entry.update_attributes(params[:evaluate_entry])
        format.html { redirect_to my_school_evaluate_evaluate_entry_path(@evaluate,@evaluate_entry), notice: '评估项更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
   end

   def create
   	 @evaluate = Evaluate.find(params[:evaluate_id])
   	 @evaluate_entry = EvaluateEntry.new(params[:evaluate_entry])
     @evaluate_entry.kindergarten = @kind
     @evaluate_entry.evaluate = @evaluate
     if @evaluate_entry.save!
      flash[:success] = "创建成功"
      redirect_to my_school_evaluates_path(@evaluate)
    else
      flash[:error] = "创建不成功"
      render :new
    end
   end
   def destroy
      @evaluate = Evaluate.find(params[:evaluate_id])
      @evaluate_entry = EvaluateEntry.find(params[:id])
      @evaluate_entry.destroy
      respond_to do |format|
      format.html { redirect_to my_school_evaluates_path }
      format.json { head :no_content }
    end
   end
   def show
     @evaluate = Evaluate.find(params[:evaluate_id])
   	 @evaluate_entry = EvaluateEntry.find(params[:id])
   end
end
