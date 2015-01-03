require 'test_helper'
# require 'active_job/test_helper'

module Devise
  module Async
    module Stretch
      module Backend
        class ActiveJobTest < ActiveSupport::TestCase
          include ::ActiveJob::TestHelper

          setup do
            @user = users(:bob)
            Devise::Async::Stretch.enabled = true
            Devise::Async::Stretch.backend = :active_job

            clear_enqueued_jobs
          end

          test "the job is queued" do
            Rails.application.config.active_job.queue_adapter = :sidekiq

            ActiveJob.enqueue_job("User", @user.id, 'password')
            assert_enqueued_jobs 1
          end

          test "the password gets updated when peformed" do
            perform_enqueued_jobs do
              ActiveJob.enqueue_job("User", @user.id, 'password')
            end
            assert_not_empty @user.reload.encrypted_password
          end

          test "the stretch_mark gets updated" do
            User.stretches = 2

            user = User.new(email: 'ed@example.com', password: 'password1')
            encrypted_password = user.encrypted_password

            perform_enqueued_jobs do
              user.save # Should trigger the ActiveJob job
            end

            refute_equal encrypted_password, user.reload.encrypted_password
          end

        end
      end
    end
  end
end