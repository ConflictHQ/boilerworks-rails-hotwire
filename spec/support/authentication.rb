module AuthenticationHelpers
  def sign_in(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
  end

  def sign_in_as(user)
    sign_in(user)
    user
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
