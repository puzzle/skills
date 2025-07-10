# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    initialize_user_rights(user)
    if user.is_conf_admin?
      initialize_conf_admin_rights(user)
    elsif user.is_admin? || user.is_conf_admin?
      initialize_admin_rights(user)
    end
  end

  def initialize_user_rights(_user)
    user_classes.each do |user_classes|
      can :manage, user_classes
    end

    can :manage, Person
    can :manage, PeopleSkill
    can :read, Skill
  end

  def initialize_admin_rights(user)
    admin_classes.each do |admin_class|
      can :manage, admin_class
      cannot :destroy, admin_class
      can :destroy, admin_class, user: user
    end
  end

  def initialize_conf_admin_rights(user)
    conf_admin_classes.each do |conf_admin_class|
      can :manage, conf_admin_class
      cannot :destroy, conf_admin_class
      can :destroy, conf_admin_class, user: user
    end
  end

  def user_classes
    [Activity, AdvancedTraining, Education, Project]
  end

  def conf_admin_classes
    [Department, Role, Company]
  end

  def admin_classes
    [Certificate, Skill, UnifiedSkill, UnifiedSkillForm]
  end
end
