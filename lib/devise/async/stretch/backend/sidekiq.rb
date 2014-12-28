module Devise
  module Async
    module Stretch
      module Backend
        class Sidekiq < Base
          include ::Sidekiq::Worker

          sidekiq_options :queue => Devise::Async::Stretch.queue

          def self.enqueue(klass, id, password)
            perform_async(klass, id, password)
          end
        end
      end
    end
  end
end