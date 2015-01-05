require 'test_helper'

module Devise
  module Async
    module Stretch
      class BackendTest < ActiveSupport::TestCase

        setup do
          Devise::Async::Stretch.backend = :sidekiq
        end

        test "sidekiq" do
          assert_equal Backend::Sidekiq, Backend.for(:sidekiq)
        end

        test "active_job" do
          assert_equal Backend::ActiveJob, Backend.for(:active_job)
        end

        test "delayed_job" do
          assert_equal Backend::DelayedJob, Backend.for(:delayed_job)
        end

        test "an error is thrown for unsupported backends" do
          assert_raises ArgumentError do
            Backend.for(:fakeerz)
          end
        end

      end
    end
  end
end