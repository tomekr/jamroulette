# frozen_string_literal: true

class GroupsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  load_and_authorize_resource

  before_action :set_group, only: %i[show edit update destroy]

  # GET /groups
  def index
    @current_user_groups = current_user&.groups
    @groups = Group.discoverable
  end

  # GET /groups/1
  def show; end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit; end

  # POST /groups
  def create
    # NOTE: ActiveRecord groups and members must be persisted before creating
    # memberships.
    @group = Group.new(group_params)

    if @group.save
      @group.add_owner(current_user)
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.fetch(:group).permit(:name, :visible)
  end
end
