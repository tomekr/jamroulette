# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#bulma_flash_mapping' do
    it 'maps alert to danger' do
      expect(helper.bulma_flash_mapping('alert')).to eq('danger')
    end
  end

  # TODO: Remove when beta invite code feature is removed
  describe '#beta_user?' do
    it 'returns true if beta user' do
      session[:is_beta_user] = true
      expect(helper.beta_user?).to be true
    end

    it 'returns false if not beta user' do
      session[:is_beta_user] = nil
      expect(helper.beta_user?).to be false
    end
  end

  describe '#has_unread_notifications?' do
    example 'unread notifications' do
      notification = create(:notification)
      expect(helper.has_unread_notifications?(notification.user)).to be true
    end

    example 'no unread notifications' do
      expect(helper.has_unread_notifications?(create(:user))).to be false
    end

    example 'user is not logged in' do
      expect(helper.has_unread_notifications?(nil)).to be false
    end
  end

  describe '#aside_link_to' do
    context 'link is to the current page' do
      before { allow(helper).to receive(:current_page?).and_return true }

      it 'adds is-active class to link' do
        link = helper.aside_link_to('/current_page_page') do
          'an icon for the link'
        end
        expect(link).to include('is-active')
      end
    end

    context 'link is not to the current page' do
      before { allow(helper).to receive(:current_page?).and_return false }

      it 'does not add is-active class to link' do
        link = helper.aside_link_to('/not_current_page') do
          'an icon for the link'
        end
        expect(link).to_not include('is-active')
      end
    end
  end
end
