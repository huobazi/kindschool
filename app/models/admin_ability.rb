#encoding:utf-8
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    if user
      if user.email == WEBSITE_CONFIG["admin_user"]
        can :read, :all
        can :manage, :all
      else
        case user.role_name
        when "admin"
          then
          can :read, :all
          can :manage, :all #,:except=>[SysLog]
        when "operation"
          then
          can [:create,:read, :update, :destroy], [WeiyiConfig,Category,CommentDatabank,WeixinDatabank,WeixinShare]
          can [:read, :update], ShrinkRecord
          can [:create,:read, :update], [Kindergarten,User,StudentInfo,Staff,OptionOperate]
          can [:read], [Teacher,CareerStrategy,Message,MessageEntry,Role,Smarty,AdminUser,TopicCategory,
            Topic,TopicEntry,GrowthRecord,SeedlingRecord,Operate,Menu,Template,Grade,Squad,
            PhysicalRecord,Album,AlbumEntry,ContentPattern,StudentResource,Activity,ActivityEntry,PageContent,ContentEntry]
          can [:read,:destroy], [AssetImg,CookBook,Notice]
          can :reset_password, User
          can :share_users, WeixinDatabank
          can [:add_functional_to_kind,:update_functional], OptionOperate
          can :loading, Kindergarten
          can [:read],[SysLog]
          #        cannot :reset_password, User
        when "bazaar"
          then
        when "member"
          then
        end
        can :read, ActiveAdmin::Page, :name => "Dashboard"
      end
    end
    
    # We operate with three role levels:
    # - Editor
    # - Moderator
    # - Manager
    #    can :read,User
    # An editor can do the following:
    #    can :manage, Foobar
    #    can :read, SomeOtherModel
    #
    #    # A moderator can do the following:
    #    if user.role?('moderator')
    #      can :manage, SomeOtherModel
    #    end
    #
    #    # A manager can do the following:
    #    if user.role?('manager')
    #      can :manage, SomeThirdModel
    #    end
  end
end