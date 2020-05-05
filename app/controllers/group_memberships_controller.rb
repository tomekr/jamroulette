# frozen_string_literal: true

class GroupMembershipsController < ApplicationController
  load_and_authorize_resource :group

  def index
    @invite = Invite.new
    @members = @group.members
    @pending_members = @group.invites.unexpired.map(&:recipient)
  end
end
