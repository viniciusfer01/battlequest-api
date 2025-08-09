require "test_helper"

class ApiTokenTest < ActiveSupport::TestCase
  test "Creates a token succesfully" do
    token = ApiToken.create!
    assert token.persisted?
    assert_not_nil token.token
  end

  test "Does not coincide with other token" do
    token = ApiToken.create!
    assert_not_nil token.token
    assert token.persisted?
    assert_equal 24, token.token.length

    new_token = ApiToken.create!
    assert new_token.persisted?
    assert_not_equal token.token, new_token.token
    assert_equal 24, new_token.token.length
  end
end
