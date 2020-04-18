# frozen_string_literal: true

class Groups::GroupMembershipsController < ApplicationController
  before_action :set_group
  before_action :set_group_membership, only: %i[show edit update destroy]

  # GET /groups/group_memberships
  def index
    @group_memberships = @group.group_memberships
  end

  # GET /groups/group_memberships/1
  def show; end

  # GET /groups/group_memberships/new
  def new
    @group_membership = Groups::GroupMembership.new
  end

  # GET /groups/group_memberships/1/edit
  def edit; end

  # POST /groups/group_memberships
  def create
    @group_membership = nil

    respond_to do |format|
      if @groups_group_membership.save
        format.html { redirect_to @groups_group_membership, notice: 'Group membership was successfully created.' }
        format.json { render :show, status: :created, location: @groups_group_membership }
      else
        format.html { render :new }
        format.json { render json: @groups_group_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/group_memberships/1
  def update
    respond_to do |format|
      if @group_membership.update(group_membership_params)
        format.html { redirect_to @groups_group_membership, notice: 'Group membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @groups_group_membership }
      else
        format.html { render :edit }
        format.json { render json: @groups_group_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/group_memberships/1
  def destroy
    @group_membership.destroy
    respond_to do |format|
      format.html { redirect_to groups_group_memberships_url, notice: 'Group membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_group_membership
    @group_membership = @group.group_memberships
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def group_membership_params
    params.fetch(:group_membership, {})
  end
end
