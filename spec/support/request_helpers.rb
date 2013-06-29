require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

module RequestHelpers
  def create_logged_in_user
    user = User.create!(
      email: 'user@example.com',
      password: 'password'
    )
    login(user)
    user
  end

  def login(user)
    login_as user, scope: :user
  end
end
