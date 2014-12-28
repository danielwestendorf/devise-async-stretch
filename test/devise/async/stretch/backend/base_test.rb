require 'test_helper'

module Devise
  module Async
    module Stretch
      module Backend
        class BaseTest < ActiveSupport::TestCase

          setup do
            @user = users(:bob)
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

        end
      end
    end
  end
end