# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Currently full right is going to get fixed in a future ticket
    person_relation_classes = [Activity, AdvancedTraining, Education, Project]
    person_relation_classes.each do |person_relation_class|
      can :manage, person_relation_class
    end
    can :manage, Person
    can :manage, PeopleSkill

    if user.is_conf_admin?
      can :update, Department
      can :destroy, Department, user: user
    elsif user.is_admin?

    else

    end
  end
end
