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
            stretch_mark = user.stretch_mark
            refute_nil stretch_mark

            user.save # Should trigger the Sidekiq job

            # Sidekiq.new.perform("User", user.id, 'password1')
            refute_equal stretch_mark, user.reload.stretch_mark
          end

        end
      end
    end
  end
end