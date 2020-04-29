# frozen_string_literal: true

class GroupMembersController < ApplicationController
  before_action :set_group

  def index
    authorize! :read, @group
    @invite = Invite.new
    @members = @group.members
    @pending_members = @group.invites.unexpired.map(&:recipient)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
