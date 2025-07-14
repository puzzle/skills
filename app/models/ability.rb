# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    initialize_user_rights
    if user.is_conf_admin?
      initialize_conf_admin_rights
    elsif user.is_admin? || user.is_conf_admin?
      initialize_admin_rights
    end
  end

  def initialize_user_rights
    user_classes.each do |user_classes|
      can :manage, user_classes
    end

    can :read, Skill
  end

  def initialize_admin_rights
    admin_classes.each do |admin_class|
      can :manage, admin_class
    end
  end

  def initialize_conf_admin_rights
    conf_admin_classes.each do |conf_admin_class|
      can :manage, conf_admin_class
    end
  end

  def user_classes
    [Activity, AdvancedTraining, Education, Project, Person, PeopleSkill]
  end

  def conf_admin_classes
    [Department, Role, Company]
  end

  def admin_classes
    [Certificate, Skill, UnifiedSkill, UnifiedSkillForm]
  end
end
