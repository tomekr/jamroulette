# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'uploading jams', type: :system do
  # TODO Remove when beta invite code feature is removed
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
      click_on 'Upload'

      expect(page).to have_content('Jam successfully created!')
      expect(page).to have_content('120')

      # Check that radio button defaults to Mix
      expect(page).to have_content('Mix')
    end

    it 'moves jams that are not mixes straight to Supporting Files section', js: true do
      click_button 'Solo'
      click_on 'Upload'

      within('section#supporting-files') do
        expect(page).to have_selector('span.jam-value', text: 'Solo')
      end
    end
  end
end
