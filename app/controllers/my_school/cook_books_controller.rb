#encoding:utf-8
#学员菜谱
class MySchool::CookBooksController < MySchool::ManageController
def index
@cook_books = @kind.cook_books.order("created_at desc")
all_roles = ['admin','principal','vice_principal','assistant_principal','park_hospital']
userrole = current_user.get_users_ranges
@flag=all_roles.include?(@role)
if userrole[:tp] == :all
  @flag= true
end

end
def new
 if content_pattern = @kind.content_patterns.where(:number=>'cook_book').first
    @cook_book = @kind.cook_books.new(:content=>content_pattern.content)
 else
    @cook_book = @kind.cook_books.new 
 end
end

def create
   @cook_book = @kind.cook_books.new(params[:cook_book])
     
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

end
