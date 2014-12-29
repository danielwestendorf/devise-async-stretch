module Devise
  module Async
    module Stretch
      module Backend
        class Base
          def self.enqueue(*args)
            raise NotImplementedError, "Any Devise::Async::Stretch::Backend subclass should implement `self.enqueue`."
          end

          # Loads the resource record and sends the email.
          #
          # It uses `orm_adapter` API to fetch the record in order to enforce
          # compatibility among diferent ORMs.
           def perform(klass, id, password)
            resource = klass.constantize.to_adapter.get!(id)
            encrypted_password = resource.bcrypt(password, resource.class.stretches)

            resource.update(encrypted_password: encrypted_password)
          end

        end
      end
    end
  end
end