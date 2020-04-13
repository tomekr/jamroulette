# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'uploading jams', type: :system do
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
    before do
      sign_in user
      visit room_path(room)
      click_on 'Upload New Track'
      attach_file :jam_file, 'spec/support/assets/test.mp3', make_visible: true
    end

    it 'allows a user to upload a jam', js: true do
      fill_in :jam_bpm_list, with: '120'
      fill_in :jam_notes, with: 'this is a note'
      click_on 'Upload'

      expect(page).to have_content('Jam successfully created!')
      expect(page).to have_content('120')
      expect(page).to have_content('this is a note')

      within('section#main') do
        # Check that radio button defaulted to Mix
        expect(page).to have_selector('span.jam-value', text: 'Mix')
        # Fixture file is 1 second long
        expect(page).to have_selector('span.jam-value', text: '00:01')
      end
    end

    it 'moves jams that are not mixes straight to Supporting Jams section', js: true do
      click_button 'Solo'
      click_on 'Upload'

      within('section#supporting-jams') do
        expect(page).to have_selector('span.jam-value', text: 'Solo')
      end
    end
  end
end
