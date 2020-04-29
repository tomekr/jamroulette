# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :set_group

  def create
    authorize! :manage, @group

    recipient = User.find_by(email: invite_params[:email])
    invite = @group.invites.build(
      sender: current_user,
      recipient: recipient
    )

    if invite.save
      flash[:success] = 'Invite sent!'
    else
      flash.alert = invite.errors.full_messages.join(', ')
    end

    redirect_to group_group_members_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def invite_params
    params.require(:invite).permit(:email, :role)
  end
end
