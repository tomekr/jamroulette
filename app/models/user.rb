# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable
  has_many :jams, dependent: :restrict_with_exception
  has_many :rooms, dependent: :restrict_with_exception

  has_many :activities, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :group_memberships
  has_many :groups, through: :group_memberships

  def in_group?(group, opts = {})
    return false unless group.present?

    groups.as(opts[:as]).include?(group)
  end
end
