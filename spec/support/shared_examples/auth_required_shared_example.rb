RSpec.shared_examples "Auth Required" do
  it "requires authentication" do
    sign_out :user
    expect(action).to redirect_to(new_user_session_path)
  end
end
