class Ability
  include CanCan::Ability

  def initialize(user)
    initialize_user_rights

    role_initializers.each do |predicate, initializer|
      send(initializer) if user.public_send(predicate)
    end
  end

  private

  def role_initializers
    {
      is_editor?: :initialize_editor_rights,
      is_admin?: :initialize_admin_rights,
      is_conf_admin?: :initialize_conf_admin_rights
    }
  end

  def initialize_user_rights
    can :read, Person
    editor_classes.each do |editor_class|
      can :read, editor_class
    end
    can :read, Skill
  end

  def initialize_editor_rights
    editor_classes.each do |editor_class|
      can :manage, editor_class
    end
  end

  def initialize_admin_rights
    initialize_editor_rights
    admin_classes.each do |admin_class|
      can :manage, admin_class
    end
  end

  def initialize_conf_admin_rights
    initialize_admin_rights
    conf_admin_classes.each do |conf_admin_class|
      can :manage, conf_admin_class
    end
  end

  def user_classes
    [Activity, AdvancedTraining, Education, Project, Person, PeopleSkill, Contribution]
  end

  def editor_classes
    [Activity, AdvancedTraining, Education, Person, Project, PeopleSkill, Contribution]
  end

  def conf_admin_classes
    [Department, Role, Company]
  end

  def admin_classes
    [Certificate, Skill, UnifiedSkill, UnifiedSkillForm]
  end
end
