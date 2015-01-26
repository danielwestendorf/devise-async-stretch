require 'test_helper'

class ModelTest < ActiveSupport::TestCase

  setup do
    @user = users(:bob)
    Devise::Async::Stretch.enabled = true

    @model = Class.new do
      extend ActiveModel::Callbacks
      define_model_callbacks :save, :commit

      include ActiveModel::AttributeMethods
      include Devise::Models::Stretchable

      attr_accessor :email, :password, :stretch_mark

      def []=(key, val); self.send(key.to_s + '=', val); end
    end
  end

  test "bcrypt accepts a stretch param" do
    refute @user.send(:bcrypt, 'bob', 1).blank?
  end

  test "bcrypt uses the default class stretch value when none is passed" do
    refute @user.send(:bcrypt, 'bob').blank?
  end

  test "required_fields doesn't include encrypted_password when enabled" do
    assert_equal [:email], Devise::Models::Stretchable.required_fields(User)
  end

  test "required_fields includes encrypted_password when disabled" do
    Devise::Async::Stretch.enabled = false
    assert_equal [:encrypted_password, :email], Devise::Models::Stretchable.required_fields(User)
  end

  test "the #authenticatable_salt returns the stretch_mark" do
    instance = @model.new
    instance.stretch_mark = "123456"

    assert_equal "123456", instance.authenticatable_salt
  end

  test "if the password has changed, the stretch_mark gets updated" do
    instance = @model.new
    instance.password = "Bob"

    assert_nil instance.stretch_mark

    instance.run_callbacks(:save)

    refute_nil instance.stretch_mark
  end

end