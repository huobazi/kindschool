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
          can :manage, :all
        when "operation"
          then
          can [:create,:read, :update, :destroy], WeiyiConfig
          can [:read, :update], ShrinkRecord
          can [:read,:reset_password], User
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