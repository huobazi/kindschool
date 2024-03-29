#encoding:utf-8
#学员菜谱
class MySchool::CookBooksController < MySchool::ManageController

  before_filter :student_can_not_destroy, :only => :destroy

  def index
    @cook_books = @kind.cook_books.search(params[:cook_book]).page(params[:page] || 1).per(10).order("created_at DESC")
    all_roles = ['admin','principal','vice_principal','assistant_principal','park_hospital']

    userrole = current_user.get_users_ranges
    @flag=all_roles.include?(@role)
    if userrole[:tp] == :all
      @flag= true
    end

    if request.xhr?
      @search_record = "cook_books"
      @search_record_count = @cook_books.total_count
      render "my_school/commons/_search_index.js.erb"
    else
      render "index"
    end
  end

  def new
   if content_pattern = @kind.content_patterns.where(:number=>'cook_book').first
      @cook_book = @kind.cook_books.new(:content=>content_pattern.content)
      @cook_book.creater_id = current_user.id
   else
      @cook_book = @kind.cook_books.new
      @cook_book.creater_id = current_user.id
   end
  end

  def create
     @cook_book = @kind.cook_books.new(params[:cook_book])
     @cook_book.creater_id = current_user.id

      respond_to do |format|
        if @cook_book.save
          format.html { redirect_to my_school_cook_books_path, notice: '菜谱创建成功.' }
        else
          format.html { render action: "new" }
        end
      end
  end

  def edit
    @cook_book = @kind.cook_books.find(params[:id])
  end

  def update
    @cook_book = @kind.cook_books.find(params[:id])
    respond_to do |format|
      if @cook_book.update_attributes(params[:cook_book])
        format.html { redirect_to my_school_cook_books_path, notice: '学员菜谱更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    unless params[:cook_book].blank? 
      @cook_books = @kind.cook_books.where(:id=>params[:cook_book])
    else
      @cook_books = @kind.cook_books.where(:id=>params[:id])
    end
    if @cook_books.blank?
      flash[:error] = "请选择菜谱"
      redirect_to :action => :index
      return
    end
    @cook_books.each do |cook_book|
      cook_book.destroy
    end
    respond_to do |format|
      flash[:success] = "删除菜谱成功"
      format.html { redirect_to my_school_cook_books_path }
      format.json { head :no_content }
    end
  end

  def show
    @cook_book = @kind.cook_books.find(params[:id])
  end

end
