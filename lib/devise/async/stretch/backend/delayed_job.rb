module Devise
  module Async
    module Stretch
      module Backend
        class DelayedJob < Base
          def self.enqueue_job(klass, id, password)
            new.delay(queue: Devise::Async::Stretch.queue).perform(klass, id, password)
          end
        end
      end
    end
  end
end