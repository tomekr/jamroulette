RSpec.shared_examples 'Auth Required' do
  it 'requires authentication' do
    sign_out :user
    action
    expect(response).to redirect_to(new_user_session_path).or have_http_status(401)
  end
end
