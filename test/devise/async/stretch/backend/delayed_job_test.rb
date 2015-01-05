require 'test_helper'
require 'delayed_job_active_record'

module Devise
  module Async
    module Stretch
      module Backend
        class DelayedJobTest < ActiveSupport::TestCase

          setup do
            @user = users(:bob)
            Devise::Async::Stretch.enabled = true
            Devise::Async::Stretch.backend = :delayed_job
          end

          test "the job is queued" do
            assert_difference '::Delayed::Backend::ActiveRecord::Job.count' do
              DelayedJob.enqueue_job("User", @user.id, "password")
            end
          end

          test "the password gets updated when peformed" do
            DelayedJob.new.perform("User", @user.id, 'password')
            assert_not_empty @user.reload.encrypted_password
          end

        end
      end
    end
  end
end