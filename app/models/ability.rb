# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    initialize_user_rights(user)
    if user.is_admin? || user.is_conf_admin?
      initialize_admin_rights
    end
    if user.is_conf_admin?
      initialize_conf_admin_rights
    end
  end

  def initialize_user_rights(user)
    user_classes.each do |user_class|
      can :read, user_class
      can :manage, user_class do |record|
        record.person.auth_user_id == user.id
      end
    end

    can :read, Skill
    can :read, Person
    can :manage, Person, auth_user_id: user.id
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
    [Activity, AdvancedTraining, Education, Project, PeopleSkill, Contribution]
  end

  def conf_admin_classes
    [Department, Role, Company]
  end

  def admin_classes
    [Certificate, Skill, UnifiedSkill, UnifiedSkillForm]
  end
end
