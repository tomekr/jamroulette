# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :read, Group, visible: true
      return
    end

    can :read, Group, visible: true

    # Group abilities
    can :manage, Group do |group|
      user.in_group?(group, as: :owner)
    end

    can :read, Group do |group|
      user.in_group?(group)
    end

    can :create, Group

    can :manage, Invite, group: { group_memberships: { user: user, membership_type: 'owner' } }
  end
end
