require 'test_helper'

module Devise
  module Async
    module Stretch
      module Backend
        class SidekiqTest < ActiveSupport::TestCase

          setup do
            @user = users(:bob)
          end

          test "the job is queued" do
            assert_difference 'Devise::Async::Stretch::Backend::Sidekiq.jobs.size' do
              Sidekiq.enqueue("User", @user.id, "password")
            end
          end

          test "the password gets updated when peformed" do
            Sidekiq.new.perform("User", @user.id, 'password')
            assert_not_empty @user.reload.encrypted_password
          end

        end
      end
    end
  end
end