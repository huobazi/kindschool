#encoding:utf-8
#学员菜谱
class Weixin::CookBooksController < Weixin::ManageController
  def index
    @cook_books = @kind.cook_books.page(params[:page] || 1).per(10).order("created_at DESC")
    all_roles = ['admin','principal','vice_principal','assistant_principal','park_hospital']

    userrole = current_user.get_users_ranges
    @flag=all_roles.include?(@role)
    if userrole[:tp] == :all
      @flag= true
    end
  end

  def show
    @cook_book = @kind.cook_books.find(params[:id])
  end
end
