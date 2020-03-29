# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    # TODO: Remove when beta invite requirements are removed
    session[:is_beta_user] = true
    # Required when testing a devise controller from a controller spec
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    it 'permits entering a display_name attribute' do
      post :create, params: {
        user: {
          display_name: "Bob",
          email: "bob@example.com",
          password: "password",
          password_confirmation: "password",
        }
      }
      expect(User.first.display_name).to eq("Bob")
    end
  end

  describe 'PUT #update' do
    it 'permits entering a display_name attribute' do
      user = create(:user, display_name: 'Original Name')
      sign_in user
      put :update, params: {
        user: {
          display_name: "New Name",
          current_password: user.password,
        }
      }
      expect(user.reload.display_name).to eq("New Name")
    end
  end
end
