module Devise
  module Async
    module Stretch
      class Worker

        def self.enqueue(klass, id, password)
          backend_klass.enqueue_job(klass, id, password)
        end

        private

        def self.backend_klass
          Backend.for(Devise::Async::Stretch.backend)
        end

      end
    end
  end
end