# frozen_string_literal: true

RSpec.shared_examples 'Owner Required' do
  it 'requires ownership of resource' do
    sign_in create(:user)

    action
    expect(response).to redirect_to(home_path).or have_http_status(403)
    expect(flash.alert).to eq 'You are not authorized to access this page.'
  end

  it 'does not allow members who are not owners' do
    member = create(:user)
    group.add(member)
    sign_in member

    action
    expect(response).to redirect_to(home_path).or have_http_status(403)
    expect(flash.alert).to eq 'You are not authorized to access this page.'
  end
end
