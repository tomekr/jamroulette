# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visiting the home page', type: :system do
  it 'allows a user to join a random room' do
    pending 'TODO'
    visit root_path
    click_on('Join a random room')

    expect(page).to have_content('My Song 1')
  end

  it 'allows a user to create a new room' do
    pending 'TODO'
    visit root_path
    click_on('Create a new room')

    expect(page).to have_content('Upload a track to get started')
  end
end
