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
              Base.enqueue_job
            end
          end

          test "the password gets updated when peformed" do
            Base.new.perform("User", @user.id, 'password')
            assert_not_empty @user.reload.encrypted_password
          end

          test "intermidiate encrypted_password gets set" do
            user = User.new(email: 'ed@example.com', password: 'password1')

            encrypted_password = user.encrypted_password
            assert_not_empty encrypted_password

            user.save
            Base.new.perform("User", user.id, 'password1')

            refute_equal encrypted_password, user.reload.encrypted_password
          end

          test "the record doesn't get touched, skipping callbacks" do
            user = User.new(email: 'ed@example.com', password: 'password1')

            user.save
            updated_at = user.updated_at

            Base.new.perform("User", user.id, 'password1')

            assert_equal updated_at, user.reload.updated_at
          end

        end
      end
    end
  end
end