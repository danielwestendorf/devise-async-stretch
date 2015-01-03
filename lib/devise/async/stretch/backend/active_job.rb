module Devise
  module Async
    module Stretch
      module Backend
        class ActiveJob < Base
          class Job < ::ActiveJob::Base
            queue_as Devise::Async::Stretch.queue

            def perform(resource, password)
              encrypted_password = resource.bcrypt(password, resource.class.stretches)
              resource.update(encrypted_password: encrypted_password)
            end
          end

          def self.enqueue_job(klass, id, password)
            resource = klass.constantize.to_adapter.get!(id)
            Job.perform_later(resource, password)
          end
        end
      end
    end
  end
end