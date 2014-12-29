require 'test_helper'

class ModelTest < ActiveSupport::TestCase

  setup do
    @user = users(:bob)
  end

  test "bcrypt accepts a stretch param" do
    refute @user.send(:bcrypt, 'bob', 1).blank?
  end

  test "bcrypt uses the default class stretch value when none is passed" do
    refute @user.send(:bcrypt, 'bob').blank?
  end

  test "required_fields doesn't include encrypted_password when enabled" do
    Devise::Async::Stretch.enabled = true
    assert_equal [:email], Devise::Models::Stretchable.required_fields(User)
  end

  test "required_fields includes encrypted_password when disabled" do
    Devise::Async::Stretch.enabled = false
    assert_equal [:encrypted_password, :email], Devise::Models::Stretchable.required_fields(User)
  end

end