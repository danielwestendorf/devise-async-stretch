require 'test_helper'

module Devise
  module Async
    module Stretch
      module Backend
        class SidekiqTest < ActiveSupport::TestCase

          setup do
            @user = users(:bob)
            Devise::Async::Stretch.enabled = true
            Devise::Async::Stretch.backend = :sidekiq
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

          test "the stretch_mark gets updated" do
            User.stretches = 2
            ::Sidekiq::Testing.inline!

            user = User.new(email: 'ed@example.com', password: 'password1')
            encrypted_password = user.encrypted_password

            user.save # Should trigger the Sidekiq job

            refute_equal encrypted_password, user.reload.encrypted_password
          end

        end
      end
    end
  end
end