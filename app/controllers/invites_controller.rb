# frozen_string_literal: true

class InvitesController < ApplicationController
  load_and_authorize_resource :group
  authorize_resource :invite, through: :group

  def create
    recipient = User.find_by(email: params[:invite][:email])
    @invite = @group.invites.build(
      sender: current_user,
      recipient: recipient
    )

    if @invite.save
      flash.notice = 'Invite sent!'
    else
      flash.alert = @invite.errors.full_messages.join(', ')
    end

    redirect_to group_group_memberships_path(@group)
  end
end
