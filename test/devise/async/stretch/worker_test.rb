require 'test_helper'

module Devise
  module Async
    module Stretch
      class ModelTest < ActiveSupport::TestCase

        setup do
          Devise::Async::Stretch.backend = :sidekiq
        end

        test "worker responds with the backend" do
          assert_equal Backend::Sidekiq, Worker.send(:backend_klass)
        end

      end
    end
  end
end