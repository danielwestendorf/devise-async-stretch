# Copyright (c) 2014 Daniel Westendorf
#
# Much credit and thanks goes to Marcelo Silveira's wonderfull devise-async gem
# https://github.com/mhfs/devise-async for inspiration on the backend
# queuing support.

require "active_support/dependencies"
require "devise"
require "devise/async/stretch/version"

module Devise
  module Async
    module Stretch

      autoload :Worker,  "devise/async/stretch/worker"
      autoload :Backend, "devise/async/stretch/backend"
      autoload :Model,   "devise/async/stretch/model"

      module Backend
        autoload :Base,         "devise/async/stretch/backend/base"
        autoload :Sidekiq,      "devise/async/stretch/backend/sidekiq"
        autoload :ActiveJob,      "devise/async/stretch/backend/active_job"
        autoload :DelayedJob,      "devise/async/stretch/backend/delayed_job"
      end

      # Defines the queue backend to be used. Sidekiq by default.
      mattr_accessor :backend
      @@backend = :sidekiq

      # Defines the queue in which the background job will be enqueued. Default is :default.
      mattr_accessor :queue
      @@queue = :default

      # Defines the enabled configuration that if set to false the stetching will be done synchronously
      mattr_accessor :enabled
      @@enabled = true

      # Defines the value for stretching at initial user creation
      mattr_accessor :intermediate_stretch
      @@intermediate_stretch = 1


      # Allow configuring Devise::Async::Stretch with a block
      #
      # Example:
      #
      #     Devise::Async::Stretch.setup do |config|
      #       config.backend = :resque
      #       config.queue   = :my_custom_queue
      #     end
      def self.setup
        yield self
      end

    end
  end
end

# Register devise-async model in Devise
::Devise.add_module(:stretchable, :model => 'devise/async/stretch/model')