# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'viewing a room', type: :system do
  # TODO: Remove when beta invite code feature is removed
  before :each do
    InviteCode.create(code: 'correct-code')
    visit root_path
    fill_in :beta_code, with: 'correct-code'
    click_on 'Go'
  end

  context 'authenticated' do
    let(:user) { create(:user) }
    let(:room) { create(:room) }

    before { sign_in user }

    it 'allows a user to promote an idea to the main area' do
      create(:jam, :idea, room: room)
      create(:jam, :mix, room: room)

      visit room_path(room)
      click_on 'Promote'

      within('section#main') do
        expect(page).to have_selector('span.jam-value', text: 'Idea')
        expect(page).to have_selector('span.jam-value', text: 'idea.mp3')
      end
    end
  end
end
