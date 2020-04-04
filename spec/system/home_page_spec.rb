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

    it 'allows a user to join a random room that contains a jam' do
      room = build(:room, public_id: "random-room")
      create(:jam, room: room)

      visit home_path

      click_link('Join a random room')

      expect(page).to have_content('random-room')
    end

    context "user is authenticated" do
      let(:user) { create(:user) }
      before(:each) { sign_in user }

      it 'allows a user to create a new room' do
        visit home_path
        click_on 'Create a new room'

        fill_in :room_name, with: 'test-room'
        click_button 'Create'

        expect(page).to have_content('Upload a track to get started')
        expect(page).to have_content('test-room')
      end

      it 'allows a user to sign out' do
        visit home_path
        click_on('Sign Out')

        expect(page).to have_content('Signed out successfully')
      end

      context 'activity feed' do
        it 'allows user to view a jam they uploaded' do
          activity = create(:activity, :jam, user: user)
          jam = activity.subject
          room = jam.room

          visit home_path

          expect(page).to have_content("Activity Feed")
          expect(page).to have_content("You uploaded #{jam.file.filename} to #{room.name}")
        end
      end
    end
  end
end
