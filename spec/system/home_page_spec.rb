# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visiting the home page', type: :system do
  before :each do
    InviteCode.create(code: 'correct-code')
  end

  context 'invite code required' do
    it 'it lets user in if they have the correct invite code' do
      visit root_path
      expect(page).to have_content('Jam Roulette is currently in closed beta.')

      fill_in :beta_code, with: 'correct-code'
      click_on 'Go'
      expect(page).to have_content('Welcome! Thanks for helping beta test Jam Roulette!')
      expect(page).to have_content('Create a new room')
    end

    it 'does not let user in if the invite code was incorrect' do
      visit root_path
      fill_in :beta_code, with: 'incorrect-code'
      click_on 'Go'
      expect(page).to have_content('Invalid invite code.')
      expect(page).to have_content('Jam Roulette is currently in closed beta.')
    end
  end

  context 'valid beta user' do
    # TODO: Remove when beta invite requirements are removed
    before(:each) do
      visit root_path
      fill_in :beta_code, with: 'correct-code'
      click_on 'Go'
    end

    it 'allows a user to join a random room' do
      room = create(:room, public_id: "random-room")

      click_link('Join a random room')

      expect(page).to have_content('random-room')
    end

    it 'allows a user to create a new room' do
      visit root_path
      click_on('Create a new room')

      expect(page).to have_content('Upload a track to get started')
    end
  end
end
