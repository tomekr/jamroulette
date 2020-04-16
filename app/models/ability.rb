# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Group, visible: true

    if user.present? # authenticated user
      # Group abilities
      can :manage, Group do |group|
        user.in_group?(group, as: :owner)
      end

      can :read, Group do |group|
        user.in_group?(group)
      end

      can :create, Group
    end
  end
end
