# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  describe 'POST #create' do
    it 'permits entering a display_name attribute' do
      post user_registration_path, params: {
        user: {
          display_name: 'Bob',
          email: 'bob@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
      expect(User.first.display_name).to eq('Bob')
    end
  end

  describe 'PUT #update' do
    it 'permits entering a display_name attribute' do
      user = create(:user, display_name: 'Original Name')
      sign_in user
      put user_registration_path, params: {
        user: {
          display_name: 'New Name',
          current_password: user.password
        }
      }
      expect(user.reload.display_name).to eq('New Name')
    end
  end
end
