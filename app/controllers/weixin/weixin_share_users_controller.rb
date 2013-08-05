#encoding:utf-8
class Weixin::WeixinShareUsersController < Weixin::ManageController
  #列表界面
  def index
    params[:weixin_share_users] = {} if params[:weixin_share_users].blank?
    @weixin_share_users = WeixinShareUser.search(params[:weixin_share_users] || {}).where("visible=1 AND user_id=? AND weixin_shares.send_date < ?" ,current_user.id, Time.zone.now).page(params[:page] || 1).joins("LEFT JOIN weixin_shares ON(weixin_shares.id = weixin_share_users.weixin_share_id)").per(10).order("weixin_shares.send_date DESC")
  end
  def show
    @weixin_share_user = WeixinShareUser.find_by_id_and_kindergarten_id_and_visible(params[:id],@kind.id,1)
    @weixin_share = @weixin_share_user.weixin_share
    @weixin_databank = @weixin_share.weixin_databank
    if !@weixin_share_user.read_status
      @weixin_share_user.update_attribute(:read_status, true)
    end
  rescue Exception=>ex
    flash[:error] = "信息不存在"
    redirect_to :action => "index"
  end
end
