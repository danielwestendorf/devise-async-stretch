require 'test_helper'

module Devise
  module Async
    module Stretch
      module Backend
        class BaseTest < ActiveSupport::TestCase

          setup do
            @user = users(:bob)
            Devise::Async::Stretch.enabled = true
            Devise::Async::Stretch.backend = :sidekiq
          end

          test "an error is raised with the built in enqueue" do
            assert_raises NotImplementedError do
              Base.enqueue
            end
          end

          test "the password gets updated when peformed" do
            Base.new.perform("User", @user.id, 'password')
            assert_not_empty @user.reload.encrypted_password
          end

          test "intermidiate encrypted_password gets set with a stretch_mark" do

            user = User.create(email: 'ed@example.com', password: 'password1')
            assert_not_empty user.reload.encrypted_password
            assert_equal Devise::Async::Stretch.intermediate_stretch, user.reload.stretch_mark
          end

        end
      end
    end
  end
end