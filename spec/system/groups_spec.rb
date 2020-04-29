# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'visiting the home page', type: :system do
  let(:user) { create(:user) }
  before do
    # TODO: Remove when beta invite requirements are removed
    InviteCode.create(code: 'correct-code')
    visit root_path
    fill_in :beta_code, with: 'correct-code'
    click_on 'Go'

    sign_in user
  end

  it 'allows a user to create a group' do
    visit home_path
    click_on 'Groups'
    click_on 'New Group'

    fill_in 'Group Name', with: 'The Groovies'
    click_on 'Create Group'

    expect(page).to have_content('Group was successfully created')
    expect(page).to have_content('The Groovies')
  end

  context 'invitations' do
    let(:group) { create(:group) }

    it 'allows a group owner to invite a user via email' do
      group.add_owner(user)
      user_to_invite = create(:user, email: 'invitee@example.com', display_name: 'Invitee')

      visit group_path(group)
      click_on 'Members'

      fill_in 'Email Address', with: 'invitee@example.com'
      select 'Member', from: :invite_role

      click_on 'Invite'

      within('.pending-invites') do
        expect(page).to have_content('Invitee')
      end
    end
  end
end
