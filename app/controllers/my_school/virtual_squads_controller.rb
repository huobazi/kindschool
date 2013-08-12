#encoding:utf-8
#延时班管理
class MySchool::VirtualSquadsController < MySchool::ManageController
  def index
   	@virtual_squads = @kind.squads.search(params[:virtual_squad] || {}).where(:tp=>1).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def new
   	@virtual_squad = Squad.new()
    @virtual_squad.kindergarten_id = @kind.id
    @virtual_squad.historyreview = Time.now.year.to_s + "届"
    @data = current_user.get_users_ranges
  end

  def create
    @virtual_squad = Squad.new(params[:squad])
    @virtual_squad.tp=1
    @virtual_squad.kindergarten_id = @kind.id
    users = User.where(:id=>params[:ids])

    users.each do |user|
      user_squad = UserSquad.new(:user_id=>user.id)
      user_squad.squad = @virtual_squad
     	@virtual_squad.user_squads << user_squad
    end
    if @virtual_squad.save!
      redirect_to my_school_virtual_squad_path(@virtual_squad.id), :success => "操作成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_virtual_squads_path
    end
  end

  def show
    @virtual_squad = @kind.squads.find(params[:id])
    unless  @virtual_squad.tp==1
      redirect_to :controller=>'my_school/main' ,:action=>:no_kindergarten#,:notice=>"操作失误，没有该延时班"
    end

  end

  def edit
    @virtual_squad = @kind.squads.find(params[:id])
    unless @virtual_squad.tp==1
     	redirect_to :controller=>'my_school/main' ,:action=>:no_kindergarten#,:notice=>"操作失误，没有该延时班"	
   	end
  end


  def  get_edit_ids
    if virtual_squad=@kind.squads.where(:id=>params[:id],:tp=>1).first
      users_data = virtual_squad.user_squads.collect{|u_s| u_s.user}
      @data = users_data.group_by(&:tp)
      render :partial => "/my_school/messages/users",:layout=>false
    else
      render :text=>"您无法修改该信息"
    end
  end
   
  def update
    @virtual_squad=@kind.squads.where(:id=>params[:id],:tp=>1).first
    

    (@virtual_squad.user_squads || []).each do |u_s|
      u_s.destroy
    end
    sender_ids = current_user.get_sender_users(params[:ids])
    sender_ids.each do |user_id|
      if user = User.find_by_id_and_kindergarten_id(user_id,@kind.id)
        @virtual_squad.user_squads << UserSquad.new(:user_id=>user.id)
      end
    end
    respond_to do |format|
      if @virtual_squad.save && @virtual_squad.update_attributes(params[:squad])
        flash[:notice] = '更新成功.'
        format.html { redirect_to(:action=>:show,:id=>@virtual_squad.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy 
    
  	unless params[:squad].blank? 
  	  @virtual_squads = @kind.squads.where(:id=>params[:squad],:tp=>1)
    else
      @virtual_squads = @kind.squads.where(:id=>params[:id],:tp=>1) 
    end
    @virtual_squads.each do |virtual_squad|
      virtual_squad.destroy
    end
    respond_to do |format|
      format.html { redirect_to my_school_virtual_squads_path }
      format.json { head :no_content }
    end
  end


end
